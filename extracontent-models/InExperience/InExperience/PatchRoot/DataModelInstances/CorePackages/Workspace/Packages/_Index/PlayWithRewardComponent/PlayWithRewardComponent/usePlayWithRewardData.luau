local AdService = game:GetService("AdService")
local ExperienceService = game:GetService("ExperienceService")

local PlayWithRewardComponent = script:FindFirstAncestor("PlayWithRewardComponent")
local FetchPlayWithRewardState = require(PlayWithRewardComponent.FetchPlayWithRewardState)
local shouldRenderPlayWithRewardBanner = require(PlayWithRewardComponent.shouldRenderPlayWithRewardBanner)

local parent = PlayWithRewardComponent.Parent
local PlayWithRewardState = require(parent.PlayWithRewardState)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local SharedFlags = require(parent.SharedFlags)

local FFlagPlayWithRewardClearOnExperienceLeave = SharedFlags.FFlagPlayWithRewardClearOnExperienceLeave
local SetPlayWithRewardState = PlayWithRewardState.SetPlayWithRewardState
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local function usePlayWithRewardData(data)
	local universeId = data.universeId
	local shouldFetch = data.shouldFetch

	local playWithRewardData = useSelector(function(p)
		if p.PlayWithRewardState and p.PlayWithRewardState.universeId == universeId then
			return p.PlayWithRewardState
		end

		return nil
	end)

	local v = useSelector(function(p)
		return p.LocalUserId
	end)

	local v2 = useDispatch()
	local ref

	if FFlagPlayWithRewardClearOnExperienceLeave then
		ref = React.useRef(false)
	else
		ref = nil
	end

	local onFetchDispatched = data.onFetchDispatched
	React.useEffect(function()
		if FFlagPlayWithRewardClearOnExperienceLeave then
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

		local v3 = tonumber(v)

		if not v3 or playWithRewardData and playWithRewardData.universeId == universeId then
			return
		end

		if onFetchDispatched then
			onFetchDispatched()
		end

		v2(FetchPlayWithRewardState(AdService, universeId, v3)):catch(function() end)
	end, { shouldFetch, universeId, v, playWithRewardData, v2, onFetchDispatched })

	React.useEffect(function()
		local connection

		if FFlagPlayWithRewardClearOnExperienceLeave then
			connection = ExperienceService:RegisterForExperienceLeave(function()
				ref.current = true
				v2(SetPlayWithRewardState("", "", false, nil))
			end)
		else
			connection = nil
		end

		return function()
			v2(SetPlayWithRewardState("", "", false, nil))

			if connection then
				connection:Disconnect()
			end
		end
	end, { v2 })
	local showPlayWithReward

	if playWithRewardData then
		local flowId = playWithRewardData.flowId
		local universeId2 = playWithRewardData.universeId
		local adData = playWithRewardData.adData
		showPlayWithReward = flowId ~= "" and playWithRewardData.isAdDataExpected
			or shouldRenderPlayWithRewardBanner(universeId, flowId, universeId2, adData)
	else
		showPlayWithReward = false
	end

	return { playWithRewardData = playWithRewardData, showPlayWithReward = showPlayWithReward }
end

return usePlayWithRewardData
