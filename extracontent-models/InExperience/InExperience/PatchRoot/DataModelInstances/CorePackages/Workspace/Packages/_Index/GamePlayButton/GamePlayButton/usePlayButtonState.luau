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

local function selectPlayButtonState(p1, p2, p3, p4, b1: boolean?, p5, b2: boolean?) -- line: 45
	-- upvalues: RetrievalStatus (copy), PlayButtonStates (copy), PlayabilityStatusEnum (copy), FFlagLuaAppPlayButtonAmpAgeCheckFlow (copy), FFlagLuaAppParentUpsellPolicy (copy), FFlagLuaAppParentApprovedExperiences (copy), GetFFlagIsSquadEnabled (copy)
	local v35 = if p1 ~= RetrievalStatus.Done or p2 == nil then PlayButtonStates.Playable else if p2.isPlayable ~= true then if p2.playabilityStatus ~= PlayabilityStatusEnum.PurchaseRequired or (p3 == nil or p3.isForSale ~= true) then if p2.playabilityStatus ~= PlayabilityStatusEnum.FiatPurchaseRequired or (p3 == nil or p3.isForSale ~= true) then if not FFlagLuaAppPlayButtonAmpAgeCheckFlow or p2.playabilityStatus ~= PlayabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser and (not (not not (not FFlagLuaAppParentUpsellPolicy or b2) and (p2.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls or not not FFlagLuaAppParentApprovedExperiences and p2.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval)) and p2.playabilityStatus ~= PlayabilityStatusEnum.ContextualPlayabilityAgeCheckRequired) then if FFlagLuaAppPlayButtonAmpAgeCheckFlow or p2.playabilityStatus ~= PlayabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser then if FFlagLuaAppPlayButtonAmpAgeCheckFlow or (not (not FFlagLuaAppParentUpsellPolicy or b2) or p2.playabilityStatus ~= PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls and (not FFlagLuaAppParentApprovedExperiences or p2.playabilityStatus ~= PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval)) then PlayButtonStates.UnplayableOther else PlayButtonStates.ActionNeeded else PlayButtonStates.ActionNeeded else PlayButtonStates.ActionNeeded else PlayButtonStates.FiatPaidAccess else PlayButtonStates.PaidAccess else PlayButtonStates.Playable

	if GetFFlagIsSquadEnabled() and (v35 == PlayButtonStates.Playable and p4 and #p4.members > 1) and (not p5 or not p5.maxPlayers or p5.maxPlayers > 1) then
		if b1 then
			return PlayButtonStates.WaitingForParty
		end

		v35 = PlayButtonStates.PlayableWithParty
	end

	return v35
end

return function(p6, p7, n1: number?, b3: boolean?, b4: boolean?, s1: string?) -- line: 130
	-- upvalues: useDispatch (copy), React (copy), FetchGamePlayButtonData (copy), FFlagLuaAppParentUpsellPolicy (copy), useAppPolicy (copy), FFlagLuaAppSupportDisablePlayableWhenLoading (copy), FFlagLuaAppDisablePlayableWhenLoadingForce (copy), GetFFlagIsSquadEnabled (copy), useCurrentSquadSelector (copy), useIsExperienceInvitePending (copy), useSelector (copy), FFlagLuaAppEnablePlayableStateWhenLoading (copy), PlayButtonStates (copy), ApiPostPreparePurchase (copy), RetrievalStatus (copy), FetchGamePlayabilityAndProductInfo (copy), GamesProductInfoReducer (copy), selectPlayButtonState (copy), FFlagLuaAppPlayButtonLoadingDurationTelemetry (copy), useRouteName (copy), sendPlayButtonLoadingDuration (copy)
	local v42 = useDispatch()

	React.useEffect(function() -- line: 140
		-- upvalues: n1 (copy), v42 (copy), FetchGamePlayButtonData (copy), p6 (copy), p7 (copy)
		local u58 = nil

		if n1 ~= nil and n1 > 0 then
			u58 = task.delay(n1, function() -- line: 143
				-- upvalues: u58 (ref), v42 (copy), FetchGamePlayButtonData (copy), p6 (copy), p7 (copy)
				u58 = nil
				v42(FetchGamePlayButtonData.Fetch(p6, p7))
			end)
		else
			v42(FetchGamePlayButtonData.Fetch(p6, p7))
		end

		return function() -- line: 151
			-- upvalues: u58 (ref)
			if u58 ~= nil then
				task.cancel(u58)
			end
		end
	end, {
		p7,
		n1
	})

	local u43 = nil

	if FFlagLuaAppParentUpsellPolicy then
		u43 = useAppPolicy(function(p8) -- line: 160
			return p8.getShouldShowVpcPlayButtonUpsells()
		end)
	end

	local u44 = nil

	if FFlagLuaAppSupportDisablePlayableWhenLoading then
		local v45 = useAppPolicy(function(p9) -- line: 167
			return p9.getDisablePlayableWhenLoading()
		end)

		u44 = FFlagLuaAppDisablePlayableWhenLoadingForce or v45
	end

	local v46 = if not GetFFlagIsSquadEnabled() then nil else useCurrentSquadSelector()
	local v47 = if not GetFFlagIsSquadEnabled() then nil else useIsExperienceInvitePending()
	local v48 = useSelector(function(p10) -- line: 176
		-- upvalues: p7 (copy)
		return p10.PlayabilityStatus and p10.PlayabilityStatus[p7] or nil
	end)
	local v49 = useSelector(function(p11) -- line: 179
		-- upvalues: FetchGamePlayButtonData (copy), p7 (copy), FFlagLuaAppEnablePlayableStateWhenLoading (copy), b3 (copy), FFlagLuaAppSupportDisablePlayableWhenLoading (copy), u44 (ref), GetFFlagIsSquadEnabled (copy), v46 (copy), v47 (copy), PlayButtonStates (copy), ApiPostPreparePurchase (copy), RetrievalStatus (copy), FetchGamePlayabilityAndProductInfo (copy), GamesProductInfoReducer (copy), selectPlayButtonState (copy), v48 (copy), FFlagLuaAppParentUpsellPolicy (copy), u43 (ref)
		if FetchGamePlayButtonData.IsLoading(p11, p7) then
			if FFlagLuaAppEnablePlayableStateWhenLoading then
				if b3 and (not FFlagLuaAppSupportDisablePlayableWhenLoading or not u44) then
					if GetFFlagIsSquadEnabled() and v46 and #v46.members > 1 then
						if v47 then
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

		if ApiPostPreparePurchase.GetFetchingStatus(p11, p7) == RetrievalStatus.Fetching then
			return PlayButtonStates.Loading
		end

		local v63 = FetchGamePlayabilityAndProductInfo.GetFetchingStatus(p11, p7)
		local v64 = p11[GamesProductInfoReducer.key] and p11[GamesProductInfoReducer.key][p7] or nil

		if GetFFlagIsSquadEnabled() then
			local v65 = p11.GameDetails[p7]

			return (selectPlayButtonState(v63, v48, v64, v46, v47, v65, if not FFlagLuaAppParentUpsellPolicy then nil else u43))
		end

		return (selectPlayButtonState(v63, v48, v64, nil, nil, nil, if not FFlagLuaAppParentUpsellPolicy then nil else u43))
	end)

	if FFlagLuaAppPlayButtonLoadingDurationTelemetry then
		local v50 = useRouteName()
		local v51 = React.useRef(nil)
		local v52 = React.useRef(nil)
		local v53 = React.useRef(nil)
		local v54 = React.useRef(nil)
		local v55 = React.useRef(v49)

		v55.current = v49

		local v56 = React.useRef(v48)

		v56.current = v48

		local v57 = React.useCallback(function(s2: string) -- line: 253
			-- upvalues: v51 (copy), v52 (copy), v53 (copy), sendPlayButtonLoadingDuration (copy), v55 (copy), v56 (copy), v54 (copy)
			local current = v51.current
			local current2 = v52.current
			local current3 = v53.current

			if not current or not current2 then
				return
			end

			v51.current = nil
			v52.current = nil
			sendPlayButtonLoadingDuration({
				universeId = current2,
				durationMs = math.floor((os.clock() - current) * 1000),
				endReason = s2,
				endPlayButtonState = v55.current,
				endPlayabilityStatus = v56.current and v56.current.playabilityStatus or nil,
				pageName = v54.current
			}, current3)
			v53.current = nil
			v54.current = nil
		end, {})

		React.useEffect(function() -- line: 280
			-- upvalues: v49 (copy), PlayButtonStates (copy), b4 (copy), v51 (copy), v52 (copy), p7 (copy), v53 (copy), s1 (copy), v54 (copy), v50 (copy), v57 (copy)
			if v49 == PlayButtonStates.Loading then
				if not b4 then
					return
				end

				if not v51.current then
					v51.current = os.clock()
					v52.current = p7
					v53.current = s1
					v54.current = v50

					return
				end

				if v52.current ~= p7 then
					v57("universeChanged")
					v51.current = os.clock()
					v52.current = p7
					v53.current = s1
					v54.current = v50

					return
				end
			else
				v57("stateChanged")
			end
		end, {
			v49,
			v57,
			p7,
			b4,
			s1,
			v50
		})
		React.useEffect(function() -- line: 312
			-- upvalues: v57 (copy)
			return function() -- line: 313
				-- upvalues: v57 (copy)
				v57("unmounted")
			end
		end, { v57 })
	end

	return {
		playButtonState = v49,
		playabilityStatus = v48
	}
end
