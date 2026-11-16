local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2

local Constants = require(AvatarExperienceCatalog.Constants)

require(script.Parent.createFaeFeatureAccessStore)

return function(data)
	local v = useNetworking()

	React.useEffect(function()
		if data.getFetchStatus(false) ~= "idle" then
			return
		end

		data.fetch(v):catch(function(p)
			if p then
				sendAXCounterV2(Constants.COUNTERS.FetchFaeFeatureAccessError)
			end
		end)
	end, { data, v })

	return {
		canClaimFaeItem = useSignalState(data.getCanClaimFaeItem),
		showFaeUpsell = useSignalState(data.getShowFaeUpsell),
		fetchStatus = useSignalState(data.getFetchStatus)
	}
end
