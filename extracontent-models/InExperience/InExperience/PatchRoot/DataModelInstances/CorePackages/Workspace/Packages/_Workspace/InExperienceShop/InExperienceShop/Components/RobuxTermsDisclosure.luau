local parent = script:FindFirstAncestor("InExperienceShop").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local WebViewUtils = require(parent.WebViewUtils)
local useOpenWebView = WebViewUtils.useOpenWebView
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local InlineLayout = require(parent.InlineLayout)
local inlineLayout = InlineLayout.Components.InlineLayout
local LinkElement = InlineLayout.Components.InlineLayoutElements.LinkElement
local TextElement = InlineLayout.Components.InlineLayoutElements.TextElement

local v = {
	disclosure = {
		"Feature.InExperienceShop.Description.RobuxPurchaseLegalDisclosure",
		termsLinkStart = "<a>",
		termsLinkEnd = "</a>"
	}
}

local function RobuxTermsDisclosure(p)
	local v2 = useTokens()
	local v3 = useOpenWebView()
	local disclosure = useLocalization(v).disclosure

	local onActivated = React.useCallback(function()
		v3(urlBuilder.static.about.terms(), "")
	end, { v3 })

	local isMobile = p.isMobile == true
	local fontStyle

	if isMobile then
		fontStyle = v2.Typography.CaptionSmall
	else
		fontStyle = v2.Typography.BodySmall
	end

	local fontStyle2

	if isMobile then
		fontStyle2 = v2.Typography.CaptionSmall
	else
		fontStyle2 = v2.Typography.CaptionMedium
	end

	local textStyle

	if isMobile then
		textStyle = v2.Color.System.Neutral
	else
		textStyle = v2.Color.Content.Default
	end

	local textStyle2

	if isMobile then
		textStyle2 = v2.Color.Content.Emphasis
	else
		textStyle2 = textStyle
	end

	local elements = React.useMemo(function()
		local text, text2, text3 = string.match(disclosure, "^(.*)<a>(.*)</a>(.*)$")

		if text2 == nil then
			return { TextElement.new({
					Text = disclosure,
					fontStyle = fontStyle,
					textStyle = textStyle
				}) }
		end

		return {
			TextElement.new({
				Text = text,
				fontStyle = fontStyle,
				textStyle = textStyle,
				testId = "RobuxTermsDisclosure-LeadingText"
			}),
			LinkElement.new(
				{ TextElement.new({
						Text = text2,
						fontStyle = fontStyle2,
						textStyle = textStyle2,
						testId = "RobuxTermsDisclosure-TermsLinkText"
					}) },
				{ key = "RobuxTermsDisclosure-TermsLink", onActivated = onActivated }
			),
			TextElement.new({ Text = text3, fontStyle = fontStyle, textStyle = textStyle })
		}
	end, { disclosure, fontStyle, fontStyle2, textStyle, textStyle2, onActivated })

	return React.createElement(
		View,
		{ tag = "size-full-0 auto-y", testId = "RobuxTermsDisclosure", LayoutOrder = p.LayoutOrder },
		{
			Layout = React.createElement(inlineLayout, { Elements = elements })
		}
	)
end

return React.memo(RobuxTermsDisclosure)
