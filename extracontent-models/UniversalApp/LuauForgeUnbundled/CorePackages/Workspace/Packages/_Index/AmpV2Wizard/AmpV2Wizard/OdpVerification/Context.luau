local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")
local WebViewUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/WebViewUtils")

local ExternalBrowser = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/OdpVerification/ExternalBrowser")
local ApiProvider = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/OdpVerification/ApiProvider")
local PersonaInquiryService = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/OdpVerification/PersonaInquiryService")

return (React.createContext({
	api = ApiProvider,
	personaInquiryService = PersonaInquiryService,
	openWebView = WebViewUtils.openWebViewSession,
	externalBrowser = ExternalBrowser
}))
