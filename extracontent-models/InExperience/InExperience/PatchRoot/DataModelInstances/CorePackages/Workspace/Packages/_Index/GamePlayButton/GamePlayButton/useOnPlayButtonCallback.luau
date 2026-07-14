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
local CheckForUpdate = require(GamePlayButtonParent.RobloxAppUpdate).Thunks.CheckForUpdate
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
local CreateExperienceInvite = require(GamePlayButtonParent.Squads.Thunks).CreateExperienceInvite
local SquadExternalContractContext = require(GamePlayButtonParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local SquadExperienceInviteType = require(GamePlayButtonParent.SquadsCore.Enums).SquadExperienceInviteType
local SquadExperienceInviteSource = require(GamePlayButtonParent.SquadsCore.Enums).SquadExperienceInviteSource

require(GamePlayButtonParent.PlayabilityRodux)

local EngineFeature = game:GetEngineFeature("AutoUpgradeEngineFeatureOnly")
local EngineFeature2 = game:GetEngineFeature("CanPerformBinaryUpdateEnabled")
local v45 = game:DefineFastFlag("IncludeWaitingForPartyInCondition", false)
local FFlagEnableUnifiedProductPurchaseFlow = require(GamePlayButtonParent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local FFlagEnableSquadRegroupExperimentation = require(GamePlayButtonParent.SharedFlags).FFlagEnableSquadRegroupExperimentation
local FFlagLuaAppPlayableUxTreatment = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppPlayableUxTreatment
local FFlagEnablePrivatePartyStartJoin = require(GamePlayButtonParent.SharedFlags).FFlagEnablePrivatePartyStartJoin
local FFlagLuaAppLogPageContextUnlockPlayIntent = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppLogPageContextUnlockPlayIntent
local FFlagLuaAppPlayButtonLoadingDurationTelemetry = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppPlayButtonLoadingDurationTelemetry
local FFlagLuaAppLaunchWhenLoadingEdp = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppLaunchWhenLoadingEdp
local FFlagLuaAppLaunchWhenLoadingForce = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppLaunchWhenLoadingForce

return function(p1, p2, p3, _, p5, t1: {[any]: any}?, p6, b1: boolean?) -- line: 74
	-- upvalues: useRoactService (copy), RoactAnalytics (copy), AppUpdateService (copy), AppEventIngestService (copy), useDispatch (copy), useSelector (copy), useGameInfosSelector (copy), useGameProductInfoSelector (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), useGameIconSelector (copy), useRouteName (copy), GetFFlagIsSquadEnabled (copy), React (copy), SquadExternalContractContext (copy), GetFFlagLuaAppEnableVirtualEventPlaceId (copy), usePlayButtonLaunchGame (copy), FFlagLuaAppPlayableUxTreatment (copy), usePlayButtonLaunchWithUxTreatment (copy), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), usePlayButtonLaunchAfterSeventeenPlusUpsell (copy), useAgeVerificationOverlayCallback (copy), RoactNetworking (copy), FFlagLuaAppLaunchWhenLoadingForce (copy), FFlagLuaAppLaunchWhenLoadingEdp (copy), EngineFeature (copy), CheckForUpdate (copy), EngineFeature2 (copy), joinGamePlayButton (copy), PlayButtonReferralSource (copy), GamePlayButtonShareLinkAnalytics (copy), PlayButtonStates (copy), CloseCentralOverlay (copy), FetchGamePlayabilityAndProductInfo (copy), OpenCentralOverlayForPurchaseGame (copy), FFlagShipUnifiedPurchaseFlowToPaidAccess (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), ProductPurchaseSurface (copy), getIsUserEligibleForUnifiedPurchaseFlow (copy), ApiPostPreparePurchase (copy), unlockPlayIntent (copy), invalidPlayIntent (copy), FFlagLuaAppPlayButtonLoadingDurationTelemetry (copy), CreateExperienceInvite (copy), FFlagEnableSquadRegroupExperimentation (copy), SquadExperienceInviteSource (copy), FFlagEnablePrivatePartyStartJoin (copy), SquadExperienceInviteType (copy), v45 (copy)
	local v62 = useRoactService(RoactAnalytics)
	local v63 = useRoactService(AppUpdateService)
	local v64 = useRoactService(AppEventIngestService)
	local v65 = useDispatch()
	local v66 = useSelector(function(p7) -- line: 89
		-- upvalues: p1 (copy)
		return p7.GameDetails[p1]
	end)
	local v67 = useGameInfosSelector(p1)
	local v68 = useGameProductInfoSelector(p1)
	local v69 = useSelector(function(p8) -- line: 94
		-- upvalues: p1 (copy)
		return p8.PlayabilityStatus[p1]
	end)
	local u70 = nil

	if FFlagEnableUnifiedProductPurchaseFlow then
		u70 = useGameIconSelector(p1)
	end

	local v71 = useRouteName()
	local v72 = if not GetFFlagIsSquadEnabled() then nil else React.useContext(SquadExternalContractContext)
	local v73 = v66 and v66.rootPlaceId or (v67 and v67.placeId or nil)
	local u74 = if not GetFFlagLuaAppEnableVirtualEventPlaceId() or p6 == "0" then v73 else p6 or v73
	local v75 = v66 and v66.name or (v67 and v67.name or nil)
	local v76 = usePlayButtonLaunchGame(p1, u74, v73, p2, p3, p5, t1)
	local v77 = nil

	if FFlagLuaAppPlayableUxTreatment then
		v77 = usePlayButtonLaunchWithUxTreatment(v69, p1, v76, if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else v71)
	end

	local v78 = usePlayButtonLaunchAfterSeventeenPlusUpsell(v69, p1, if not FFlagLuaAppPlayableUxTreatment then v76 else v77, if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else v71)
	local v79 = useAgeVerificationOverlayCallback(p1, v76, v78)
	local v80 = useRoactService(RoactNetworking)
	local v81 = FFlagLuaAppLaunchWhenLoadingForce or FFlagLuaAppLaunchWhenLoadingEdp and b1 == true
	local v82 = if not FFlagLuaAppLaunchWhenLoadingForce and not FFlagLuaAppLaunchWhenLoadingEdp then nil else React.useCallback(function(p9) -- line: 156
		-- upvalues: v79 (copy), v78 (copy), EngineFeature (copy), v65 (copy), CheckForUpdate (copy), v63 (copy), EngineFeature2 (copy), v62 (copy), p3 (copy)
		local v86 = not game:GetEngineFeature("VoiceChatSupported") and function() -- line: 163
			-- upvalues: v78 (copy), p9 (copy)
			v78(p9)
		end or function() -- line: 159
			-- upvalues: v79 (copy), p9 (copy)
			v79(p9)
		end

		if EngineFeature then
			v65(CheckForUpdate(v63, EngineFeature2, v62, v86, {
				ctx = p3
			}))

			return
		end

		v86()
	end, {
		v62,
		v63,
		EngineFeature2,
		p3,
		v79,
		v78,
		v65
	})

	return (React.useCallback(function(p10, p11, t2: {[any]: any}?) -- line: 187
		-- upvalues: joinGamePlayButton (copy), v62 (copy), p2 (copy), v73 (copy), p3 (copy), PlayButtonReferralSource (copy), GamePlayButtonShareLinkAnalytics (copy), GetFFlagLuaAppEnableVirtualEventPlaceId (copy), u74 (ref), p1 (copy), PlayButtonStates (copy), FFlagLuaAppLaunchWhenLoadingForce (copy), FFlagLuaAppLaunchWhenLoadingEdp (copy), v82 (copy), v79 (copy), v78 (copy), EngineFeature (copy), v65 (copy), CheckForUpdate (copy), v63 (copy), EngineFeature2 (copy), v68 (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), CloseCentralOverlay (copy), FetchGamePlayabilityAndProductInfo (copy), v80 (copy), OpenCentralOverlayForPurchaseGame (copy), v75 (copy), v71 (copy), FFlagShipUnifiedPurchaseFlowToPaidAccess (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), u70 (ref), ProductPurchaseSurface (copy), getIsUserEligibleForUnifiedPurchaseFlow (copy), ApiPostPreparePurchase (copy), unlockPlayIntent (copy), v64 (copy), v69 (copy), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), invalidPlayIntent (copy), FFlagLuaAppPlayButtonLoadingDurationTelemetry (copy), v81 (copy), GetFFlagIsSquadEnabled (copy), CreateExperienceInvite (copy), v72 (copy), FFlagEnableSquadRegroupExperimentation (copy), SquadExperienceInviteSource (copy), FFlagEnablePrivatePartyStartJoin (copy), SquadExperienceInviteType (copy), v45 (copy)
		joinGamePlayButton(v62.InfluxDb, "playButtonClicked", {
			isUniversalApp = true,
			referralSource = p2,
			placeId = v73,
			buttonState = p10 and p10 or "Invalid",
			ctx = p3
		})

		if p2 == PlayButtonReferralSource.ExperienceDetailsLink then
			GamePlayButtonShareLinkAnalytics(v62, {
				placeId = if not GetFFlagLuaAppEnableVirtualEventPlaceId() then v73 else u74,
				playButtonState = p10,
				universeId = p1
			})
		end

		if p10 == PlayButtonStates.Playable or p10 == PlayButtonStates.ActionNeeded then
			if FFlagLuaAppLaunchWhenLoadingForce or FFlagLuaAppLaunchWhenLoadingEdp then
				v82(p11)

				return
			end

			local v90 = not game:GetEngineFeature("VoiceChatSupported") and function() -- line: 213
				-- upvalues: v78 (copy), p11 (copy)
				v78(p11)
			end or function() -- line: 209
				-- upvalues: v79 (copy), p11 (copy)
				v79(p11)
			end

			if EngineFeature then
				v65(CheckForUpdate(v63, EngineFeature2, v62, v90, {
					ctx = p3
				}))

				return
			end

			v90()

			return
		end

		if p10 == PlayButtonStates.PaidAccess then
			local v91 = v68 and v68.price or nil
			local v92 = v68 and v68.productId or nil
			local v93 = v68 and v68.sellerId or nil

			if FFlagEnableUnifiedProductPurchaseFlow then
				local v94 = v68 and v68.universeId or nil

				local function onFlowComplete() -- line: 233
					-- upvalues: v65 (copy), CloseCentralOverlay (copy)
					v65(CloseCentralOverlay())
				end
				local function onPurchaseSuccess() -- line: 236
					-- upvalues: v65 (copy), FetchGamePlayabilityAndProductInfo (copy), v80 (copy), v94 (copy)
					v65(FetchGamePlayabilityAndProductInfo.Fetch(v80, v94))
				end
				local function initiateLegacyPurchaseFlow() -- line: 239
					-- upvalues: v65 (copy), OpenCentralOverlayForPurchaseGame (copy), v94 (copy), v75 (copy), v91 (copy), v92 (copy), v93 (copy), v71 (copy)
					v65(OpenCentralOverlayForPurchaseGame(v94, v75, v91, v92, v93, { v71 }))
				end

				if FFlagShipUnifiedPurchaseFlowToPaidAccess then
					v65(OpenCentralOverlayForUnifiedPurchasePrompt({
						productPayload = {
							kind = "Experience",
							universeId = v94,
							experienceName = v75,
							experienceIconUrl = u70.url
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

				getIsUserEligibleForUnifiedPurchaseFlow(v80):andThen(function(p12) -- line: 270
					-- upvalues: v65 (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), v94 (copy), v75 (copy), u70 (ref), onFlowComplete (copy), onPurchaseSuccess (copy), ProductPurchaseSurface (copy), OpenCentralOverlayForPurchaseGame (copy), v91 (copy), v92 (copy), v93 (copy), v71 (copy)
					if p12 then
						v65(OpenCentralOverlayForUnifiedPurchasePrompt({
							productPayload = {
								kind = "Experience",
								universeId = v94,
								experienceName = v75,
								experienceIconUrl = u70.url
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

					v65(OpenCentralOverlayForPurchaseGame(v94, v75, v91, v92, v93, { v71 }))
				end):catch(function(_) -- line: 291
					-- upvalues: v65 (copy), OpenCentralOverlayForPurchaseGame (copy), v94 (copy), v75 (copy), v91 (copy), v92 (copy), v93 (copy), v71 (copy)
					v65(OpenCentralOverlayForPurchaseGame(v94, v75, v91, v92, v93, { v71 }))
				end)

				return
			end

			v65(OpenCentralOverlayForPurchaseGame(p1, v75, v91, v92, v93, { v71 }))

			return
		end

		if p10 == PlayButtonStates.FiatPaidAccess then
			if v73 and v68 and v68.fiatBasePriceId then
				v65(ApiPostPreparePurchase.Fetch(v80, v73, p1, v68.fiatBasePriceId))
				unlockPlayIntent(v64, {
					upsellName = "FiatPurchase",
					universeId = p1,
					playabilityStatus = v69 and v69.playabilityStatus or nil,
					pageName = if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else v71
				})

				return
			end
		else
			if p10 == PlayButtonStates.Loading then
				invalidPlayIntent(p3, {
					universeId = p1,
					playButtonState = p10,
					playabilityStatus = v69 and v69.playabilityStatus or nil,
					pageName = if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else v71
				})

				if v81 then
					v82(p11)
				end

				return
			end

			if GetFFlagIsSquadEnabled() and p10 == PlayButtonStates.PlayableWithParty then
				if v73 then
					v65(CreateExperienceInvite(v73, v72, if not FFlagEnableSquadRegroupExperimentation then nil else SquadExperienceInviteSource.Default, if not FFlagEnablePrivatePartyStartJoin or (not t2 or not t2.isPrivateParty) then nil else SquadExperienceInviteType.PlayWithPartyInPrivatePartyServer))

					return
				end
			else
				if v45 and p10 == PlayButtonStates.WaitingForParty then
					invalidPlayIntent(p3, {
						universeId = p1,
						playButtonState = p10,
						playabilityStatus = v69 and v69.playabilityStatus or nil,
						pageName = if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else v71
					})

					return
				end

				if p10 == PlayButtonStates.UnplayableOther then
					invalidPlayIntent(p3, {
						universeId = p1,
						playButtonState = p10,
						playabilityStatus = v69 and v69.playabilityStatus or nil,
						pageName = if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else v71
					})

					return
				end

				error(`invalid play button state { p10 }!`)
			end
		end
	end, {
		v62,
		v63,
		EngineFeature2,
		p1,
		if not GetFFlagLuaAppEnableVirtualEventPlaceId() then nil else u74,
		v73,
		v75,
		p2,
		p3,
		if not FFlagLuaAppLaunchWhenLoadingForce and not FFlagLuaAppLaunchWhenLoadingEdp then nil else v82,
		if not FFlagLuaAppLaunchWhenLoadingForce and not FFlagLuaAppLaunchWhenLoadingEdp then v79 else nil,
		if not FFlagLuaAppLaunchWhenLoadingForce and not FFlagLuaAppLaunchWhenLoadingEdp then v78 else nil,
		v68,
		v71,
		if not GetFFlagIsSquadEnabled() then nil else v72,
		v69,
		if not FFlagLuaAppLaunchWhenLoadingForce and not FFlagLuaAppLaunchWhenLoadingEdp then nil else v81
	}))
end
