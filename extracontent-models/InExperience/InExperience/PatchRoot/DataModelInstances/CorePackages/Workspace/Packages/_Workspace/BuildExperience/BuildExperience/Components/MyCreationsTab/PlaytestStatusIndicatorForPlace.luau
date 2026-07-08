local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local GetPlaytestLoadingStore = require(BuildExperience.Stores.GetPlaytestLoadingStore)

require(BuildExperience.Stores.GetPlaytestLoadingStore.createPlaytestLoadingStore)

local PlaytestStatusIndicator = require(script.Parent.PlaytestStatusIndicator)

local function getStatusForPlaceId(p1, n1: number, p2) -- line: 22
	-- upvalues: GetPlaytestLoadingStore (copy)
	return (p2 or GetPlaytestLoadingStore(p1)).getStatusForPlaceId(n1)(p1)
end
local function PlaytestStatusIndicatorForPlace(t1: {[any]: any}) -- line: 31
	-- upvalues: React (copy), getStatusForPlaceId (copy), SignalsReact (copy), PlaytestStatusIndicator (copy)
	local v13 = React.useCallback(function(p3) -- line: 32
		-- upvalues: getStatusForPlaceId (copy), t1 (copy)
		return getStatusForPlaceId(p3, t1.placeId, t1.playtestLoadingStore)
	end, {
		t1.placeId,
		t1.playtestLoadingStore
	})
	local v14 = SignalsReact.useSignalState(v13)

	return React.createElement(PlaytestStatusIndicator, {
		LayoutOrder = t1.LayoutOrder,
		status = v14
	})
end

return PlaytestStatusIndicatorForPlace
