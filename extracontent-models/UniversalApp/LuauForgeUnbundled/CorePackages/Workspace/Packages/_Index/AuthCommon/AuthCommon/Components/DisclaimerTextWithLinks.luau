local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Localization").Hooks.useLocalization
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UrlBuilder").UrlBuilder

local LegalTextWithLinks = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/LegalTextWithLinks")
local useOpenDisclaimerLinks = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Hooks/useOpenDisclaimerLinks")
local RegisterAuditContent = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/RegisterAuditContent")
local RegisterAdditionalAuditContent = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/RegisterAdditionalAuditContent")

local v5 = {
	startTermsTag = "<a href=\"terms\">",
	endTermsTag = "</a>",
	startPrivacyTag = "<a href=\"privacy\">",
	endPrivacyTag = "</a>"
}

local function DisclaimerTextWithLinks(props)
	local enableAuditContentCapture = props.enableAuditContentCapture == true

	local clone = table.clone(v5)
	clone[1] = props.textKey

	local v8 = if enableAuditContentCapture then props.textKey else nil
	local v9 = useLocalization({ text = clone, template = v8 })

	local v10 = useOpenDisclaimerLinks({ ctx = props.ctx, state = props.state, origin = props.origin })

	local v11 = React.useCallback(function(p2)
		if p2 == "terms" then
			v10.openTerms()
		elseif p2 == "privacy" then
			v10.openPrivacy()
		end
	end, { v10 })

	local createElement = React.createElement
	local fragment = React.Fragment
	local v13 = {
		Text = React.createElement(LegalTextWithLinks, {
			text = v9.text,
			onLinkActivated = v11,
			LayoutOrder = props.LayoutOrder
		}),
		TextAuditContent = 0,
		TermsLinkAuditContent = 0,
		PrivacyLinkAuditContent = 0
	}

	local v14 = if enableAuditContentCapture then React.createElement(RegisterAuditContent, {
		translationKey = props.textKey,
		translatedSourceString = v9.template,
		parameters = v5
	}) else nil
	v13.TextAuditContent = v14

	local v15 = if enableAuditContentCapture then React.createElement(RegisterAdditionalAuditContent, {
		contentKey = "termsLink",
		value = urlBuilder.static.about.terms()
	}) else nil
	v13.TermsLinkAuditContent = v15

	local v16 = if enableAuditContentCapture then React.createElement(RegisterAdditionalAuditContent, {
		contentKey = "privacyLink",
		value = urlBuilder.static.about.privacy()
	}) else nil
	v13.PrivacyLinkAuditContent = v16
	return createElement(fragment, nil, v13)
end

return DisclaimerTextWithLinks
