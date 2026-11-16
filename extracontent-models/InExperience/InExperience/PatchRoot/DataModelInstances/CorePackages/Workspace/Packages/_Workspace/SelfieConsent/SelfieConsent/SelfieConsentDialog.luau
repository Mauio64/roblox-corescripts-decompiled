local parent = script.Parent
local parent2 = parent.Parent

local HttpService = game:GetService("HttpService")

local CoreScriptsRoactCommon = require(parent2.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider
local React = require(parent2.React)
local RoactCompat = require(parent2.RoactCompat)
local RoactServiceTags = require(parent2.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactServices = require(parent2.RoactServices)
local roactServices = RoactServices.RoactServices

local SelfieConsentConnection = require(parent.SelfieConsentConnection)

local Http = require(parent2.Http)
local requestInternalWrapper = Http.NetworkLayers.requestInternalWrapper

local function fn(p, p2)
	local element = React.createElement(CoreScriptsRootProvider, {}, {
		RoactServicesProvider = React.createElement(roactServices.ServiceProvider, {
			services = {
				[RoactNetworking] = requestInternalWrapper(HttpService)
			}
		}, p2)
	})

	local element2 = React.createElement("Folder", nil, element)
	return RoactCompat.mount(element2, p, "SelfieConsentRoot")
end

return {
	createDialog = function()
		local dialog = {}

		function dialog.mountCoreUI(p)
			dialog._coreUiHandle = fn(p, {
				SelfieConsent = React.createElement(SelfieConsentConnection, {})
			})
		end
		return dialog
	end
}
