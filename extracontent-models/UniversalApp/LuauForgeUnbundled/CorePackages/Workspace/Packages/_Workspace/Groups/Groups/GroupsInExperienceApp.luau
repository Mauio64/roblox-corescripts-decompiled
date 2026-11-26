local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Roact")
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/RoactServiceTags").RoactNetworking
local roactServices = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/RoactServices").RoactServices
local requestInternalWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Http").NetworkLayers.requestInternalWrapper

local coreScriptsRootProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/CoreScriptsRoactCommon").CoreScriptsRootProvider

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Components/CoreUI/GroupInExperiencePrompts")

local function fn(p2, p3)
	return Roact.mount(React.createElement(coreScriptsRootProvider, {}, {
		RoactServicesProvider = React.createElement(roactServices.ServiceProvider, {
			services = {
				[roactNetworking] = requestInternalWrapper(HttpService)
			}
		}, p3)
	}), p2, "GroupsInExperienceRoot")
end

return {
	createApp = function()
		local app = { _coreUiHandle = nil }

		function app.mountCoreUI(p2)
			app._coreUiHandle = fn(p2, {
				GroupInExperiencePrompts = React.createElement(module3)
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
