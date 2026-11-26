local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local module = require("@luauforge/bundled/gvU")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")

local module3 = require("@luauforge/bundled/gxL")

local getFFlagEnableAuditForSinglePageSignUp = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAuditForSinglePageSignUp
local module4 = require("@luauforge/bundled/guM")

local accountUpgradeContainer = module.Components.AccountUpgradeContainer
local accountUpgradeFlow = module.AccountUpgradeFlow
local auditContentContext = AuthCommon.Stores.AuditContentContext.AuditContentContext
local registerAdditionalAuditContent = AuthCommon.Components.RegisterAdditionalAuditContent

local function onSignUpComplete() end

local function DesktopSignupDialogContent(p2)
	local v5 = module3(p2)
	local v6 = p2.usesKoreaKISAAgreements ~= true

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local v10 = {
		flow = accountUpgradeFlow.Signup,
		submit = v5.submit,
		onClose = 0,
		onSignUpComplete = 0,
		onLegalLinkSelected = 0,
		onFieldInteraction = 0,
		hasBackdrop = true,
		isHidden = 0,
		linkedPlatformAccountName = 0,
		hidesLegalText = 0
	}
	local v11 = if module4 then v5.dismiss else p2.onClose
	v10.onClose = v11
	v10.onSignUpComplete = onSignUpComplete
	v10.onLegalLinkSelected = v5.onLegalLinkSelected
	v10.onFieldInteraction = v5.onFieldInteraction

	v10.isHidden = v5.isFormHidden
	v10.linkedPlatformAccountName = v5.linkedPlatformAccountName
	v10.hidesLegalText = not v6
	local v8 = {
		Form = createElement2(accountUpgradeContainer, v10),
		TermsLinkAuditContent = 0,
		PrivacyLinkAuditContent = 0
	}

	local v12 = if v6 then React.createElement(registerAdditionalAuditContent, {
		contentKey = "termsLink",
		value = urlBuilder.static.about.terms()
	}) else nil
	v8.TermsLinkAuditContent = v12

	local v13 = if v6 then React.createElement(registerAdditionalAuditContent, {
		contentKey = "privacyLink",
		value = urlBuilder.static.about.privacy()
	}) else nil
	v8.PrivacyLinkAuditContent = v13
	return createElement(fragment, nil, v8)
end

local function DesktopSignupDialog(p2)
	local element = React.createElement(DesktopSignupDialogContent, p2)

	if getFFlagEnableAuditForSinglePageSignUp() then
		return React.createElement(auditContentContext.Provider, nil, {
			Content = element
		})
	end

	return element
end

return DesktopSignupDialog
