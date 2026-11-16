local PlayButtonStates = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonStates")
local FetchGamePlayButtonData = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/FetchGamePlayButtonData")
local ApiPostPreparePurchase = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/ApiPostPreparePurchase")
local PlaytestUnlockUpsell = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlaytestUnlockUpsell")

local fFlagEnableGameJoinEarlyAccess = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagEnableGameJoinEarlyAccess
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").GetFFlagIsSquadEnabled

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/PlayabilityRodux")
local playabilityStatusEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryTypes").PlayabilityStatusEnum
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Http").Enum.RetrievalStatus
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local fetchGamePlayabilityAndProductInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameDetailRodux").FetchGamePlayabilityAndProductInfo
local gamesProductInfoReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameProductInfoRodux").GamesProductInfoReducer
local useCurrentSquadSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoduxSquads").Hooks.useCurrentSquadSelector
local useIsExperienceInvitePending = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/Squads/useIsExperienceInvitePending")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/UniversalAppPolicy").useAppPolicy
local useRouteName = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Navigation").useRouteName
local sendPlayButtonLoadingDuration = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryAnalytics").Events.sendPlayButtonLoadingDuration

local fFlagLuaAppParentUpsellPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppParentUpsellPolicy

local fFlagLuaAppEnablePlayableStateWhenLoading = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppEnablePlayableStateWhenLoading

local fFlagLuaAppSupportDisablePlayableWhenLoading = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppSupportDisablePlayableWhenLoading

local fFlagLuaAppDisablePlayableWhenLoadingForce = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppDisablePlayableWhenLoadingForce
local fFlagLuaAppPlayButtonAmpAgeCheckFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonAmpAgeCheckFlow
local fFlagLuaAppParentApprovedExperiences = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppParentApprovedExperiences

local fFlagLuaAppPlayButtonLoadingDurationTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonLoadingDurationTelemetry

local fFlagLuaAppPlayButtonPrivatePTEnableSingleButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonPrivatePTEnableSingleButton

local fFlagLuaAppPlayButtonPrivatePTEnableDualButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonPrivatePTEnableDualButton
local defineFastFlag = game:DefineFastFlag("LuaAppPlaytestSingleBlocksPlayable", false)

local function selectPlayButtonState(p2, data, p3, p4, p5, p6, p7, p8)
	local v5

	if p2 == retrievalStatus.Done and data ~= nil then
		local v6

		if fFlagLuaAppPlayButtonPrivatePTEnableSingleButton then
			if data.privatePlaytestInfo == nil then
				v6 = false
			else
				v6 = not data.privatePlaytestInfo.isPlayable
					and PlaytestUnlockUpsell.getType(data.privatePlaytestInfo.playabilityStatus) ~= nil
			end
		end

		if data.isPlayable == true and not (defineFastFlag and v6) then
			v5 = PlayButtonStates.Playable
		elseif fFlagLuaAppPlayButtonPrivatePTEnableSingleButton and v6 then
			v5 = PlayButtonStates.ActionNeeded
		elseif
			data.playabilityStatus == playabilityStatusEnum.PurchaseRequired
			and p3 ~= nil
			and p3.isForSale == true
		then
			v5 = PlayButtonStates.PaidAccess
		elseif
			data.playabilityStatus == playabilityStatusEnum.FiatPurchaseRequired
			and p3 ~= nil
			and p3.isForSale == true
		then
			v5 = PlayButtonStates.FiatPaidAccess
		elseif
			fFlagLuaAppPlayButtonAmpAgeCheckFlow
			and (data.playabilityStatus == playabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser or (not fFlagLuaAppParentUpsellPolicy or p7) and (data.playabilityStatus == playabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls or fFlagLuaAppParentApprovedExperiences and data.playabilityStatus == playabilityStatusEnum.ContextualPlayabilityRequireParentApproval) or data.playabilityStatus == playabilityStatusEnum.ContextualPlayabilityAgeCheckRequired)
		then
			v5 = PlayButtonStates.ActionNeeded
		elseif
			fFlagLuaAppPlayButtonAmpAgeCheckFlow
			or data.playabilityStatus ~= playabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser
		then
			if
				fFlagLuaAppPlayButtonAmpAgeCheckFlow
				or fFlagLuaAppParentUpsellPolicy and not p7
				or data.playabilityStatus ~= playabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls
				and (not fFlagLuaAppParentApprovedExperiences or data.playabilityStatus ~= playabilityStatusEnum.ContextualPlayabilityRequireParentApproval)
			then
				if
					fFlagEnableGameJoinEarlyAccess
					and p8
					and data.playabilityStatus == playabilityStatusEnum.PlusSubscriptionRequired
				then
					v5 = PlayButtonStates.EarlyAccessLocked
				else
					v5 = PlayButtonStates.UnplayableOther
				end
			else
				v5 = PlayButtonStates.ActionNeeded
			end
		else
			v5 = PlayButtonStates.ActionNeeded
		end
	else
		v5 = PlayButtonStates.Playable
	end

	if
		not getFFlagIsSquadEnabled()
		or v5 ~= PlayButtonStates.Playable
		or not p4
		or not (#p4.members > 1)
		or p6 and p6.maxPlayers and not (p6.maxPlayers > 1)
	then
		return v5
	end

	if p5 then
		return PlayButtonStates.WaitingForParty
	end

	v5 = PlayButtonStates.PlayableWithParty

	return v5
end

local function selectSecondaryPlayButtonState(p2, data)
	if data == nil then
		return nil
	end

	if fFlagLuaAppPlayButtonPrivatePTEnableDualButton and data.privatePlaytestInfo ~= nil then
		local privatePlaytestInfo = data.privatePlaytestInfo
		local kind = PlaytestUnlockUpsell.getType(privatePlaytestInfo.playabilityStatus)

		if p2 == PlayButtonStates.ActionNeeded then
			return nil
		end

		if privatePlaytestInfo.isPlayable or kind ~= nil then
			return PlayButtonStates.Playtest
		end
	end

	local v5

	if
		p2 == PlayButtonStates.PaidAccess
		or p2 == PlayButtonStates.FiatPaidAccess
		or data.playabilityStatus == playabilityStatusEnum.FiatPurchaseDeviceRestricted
		and p2 == PlayButtonStates.UnplayableOther
	then
		v5 = true
	elseif data.playabilityStatus == playabilityStatusEnum.ContextualPlayabilityRegionalAvailability then
		v5 = p2 == PlayButtonStates.UnplayableOther
	else
		v5 = false
	end

	if v5 and data.demoModeAvailable then
		return PlayButtonStates.DemoMode
	end

	return nil
end

return function(p2, current, duration, p3, p4, current2, p5)
	local v5 = useDispatch()

	React.useEffect(function()
		local thread = nil

		if duration == nil or not (duration > 0) then
			v5(FetchGamePlayButtonData.Fetch(p2, current))
		else
			thread = task.delay(duration, function()
				thread = nil
				v5(FetchGamePlayButtonData.Fetch(p2, current))
			end)
		end

		return function()
			if thread ~= nil then
				task.cancel(thread)
			end
		end
	end, { current, duration })
	local v6

	if fFlagLuaAppParentUpsellPolicy then
		v6 = useAppPolicy(function(p6)
			return p6.getShouldShowVpcPlayButtonUpsells()
		end)
	else
		v6 = nil
	end

	local v7

	if fFlagLuaAppSupportDisablePlayableWhenLoading then
		local v8 = useAppPolicy(function(p6)
			return p6.getDisablePlayableWhenLoading()
		end)

		v7 = fFlagLuaAppDisablePlayableWhenLoadingForce or v8
	else
		v7 = nil
	end

	local v8 = if getFFlagIsSquadEnabled() then useCurrentSquadSelector() else nil
	local v9 = if getFFlagIsSquadEnabled() then useIsExperienceInvitePending() else nil
	local v10 = useSelector(function(p6)
		return p6.PlayabilityStatus and p6.PlayabilityStatus[current] or nil
	end)
	local v11

	if fFlagEnableGameJoinEarlyAccess then
		v11 = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/EarlyAccess/useGameJoinEarlyAccess")(current, v10)

		local v12 = not (v11 == nil) and v11.isPendingUnlock == true
		local v13 = v11 == nil and 0 or v11.unlockRefetchTick
		local v14 = not (v11 == nil) and v11.gainedSubscription == true
		React.useEffect(function()
			if v12 or v14 then
				v5(FetchGamePlayButtonData.Fetch(p2, current, true))
			end
		end, { v12, v13, v14, current })
	end

	local v12 = useSelector(function(p6)
		if FetchGamePlayButtonData.IsLoading(p6, current) then
			if
				not fFlagLuaAppEnablePlayableStateWhenLoading
				or (not p3 or fFlagLuaAppSupportDisablePlayableWhenLoading and v7)
			then
				return PlayButtonStates.Loading
			end

			if getFFlagIsSquadEnabled() and v8 and #v8.members > 1 then
				if v9 then
					return PlayButtonStates.WaitingForParty
				end

				return PlayButtonStates.PlayableWithParty
			end

			return PlayButtonStates.Playable
		else
			if ApiPostPreparePurchase.GetFetchingStatus(p6, current) == retrievalStatus.Fetching then
				return PlayButtonStates.Loading
			end

			local fetchingStatus = fetchGamePlayabilityAndProductInfo.GetFetchingStatus(p6, current)
			local v13

			if p6[gamesProductInfoReducer.key] then
				v13 = p6[gamesProductInfoReducer.key][current] or nil
			end

			if getFFlagIsSquadEnabled() then
				local gameDetail = p6.GameDetails[current]
				local v18 = if fFlagLuaAppParentUpsellPolicy then v6 else nil
				local v19 = if fFlagEnableGameJoinEarlyAccess then p5 else nil
				return selectPlayButtonState(fetchingStatus, v10, v13, v8, v9, gameDetail, v18, v19)
			else
				local v19 = if fFlagLuaAppParentUpsellPolicy then v6 else nil
				local v20 = if fFlagEnableGameJoinEarlyAccess then p5 else nil
				return selectPlayButtonState(fetchingStatus, v10, v13, nil, nil, nil, v19, v20)
			end
		end
	end)

	if fFlagLuaAppPlayButtonLoadingDurationTelemetry then
		local v13 = useRouteName()

		local ref = React.useRef(nil)
		local ref2 = React.useRef(nil)
		local ref3 = React.useRef(nil)
		local ref4 = React.useRef(nil)

		local ref5 = React.useRef(v12)
		ref5.current = v12

		local ref6 = React.useRef(v10)
		ref6.current = v10

		local v14 = React.useCallback(function(p6)
			local current3 = ref.current
			local current4 = ref2.current
			local current5 = ref3.current

			if not (current3 and current4) then
				return
			end

			ref.current = nil
			ref2.current = nil

			sendPlayButtonLoadingDuration({
				universeId = current4,
				durationMs = math.floor((os.clock() - current3) * 1000),
				endReason = p6,
				endPlayButtonState = ref5.current,
				endPlayabilityStatus = ref6.current and ref6.current.playabilityStatus or nil,
				pageName = ref4.current
			}, current5)

			ref3.current = nil
			ref4.current = nil
		end, {})

		React.useEffect(function()
			if v12 == PlayButtonStates.Loading then
				if not p4 then
					return
				end

				if ref.current then
					if ref2.current ~= current then
						v14("universeChanged")
						ref.current = os.clock()
						ref2.current = current
						ref3.current = current2
						ref4.current = v13
					end
				else
					ref.current = os.clock()
					ref2.current = current
					ref3.current = current2
					ref4.current = v13
				end
			else
				v14("stateChanged")
			end
		end, { v12, v14, current, p4, current2, v13 })

		React.useEffect(function()
			return function()
				v14("unmounted")
			end
		end, { v14 })
	end

	return {
		playButtonState = v12,
		secondaryPlayButtonState = selectSecondaryPlayButtonState(v12, v10),
		playabilityStatus = v10,
		earlyAccess = v11
	}
end
