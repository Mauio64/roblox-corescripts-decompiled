local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Roact")
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RoactServiceTags").RoactNetworking
local roactServices = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RoactServices").RoactServices
local requestInternalWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Http").NetworkLayers.requestInternalWrapper

local coreScriptsRootProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/CoreScriptsRoactCommon").CoreScriptsRootProvider

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/CoreUI/EventInExperiencePrompts")

local function fn(p2, p3)
	local element = React.createElement(coreScriptsRootProvider, {}, {
		RoactServicesProvider = React.createElement(roactServices.ServiceProvider, {
			services = {
				[roactNetworking] = requestInternalWrapper(HttpService)
			}
		}, p3)
	})

	local element2 = React.createElement("Folder", nil, element)
	return Roact.mount(element2, p2, "EventsInExperienceRoot")
end

return {
	createApp = function()
		local app = { _coreUiHandle = nil }

		function app.mountCoreUI(p2)
			app._coreUiHandle = fn(p2, {
				EventInExperiencePrompts = React.createElement(module3)
			})
		end

		function app.unMountCoreUI()
			if app._coreUiHandle then
				Roact.unmount(app._coreUiHandle)
				app._coreUiHandle = nil
			end
		end

		return app
	end
}
