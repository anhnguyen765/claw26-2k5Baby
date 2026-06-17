// BabyWhy Chat Application
const API_ENDPOINT = 'https://endpoint-3f1e948d-3509-4189-902d-5d5a173745fa.agentbase-runtime.aiplatform.vngcloud.vn';

// DOM Elements
const messagesDiv = document.getElementById('messages');
const challengeInput = document.getElementById('challengeInput');
const sendBtn = document.getElementById('sendBtn');
const saveBtn = document.getElementById('saveBtn');
const newChatBtn = document.getElementById('newChatBtn');
const historySearch = document.getElementById('historySearch');
const chatHistoryDiv = document.getElementById('chatHistory');
const emptyStateDiv = document.getElementById('emptyState');
const exportBtn = document.getElementById('exportBtn');
const clearBtn = document.getElementById('clearBtn');
const headerSubtitle = document.getElementById('headerSubtitle');

let lastAnalysis = null;

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    initializeApp();
    setupEventListeners();
    renderHistory();

    if (chatHistory.currentChatId) {
        loadChatMessages();
    }
});

function initializeApp() {
    if (chatHistory.history.length === 0) {
        chatHistory.createNewChat();
    } else if (!chatHistory.currentChatId) {
        chatHistory.currentChatId = chatHistory.history[0].id;
    }
    renderHistory();
}

function setupEventListeners() {
    sendBtn.addEventListener('click', handleSendMessage);
    newChatBtn.addEventListener('click', handleNewChat);
    saveBtn.addEventListener('click', handleSaveDecision);
    historySearch.addEventListener('input', handleSearchHistory);
    exportBtn.addEventListener('click', handleExport);
    clearBtn.addEventListener('click', handleClear);

    challengeInput.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            handleSendMessage();
        }
    });
}

// Chat Functions
async function handleSendMessage() {
    const challenge = challengeInput.value.trim();

    if (!challenge) {
        showToast('Please describe your challenge', true);
        return;
    }

    const currentChat = chatHistory.getCurrentChat();
    if (!currentChat) {
        chatHistory.createNewChat();
    }

    // Add user message
    addMessage(challenge, 'user');
    chatHistory.addMessage('user', challenge);
    challengeInput.value = '';
    sendBtn.disabled = true;

    // Show loading
    const loadingId = addLoadingMessage();

    try {
        console.log('📡 Calling API:', `${API_ENDPOINT}/decide`);
        const response = await fetch(`${API_ENDPOINT}/decide`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ challenge })
        });

        console.log('📍 API Response Status:', response.status);

        if (!response.ok) {
            const errorText = await response.text();
            console.error('❌ API Error:', errorText);
            throw new Error(`API Error: ${response.status} ${response.statusText}`);
        }

        const data = await response.json();
        console.log('✅ Analysis received:', data);
        lastAnalysis = data;

        // Remove loading message
        document.getElementById(loadingId)?.remove();

        // Add analysis message
        addAnalysisMessage(data);
        chatHistory.addMessage('assistant', JSON.stringify(data.analysis), data);

        // Update UI
        saveBtn.style.display = 'block';
        showToast('✨ Analysis complete! Reflect on the questions.');
        renderHistory();

    } catch (error) {
        console.error('🚨 Fetch Error:', error);
        console.error('API Endpoint:', API_ENDPOINT);
        document.getElementById(loadingId)?.remove();
        addMessage(`Sorry, I encountered an error: ${error.message}. Check console (F12) for details.`, 'assistant');
        showToast('❌ ' + error.message, true);
    } finally {
        sendBtn.disabled = false;
        challengeInput.focus();
    }
}

function handleNewChat() {
    chatHistory.createNewChat();
    clearMessages();
    messagesDiv.innerHTML = `
        <div class="message assistant">
            <div class="bubble">
                <div style="margin-bottom: 12px;">👋 New conversation started</div>
                <div style="font-size: 13px; line-height: 1.6;">
                    Ready to help you explore a new decision. What's on your mind?
                </div>
            </div>
        </div>
    `;
    saveBtn.style.display = 'none';
    lastAnalysis = null;
    challengeInput.value = '';
    challengeInput.focus();
    renderHistory();
}

function handleSaveDecision() {
    if (!lastAnalysis) return;

    const decision = prompt('What decision did you make or what will you do next?');
    if (!decision) return;

    const reasoning = prompt('Why did you choose this?');
    if (reasoning === null) return;

    sendBtn.disabled = true;

    fetch(`${API_ENDPOINT}/journal`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            challenge: lastAnalysis.challenge,
            decision,
            reasoning,
            timestamp: new Date().toISOString()
        })
    }).then(response => {
        if (!response.ok) throw new Error('Failed to save');
        return response.json();
    }).then(data => {
        addMessage(`✅ Decision saved to journal!\nDecision ID: ${data.decision_id}`, 'assistant');
        showToast('Decision saved successfully!');
        saveBtn.style.display = 'none';
        lastAnalysis = null;
    }).catch(error => {
        showToast('Error saving: ' + error.message, true);
    }).finally(() => {
        sendBtn.disabled = false;
    });
}

// History Functions
function renderHistory() {
    if (chatHistory.history.length === 0) {
        chatHistoryDiv.style.display = 'none';
        emptyStateDiv.style.display = 'flex';
        return;
    }

    chatHistoryDiv.style.display = 'flex';
    emptyStateDiv.style.display = 'none';

    const query = historySearch.value.toLowerCase();
    const filtered = query ? chatHistory.searchChats(query) : chatHistory.history;

    chatHistoryDiv.innerHTML = filtered.map(chat => `
        <div class="history-item ${chat.id === chatHistory.currentChatId ? 'active' : ''}" onclick="loadChat('${chat.id}')">
            <div style="display: flex; justify-content: space-between; align-items: start;">
                <div style="flex: 1;">
                    <div class="history-item-title">${escapeHtml(chat.title)}</div>
                    <div class="history-item-time">${chatHistory.getFormattedTime(chat.timestamp)} • ${chat.messages.length} messages</div>
                </div>
                <button class="history-item-delete" onclick="event.stopPropagation(); deleteChat('${chat.id}')" title="Delete">✕</button>
            </div>
        </div>
    `).join('');
}

function handleSearchHistory(e) {
    renderHistory();
}

function loadChat(chatId) {
    const chat = chatHistory.loadChat(chatId);
    if (!chat) return;

    clearMessages();
    saveBtn.style.display = 'none';
    lastAnalysis = null;

    if (chat.messages.length === 0) {
        messagesDiv.innerHTML = `
            <div class="message assistant">
                <div class="bubble">
                    <div style="margin-bottom: 12px;">💬 Start a conversation</div>
                    <div style="font-size: 13px;">Share your decision challenge below</div>
                </div>
            </div>
        `;
    } else {
        chat.messages.forEach(msg => {
            if (msg.role === 'user') {
                addMessage(msg.content, 'user');
            } else if (msg.analysis) {
                addAnalysisMessage(msg.analysis);
                lastAnalysis = msg.analysis;
                saveBtn.style.display = 'block';
            }
        });
    }

    renderHistory();
    headerSubtitle.textContent = `${chat.messages.length} messages`;
}

function loadChatMessages() {
    const currentChat = chatHistory.getCurrentChat();
    if (currentChat) {
        loadChat(currentChat.id);
    }
}

function deleteChat(chatId) {
    if (confirm('Delete this conversation?')) {
        chatHistory.deleteChat(chatId);
        if (chatHistory.currentChatId === null) {
            handleNewChat();
        } else {
            loadChat(chatHistory.currentChatId);
        }
        renderHistory();
    }
}

function handleExport() {
    chatHistory.exportHistory();
    showToast('💾 Conversations exported successfully!');
}

function handleClear() {
    if (chatHistory.clearAll()) {
        handleNewChat();
        renderHistory();
        showToast('🗑️ All conversations cleared');
    }
}

// Message Display Functions
function addMessage(text, role) {
    const message = document.createElement('div');
    message.className = `message ${role}`;
    message.innerHTML = `<div class="bubble">${escapeHtml(text)}</div>`;
    messagesDiv.appendChild(message);
    messagesDiv.scrollTop = messagesDiv.scrollHeight;
    return message.id;
}

function addLoadingMessage() {
    const message = document.createElement('div');
    message.className = 'message assistant';
    message.id = 'loading-' + Date.now();
    message.innerHTML = `
        <div class="bubble">
            <div class="loading">
                <div class="loading-dot"></div>
                <div class="loading-dot"></div>
                <div class="loading-dot"></div>
            </div>
            <div style="margin-top: 8px; font-size: 12px; color: #6b7280;">Analyzing your challenge...</div>
        </div>
    `;
    messagesDiv.appendChild(message);
    messagesDiv.scrollTop = messagesDiv.scrollHeight;
    return message.id;
}

function addAnalysisMessage(data) {
    const message = document.createElement('div');
    message.className = 'message assistant';

    const emotion = data.analysis.emotion;
    const emotionColor = emotion.intensity >= 7 ? '#ef4444' : emotion.intensity >= 4 ? '#f59e0b' : '#10b981';

    let html = `<div class="bubble">
        <div class="analysis-box">
            <div class="analysis-section">
                <div class="section-title">🎭 Your Emotional Signal</div>
                <div class="emotion-display">
                    <div class="emotion-label">${escapeHtml(emotion.primary_emotion)}</div>
                    <div class="intensity-bar">
                        <div class="intensity-fill" style="width: ${emotion.intensity * 10}%; background: ${emotionColor};"></div>
                    </div>
                    <div class="emotion-value">${emotion.intensity}/10</div>
                </div>
            </div>

            <div class="analysis-section">
                <div class="section-title">❓ Socratic Questions</div>
                <div class="questions-list">
                    ${data.analysis.questions.map(q => `<div class="question">${escapeHtml(q)}</div>`).join('')}
                </div>
            </div>

            <div class="analysis-section">
                <div class="section-title">📍 Next Steps</div>
                <div class="next-steps">
                    ${data.next_steps.map(step => `<div class="step-tag">${escapeHtml(step)}</div>`).join('')}
                </div>
            </div>
        </div>
    </div>`;

    message.innerHTML = html;
    messagesDiv.appendChild(message);
    messagesDiv.scrollTop = messagesDiv.scrollHeight;
}

function clearMessages() {
    messagesDiv.innerHTML = '';
}

// Utility Functions
function showToast(message, isError = false) {
    const toast = document.createElement('div');
    toast.className = `toast ${isError ? 'error' : ''}`;
    toast.textContent = message;
    document.body.appendChild(toast);

    setTimeout(() => {
        toast.style.animation = 'slideInRight 0.3s ease-out reverse';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

function escapeHtml(text) {
    const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return String(text).replace(/[&<>"']/g, m => map[m]);
}

// Focus input on load
window.addEventListener('load', () => {
    challengeInput.focus();
});
