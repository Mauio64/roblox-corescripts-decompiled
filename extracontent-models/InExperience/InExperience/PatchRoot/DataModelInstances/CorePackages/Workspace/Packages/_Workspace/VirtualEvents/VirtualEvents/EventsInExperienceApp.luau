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

local EventInExperiencePrompts = require(parent.Components.CoreUI.EventInExperiencePrompts)

local function fn(p, p2)
	local element = React.createElement(CoreScriptsRootProvider, {}, {
		RoactServicesProvider = React.createElement(roactServices.ServiceProvider, {
			services = {
				[RoactNetworking] = requestInternalWrapper(HttpService)
			}
		}, p2)
	})

	local element2 = React.createElement("Folder", nil, element)
	return RoactCompat.mount(element2, p, "EventsInExperienceRoot")
end

return {
	createApp = function()
		local app = { _coreUiHandle = nil }

		function app.mountCoreUI(p)
			app._coreUiHandle = fn(p, {
				EventInExperiencePrompts = React.createElement(EventInExperiencePrompts)
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
