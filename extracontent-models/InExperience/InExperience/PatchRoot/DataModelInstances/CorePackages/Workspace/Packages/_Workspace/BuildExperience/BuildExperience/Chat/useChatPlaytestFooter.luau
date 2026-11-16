local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local GetPlaytestLoadingStore = require(parent.BuildExperiencePlaytestLaunch.GetPlaytestLoadingStore)

local function getIsPlaytestLoadingForPlaceId(p, playtestPlaceId: number?)
	local playtestLoadingStore = GetPlaytestLoadingStore(p)

	if playtestPlaceId == nil then
		return false
	end

	return playtestLoadingStore.getIsPlaytestLoadingForPlaceId(playtestPlaceId)(p)
end

local function useChatPlaytestFooter(p, p2: string)
	local launchPlaytest = p.launchPlaytest
	local v = React.useCallback(function(p3)
		return getIsPlaytestLoadingForPlaceId(p3, p.playtestPlaceId)
	end, { p.playtestPlaceId })
	local isPlaytestLoading = SignalsReact.useSignalState(v)

	local onPlaytest = React.useCallback(function()
		if launchPlaytest and not isPlaytestLoading then
			launchPlaytest(p2)
		end
	end, { isPlaytestLoading, launchPlaytest, p2 })

	if p.playtestPlaceId == nil or not launchPlaytest then
		onPlaytest = nil
	end

	return { onPlaytest = onPlaytest, isPlaytestLoading = isPlaytestLoading }
end

return useChatPlaytestFooter
