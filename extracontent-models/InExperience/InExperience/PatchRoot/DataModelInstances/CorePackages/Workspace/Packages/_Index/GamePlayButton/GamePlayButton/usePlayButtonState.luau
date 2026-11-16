local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local PlayButtonStates = require(GamePlayButton.PlayButtonStates)
local FetchGamePlayButtonData = require(GamePlayButton.FetchGamePlayButtonData)
local ApiPostPreparePurchase = require(GamePlayButton.ApiPostPreparePurchase)
local PlaytestUnlockUpsell = require(GamePlayButton.PlaytestUnlockUpsell)

local parent = GamePlayButton.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableGameJoinEarlyAccess = SharedFlags.FFlagEnableGameJoinEarlyAccess
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags2.GetFFlagIsSquadEnabled

local React = require(parent.React)
require(parent.PlayabilityRodux)
local DiscoveryTypes = require(parent.DiscoveryTypes)
local PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum
local Http = require(parent.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local GameDetailRodux = require(parent.GameDetailRodux)
local FetchGamePlayabilityAndProductInfo = GameDetailRodux.FetchGamePlayabilityAndProductInfo
local GameProductInfoRodux = require(parent.GameProductInfoRodux)
local GamesProductInfoReducer = GameProductInfoRodux.GamesProductInfoReducer
local RoduxSquads = require(parent.RoduxSquads)
local useCurrentSquadSelector = RoduxSquads.Hooks.useCurrentSquadSelector
local useIsExperienceInvitePending = require(parent.Squads.useIsExperienceInvitePending)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local Navigation = require(parent.Navigation)
local useRouteName = Navigation.useRouteName
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local sendPlayButtonLoadingDuration = DiscoveryAnalytics.Events.sendPlayButtonLoadingDuration

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppParentUpsellPolicy = SharedFlags3.FFlagLuaAppParentUpsellPolicy

local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppEnablePlayableStateWhenLoading = SharedFlags4.FFlagLuaAppEnablePlayableStateWhenLoading

local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppSupportDisablePlayableWhenLoading = SharedFlags5.FFlagLuaAppSupportDisablePlayableWhenLoading

local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppDisablePlayableWhenLoadingForce = SharedFlags6.FFlagLuaAppDisablePlayableWhenLoadingForce
local SharedFlags7 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonAmpAgeCheckFlow = SharedFlags7.FFlagLuaAppPlayButtonAmpAgeCheckFlow
local SharedFlags8 = require(parent.SharedFlags)
local FFlagLuaAppParentApprovedExperiences = SharedFlags8.FFlagLuaAppParentApprovedExperiences

local SharedFlags9 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonLoadingDurationTelemetry = SharedFlags9.FFlagLuaAppPlayButtonLoadingDurationTelemetry

local SharedFlags10 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonPrivatePTEnableSingleButton = SharedFlags10.FFlagLuaAppPlayButtonPrivatePTEnableSingleButton

local SharedFlags11 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonPrivatePTEnableDualButton = SharedFlags11.FFlagLuaAppPlayButtonPrivatePTEnableDualButton
local defineFastFlag = game:DefineFastFlag("LuaAppPlaytestSingleBlocksPlayable", false)

local function selectPlayButtonState(fetchingStatus, data, p, p2, flag: boolean?, p3, flag2: boolean?, flag3: boolean?)
	local v

	if fetchingStatus == RetrievalStatus.Done and data ~= nil then
		local v2

		if FFlagLuaAppPlayButtonPrivatePTEnableSingleButton then
			if data.privatePlaytestInfo == nil then
				v2 = false
			else
				v2 = not data.privatePlaytestInfo.isPlayable
					and PlaytestUnlockUpsell.getType(data.privatePlaytestInfo.playabilityStatus) ~= nil
			end
		end

		if data.isPlayable == true and not (defineFastFlag and v2) then
			v = PlayButtonStates.Playable
		elseif FFlagLuaAppPlayButtonPrivatePTEnableSingleButton and v2 then
			v = PlayButtonStates.ActionNeeded
		elseif
			data.playabilityStatus == PlayabilityStatusEnum.PurchaseRequired
			and p ~= nil
			and p.isForSale == true
		then
			v = PlayButtonStates.PaidAccess
		elseif
			data.playabilityStatus == PlayabilityStatusEnum.FiatPurchaseRequired
			and p ~= nil
			and p.isForSale == true
		then
			v = PlayButtonStates.FiatPaidAccess
		elseif
			FFlagLuaAppPlayButtonAmpAgeCheckFlow
			and (data.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser or (not FFlagLuaAppParentUpsellPolicy or flag2) and (data.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls or FFlagLuaAppParentApprovedExperiences and data.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval) or data.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityAgeCheckRequired)
		then
			v = PlayButtonStates.ActionNeeded
		elseif
			FFlagLuaAppPlayButtonAmpAgeCheckFlow
			or data.playabilityStatus ~= PlayabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser
		then
			if
				FFlagLuaAppPlayButtonAmpAgeCheckFlow
				or FFlagLuaAppParentUpsellPolicy and not flag2
				or data.playabilityStatus ~= PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls
				and (not FFlagLuaAppParentApprovedExperiences or data.playabilityStatus ~= PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval)
			then
				if
					FFlagEnableGameJoinEarlyAccess
					and flag3
					and data.playabilityStatus == PlayabilityStatusEnum.PlusSubscriptionRequired
				then
					v = PlayButtonStates.EarlyAccessLocked
				else
					v = PlayButtonStates.UnplayableOther
				end
			else
				v = PlayButtonStates.ActionNeeded
			end
		else
			v = PlayButtonStates.ActionNeeded
		end
	else
		v = PlayButtonStates.Playable
	end

	if
		not GetFFlagIsSquadEnabled()
		or v ~= PlayButtonStates.Playable
		or not p2
		or not (#p2.members > 1)
		or p3 and p3.maxPlayers and not (p3.maxPlayers > 1)
	then
		return v
	end

	if flag then
		return PlayButtonStates.WaitingForParty
	end

	return PlayButtonStates.PlayableWithParty
end

local function selectSecondaryPlayButtonState(p: string, data)
	if data == nil then
		return nil
	end

	if FFlagLuaAppPlayButtonPrivatePTEnableDualButton and data.privatePlaytestInfo ~= nil then
		local privatePlaytestInfo = data.privatePlaytestInfo
		local kind = PlaytestUnlockUpsell.getType(privatePlaytestInfo.playabilityStatus)

		if p == PlayButtonStates.ActionNeeded then
			return nil
		end

		if privatePlaytestInfo.isPlayable or kind ~= nil then
			return PlayButtonStates.Playtest
		end
	end

	local v

	if
		p == PlayButtonStates.PaidAccess
		or p == PlayButtonStates.FiatPaidAccess
		or data.playabilityStatus == PlayabilityStatusEnum.FiatPurchaseDeviceRestricted
		and p == PlayButtonStates.UnplayableOther
	then
		v = true
	elseif data.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityRegionalAvailability then
		v = p == PlayButtonStates.UnplayableOther
	else
		v = false
	end

	if v and data.demoModeAvailable then
		return PlayButtonStates.DemoMode
	end

	return nil
end

return function(p, current, duration: number?, flag: boolean?, flag2: boolean?, current2: string?, flag3: boolean?)
	local v = useDispatch()

	React.useEffect(function()
		local thread = nil

		if duration == nil or not (duration > 0) then
			v(FetchGamePlayButtonData.Fetch(p, current))
		else
			thread = task.delay(duration, function()
				thread = nil
				v(FetchGamePlayButtonData.Fetch(p, current))
			end)
		end

		return function()
			if thread ~= nil then
				task.cancel(thread)
			end
		end
	end, { current, duration })
	local v2

	if FFlagLuaAppParentUpsellPolicy then
		v2 = useAppPolicy(function(p2)
			return p2.getShouldShowVpcPlayButtonUpsells()
		end)
	else
		v2 = nil
	end

	local v3

	if FFlagLuaAppSupportDisablePlayableWhenLoading then
		local v4 = useAppPolicy(function(p2)
			return p2.getDisablePlayableWhenLoading()
		end)

		v3 = FFlagLuaAppDisablePlayableWhenLoadingForce or v4
	else
		v3 = nil
	end

	local v4

	if GetFFlagIsSquadEnabled() then
		v4 = useCurrentSquadSelector()
	else
		v4 = nil
	end

	local v5

	if GetFFlagIsSquadEnabled() then
		v5 = useIsExperienceInvitePending()
	else
		v5 = nil
	end

	local v6 = useSelector(function(p2)
		return p2.PlayabilityStatus and p2.PlayabilityStatus[current] or nil
	end)
	local earlyAccess

	if FFlagEnableGameJoinEarlyAccess then
		local useGameJoinEarlyAccess = require(GamePlayButton.EarlyAccess.useGameJoinEarlyAccess)
		earlyAccess = useGameJoinEarlyAccess(current, v6)
		local v7

		if earlyAccess == nil then
			v7 = false
		else
			v7 = earlyAccess.isPendingUnlock == true
		end

		local v8 = earlyAccess == nil and 0 or earlyAccess.unlockRefetchTick
		local v9

		if earlyAccess == nil then
			v9 = false
		else
			v9 = earlyAccess.gainedSubscription == true
		end

		React.useEffect(function()
			if v7 or v9 then
				v(FetchGamePlayButtonData.Fetch(p, current, true))
			end
		end, { v7, v8, v9, current })
	end

	local v7 = useSelector(function(p2)
		if FetchGamePlayButtonData.IsLoading(p2, current) then
			if
				not FFlagLuaAppEnablePlayableStateWhenLoading
				or (not flag or FFlagLuaAppSupportDisablePlayableWhenLoading and v3)
			then
				return PlayButtonStates.Loading
			end

			if GetFFlagIsSquadEnabled() and v4 and #v4.members > 1 then
				if v5 then
					return PlayButtonStates.WaitingForParty
				end

				return PlayButtonStates.PlayableWithParty
			end

			return PlayButtonStates.Playable
		else
			if ApiPostPreparePurchase.GetFetchingStatus(p2, current) == RetrievalStatus.Fetching then
				return PlayButtonStates.Loading
			end

			local fetchingStatus = FetchGamePlayabilityAndProductInfo.GetFetchingStatus(p2, current)
			local v7

			if p2[GamesProductInfoReducer.key] then
				v7 = p2[GamesProductInfoReducer.key][current] or nil
			end

			if GetFFlagIsSquadEnabled() then
				local gameDetail = p2.GameDetails[current]
				local v8

				if FFlagLuaAppParentUpsellPolicy then
					v8 = v2
				end

				local v9

				if FFlagEnableGameJoinEarlyAccess then
					v9 = flag3
				end

				return selectPlayButtonState(fetchingStatus, v6, v7, v4, v5, gameDetail, v8, v9)
			else
				local v8

				if FFlagLuaAppParentUpsellPolicy then
					v8 = v2
				end

				local v9

				if FFlagEnableGameJoinEarlyAccess then
					v9 = flag3
				end

				return selectPlayButtonState(fetchingStatus, v6, v7, nil, nil, nil, v8, v9)
			end
		end
	end)

	if FFlagLuaAppPlayButtonLoadingDurationTelemetry then
		local current6 = useRouteName()

		local ref = React.useRef(nil)
		local ref2 = React.useRef(nil)
		local ref3 = React.useRef(nil)
		local ref4 = React.useRef(nil)

		local ref5 = React.useRef(v7)
		ref5.current = v7

		local ref6 = React.useRef(v6)
		ref6.current = v6

		local v8 = React.useCallback(function(endReason: string)
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
				endReason = endReason,
				endPlayButtonState = ref5.current,
				endPlayabilityStatus = ref6.current and ref6.current.playabilityStatus or nil,
				pageName = ref4.current
			}, current5)

			ref3.current = nil
			ref4.current = nil
		end, {})

		React.useEffect(function()
			if v7 == PlayButtonStates.Loading then
				if not flag2 then
					return
				end

				if ref.current then
					if ref2.current ~= current then
						v8("universeChanged")
						ref.current = os.clock()
						ref2.current = current
						ref3.current = current2
						ref4.current = current6
					end
				else
					ref.current = os.clock()
					ref2.current = current
					ref3.current = current2
					ref4.current = current6
				end
			else
				v8("stateChanged")
			end
		end, { v7, v8, current, flag2, current2, current6 })

		React.useEffect(function()
			return function()
				v8("unmounted")
			end
		end, { v8 })
	end

	return {
		playButtonState = v7,
		secondaryPlayButtonState = selectSecondaryPlayButtonState(v7, v6),
		playabilityStatus = v6,
		earlyAccess = earlyAccess
	}
end
