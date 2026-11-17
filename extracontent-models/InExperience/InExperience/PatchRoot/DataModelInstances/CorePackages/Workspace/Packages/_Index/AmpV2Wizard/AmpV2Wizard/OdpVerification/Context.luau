local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)
local WebViewUtils = require(parent.WebViewUtils)

local ExternalBrowser = require(AmpV2Wizard.OdpVerification.ExternalBrowser)
local ApiProvider = require(AmpV2Wizard.OdpVerification.ApiProvider)
local PersonaInquiryService = require(AmpV2Wizard.OdpVerification.PersonaInquiryService)

return (React.createContext({
	api = ApiProvider,
	personaInquiryService = PersonaInquiryService,
	openWebView = WebViewUtils.openWebViewSession,
	externalBrowser = ExternalBrowser
}))
