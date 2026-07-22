local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local ApiPostPreparePurchase = require(GamePlayButton.ApiPostPreparePurchase)
local GamePlayButtonShareLinkAnalytics = require(GamePlayButton.GamePlayButtonShareLinkAnalytics)
local OpenCentralOverlayForPurchaseGame = require(GamePlayButton.OpenCentralOverlayForPurchaseGame)
local OpenCentralOverlayForUnifiedPurchasePrompt = require(GamePlayButton.OpenCentralOverlayForUnifiedPurchasePrompt)
local PlayButtonReferralSource = require(GamePlayButton.PlayButtonReferralSource)
local PlayButtonStates = require(GamePlayButton.PlayButtonStates)

require(GamePlayButton.PlayButtonTypes)

local usePlayButtonLaunchAfterSeventeenPlusUpsell = require(GamePlayButton.PlayButtonLaunchChecks.usePlayButtonLaunchAfterSeventeenPlusUpsell)
local usePlayButtonLaunchGame = require(GamePlayButton.PlayButtonLaunchChecks.usePlayButtonLaunchGame)
local usePlayButtonLaunchWithUxTreatment = require(GamePlayButton.PlayButtonLaunchChecks.usePlayButtonLaunchWithUxTreatment)
local useAgeVerificationOverlayCallback = require(GamePlayButton.PlayButtonLaunchChecks.useAgeVerificationOverlayCallback)
local GamePlayButtonParent = GamePlayButton.Parent
local React = require(GamePlayButtonParent.React)
local RoactUtils = require(GamePlayButtonParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useRouteName = require(GamePlayButtonParent.Navigation).useRouteName
local useRoactService = require(GamePlayButtonParent.RobloxAppHooks).useRoactService
local RoactServiceTags = require(GamePlayButtonParent.RoactServiceTags)
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local RoactNetworking = RoactServiceTags.RoactNetworking
local AppUpdateService = RoactServiceTags.AppUpdateService
local joinGamePlayButton = require(GamePlayButtonParent.DiscoveryAnalytics).Points.joinGamePlayButton
local unlockPlayIntent = require(GamePlayButtonParent.DiscoveryAnalytics).Events.unlockPlayIntent
local invalidPlayIntent = require(GamePlayButtonParent.DiscoveryAnalytics).Events.invalidPlayIntent
local AppEventIngestService = require(GamePlayButtonParent.RoactServiceTags).AppEventIngestService
local RobloxAppUpdate = require(GamePlayButtonParent.RobloxAppUpdate)
local CheckForUpdate = RobloxAppUpdate.Thunks.CheckForUpdate
local HandleUpdate = RobloxAppUpdate.HandleUpdate
local useGameProductInfoSelector = require(GamePlayButtonParent.GameProductInfoRodux).useGameProductInfoSelector
local useGameInfosSelector = require(GamePlayButtonParent.GameInfosRodux).useGameInfosSelector
local useGameIconSelector = require(GamePlayButtonParent.GameIconRodux).GameIcons.useGameIconSelector
local CloseCentralOverlay = require(GamePlayButtonParent.CentralOverlay).Thunks.CloseCentralOverlay
local FetchGamePlayabilityAndProductInfo = require(GamePlayButtonParent.GameDetailRodux).FetchGamePlayabilityAndProductInfo
local PurchasePromptLite = require(GamePlayButtonParent.PurchasePromptLite)
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local getIsUserEligibleForUnifiedPurchaseFlow = PurchasePromptLite.getIsUserEligibleForUnifiedPurchaseFlow
local GetFFlagIsSquadEnabled = require(GamePlayButtonParent.SharedFlags).GetFFlagIsSquadEnabled
local GetFFlagLuaAppEnableVirtualEventPlaceId = require(GamePlayButtonParent.SharedFlags).GetFFlagLuaAppEnableVirtualEventPlaceId
local FFlagShipUnifiedPurchaseFlowToPaidAccess = require(GamePlayButtonParent.SharedFlags).FFlagShipUnifiedPurchaseFlowToPaidAccess
local FFlagCheckForUpdatePromise = require(GamePlayButtonParent.SharedFlags).FFlagCheckForUpdatePromise
local CreateExperienceInvite = require(GamePlayButtonParent.Squads.Thunks).CreateExperienceInvite
local SquadExternalContractContext = require(GamePlayButtonParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local SquadExperienceInviteType = require(GamePlayButtonParent.SquadsCore.Enums).SquadExperienceInviteType
local SquadExperienceInviteSource = require(GamePlayButtonParent.SquadsCore.Enums).SquadExperienceInviteSource

require(GamePlayButtonParent.PlayabilityRodux)

local EngineFeature = game:GetEngineFeature("AutoUpgradeEngineFeatureOnly")
local EngineFeature2 = game:GetEngineFeature("CanPerformBinaryUpdateEnabled")
local v48 = game:DefineFastFlag("IncludeWaitingForPartyInCondition", false)
local FFlagEnableUnifiedProductPurchaseFlow = require(GamePlayButtonParent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local FFlagEnableSquadRegroupExperimentation = require(GamePlayButtonParent.SharedFlags).FFlagEnableSquadRegroupExperimentation
local FFlagLuaAppPlayableUxTreatment = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppPlayableUxTreatment
local FFlagEnablePrivatePartyStartJoin = require(GamePlayButtonParent.SharedFlags).FFlagEnablePrivatePartyStartJoin
local FFlagLuaAppLogPageContextUnlockPlayIntent = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppLogPageContextUnlockPlayIntent
local FFlagLuaAppPlayButtonLoadingDurationTelemetry = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppPlayButtonLoadingDurationTelemetry
local FFlagLuaAppLaunchWhenLoadingEdp = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppLaunchWhenLoadingEdp
local FFlagLuaAppLaunchWhenLoadingForce = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppLaunchWhenLoadingForce
local FFlagLuaAppDemoModePlayButton = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppDemoModePlayButton
local FFlagLuaAppDemoModePlayButtonTelemetry = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppDemoModePlayButtonTelemetry

return function(p1, p2, p3, _, p5, t1: {[any]: any}?, p6, b1: boolean?) -- line: 79
	-- upvalues: useRoactService (copy), RoactAnalytics (copy), AppUpdateService (copy), AppEventIngestService (copy), useDispatch (copy), useSelector (copy), useGameInfosSelector (copy), useGameProductInfoSelector (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), useGameIconSelector (copy), useRouteName (copy), GetFFlagIsSquadEnabled (copy), React (copy), SquadExternalContractContext (copy), GetFFlagLuaAppEnableVirtualEventPlaceId (copy), usePlayButtonLaunchGame (copy), FFlagLuaAppPlayableUxTreatment (copy), usePlayButtonLaunchWithUxTreatment (copy), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), usePlayButtonLaunchAfterSeventeenPlusUpsell (copy), useAgeVerificationOverlayCallback (copy), RoactNetworking (copy), FFlagLuaAppLaunchWhenLoadingForce (copy), FFlagLuaAppLaunchWhenLoadingEdp (copy), FFlagLuaAppDemoModePlayButton (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), EngineFeature (copy), FFlagCheckForUpdatePromise (copy), HandleUpdate (copy), EngineFeature2 (copy), CheckForUpdate (copy), joinGamePlayButton (copy), PlayButtonReferralSource (copy), GamePlayButtonShareLinkAnalytics (copy), PlayButtonStates (copy), CloseCentralOverlay (copy), FetchGamePlayabilityAndProductInfo (copy), OpenCentralOverlayForPurchaseGame (copy), FFlagShipUnifiedPurchaseFlowToPaidAccess (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), ProductPurchaseSurface (copy), getIsUserEligibleForUnifiedPurchaseFlow (copy), ApiPostPreparePurchase (copy), unlockPlayIntent (copy), invalidPlayIntent (copy), FFlagLuaAppPlayButtonLoadingDurationTelemetry (copy), CreateExperienceInvite (copy), FFlagEnableSquadRegroupExperimentation (copy), SquadExperienceInviteSource (copy), FFlagEnablePrivatePartyStartJoin (copy), SquadExperienceInviteType (copy), v48 (copy)
	local v67 = useRoactService(RoactAnalytics)
	local v68 = useRoactService(AppUpdateService)
	local v69 = useRoactService(AppEventIngestService)
	local v70 = useDispatch()
	local v71 = useSelector(function(p7) -- line: 94
		-- upvalues: p1 (copy)
		return p7.GameDetails[p1]
	end)
	local v72 = useGameInfosSelector(p1)
	local v73 = useGameProductInfoSelector(p1)
	local v74 = useSelector(function(p8) -- line: 99
		-- upvalues: p1 (copy)
		return p8.PlayabilityStatus[p1]
	end)
	local u75 = nil

	if FFlagEnableUnifiedProductPurchaseFlow then
		u75 = useGameIconSelector(p1)
	end

	local v76 = useRouteName()
	local v77 = if not GetFFlagIsSquadEnabled() then nil else React.useContext(SquadExternalContractContext)
	local v78 = v71 and v71.rootPlaceId or (v72 and v72.placeId or nil)
	local u79 = if not GetFFlagLuaAppEnableVirtualEventPlaceId() or p6 == "0" then v78 else p6 or v78
	local v80 = v71 and v71.name or (v72 and v72.name or nil)
	local v81 = usePlayButtonLaunchGame(p1, u79, v78, p2, p3, p5, t1)
	local v82 = nil

	if FFlagLuaAppPlayableUxTreatment then
		v82 = usePlayButtonLaunchWithUxTreatment(v74, p1, v81, if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else v76)
	end

	local v83 = usePlayButtonLaunchAfterSeventeenPlusUpsell(v74, p1, if not FFlagLuaAppPlayableUxTreatment then v81 else v82, if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else v76)
	local v84 = useAgeVerificationOverlayCallback(p1, v81, v83)
	local v85 = useRoactService(RoactNetworking)
	local v86 = FFlagLuaAppLaunchWhenLoadingForce or FFlagLuaAppLaunchWhenLoadingEdp and b1 == true
	local v87 = if not FFlagLuaAppLaunchWhenLoadingForce and (not FFlagLuaAppLaunchWhenLoadingEdp and not FFlagLuaAppDemoModePlayButton) then nil else React.useCallback(function(p9, s1: string?) -- line: 163
		-- upvalues: v84 (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), v83 (copy), EngineFeature (copy), FFlagCheckForUpdatePromise (copy), HandleUpdate (copy), v70 (copy), v68 (copy), EngineFeature2 (copy), v67 (copy), p3 (copy), CheckForUpdate (copy)
		local v92 = not game:GetEngineFeature("VoiceChatSupported") and function() -- line: 173
			-- upvalues: v83 (copy), p9 (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), s1 (copy)
			v83(p9, if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s1)
		end or function() -- line: 166
			-- upvalues: v84 (copy), p9 (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), s1 (copy)
			v84(p9, if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s1)
		end

		if EngineFeature then
			if FFlagCheckForUpdatePromise then
				HandleUpdate(v70, v68, EngineFeature2, v67, p3, v92)

				return
			end

			v70(CheckForUpdate(v68, EngineFeature2, v67, v92, {
				ctx = p3
			}))

			return
		end

		v92()
	end, {
		v67,
		v68,
		EngineFeature2,
		p3,
		v84,
		v83,
		v70
	})

	return (React.useCallback(function(p10, p11, t2: {[any]: any}?) -- line: 211
		-- upvalues: joinGamePlayButton (copy), v67 (copy), p2 (copy), v78 (copy), p3 (copy), PlayButtonReferralSource (copy), GamePlayButtonShareLinkAnalytics (copy), GetFFlagLuaAppEnableVirtualEventPlaceId (copy), u79 (ref), p1 (copy), PlayButtonStates (copy), FFlagLuaAppLaunchWhenLoadingForce (copy), FFlagLuaAppLaunchWhenLoadingEdp (copy), FFlagLuaAppDemoModePlayButton (copy), v87 (copy), v84 (copy), v83 (copy), EngineFeature (copy), FFlagCheckForUpdatePromise (copy), HandleUpdate (copy), v70 (copy), v68 (copy), EngineFeature2 (copy), CheckForUpdate (copy), v73 (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), CloseCentralOverlay (copy), FetchGamePlayabilityAndProductInfo (copy), v85 (copy), OpenCentralOverlayForPurchaseGame (copy), v80 (copy), v76 (copy), FFlagShipUnifiedPurchaseFlowToPaidAccess (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), u75 (ref), ProductPurchaseSurface (copy), getIsUserEligibleForUnifiedPurchaseFlow (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), ApiPostPreparePurchase (copy), unlockPlayIntent (copy), v69 (copy), v74 (copy), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), invalidPlayIntent (copy), FFlagLuaAppPlayButtonLoadingDurationTelemetry (copy), v86 (copy), GetFFlagIsSquadEnabled (copy), CreateExperienceInvite (copy), v77 (copy), FFlagEnableSquadRegroupExperimentation (copy), SquadExperienceInviteSource (copy), FFlagEnablePrivatePartyStartJoin (copy), SquadExperienceInviteType (copy), v48 (copy)
		joinGamePlayButton(v67.InfluxDb, "playButtonClicked", {
			isUniversalApp = true,
			referralSource = p2,
			placeId = v78,
			buttonState = p10 and p10 or "Invalid",
			ctx = p3
		})

		if p2 == PlayButtonReferralSource.ExperienceDetailsLink then
			GamePlayButtonShareLinkAnalytics(v67, {
				placeId = if not GetFFlagLuaAppEnableVirtualEventPlaceId() then v78 else u79,
				playButtonState = p10,
				universeId = p1
			})
		end

		if p10 == PlayButtonStates.Playable or p10 == PlayButtonStates.ActionNeeded then
			if FFlagLuaAppLaunchWhenLoadingForce or FFlagLuaAppLaunchWhenLoadingEdp or FFlagLuaAppDemoModePlayButton then
				v87(p11)

				return
			end

			local v96 = not game:GetEngineFeature("VoiceChatSupported") and function() -- line: 241
				-- upvalues: v83 (copy), p11 (copy)
				v83(p11)
			end or function() -- line: 237
				-- upvalues: v84 (copy), p11 (copy)
				v84(p11)
			end

			if EngineFeature then
				if FFlagCheckForUpdatePromise then
					HandleUpdate(v70, v68, EngineFeature2, v67, p3, v96)

					return
				end

				v70(CheckForUpdate(v68, EngineFeature2, v67, v96, {
					ctx = p3
				}))

				return
			end

			v96()

			return
		end

		if p10 == PlayButtonStates.PaidAccess then
			local v97 = v73 and v73.price or nil
			local v98 = v73 and v73.productId or nil
			local v99 = v73 and v73.sellerId or nil

			if FFlagEnableUnifiedProductPurchaseFlow then
				local v100 = v73 and v73.universeId or nil

				local function onFlowComplete() -- line: 274
					-- upvalues: v70 (copy), CloseCentralOverlay (copy)
					v70(CloseCentralOverlay())
				end
				local function onPurchaseSuccess() -- line: 277
					-- upvalues: v70 (copy), FetchGamePlayabilityAndProductInfo (copy), v85 (copy), v100 (copy)
					v70(FetchGamePlayabilityAndProductInfo.Fetch(v85, v100))
				end
				local function initiateLegacyPurchaseFlow() -- line: 280
					-- upvalues: v70 (copy), OpenCentralOverlayForPurchaseGame (copy), v100 (copy), v80 (copy), v97 (copy), v98 (copy), v99 (copy), v76 (copy)
					v70(OpenCentralOverlayForPurchaseGame(v100, v80, v97, v98, v99, { v76 }))
				end

				if FFlagShipUnifiedPurchaseFlowToPaidAccess then
					v70(OpenCentralOverlayForUnifiedPurchasePrompt({
						productPayload = {
							kind = "Experience",
							universeId = v100,
							experienceName = v80,
							experienceIconUrl = u75.url
						},
						purchaseCallbacks = {
							onFlowComplete = onFlowComplete,
							onPurchaseSuccess = onPurchaseSuccess
						},
						purchaseAnalyticsMetadata = {
							surface = ProductPurchaseSurface.PaidAccess
						}
					}))

					return
				end

				getIsUserEligibleForUnifiedPurchaseFlow(v85):andThen(function(p12) -- line: 311
					-- upvalues: v70 (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), v100 (copy), v80 (copy), u75 (ref), onFlowComplete (copy), onPurchaseSuccess (copy), ProductPurchaseSurface (copy), OpenCentralOverlayForPurchaseGame (copy), v97 (copy), v98 (copy), v99 (copy), v76 (copy)
					if p12 then
						v70(OpenCentralOverlayForUnifiedPurchasePrompt({
							productPayload = {
								kind = "Experience",
								universeId = v100,
								experienceName = v80,
								experienceIconUrl = u75.url
							},
							purchaseCallbacks = {
								onFlowComplete = onFlowComplete,
								onPurchaseSuccess = onPurchaseSuccess
							},
							purchaseAnalyticsMetadata = {
								surface = ProductPurchaseSurface.PaidAccess
							}
						}))

						return
					end

					v70(OpenCentralOverlayForPurchaseGame(v100, v80, v97, v98, v99, { v76 }))
				end):catch(function(_) -- line: 332
					-- upvalues: v70 (copy), OpenCentralOverlayForPurchaseGame (copy), v100 (copy), v80 (copy), v97 (copy), v98 (copy), v99 (copy), v76 (copy)
					v70(OpenCentralOverlayForPurchaseGame(v100, v80, v97, v98, v99, { v76 }))
				end)

				return
			end

			v70(OpenCentralOverlayForPurchaseGame(p1, v80, v97, v98, v99, { v76 }))

			return
		end

		if FFlagLuaAppDemoModePlayButton and p10 == PlayButtonStates.DemoMode then
			if FFlagLuaAppDemoModePlayButtonTelemetry then
				v87(p11, "DemoPlayButtonClick")

				return
			end

			v87(p11)

			return
		end

		if p10 == PlayButtonStates.FiatPaidAccess then
			if v78 and v73 and v73.fiatBasePriceId then
				v70(ApiPostPreparePurchase.Fetch(v85, v78, p1, v73.fiatBasePriceId))
				unlockPlayIntent(v69, {
					upsellName = "FiatPurchase",
					universeId = p1,
					playabilityStatus = v74 and v74.playabilityStatus or nil,
					pageName = if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else v76
				})

				return
			end
		else
			if p10 == PlayButtonStates.Loading then
				invalidPlayIntent(p3, {
					universeId = p1,
					playButtonState = p10,
					playabilityStatus = v74 and v74.playabilityStatus or nil,
					pageName = if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else v76
				})

				if v86 then
					v87(p11)
				end

				return
			end

			if GetFFlagIsSquadEnabled() and p10 == PlayButtonStates.PlayableWithParty then
				if v78 then
					v70(CreateExperienceInvite(v78, v77, if not FFlagEnableSquadRegroupExperimentation then nil else SquadExperienceInviteSource.Default, if not FFlagEnablePrivatePartyStartJoin or (not t2 or not t2.isPrivateParty) then nil else SquadExperienceInviteType.PlayWithPartyInPrivatePartyServer))

					return
				end
			else
				if v48 and p10 == PlayButtonStates.WaitingForParty then
					invalidPlayIntent(p3, {
						universeId = p1,
						playButtonState = p10,
						playabilityStatus = v74 and v74.playabilityStatus or nil,
						pageName = if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else v76
					})

					return
				end

				if p10 == PlayButtonStates.UnplayableOther then
					invalidPlayIntent(p3, {
						universeId = p1,
						playButtonState = p10,
						playabilityStatus = v74 and v74.playabilityStatus or nil,
						pageName = if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else v76
					})

					return
				end

				error(`invalid play button state { p10 }!`)
			end
		end
	end, {
		v67,
		v68,
		EngineFeature2,
		p1,
		if not GetFFlagLuaAppEnableVirtualEventPlaceId() then nil else u79,
		v78,
		v80,
		p2,
		p3,
		if not FFlagLuaAppLaunchWhenLoadingForce and (not FFlagLuaAppLaunchWhenLoadingEdp and not FFlagLuaAppDemoModePlayButton) then nil else v87,
		if not FFlagLuaAppLaunchWhenLoadingForce and (not FFlagLuaAppLaunchWhenLoadingEdp and not FFlagLuaAppDemoModePlayButton) then v84 else nil,
		if not FFlagLuaAppLaunchWhenLoadingForce and (not FFlagLuaAppLaunchWhenLoadingEdp and not FFlagLuaAppDemoModePlayButton) then v83 else nil,
		v73,
		v76,
		if not GetFFlagIsSquadEnabled() then nil else v77,
		v74,
		if not FFlagLuaAppDemoModePlayButton then nil else v70,
		if not FFlagLuaAppDemoModePlayButton then nil else v69,
		if not FFlagLuaAppDemoModePlayButton then nil else u75,
		if not FFlagLuaAppDemoModePlayButton then nil else v85,
		if not FFlagLuaAppLaunchWhenLoadingForce and not FFlagLuaAppLaunchWhenLoadingEdp then nil else v86
	}))
end
