local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local HttpService = game:GetService("HttpService")
local React = require(scriptParentParent.React)
local RoactCompat = require(scriptParentParent.RoactCompat)
local RoactNetworking = require(scriptParentParent.RoactServiceTags).RoactNetworking
local RoactServices = require(scriptParentParent.RoactServices).RoactServices
local requestInternalWrapper = require(scriptParentParent.Http).NetworkLayers.requestInternalWrapper
local CoreScriptsRootProvider = require(scriptParentParent.CoreScriptsRoactCommon).CoreScriptsRootProvider
local GroupInExperiencePrompts = require(scriptParent.Components.CoreUI.GroupInExperiencePrompts)
local t1 = {}

local function v12(p1, t2: {[any]: any}) -- line: 27
	-- upvalues: RoactCompat (copy), React (copy), CoreScriptsRootProvider (copy), RoactServices (copy), RoactNetworking (copy), requestInternalWrapper (copy), HttpService (copy)
	return RoactCompat.mount(React.createElement(CoreScriptsRootProvider, {}, {
		RoactServicesProvider = React.createElement(RoactServices.ServiceProvider, {
			services = {
				[RoactNetworking] = requestInternalWrapper(HttpService)
			}
		}, t2)
	}), p1, "GroupsInExperienceRoot")
end

function t1.createApp() -- line: 41
	-- upvalues: v12 (copy), React (copy), GroupInExperiencePrompts (copy), RoactCompat (copy)
	local t3 = {
		_coreUiHandle = nil
	}

	function t3.mountCoreUI(p2) -- line: 46
		-- upvalues: t3 (copy), v12 (copy), React (copy), GroupInExperiencePrompts (copy)
		t3._coreUiHandle = v12(p2, {
			GroupInExperiencePrompts = React.createElement(GroupInExperiencePrompts)
		})
	end
	function t3.unMountCoreUI() -- line: 52
		-- upvalues: t3 (copy), RoactCompat (copy)
		if t3._coreUiHandle then
			RoactCompat.unmount(t3._coreUiHandle)
			t3._coreUiHandle = nil
		end
	end

	return t3
end

return t1
