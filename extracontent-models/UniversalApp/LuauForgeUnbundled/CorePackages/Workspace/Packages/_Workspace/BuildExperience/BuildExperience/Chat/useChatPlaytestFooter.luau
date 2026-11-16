local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local GetPlaytestLoadingStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/GetPlaytestLoadingStore")

local function getIsPlaytestLoadingForPlaceId(p2, playtestPlaceId)
	local v5 = GetPlaytestLoadingStore(p2)

	if playtestPlaceId == nil then
		return false
	end

	return v5.getIsPlaytestLoadingForPlaceId(playtestPlaceId)(p2)
end

local function useChatPlaytestFooter(p2, p3)
	local launchPlaytest = p2.launchPlaytest
	local v5 = React.useCallback(function(p4)
		return getIsPlaytestLoadingForPlaceId(p4, p2.playtestPlaceId)
	end, { p2.playtestPlaceId })
	local v6 = SignalsReact.useSignalState(v5)

	local v7 = React.useCallback(function()
		if launchPlaytest and not v6 then
			launchPlaytest(p3)
		end
	end, { v6, launchPlaytest, p3 })

	if p2.playtestPlaceId == nil or not launchPlaytest then
		v7 = nil
	end

	return { onPlaytest = v7, isPlaytestLoading = v6 }
end

return useChatPlaytestFooter
