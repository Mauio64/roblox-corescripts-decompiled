local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local Constants = require(Modules.AvatarExperience.Common.Constants)
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2

require(script.Parent.createFaeFeatureAccessStore)

return function(p1) -- line: 28
	-- upvalues: useRoactService (copy), RoactNetworking (copy), React (copy), sendAXCounterV2 (copy), Constants (copy), useSignalState (copy)
	local v10 = useRoactService(RoactNetworking)

	React.useEffect(function() -- line: 31
		-- upvalues: p1 (copy), v10 (copy), sendAXCounterV2 (copy), Constants (copy)
		if p1.getFetchStatus(false) ~= "idle" then
			return
		end

		p1.fetch(v10):catch(function(p2) -- line: 35
			-- upvalues: sendAXCounterV2 (copy), Constants (copy)
			if p2 then
				sendAXCounterV2(Constants.Counter.Errors.FetchFaeFeatureAccessError)
			end
		end)
	end, {
		p1,
		v10
	})

	local v11 = useSignalState(p1.getCanClaimFaeItem)
	local v12 = useSignalState(p1.getShowFaeUpsell)
	local v13 = useSignalState(p1.getFetchStatus)

	return {
		canClaimFaeItem = v11,
		showFaeUpsell = v12,
		fetchStatus = v13
	}
end
