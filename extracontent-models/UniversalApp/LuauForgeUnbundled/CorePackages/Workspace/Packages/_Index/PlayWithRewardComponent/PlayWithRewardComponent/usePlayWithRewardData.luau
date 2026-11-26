local AdService = game:GetService("AdService")
local ExperienceService = game:GetService("ExperienceService")

local FetchPlayWithRewardState = require("@game/CorePackages/Workspace/Packages/_Index/PlayWithRewardComponent/PlayWithRewardComponent/FetchPlayWithRewardState")
local shouldRenderPlayWithRewardBanner = require("@game/CorePackages/Workspace/Packages/_Index/PlayWithRewardComponent/PlayWithRewardComponent/shouldRenderPlayWithRewardBanner")

local PlayWithRewardState = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/PlayWithRewardState")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/RoactUtils")
local fFlagPlayWithRewardClearOnExperienceLeave = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/SharedFlags").FFlagPlayWithRewardClearOnExperienceLeave
local setPlayWithRewardState = PlayWithRewardState.SetPlayWithRewardState
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local function usePlayWithRewardData(data)
	local universeId = data.universeId
	local shouldFetch = data.shouldFetch

	local v5 = useSelector(function(p2)
		if p2.PlayWithRewardState and p2.PlayWithRewardState.universeId == universeId then
			return p2.PlayWithRewardState
		end

		return nil
	end)

	local v6 = useSelector(function(p2)
		return p2.LocalUserId
	end)

	local v7 = useDispatch()

	local ref = if fFlagPlayWithRewardClearOnExperienceLeave then React.useRef(false) else nil

	local onFetchDispatched = data.onFetchDispatched
	React.useEffect(function()
		if fFlagPlayWithRewardClearOnExperienceLeave then
			if shouldFetch or ref.current then
				if ref.current then
					ref.current = false
				end
			else
				return
			end
		elseif not shouldFetch then
			return
		end

		local v8 = tonumber(v6)

		if not v8 or v5 and v5.universeId == universeId then
			return
		end

		if onFetchDispatched then
			onFetchDispatched()
		end

		v7(FetchPlayWithRewardState(AdService, universeId, v8)):catch(function() end)
	end, { shouldFetch, universeId, v6, v5, v7, onFetchDispatched })

	React.useEffect(function()
		local connection

		if fFlagPlayWithRewardClearOnExperienceLeave then
			connection = ExperienceService:RegisterForExperienceLeave(function()
				ref.current = true
				v7(setPlayWithRewardState("", "", false, nil))
			end)
		else
			connection = nil
		end

		return function()
			v7(setPlayWithRewardState("", "", false, nil))

			if connection then
				connection:Disconnect()
			end
		end
	end, { v7 })
	local v8

	if v5 then
		local flowId = v5.flowId
		local universeId2 = v5.universeId
		local adData = v5.adData
		v8 = flowId ~= "" and v5.isAdDataExpected or shouldRenderPlayWithRewardBanner(universeId, flowId, universeId2, adData)
	else
		v8 = false
	end

	return { playWithRewardData = v5, showPlayWithReward = v8 }
end

return usePlayWithRewardData
