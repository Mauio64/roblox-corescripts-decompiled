local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local GetPlaytestLoadingStore = require(BuildExperience.Stores.GetPlaytestLoadingStore)

local function getIsPlaytestLoadingForPlaceId(p1, n1: number?) -- line: 19
	-- upvalues: GetPlaytestLoadingStore (copy)
	local v10 = GetPlaytestLoadingStore(p1)

	if n1 == nil then
		return false
	end

	return v10.getIsPlaytestLoadingForPlaceId(n1)(p1)
end
local function useChatPlaytestFooter(t1: {[any]: any}, s1: string) -- line: 27
	-- upvalues: React (copy), getIsPlaytestLoadingForPlaceId (copy), SignalsReact (copy)
	local launchPlaytest = t1.launchPlaytest
	local v14 = React.useCallback(function(p2) -- line: 29
		-- upvalues: getIsPlaytestLoadingForPlaceId (copy), t1 (copy)
		return getIsPlaytestLoadingForPlaceId(p2, t1.playtestPlaceId)
	end, { t1.playtestPlaceId })
	local v15 = SignalsReact.useSignalState(v14)
	local v16 = React.useCallback(function() -- line: 34
		-- upvalues: launchPlaytest (copy), v15 (copy), s1 (copy)
		if not launchPlaytest or v15 then
			return
		end

		launchPlaytest(s1)
	end, {
		v15,
		launchPlaytest,
		s1
	})

	return {
		onPlaytest = if t1.playtestPlaceId == nil or not launchPlaytest then nil else v16,
		isPlaytestLoading = v15
	}
end

return useChatPlaytestFooter
