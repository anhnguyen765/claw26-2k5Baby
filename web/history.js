// Chat History Management
class ChatHistory {
    constructor() {
        this.storageKey = 'babyWhy_chatHistory';
        this.currentChatId = null;
        this.loadHistory();
    }

    loadHistory() {
        const data = localStorage.getItem(this.storageKey);
        this.history = data ? JSON.parse(data) : [];
    }

    saveHistory() {
        localStorage.setItem(this.storageKey, JSON.stringify(this.history));
    }

    createNewChat() {
        const chat = {
            id: Date.now().toString(),
            title: 'New Conversation',
            timestamp: new Date().toISOString(),
            messages: []
        };
        this.history.unshift(chat);
        this.currentChatId = chat.id;
        this.saveHistory();
        return chat;
    }

    getCurrentChat() {
        return this.history.find(c => c.id === this.currentChatId);
    }

    addMessage(role, content, analysis = null) {
        const chat = this.getCurrentChat();
        if (!chat) return;

        const message = {
            id: Date.now().toString(),
            role,
            content,
            analysis,
            timestamp: new Date().toISOString()
        };

        chat.messages.push(message);

        // Update title from first user message
        if (role === 'user' && chat.messages.length === 1) {
            chat.title = content.substring(0, 50).trim() + (content.length > 50 ? '...' : '');
        }

        this.saveHistory();
        return message;
    }

    loadChat(chatId) {
        this.currentChatId = chatId;
        return this.getCurrentChat();
    }

    deleteChat(chatId) {
        this.history = this.history.filter(c => c.id !== chatId);
        if (this.currentChatId === chatId) {
            this.currentChatId = this.history.length > 0 ? this.history[0].id : null;
        }
        this.saveHistory();
    }

    clearAll() {
        if (confirm('Are you sure you want to delete all conversations? This cannot be undone.')) {
            this.history = [];
            this.currentChatId = null;
            this.saveHistory();
            return true;
        }
        return false;
    }

    exportHistory() {
        const dataStr = JSON.stringify(this.history, null, 2);
        const dataBlob = new Blob([dataStr], { type: 'application/json' });
        const url = URL.createObjectURL(dataBlob);
        const link = document.createElement('a');
        link.href = url;
        link.download = `babyWhy_history_${new Date().toISOString().split('T')[0]}.json`;
        link.click();
        URL.revokeObjectURL(url);
    }

    importHistory(file) {
        const reader = new FileReader();
        reader.onload = (e) => {
            try {
                const imported = JSON.parse(e.target.result);
                if (Array.isArray(imported)) {
                    this.history = [...this.history, ...imported];
                    this.saveHistory();
                    return true;
                }
            } catch (error) {
                console.error('Failed to import history:', error);
                return false;
            }
        };
        reader.readAsText(file);
    }

    searchChats(query) {
        const q = query.toLowerCase();
        return this.history.filter(chat =>
            chat.title.toLowerCase().includes(q) ||
            chat.messages.some(msg => msg.content.toLowerCase().includes(q))
        );
    }

    getFormattedTime(isoString) {
        const date = new Date(isoString);
        const now = new Date();
        const diffMs = now - date;
        const diffMins = Math.floor(diffMs / 60000);
        const diffHours = Math.floor(diffMs / 3600000);
        const diffDays = Math.floor(diffMs / 86400000);

        if (diffMins < 1) return 'just now';
        if (diffMins < 60) return `${diffMins}m ago`;
        if (diffHours < 24) return `${diffHours}h ago`;
        if (diffDays < 7) return `${diffDays}d ago`;

        return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
    }
}

// Export for use in app.js
const chatHistory = new ChatHistory();
