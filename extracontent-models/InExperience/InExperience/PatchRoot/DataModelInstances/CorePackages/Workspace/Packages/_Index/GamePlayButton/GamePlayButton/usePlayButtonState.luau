local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local PlayButtonStates = require(GamePlayButton.PlayButtonStates)
local FetchGamePlayButtonData = require(GamePlayButton.FetchGamePlayButtonData)
local ApiPostPreparePurchase = require(GamePlayButton.ApiPostPreparePurchase)
local GamePlayButtonParent = GamePlayButton.Parent
local GetFFlagIsSquadEnabled = require(GamePlayButtonParent.SharedFlags).GetFFlagIsSquadEnabled
local React = require(GamePlayButtonParent.React)

require(GamePlayButtonParent.PlayabilityRodux)

local PlayabilityStatusEnum = require(GamePlayButtonParent.DiscoveryTypes).PlayabilityStatusEnum
local RetrievalStatus = require(GamePlayButtonParent.Http).Enum.RetrievalStatus
local RoactUtils = require(GamePlayButtonParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local FetchGamePlayabilityAndProductInfo = require(GamePlayButtonParent.GameDetailRodux).FetchGamePlayabilityAndProductInfo
local GamesProductInfoReducer = require(GamePlayButtonParent.GameProductInfoRodux).GamesProductInfoReducer
local useCurrentSquadSelector = require(GamePlayButtonParent.RoduxSquads).Hooks.useCurrentSquadSelector
local useIsExperienceInvitePending = require(GamePlayButtonParent.Squads.useIsExperienceInvitePending)
local useAppPolicy = require(GamePlayButtonParent.UniversalAppPolicy).useAppPolicy
local useRouteName = require(GamePlayButtonParent.Navigation).useRouteName
local sendPlayButtonLoadingDuration = require(GamePlayButtonParent.DiscoveryAnalytics).Events.sendPlayButtonLoadingDuration
local FFlagLuaAppParentUpsellPolicy = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppParentUpsellPolicy
local FFlagLuaAppEnablePlayableStateWhenLoading = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppEnablePlayableStateWhenLoading
local FFlagLuaAppSupportDisablePlayableWhenLoading = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppSupportDisablePlayableWhenLoading
local FFlagLuaAppDisablePlayableWhenLoadingForce = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppDisablePlayableWhenLoadingForce
local FFlagLuaAppPlayButtonAmpAgeCheckFlow = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppPlayButtonAmpAgeCheckFlow
local FFlagLuaAppParentApprovedExperiences = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppParentApprovedExperiences
local FFlagLuaAppPlayButtonLoadingDurationTelemetry = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppPlayButtonLoadingDurationTelemetry
local FFlagLuaAppDemoModePlayButton = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppDemoModePlayButton
local FFlagEnableDemoModeRegionalAvailability = require(GamePlayButtonParent.SharedFlags).FFlagEnableDemoModeRegionalAvailability

local function selectPlayButtonState(p1, p2, p3, p4, b1: boolean?, p5, b2: boolean?) -- line: 48
	-- upvalues: RetrievalStatus (copy), PlayButtonStates (copy), PlayabilityStatusEnum (copy), FFlagLuaAppPlayButtonAmpAgeCheckFlow (copy), FFlagLuaAppParentUpsellPolicy (copy), FFlagLuaAppParentApprovedExperiences (copy), GetFFlagIsSquadEnabled (copy)
	local v38 = if p1 ~= RetrievalStatus.Done or p2 == nil then PlayButtonStates.Playable else if p2.isPlayable ~= true then if p2.playabilityStatus ~= PlayabilityStatusEnum.PurchaseRequired or (p3 == nil or p3.isForSale ~= true) then if p2.playabilityStatus ~= PlayabilityStatusEnum.FiatPurchaseRequired or (p3 == nil or p3.isForSale ~= true) then if not FFlagLuaAppPlayButtonAmpAgeCheckFlow or p2.playabilityStatus ~= PlayabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser and (not (not not (not FFlagLuaAppParentUpsellPolicy or b2) and (p2.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls or not not FFlagLuaAppParentApprovedExperiences and p2.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval)) and p2.playabilityStatus ~= PlayabilityStatusEnum.ContextualPlayabilityAgeCheckRequired) then if FFlagLuaAppPlayButtonAmpAgeCheckFlow or p2.playabilityStatus ~= PlayabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser then if FFlagLuaAppPlayButtonAmpAgeCheckFlow or (not (not FFlagLuaAppParentUpsellPolicy or b2) or p2.playabilityStatus ~= PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls and (not FFlagLuaAppParentApprovedExperiences or p2.playabilityStatus ~= PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval)) then PlayButtonStates.UnplayableOther else PlayButtonStates.ActionNeeded else PlayButtonStates.ActionNeeded else PlayButtonStates.ActionNeeded else PlayButtonStates.FiatPaidAccess else PlayButtonStates.PaidAccess else PlayButtonStates.Playable

	if GetFFlagIsSquadEnabled() and (v38 == PlayButtonStates.Playable and p4 and #p4.members > 1) and (not p5 or not p5.maxPlayers or p5.maxPlayers > 1) then
		if b1 then
			return PlayButtonStates.WaitingForParty
		end

		v38 = PlayButtonStates.PlayableWithParty
	end

	return v38
end
local function selectSecondaryPlayButtonState(s1: string, p6) -- line: 133
	-- upvalues: PlayButtonStates (copy), PlayabilityStatusEnum (copy), FFlagEnableDemoModeRegionalAvailability (copy)
	if p6 == nil then
		return nil
	end

	if (s1 == PlayButtonStates.PaidAccess or (s1 == PlayButtonStates.FiatPaidAccess or (p6.playabilityStatus == PlayabilityStatusEnum.FiatPurchaseDeviceRestricted and s1 == PlayButtonStates.UnplayableOther or FFlagEnableDemoModeRegionalAvailability and (p6.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityRegionalAvailability and s1 == PlayButtonStates.UnplayableOther)))) and p6.demoModeAvailable then
		return PlayButtonStates.DemoMode
	end

	return nil
end

return function(p7, p8, n1: number?, b3: boolean?, b4: boolean?, s2: string?) -- line: 157
	-- upvalues: useDispatch (copy), React (copy), FetchGamePlayButtonData (copy), FFlagLuaAppParentUpsellPolicy (copy), useAppPolicy (copy), FFlagLuaAppSupportDisablePlayableWhenLoading (copy), FFlagLuaAppDisablePlayableWhenLoadingForce (copy), GetFFlagIsSquadEnabled (copy), useCurrentSquadSelector (copy), useIsExperienceInvitePending (copy), useSelector (copy), FFlagLuaAppEnablePlayableStateWhenLoading (copy), PlayButtonStates (copy), ApiPostPreparePurchase (copy), RetrievalStatus (copy), FetchGamePlayabilityAndProductInfo (copy), GamesProductInfoReducer (copy), selectPlayButtonState (copy), FFlagLuaAppPlayButtonLoadingDurationTelemetry (copy), useRouteName (copy), sendPlayButtonLoadingDuration (copy), FFlagLuaAppDemoModePlayButton (copy), PlayabilityStatusEnum (copy), FFlagEnableDemoModeRegionalAvailability (copy)
	local v47 = useDispatch()

	React.useEffect(function() -- line: 167
		-- upvalues: n1 (copy), v47 (copy), FetchGamePlayButtonData (copy), p7 (copy), p8 (copy)
		local u63 = nil

		if n1 ~= nil and n1 > 0 then
			u63 = task.delay(n1, function() -- line: 170
				-- upvalues: u63 (ref), v47 (copy), FetchGamePlayButtonData (copy), p7 (copy), p8 (copy)
				u63 = nil
				v47(FetchGamePlayButtonData.Fetch(p7, p8))
			end)
		else
			v47(FetchGamePlayButtonData.Fetch(p7, p8))
		end

		return function() -- line: 178
			-- upvalues: u63 (ref)
			if u63 ~= nil then
				task.cancel(u63)
			end
		end
	end, {
		p8,
		n1
	})

	local u48 = nil

	if FFlagLuaAppParentUpsellPolicy then
		u48 = useAppPolicy(function(p9) -- line: 187
			return p9.getShouldShowVpcPlayButtonUpsells()
		end)
	end

	local u49 = nil

	if FFlagLuaAppSupportDisablePlayableWhenLoading then
		local v50 = useAppPolicy(function(p10) -- line: 194
			return p10.getDisablePlayableWhenLoading()
		end)

		u49 = FFlagLuaAppDisablePlayableWhenLoadingForce or v50
	end

	local v51 = if not GetFFlagIsSquadEnabled() then nil else useCurrentSquadSelector()
	local v52 = if not GetFFlagIsSquadEnabled() then nil else useIsExperienceInvitePending()
	local v53 = useSelector(function(p11) -- line: 203
		-- upvalues: p8 (copy)
		return p11.PlayabilityStatus and p11.PlayabilityStatus[p8] or nil
	end)
	local v54 = useSelector(function(p12) -- line: 206
		-- upvalues: FetchGamePlayButtonData (copy), p8 (copy), FFlagLuaAppEnablePlayableStateWhenLoading (copy), b3 (copy), FFlagLuaAppSupportDisablePlayableWhenLoading (copy), u49 (ref), GetFFlagIsSquadEnabled (copy), v51 (copy), v52 (copy), PlayButtonStates (copy), ApiPostPreparePurchase (copy), RetrievalStatus (copy), FetchGamePlayabilityAndProductInfo (copy), GamesProductInfoReducer (copy), selectPlayButtonState (copy), v53 (copy), FFlagLuaAppParentUpsellPolicy (copy), u48 (ref)
		if FetchGamePlayButtonData.IsLoading(p12, p8) then
			if FFlagLuaAppEnablePlayableStateWhenLoading then
				if b3 and (not FFlagLuaAppSupportDisablePlayableWhenLoading or not u49) then
					if GetFFlagIsSquadEnabled() and v51 and #v51.members > 1 then
						if v52 then
							return PlayButtonStates.WaitingForParty
						end

						return PlayButtonStates.PlayableWithParty
					end

					return PlayButtonStates.Playable
				end

				return PlayButtonStates.Loading
			end

			return PlayButtonStates.Loading
		end

		if ApiPostPreparePurchase.GetFetchingStatus(p12, p8) == RetrievalStatus.Fetching then
			return PlayButtonStates.Loading
		end

		local v68 = FetchGamePlayabilityAndProductInfo.GetFetchingStatus(p12, p8)
		local v69 = p12[GamesProductInfoReducer.key] and p12[GamesProductInfoReducer.key][p8] or nil

		if GetFFlagIsSquadEnabled() then
			local v70 = p12.GameDetails[p8]

			return (selectPlayButtonState(v68, v53, v69, v51, v52, v70, if not FFlagLuaAppParentUpsellPolicy then nil else u48))
		end

		return (selectPlayButtonState(v68, v53, v69, nil, nil, nil, if not FFlagLuaAppParentUpsellPolicy then nil else u48))
	end)

	if FFlagLuaAppPlayButtonLoadingDurationTelemetry then
		local v55 = useRouteName()
		local v56 = React.useRef(nil)
		local v57 = React.useRef(nil)
		local v58 = React.useRef(nil)
		local v59 = React.useRef(nil)
		local v60 = React.useRef(v54)

		v60.current = v54

		local v61 = React.useRef(v53)

		v61.current = v53

		local v62 = React.useCallback(function(s3: string) -- line: 280
			-- upvalues: v56 (copy), v57 (copy), v58 (copy), sendPlayButtonLoadingDuration (copy), v60 (copy), v61 (copy), v59 (copy)
			local current = v56.current
			local current2 = v57.current
			local current3 = v58.current

			if not current or not current2 then
				return
			end

			v56.current = nil
			v57.current = nil
			sendPlayButtonLoadingDuration({
				universeId = current2,
				durationMs = math.floor((os.clock() - current) * 1000),
				endReason = s3,
				endPlayButtonState = v60.current,
				endPlayabilityStatus = v61.current and v61.current.playabilityStatus or nil,
				pageName = v59.current
			}, current3)
			v58.current = nil
			v59.current = nil
		end, {})

		React.useEffect(function() -- line: 307
			-- upvalues: v54 (copy), PlayButtonStates (copy), b4 (copy), v56 (copy), v57 (copy), p8 (copy), v58 (copy), s2 (copy), v59 (copy), v55 (copy), v62 (copy)
			if v54 == PlayButtonStates.Loading then
				if not b4 then
					return
				end

				if not v56.current then
					v56.current = os.clock()
					v57.current = p8
					v58.current = s2
					v59.current = v55

					return
				end

				if v57.current ~= p8 then
					v62("universeChanged")
					v56.current = os.clock()
					v57.current = p8
					v58.current = s2
					v59.current = v55

					return
				end
			else
				v62("stateChanged")
			end
		end, {
			v54,
			v62,
			p8,
			b4,
			s2,
			v55
		})
		React.useEffect(function() -- line: 339
			-- upvalues: v62 (copy)
			return function() -- line: 340
				-- upvalues: v62 (copy)
				v62("unmounted")
			end
		end, { v62 })
	end

	return {
		playButtonState = v54,
		secondaryPlayButtonState = if not FFlagLuaAppDemoModePlayButton then nil else if v53 ~= nil then if not (v54 == PlayButtonStates.PaidAccess or (v54 == PlayButtonStates.FiatPaidAccess or (v53.playabilityStatus == PlayabilityStatusEnum.FiatPurchaseDeviceRestricted and v54 == PlayButtonStates.UnplayableOther or FFlagEnableDemoModeRegionalAvailability and (v53.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityRegionalAvailability and v54 == PlayButtonStates.UnplayableOther)))) or not v53.demoModeAvailable then nil else PlayButtonStates.DemoMode else nil,
		playabilityStatus = v53
	}
end
