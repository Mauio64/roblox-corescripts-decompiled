local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local HttpService = game:GetService("HttpService")
local CoreScriptsRootProvider = require(scriptParentParent.CoreScriptsRoactCommon).CoreScriptsRootProvider
local React = require(scriptParentParent.React)
local RoactCompat = require(scriptParentParent.RoactCompat)
local RoactNetworking = require(scriptParentParent.RoactServiceTags).RoactNetworking
local RoactServices = require(scriptParentParent.RoactServices).RoactServices
local SelfieConsentConnection = require(scriptParent.SelfieConsentConnection)
local requestInternalWrapper = require(scriptParentParent.Http).NetworkLayers.requestInternalWrapper
local t1 = {}

local function v12(p1, t2: {[any]: any}) -- line: 18
	-- upvalues: React (copy), CoreScriptsRootProvider (copy), RoactServices (copy), RoactNetworking (copy), requestInternalWrapper (copy), HttpService (copy), RoactCompat (copy)
	local v15 = React.createElement(CoreScriptsRootProvider, {}, {
		RoactServicesProvider = React.createElement(RoactServices.ServiceProvider, {
			services = {
				[RoactNetworking] = requestInternalWrapper(HttpService)
			}
		}, t2)
	})
	local v16 = React.createElement("Folder", nil, v15)

	return RoactCompat.mount(v16, p1, "SelfieConsentRoot")
end

function t1.createDialog() -- line: 30
	-- upvalues: v12 (copy), React (copy), SelfieConsentConnection (copy)
	local t3 = {}

	function t3.mountCoreUI(p2) -- line: 33
		-- upvalues: t3 (copy), v12 (copy), React (copy), SelfieConsentConnection (copy)
		t3._coreUiHandle = v12(p2, {
			SelfieConsent = React.createElement(SelfieConsentConnection, {})
		})
	end

	return t3
end

return t1
