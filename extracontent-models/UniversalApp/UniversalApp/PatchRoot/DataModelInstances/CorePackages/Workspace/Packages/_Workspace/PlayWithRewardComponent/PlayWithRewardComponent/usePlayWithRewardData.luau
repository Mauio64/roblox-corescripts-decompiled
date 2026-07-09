local AdService = game:GetService("AdService")
local PlayWithRewardComponent = script:FindFirstAncestor("PlayWithRewardComponent")
local FetchPlayWithRewardState = require(PlayWithRewardComponent.FetchPlayWithRewardState)
local shouldRenderPlayWithRewardBanner = require(PlayWithRewardComponent.shouldRenderPlayWithRewardBanner)
local PlayWithRewardComponentParent = PlayWithRewardComponent.Parent
local PlayWithRewardState = require(PlayWithRewardComponentParent.PlayWithRewardState)
local React = require(PlayWithRewardComponentParent.React)
local RoactUtils = require(PlayWithRewardComponentParent.RoactUtils)
local SetPlayWithRewardState = PlayWithRewardState.SetPlayWithRewardState
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local function usePlayWithRewardData(t1: {[any]: any}) -- line: 27
	-- upvalues: useSelector (copy), useDispatch (copy), React (copy), FetchPlayWithRewardState (copy), AdService (copy), SetPlayWithRewardState (copy), shouldRenderPlayWithRewardBanner (copy)
	local universeId = t1.universeId
	local shouldFetch = t1.shouldFetch
	local v16 = useSelector(function(p1) -- line: 31
		-- upvalues: universeId (copy)
		if p1.PlayWithRewardState and p1.PlayWithRewardState.universeId == universeId then
			return p1.PlayWithRewardState
		end

		return nil
	end)
	local v17 = useSelector(function(p2) -- line: 37
		return p2.LocalUserId
	end)
	local v18 = useDispatch()
	local onFetchDispatched = t1.onFetchDispatched

	React.useEffect(function() -- line: 43
		-- upvalues: shouldFetch (copy), v17 (copy), v16 (copy), universeId (copy), onFetchDispatched (copy), v18 (copy), FetchPlayWithRewardState (copy), AdService (copy)
		if not shouldFetch then
			return
		end

		local num = tonumber(v17)

		if not num then
			return
		end

		if v16 and v16.universeId == universeId then
			return
		end

		if onFetchDispatched then
			onFetchDispatched()
		end

		v18(FetchPlayWithRewardState(AdService, universeId, num)):catch(function() -- line: 57
		end)
	end, {
		shouldFetch,
		universeId,
		v17,
		v16,
		v18,
		onFetchDispatched
	})
	React.useEffect(function() -- line: 60
		-- upvalues: v18 (copy), SetPlayWithRewardState (copy)
		return function() -- line: 61
			-- upvalues: v18 (copy), SetPlayWithRewardState (copy)
			v18(SetPlayWithRewardState("", "", false, nil))
		end
	end, { v18 })

	local v20 = false

	if v16 then
		local flowId = v16.flowId
		local universeId2 = v16.universeId
		local adData = v16.adData

		v20 = flowId ~= "" and v16.isAdDataExpected or shouldRenderPlayWithRewardBanner(universeId, flowId, universeId2, adData)
	end

	return {
		playWithRewardData = v16,
		showPlayWithReward = v20
	}
end

return usePlayWithRewardData
