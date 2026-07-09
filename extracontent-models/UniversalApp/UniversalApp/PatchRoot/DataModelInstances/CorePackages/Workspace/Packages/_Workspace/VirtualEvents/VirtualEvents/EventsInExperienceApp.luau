local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local HttpService = game:GetService("HttpService")
local React = require(scriptParentParent.React)
local RoactCompat = require(scriptParentParent.RoactCompat)
local RoactNetworking = require(scriptParentParent.RoactServiceTags).RoactNetworking
local RoactServices = require(scriptParentParent.RoactServices).RoactServices
local requestInternalWrapper = require(scriptParentParent.Http).NetworkLayers.requestInternalWrapper
local CoreScriptsRootProvider = require(scriptParentParent.CoreScriptsRoactCommon).CoreScriptsRootProvider
local EventInExperiencePrompts = require(scriptParent.Components.CoreUI.EventInExperiencePrompts)
local v11 = game:DefineFastFlag("EventsInExperienceAppFixStyleLink", false)
local t1 = {}

local function v13(p1, t2: {[any]: any}) -- line: 29
	-- upvalues: React (copy), CoreScriptsRootProvider (copy), RoactServices (copy), RoactNetworking (copy), requestInternalWrapper (copy), HttpService (copy), v11 (copy), RoactCompat (copy)
	local v16 = React.createElement(CoreScriptsRootProvider, {}, {
		RoactServicesProvider = React.createElement(RoactServices.ServiceProvider, {
			services = {
				[RoactNetworking] = requestInternalWrapper(HttpService)
			}
		}, t2)
	})

	if v11 then
		v16 = React.createElement("Folder", nil, v16)
	end

	return RoactCompat.mount(v16, p1, "EventsInExperienceRoot")
end

function t1.createApp() -- line: 43
	-- upvalues: v13 (copy), React (copy), EventInExperiencePrompts (copy), RoactCompat (copy)
	local t3 = {
		_coreUiHandle = nil
	}

	function t3.mountCoreUI(p2) -- line: 48
		-- upvalues: t3 (copy), v13 (copy), React (copy), EventInExperiencePrompts (copy)
		t3._coreUiHandle = v13(p2, {
			EventInExperiencePrompts = React.createElement(EventInExperiencePrompts)
		})
	end
	function t3.unMountCoreUI() -- line: 54
		-- upvalues: t3 (copy), RoactCompat (copy)
		if t3._coreUiHandle then
			RoactCompat.unmount(t3._coreUiHandle)
			t3._coreUiHandle = nil
		end
	end

	return t3
end

return t1
