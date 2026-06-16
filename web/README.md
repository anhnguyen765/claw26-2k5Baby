# BabyWhy Web Application

A modern, packaged web interface for the BabyWhy AI Decision Clarity Coach.

## 📦 Package Contents

```
web/
├── index.html          # Main HTML file
├── styles.css          # Complete styling
├── app.js              # Main application logic
├── history.js          # Chat history management
└── README.md           # This file
```

## ✨ Features

✅ **Real-time Chat Interface** - Natural conversation with your AI coach  
✅ **Chat History** - All conversations stored locally in browser  
✅ **Search Conversations** - Find past discussions quickly  
✅ **Export History** - Download all conversations as JSON  
✅ **Emotional Analysis** - Visual representation of emotional signals  
✅ **Socratic Questions** - Guided inquiry for deeper thinking  
✅ **Save Decisions** - Document decisions with reasoning  
✅ **Responsive Design** - Works on desktop, tablet, and mobile  
✅ **Dark/Light Themes** - Professional color scheme  

## 🚀 Deployment Options

### Option 1: Local Development (Simplest)

```bash
# Navigate to web directory
cd web

# Start a simple HTTP server
python3 -m http.server 8000

# Open browser to http://localhost:8000
```

### Option 2: GitHub Pages

1. Fork or create a GitHub repository
2. Upload the `web/` folder contents
3. Enable GitHub Pages in repository settings
4. Set source to `main` branch
5. Access at `https://yourusername.github.io/baby-why`

### Option 3: Netlify (Recommended)

1. Install Netlify CLI:
```bash
npm install -g netlify-cli
```

2. Deploy:
```bash
cd web
netlify deploy --prod --dir .
```

3. Your site will be live at a Netlify URL

### Option 4: Vercel

1. Install Vercel CLI:
```bash
npm install -g vercel
```

2. Deploy:
```bash
cd web
vercel --prod
```

### Option 5: Traditional Web Hosting

1. Upload all files in `web/` folder to your hosting provider
2. Ensure files are publicly accessible
3. Access via your domain

### Option 6: Serve from Flask Agent

Add this to your Flask `main.py`:

```python
from flask import send_file, send_from_directory

@app.route('/')
def serve_index():
    return send_file('web/index.html')

@app.route('/<path:filename>')
def serve_static(filename):
    return send_from_directory('web', filename)
```

Then restart your agent and visit the endpoint in your browser.

## 💾 Data Storage

- **Chat History**: Stored in browser's localStorage
- **Maximum Storage**: Varies by browser (typically 5-50MB)
- **Persistence**: Remains until user clears browser data
- **Export**: JSON format compatible with external storage

## ⚙️ Configuration

### Change API Endpoint

Edit `app.js` line 3:

```javascript
const API_ENDPOINT = 'https://your-endpoint-here.com';
```

### Customize Theme

Edit `styles.css` to change:
- Color scheme (search for `#667eea`)
- Font family
- Layout dimensions
- Animation timing

### Modify Assistant Messages

Edit `history.js` and `app.js` to change greeting messages and prompts.

## 🔒 Security & Privacy

- **No Server Storage**: All data stays in user's browser
- **Local Processing**: Chat history never sent to external servers
- **API Calls Only**: Only `/decide` and `/journal` endpoints called
- **No Tracking**: No analytics or user tracking
- **No Authentication**: Public access (add your own if needed)

## 🎯 Usage Guide

### Starting a Conversation

1. Click **"+ New"** to start a new conversation
2. Type your product decision challenge
3. Press **Enter** or click **"Send"**
4. BabyWhy will analyze and provide Socratic questions

### Viewing History

- Left sidebar shows all past conversations
- Click any conversation to reload it
- Search conversations by typing in the search box
- Delete individual conversations with the ✕ button

### Saving Decisions

1. After getting analysis, click **"💾 Save to Journal"**
2. Enter your decision
3. Enter your reasoning
4. Decision is saved with timestamp and ID

### Exporting Data

- Click **"📥 Export"** to download all conversations as JSON
- File includes all messages and analysis
- Useful for backup or sharing with team

### Clearing Data

- Click **"🗑️ Clear"** to remove all conversations
- **Warning**: This action cannot be undone
- Browser will prompt for confirmation

## 📱 Browser Compatibility

- **Chrome/Edge**: ✅ Full support
- **Firefox**: ✅ Full support
- **Safari**: ✅ Full support
- **Mobile browsers**: ✅ Responsive design
- **IE11**: ❌ Not supported (use modern browser)

## 🔧 Troubleshooting

### "Failed to get analysis" Error
- Check that API endpoint is correct in `app.js`
- Verify BabyWhy agent is running and accessible
- Check browser console for CORS errors
- Ensure network connection is stable

### Chat History Not Saving
- Check if localStorage is enabled in browser
- Clear browser cache and try again
- Try a different browser
- Check available storage space

### Slow Responses
- Network latency to API endpoint
- Agent processing time (normal: 2-5 seconds)
- Browser performance
- Try closing other tabs

### Mobile Layout Issues
- Rotate device to landscape for better view
- Zoom out if text is too large
- Use landscape mode for sidebar access

## 🎓 Integration Examples

### Embed in Slack Workflow
Create a workflow that links to your deployed BabyWhy instance with pre-filled topic.

### Share with Team
- Generate export JSON
- Share via email or Slack
- Team members can view decision history

### Internal Documentation
Link to BabyWhy from:
- Product playbooks
- Decision-making guides
- Onboarding materials

## 📊 Analytics & Monitoring

To add analytics, edit `app.js` and add tracking calls:

```javascript
// Example: Track decision analyses
function handleSendMessage() {
    // ... existing code ...
    
    // Add analytics
    if (window.gtag) {
        gtag('event', 'analysis_requested', {
            challenge_length: challenge.length
        });
    }
}
```

## 🆘 Support & Feedback

For issues or suggestions:
1. Check browser console for error messages
2. Verify API endpoint accessibility
3. Test with sample challenges
4. Contact the BabyWhy development team

## 📄 License

BabyWhy is provided as-is for organizational use.

## 🎉 Getting Started

1. **Download** the `web/` folder
2. **Choose a deployment option** above
3. **Configure API endpoint** if needed
4. **Deploy** to your platform
5. **Share** the URL with your team
6. **Start conversations** and save decisions!

---

**Version**: 1.0  
**Last Updated**: June 2026  
**Status**: Active ✅

Enjoy using BabyWhy! 🤔
