local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.renderer.html.AttributeProvider)
require(CommonMark.renderer.html.AttributeProviderContext)
require(CommonMark.renderer.html.AttributeProviderFactory)
require(CommonMark.renderer.html.DefaultUrlSanitizer)
require(CommonMark.renderer.html.HtmlNodeRendererContext)
require(CommonMark.renderer.html.HtmlNodeRendererFactory)
require(CommonMark.renderer.html.HtmlWriter)
require(CommonMark.renderer.NodeRenderer)
require(CommonMark.renderer.html.UrlSanitizer)

return {
	AttributeProvider = nil,
	AttributeProviderContext = nil,
	AttributeProviderFactory = nil,
	DefaultUrlSanitizer = nil,
	HtmlNodeRendererContext = nil,
	HtmlNodeRendererFactory = nil,
	HtmlWriter = nil,
	NodeRenderer = nil,
	UrlSanitizer = nil
}
