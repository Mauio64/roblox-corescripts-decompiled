local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SignalsReact").useSignalState

local useNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Hooks.useNetworking
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics").sendAXCounterV2

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Constants")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/GetFaeFeatureAccessStore/createFaeFeatureAccessStore")

return function(data)
	local v5 = useNetworking()

	React.useEffect(function()
		if data.getFetchStatus(false) ~= "idle" then
			return
		end

		data.fetch(v5):catch(function(p2)
			if p2 then
				sendAXCounterV2(Constants.COUNTERS.FetchFaeFeatureAccessError)
			end
		end)
	end, { data, v5 })

	return {
		canClaimFaeItem = useSignalState(data.getCanClaimFaeItem),
		showFaeUpsell = useSignalState(data.getShowFaeUpsell),
		fetchStatus = useSignalState(data.getFetchStatus)
	}
end
