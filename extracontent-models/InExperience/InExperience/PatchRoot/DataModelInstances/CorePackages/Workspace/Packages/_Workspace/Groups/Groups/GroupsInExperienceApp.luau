local parent = script.Parent
local parent2 = parent.Parent

local HttpService = game:GetService("HttpService")

local React = require(parent2.React)
local RoactCompat = require(parent2.RoactCompat)
local RoactServiceTags = require(parent2.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactServices = require(parent2.RoactServices)
local roactServices = RoactServices.RoactServices
local Http = require(parent2.Http)
local requestInternalWrapper = Http.NetworkLayers.requestInternalWrapper

local CoreScriptsRoactCommon = require(parent2.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider

local GroupInExperiencePrompts = require(parent.Components.CoreUI.GroupInExperiencePrompts)

local function fn(p, p2)
	return RoactCompat.mount(React.createElement(CoreScriptsRootProvider, {}, {
		RoactServicesProvider = React.createElement(roactServices.ServiceProvider, {
			services = {
				[RoactNetworking] = requestInternalWrapper(HttpService)
			}
		}, p2)
	}), p, "GroupsInExperienceRoot")
end

return {
	createApp = function()
		local app = { _coreUiHandle = nil }

		function app.mountCoreUI(p)
			app._coreUiHandle = fn(p, {
				GroupInExperiencePrompts = React.createElement(GroupInExperiencePrompts)
			})
		end

		function app.unMountCoreUI()
			if app._coreUiHandle then
				RoactCompat.unmount(app._coreUiHandle)
				app._coreUiHandle = nil
			end
		end

		return app
	end
}
