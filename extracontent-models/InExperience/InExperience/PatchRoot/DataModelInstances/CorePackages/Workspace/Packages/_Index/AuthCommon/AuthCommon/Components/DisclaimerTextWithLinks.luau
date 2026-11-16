local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local LegalTextWithLinks = require(script.Parent.LegalTextWithLinks)
local useOpenDisclaimerLinks = require(AuthCommon.Hooks.useOpenDisclaimerLinks)
local RegisterAuditContent = require(AuthCommon.Components.RegisterAuditContent)
local RegisterAdditionalAuditContent = require(AuthCommon.Components.RegisterAdditionalAuditContent)

local parameters = {
	startTermsTag = "<a href=\"terms\">",
	endTermsTag = "</a>",
	startPrivacyTag = "<a href=\"privacy\">",
	endPrivacyTag = "</a>"
}

local function DisclaimerTextWithLinks(props)
	local enableAuditContentCapture = props.enableAuditContentCapture == true

	local clone = table.clone(parameters)
	clone[1] = props.textKey
	local template

	if enableAuditContentCapture then
		template = props.textKey
	end

	local v = useLocalization({ text = clone, template = template })

	local v2 = useOpenDisclaimerLinks({
		ctx = props.ctx,
		state = props.state,
		origin = props.origin
	})

	local onLinkActivated = React.useCallback(function(p: string)
		if p == "terms" then
			v2.openTerms()
		elseif p == "privacy" then
			v2.openPrivacy()
		end
	end, { v2 })

	local createElement = React.createElement
	local fragment = React.Fragment
	local v3 = {
		Text = React.createElement(LegalTextWithLinks, {
			text = v.text,
			onLinkActivated = onLinkActivated,
			LayoutOrder = props.LayoutOrder
		}),
		TextAuditContent = 0,
		TermsLinkAuditContent = 0,
		PrivacyLinkAuditContent = 0
	}
	local textAuditContent

	if enableAuditContentCapture then
		textAuditContent = React.createElement(RegisterAuditContent, {
			translationKey = props.textKey,
			translatedSourceString = v.template,
			parameters = parameters
		})
	end

	v3.TextAuditContent = textAuditContent
	local termsLinkAuditContent

	if enableAuditContentCapture then
		termsLinkAuditContent = React.createElement(RegisterAdditionalAuditContent, {
			contentKey = "termsLink",
			value = urlBuilder.static.about.terms()
		})
	end

	v3.TermsLinkAuditContent = termsLinkAuditContent
	local privacyLinkAuditContent

	if enableAuditContentCapture then
		privacyLinkAuditContent = React.createElement(RegisterAdditionalAuditContent, {
			contentKey = "privacyLink",
			value = urlBuilder.static.about.privacy()
		})
	end

	v3.PrivacyLinkAuditContent = privacyLinkAuditContent
	return createElement(fragment, nil, v3)
end

return DisclaimerTextWithLinks
