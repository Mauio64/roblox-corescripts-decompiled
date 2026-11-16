local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local GetPlaytestLoadingStore = require(parent.BuildExperiencePlaytestLaunch.GetPlaytestLoadingStore)
require(parent.BuildExperiencePlaytestLaunch.createPlaytestLoadingStore)
local PlaytestStatusIndicator = require(script.Parent.PlaytestStatusIndicator)

local function getStatusForPlaceId(p, placeId: number, playtestLoadingStore)
	return (playtestLoadingStore or GetPlaytestLoadingStore(p)).getStatusForPlaceId(placeId)(p)
end

local function PlaytestStatusIndicatorForPlace(props)
	local v = React.useCallback(function(p)
		return getStatusForPlaceId(p, props.placeId, props.playtestLoadingStore)
	end, { props.placeId, props.playtestLoadingStore })
	local status = SignalsReact.useSignalState(v)

	return React.createElement(PlaytestStatusIndicator, {
		LayoutOrder = props.LayoutOrder,
		status = status
	})
end

return PlaytestStatusIndicatorForPlace
