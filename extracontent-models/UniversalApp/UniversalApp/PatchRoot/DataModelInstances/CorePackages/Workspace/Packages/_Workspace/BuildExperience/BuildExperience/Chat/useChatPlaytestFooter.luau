local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local GetPlaytestLoadingStore = require(BuildExperience.Stores.GetPlaytestLoadingStore)

local function getIsPlaytestLoadingForPlaceId(p1, n1: number?) -- line: 21
	-- upvalues: GetPlaytestLoadingStore (copy)
	if n1 == nil then
		return false
	end

	return GetPlaytestLoadingStore(p1).getIsPlaytestLoadingForPlaceId(n1)(p1)
end
local function useChatPlaytestFooter(t1: {[any]: any}, s1: string) -- line: 28
	-- upvalues: React (copy), getIsPlaytestLoadingForPlaceId (copy), SignalsReact (copy)
	local launchPlaytest = t1.launchPlaytest
	local v13 = React.useCallback(function(p2) -- line: 30
		-- upvalues: getIsPlaytestLoadingForPlaceId (copy), t1 (copy)
		return getIsPlaytestLoadingForPlaceId(p2, t1.playtestPlaceId)
	end, { t1.playtestPlaceId })
	local v14 = SignalsReact.useSignalState(v13)
	local v15 = React.useCallback(function() -- line: 35
		-- upvalues: launchPlaytest (copy), v14 (copy), s1 (copy)
		if not launchPlaytest or v14 then
			return
		end

		launchPlaytest(s1)
	end, {
		v14,
		launchPlaytest,
		s1
	})

	return {
		onPlaytest = if t1.playtestPlaceId == nil or not launchPlaytest then nil else v15,
		isPlaytestLoading = v14
	}
end

return useChatPlaytestFooter
