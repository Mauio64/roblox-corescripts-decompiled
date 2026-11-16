local parent = script:FindFirstAncestor("InExperienceTopBar").Parent

local DataHydration = require(parent.DataHydration)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
require(script.Parent.ExperienceAgeRatingBadgeView)
local DataStatus = DataHydration.DataStatus

local function useExperienceAgeRatingBadgeViewModel(data)
	local universeId = data.universeId

	local v = React.useMemo(function()
		return Signals.createComputed(function(p)
			local fetchAgeRecommendation = DataHydration.Game.getAgeRecommendationStore(p).getAndFetchAgeRecommendation(universeId)
			local status = fetchAgeRecommendation.status(p)

			if status == DataStatus.Failed then
				return "12+"
			end

			if status == DataStatus.NotReady then
				return nil
			end

			local data2 = fetchAgeRecommendation.data(p)
			return data2 and data2.minimumAgeDisplay or "12+"
		end)
	end, { universeId })
	local text = SignalsReact.useSignalState(v)

	if text == nil then
		return nil
	end

	return {
		text = text,
		layoutOrder = data.layoutOrder,
		onAbsoluteSizeChanged = data.onAbsoluteSizeChanged,
		onAbsolutePositionChanged = data.onAbsolutePositionChanged
	}
end

return useExperienceAgeRatingBadgeViewModel
