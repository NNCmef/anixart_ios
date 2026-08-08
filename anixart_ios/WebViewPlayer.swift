import SwiftUI
import WebKit

struct WebViewPlayer: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        
        let userContentController = WKUserContentController()
        
        let blockPopupsScriptString = """
            window.open = function() { return null; };
            document.addEventListener('click', function(e) {
                var target = e.target;
                while(target && target.tagName !== 'A') {
                    target = target.parentNode;
                }
                if(target && target.tagName === 'A' && target.target === '_blank') {
                    e.preventDefault();
                    e.stopPropagation();
                }
            }, true);
        """
        let blockPopupsScript = WKUserScript(
            source: blockPopupsScriptString,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
        
        let hideAdsScriptString = """
            var style = document.createElement('style');
            style.innerHTML = `
                .ad-overlay, .banner, .adv, 
                [id*="yandex_rtb"], [class*="yandex-rtb"], .kodik-ad 
                { display: none !important; opacity: 0 !important; pointer-events: none !important; }
            `;
            document.head.appendChild(style);
        """
        let hideAdsScript = WKUserScript(
            source: hideAdsScriptString,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: false
        )
        
        userContentController.addUserScript(blockPopupsScript)
        userContentController.addUserScript(hideAdsScript)
        
        configuration.userContentController = userContentController
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
