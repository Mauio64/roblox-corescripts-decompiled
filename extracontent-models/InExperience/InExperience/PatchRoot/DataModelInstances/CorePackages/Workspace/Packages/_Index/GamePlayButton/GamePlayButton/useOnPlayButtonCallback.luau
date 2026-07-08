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
local v50 = game:DefineFastFlag("LuaAppInvalidPlayIntent", false)
local FFlagLuaAppLogPageContextUnlockPlayIntent = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppLogPageContextUnlockPlayIntent
local FFlagLuaAppPlayButtonLoadingDurationTelemetry = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppPlayButtonLoadingDurationTelemetry
local FFlagLuaAppLaunchWhenLoadingEdp = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppLaunchWhenLoadingEdp
local FFlagLuaAppLaunchWhenLoadingForce = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppLaunchWhenLoadingForce

return function(p1, p2, p3, _, p5, t1: {[any]: any}?, p6, b1: boolean?) -- line: 75
	-- upvalues: useRoactService (copy), RoactAnalytics (copy), AppUpdateService (copy), AppEventIngestService (copy), useDispatch (copy), useSelector (copy), useGameInfosSelector (copy), useGameProductInfoSelector (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), useGameIconSelector (copy), useRouteName (copy), GetFFlagIsSquadEnabled (copy), React (copy), SquadExternalContractContext (copy), GetFFlagLuaAppEnableVirtualEventPlaceId (copy), usePlayButtonLaunchGame (copy), FFlagLuaAppPlayableUxTreatment (copy), usePlayButtonLaunchWithUxTreatment (copy), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), usePlayButtonLaunchAfterSeventeenPlusUpsell (copy), useAgeVerificationOverlayCallback (copy), RoactNetworking (copy), FFlagLuaAppLaunchWhenLoadingForce (copy), FFlagLuaAppLaunchWhenLoadingEdp (copy), EngineFeature (copy), CheckForUpdate (copy), EngineFeature2 (copy), joinGamePlayButton (copy), PlayButtonReferralSource (copy), GamePlayButtonShareLinkAnalytics (copy), PlayButtonStates (copy), CloseCentralOverlay (copy), FetchGamePlayabilityAndProductInfo (copy), OpenCentralOverlayForPurchaseGame (copy), FFlagShipUnifiedPurchaseFlowToPaidAccess (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), ProductPurchaseSurface (copy), getIsUserEligibleForUnifiedPurchaseFlow (copy), ApiPostPreparePurchase (copy), unlockPlayIntent (copy), v50 (copy), invalidPlayIntent (copy), FFlagLuaAppPlayButtonLoadingDurationTelemetry (copy), CreateExperienceInvite (copy), FFlagEnableSquadRegroupExperimentation (copy), SquadExperienceInviteSource (copy), FFlagEnablePrivatePartyStartJoin (copy), SquadExperienceInviteType (copy), v45 (copy)
	local v63 = useRoactService(RoactAnalytics)
	local v64 = useRoactService(AppUpdateService)
	local v65 = useRoactService(AppEventIngestService)
	local v66 = useDispatch()
	local v67 = useSelector(function(p7) -- line: 90
		-- upvalues: p1 (copy)
		return p7.GameDetails[p1]
	end)
	local v68 = useGameInfosSelector(p1)
	local v69 = useGameProductInfoSelector(p1)
	local v70 = useSelector(function(p8) -- line: 95
		-- upvalues: p1 (copy)
		return p8.PlayabilityStatus[p1]
	end)
	local u71 = nil

	if FFlagEnableUnifiedProductPurchaseFlow then
		u71 = useGameIconSelector(p1)
	end

	local v72 = useRouteName()
	local v73 = if not GetFFlagIsSquadEnabled() then nil else React.useContext(SquadExternalContractContext)
	local v74 = v67 and v67.rootPlaceId or (v68 and v68.placeId or nil)
	local u75 = if not GetFFlagLuaAppEnableVirtualEventPlaceId() or p6 == "0" then v74 else p6 or v74
	local v76 = v67 and v67.name or (v68 and v68.name or nil)
	local v77 = usePlayButtonLaunchGame(p1, u75, v74, p2, p3, p5, t1)
	local v78 = nil

	if FFlagLuaAppPlayableUxTreatment then
		v78 = usePlayButtonLaunchWithUxTreatment(v70, p1, v77, if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else v72)
	end

	local v79 = usePlayButtonLaunchAfterSeventeenPlusUpsell(v70, p1, if not FFlagLuaAppPlayableUxTreatment then v77 else v78, if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else v72)
	local v80 = useAgeVerificationOverlayCallback(p1, v77, v79)
	local v81 = useRoactService(RoactNetworking)
	local v82 = FFlagLuaAppLaunchWhenLoadingForce or FFlagLuaAppLaunchWhenLoadingEdp and b1 == true
	local v83 = if not FFlagLuaAppLaunchWhenLoadingForce and not FFlagLuaAppLaunchWhenLoadingEdp then nil else React.useCallback(function(p9) -- line: 157
		-- upvalues: v80 (copy), v79 (copy), EngineFeature (copy), v66 (copy), CheckForUpdate (copy), v64 (copy), EngineFeature2 (copy), v63 (copy), p3 (copy)
		local v87 = not game:GetEngineFeature("VoiceChatSupported") and function() -- line: 164
			-- upvalues: v79 (copy), p9 (copy)
			v79(p9)
		end or function() -- line: 160
			-- upvalues: v80 (copy), p9 (copy)
			v80(p9)
		end

		if EngineFeature then
			v66(CheckForUpdate(v64, EngineFeature2, v63, v87, {
				ctx = p3
			}))

			return
		end

		v87()
	end, {
		v63,
		v64,
		EngineFeature2,
		p3,
		v80,
		v79,
		v66
	})

	return (React.useCallback(function(p10, p11, t2: {[any]: any}?) -- line: 188
		-- upvalues: joinGamePlayButton (copy), v63 (copy), p2 (copy), v74 (copy), p3 (copy), PlayButtonReferralSource (copy), GamePlayButtonShareLinkAnalytics (copy), GetFFlagLuaAppEnableVirtualEventPlaceId (copy), u75 (ref), p1 (copy), PlayButtonStates (copy), FFlagLuaAppLaunchWhenLoadingForce (copy), FFlagLuaAppLaunchWhenLoadingEdp (copy), v83 (copy), v80 (copy), v79 (copy), EngineFeature (copy), v66 (copy), CheckForUpdate (copy), v64 (copy), EngineFeature2 (copy), v69 (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), CloseCentralOverlay (copy), FetchGamePlayabilityAndProductInfo (copy), v81 (copy), OpenCentralOverlayForPurchaseGame (copy), v76 (copy), v72 (copy), FFlagShipUnifiedPurchaseFlowToPaidAccess (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), u71 (ref), ProductPurchaseSurface (copy), getIsUserEligibleForUnifiedPurchaseFlow (copy), ApiPostPreparePurchase (copy), unlockPlayIntent (copy), v65 (copy), v70 (copy), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), v50 (copy), invalidPlayIntent (copy), FFlagLuaAppPlayButtonLoadingDurationTelemetry (copy), v82 (copy), GetFFlagIsSquadEnabled (copy), CreateExperienceInvite (copy), v73 (copy), FFlagEnableSquadRegroupExperimentation (copy), SquadExperienceInviteSource (copy), FFlagEnablePrivatePartyStartJoin (copy), SquadExperienceInviteType (copy), v45 (copy)
		joinGamePlayButton(v63.InfluxDb, "playButtonClicked", {
			isUniversalApp = true,
			referralSource = p2,
			placeId = v74,
			buttonState = p10 and p10 or "Invalid",
			ctx = p3
		})

		if p2 == PlayButtonReferralSource.ExperienceDetailsLink then
			GamePlayButtonShareLinkAnalytics(v63, {
				placeId = if not GetFFlagLuaAppEnableVirtualEventPlaceId() then v74 else u75,
				playButtonState = p10,
				universeId = p1
			})
		end

		if p10 == PlayButtonStates.Playable or p10 == PlayButtonStates.ActionNeeded then
			if FFlagLuaAppLaunchWhenLoadingForce or FFlagLuaAppLaunchWhenLoadingEdp then
				v83(p11)

				return
			end

			local v91 = not game:GetEngineFeature("VoiceChatSupported") and function() -- line: 214
				-- upvalues: v79 (copy), p11 (copy)
				v79(p11)
			end or function() -- line: 210
				-- upvalues: v80 (copy), p11 (copy)
				v80(p11)
			end

			if EngineFeature then
				v66(CheckForUpdate(v64, EngineFeature2, v63, v91, {
					ctx = p3
				}))

				return
			end

			v91()

			return
		end

		if p10 == PlayButtonStates.PaidAccess then
			local v92 = v69 and v69.price or nil
			local v93 = v69 and v69.productId or nil
			local v94 = v69 and v69.sellerId or nil

			if FFlagEnableUnifiedProductPurchaseFlow then
				local v95 = v69 and v69.universeId or nil

				local function onFlowComplete() -- line: 234
					-- upvalues: v66 (copy), CloseCentralOverlay (copy)
					v66(CloseCentralOverlay())
				end
				local function onPurchaseSuccess() -- line: 237
					-- upvalues: v66 (copy), FetchGamePlayabilityAndProductInfo (copy), v81 (copy), v95 (copy)
					v66(FetchGamePlayabilityAndProductInfo.Fetch(v81, v95))
				end
				local function initiateLegacyPurchaseFlow() -- line: 240
					-- upvalues: v66 (copy), OpenCentralOverlayForPurchaseGame (copy), v95 (copy), v76 (copy), v92 (copy), v93 (copy), v94 (copy), v72 (copy)
					v66(OpenCentralOverlayForPurchaseGame(v95, v76, v92, v93, v94, { v72 }))
				end

				if FFlagShipUnifiedPurchaseFlowToPaidAccess then
					v66(OpenCentralOverlayForUnifiedPurchasePrompt({
						productPayload = {
							kind = "Experience",
							universeId = v95,
							experienceName = v76,
							experienceIconUrl = u71.url
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

				getIsUserEligibleForUnifiedPurchaseFlow(v81):andThen(function(p12) -- line: 271
					-- upvalues: v66 (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), v95 (copy), v76 (copy), u71 (ref), onFlowComplete (copy), onPurchaseSuccess (copy), ProductPurchaseSurface (copy), OpenCentralOverlayForPurchaseGame (copy), v92 (copy), v93 (copy), v94 (copy), v72 (copy)
					if p12 then
						v66(OpenCentralOverlayForUnifiedPurchasePrompt({
							productPayload = {
								kind = "Experience",
								universeId = v95,
								experienceName = v76,
								experienceIconUrl = u71.url
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

					v66(OpenCentralOverlayForPurchaseGame(v95, v76, v92, v93, v94, { v72 }))
				end):catch(function(_) -- line: 292
					-- upvalues: v66 (copy), OpenCentralOverlayForPurchaseGame (copy), v95 (copy), v76 (copy), v92 (copy), v93 (copy), v94 (copy), v72 (copy)
					v66(OpenCentralOverlayForPurchaseGame(v95, v76, v92, v93, v94, { v72 }))
				end)

				return
			end

			v66(OpenCentralOverlayForPurchaseGame(p1, v76, v92, v93, v94, { v72 }))

			return
		end

		if p10 == PlayButtonStates.FiatPaidAccess then
			if v74 and v69 and v69.fiatBasePriceId then
				v66(ApiPostPreparePurchase.Fetch(v81, v74, p1, v69.fiatBasePriceId))
				unlockPlayIntent(v65, {
					upsellName = "FiatPurchase",
					universeId = p1,
					playabilityStatus = v70 and v70.playabilityStatus or nil,
					pageName = if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else v72
				})

				return
			end
		else
			if p10 == PlayButtonStates.Loading then
				if v50 then
					invalidPlayIntent(p3, {
						universeId = p1,
						playButtonState = p10,
						playabilityStatus = v70 and v70.playabilityStatus or nil,
						pageName = if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else v72
					})
				end

				if v82 then
					v83(p11)
				end

				return
			end

			if GetFFlagIsSquadEnabled() and p10 == PlayButtonStates.PlayableWithParty then
				if v74 then
					v66(CreateExperienceInvite(v74, v73, if not FFlagEnableSquadRegroupExperimentation then nil else SquadExperienceInviteSource.Default, if not FFlagEnablePrivatePartyStartJoin or (not t2 or not t2.isPrivateParty) then nil else SquadExperienceInviteType.PlayWithPartyInPrivatePartyServer))

					return
				end
			else
				if v45 and p10 == PlayButtonStates.WaitingForParty then
					if v50 then
						invalidPlayIntent(p3, {
							universeId = p1,
							playButtonState = p10,
							playabilityStatus = v70 and v70.playabilityStatus or nil,
							pageName = if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else v72
						})
					end

					return
				end

				if p10 == PlayButtonStates.UnplayableOther then
					if v50 then
						invalidPlayIntent(p3, {
							universeId = p1,
							playButtonState = p10,
							playabilityStatus = v70 and v70.playabilityStatus or nil,
							pageName = if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else v72
						})
					end

					return
				end

				error(`invalid play button state { p10 }!`)
			end
		end
	end, {
		v63,
		v64,
		EngineFeature2,
		p1,
		if not GetFFlagLuaAppEnableVirtualEventPlaceId() then nil else u75,
		v74,
		v76,
		p2,
		p3,
		if not FFlagLuaAppLaunchWhenLoadingForce and not FFlagLuaAppLaunchWhenLoadingEdp then nil else v83,
		if not FFlagLuaAppLaunchWhenLoadingForce and not FFlagLuaAppLaunchWhenLoadingEdp then v80 else nil,
		if not FFlagLuaAppLaunchWhenLoadingForce and not FFlagLuaAppLaunchWhenLoadingEdp then v79 else nil,
		v69,
		v72,
		if not GetFFlagIsSquadEnabled() then nil else v73,
		if not v50 then nil else v70,
		if not FFlagLuaAppLaunchWhenLoadingForce and not FFlagLuaAppLaunchWhenLoadingEdp then nil else v82
	}))
end
