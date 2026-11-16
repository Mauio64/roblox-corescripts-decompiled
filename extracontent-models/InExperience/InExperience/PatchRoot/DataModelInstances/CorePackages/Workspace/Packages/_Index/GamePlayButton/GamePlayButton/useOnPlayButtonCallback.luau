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

local usePrivatePlaytestLaunchWithUpsell = require(GamePlayButton.PlayButtonLaunchChecks.usePrivatePlaytestLaunchWithUpsell)

local parent = GamePlayButton.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Navigation = require(parent.Navigation)
local useRouteName = Navigation.useRouteName
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local RoactNetworking = RoactServiceTags.RoactNetworking
local AppUpdateService = RoactServiceTags.AppUpdateService
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local joinGamePlayButton = DiscoveryAnalytics.Points.joinGamePlayButton
local DiscoveryAnalytics2 = require(parent.DiscoveryAnalytics)
local unlockPlayIntent = DiscoveryAnalytics2.Events.unlockPlayIntent
local DiscoveryAnalytics3 = require(parent.DiscoveryAnalytics)
local invalidPlayIntent = DiscoveryAnalytics3.Events.invalidPlayIntent
local RoactServiceTags2 = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags2.AppEventIngestService
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local RobloxAppUpdate = require(parent.RobloxAppUpdate)
local HandleUpdate = RobloxAppUpdate.HandleUpdate
local launchPlaytestWithLoadingState = require(parent.BuildExperiencePlaytestLaunch.launchPlaytestWithLoadingState)
local GameProductInfoRodux = require(parent.GameProductInfoRodux)
local useGameProductInfoSelector = GameProductInfoRodux.useGameProductInfoSelector
local GameInfosRodux = require(parent.GameInfosRodux)
local useGameInfosSelector = GameInfosRodux.useGameInfosSelector
local GameHydrationReact = require(parent.GameHydrationReact)
local CentralOverlay = require(parent.CentralOverlay)
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local GameDetailRodux = require(parent.GameDetailRodux)
local FetchGamePlayabilityAndProductInfo = GameDetailRodux.FetchGamePlayabilityAndProductInfo
local PurchasePromptLite = require(parent.PurchasePromptLite)
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local getIsUserEligibleForUnifiedPurchaseFlow = PurchasePromptLite.getIsUserEligibleForUnifiedPurchaseFlow
local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagLuaAppEnableVirtualEventPlaceId = SharedFlags2.GetFFlagLuaAppEnableVirtualEventPlaceId
local SharedFlags3 = require(parent.SharedFlags)
local FFlagShipUnifiedPurchaseFlowToPaidAccess = SharedFlags3.FFlagShipUnifiedPurchaseFlowToPaidAccess
local Thunks = require(parent.Squads.Thunks)
local CreateExperienceInvite = Thunks.CreateExperienceInvite

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local Enums = require(parent.SquadsCore.Enums)
local SquadExperienceInviteType = Enums.SquadExperienceInviteType
local Enums2 = require(parent.SquadsCore.Enums)
local SquadExperienceInviteSource = Enums2.SquadExperienceInviteSource
require(parent.PlayabilityRodux)

local engineFeature = game:GetEngineFeature("CanPerformBinaryUpdateEnabled")
local SharedFlags4 = require(parent.SharedFlags)
local FFlagEnableSquadRegroupExperimentation = SharedFlags4.FFlagEnableSquadRegroupExperimentation
local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppPlayableUxTreatment = SharedFlags5.FFlagLuaAppPlayableUxTreatment
local SharedFlags6 = require(parent.SharedFlags)
local FFlagEnablePrivatePartyStartJoin = SharedFlags6.FFlagEnablePrivatePartyStartJoin

local SharedFlags7 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonLoadingDurationTelemetry = SharedFlags7.FFlagLuaAppPlayButtonLoadingDurationTelemetry
local SharedFlags8 = require(parent.SharedFlags)
local FFlagLuaAppLaunchWhenLoadingEdp = SharedFlags8.FFlagLuaAppLaunchWhenLoadingEdp
local SharedFlags9 = require(parent.SharedFlags)
local FFlagEnableGameJoinEarlyAccess = SharedFlags9.FFlagEnableGameJoinEarlyAccess
local SharedFlags10 = require(parent.SharedFlags)
local FFlagLuaAppLaunchWhenLoadingForce = SharedFlags10.FFlagLuaAppLaunchWhenLoadingForce
local SharedFlags11 = require(parent.SharedFlags)
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags11.FFlagLuaAppDemoModePlayButtonTelemetry
local SharedFlags12 = require(parent.SharedFlags)
local FFlagMigrateGameInfoToStore = SharedFlags12.FFlagMigrateGameInfoToStore
local SharedFlags13 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonPrivatePT = SharedFlags13.FFlagLuaAppPlayButtonPrivatePT
local SharedFlags14 = require(parent.SharedFlags)
local FFlagLuaAppPrivatePlaytestEarlyTesting = SharedFlags14.FFlagLuaAppPrivatePlaytestEarlyTesting

local SharedFlags15 = require(parent.SharedFlags)
local FFlagLuaAppPrivatePlaytestWithoutBuildMode = SharedFlags15.FFlagLuaAppPrivatePlaytestWithoutBuildMode

local SharedFlags16 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonPrivatePTEnableSingleButton = SharedFlags16.FFlagLuaAppPlayButtonPrivatePTEnableSingleButton

local SharedFlags17 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonPrivatePTEnableDualButton = SharedFlags17.FFlagLuaAppPlayButtonPrivatePTEnableDualButton
local SharedFlags18 = require(parent.SharedFlags)
local FFlagLuaAppCloudClientPlayButtonOffer = SharedFlags18.FFlagLuaAppCloudClientPlayButtonOffer
local usePlayButtonLaunchWithCloudClientOffer

if FFlagLuaAppCloudClientPlayButtonOffer then
	usePlayButtonLaunchWithCloudClientOffer = require(GamePlayButton.PlayButtonLaunchChecks.usePlayButtonLaunchWithCloudClientOffer)
else
	usePlayButtonLaunchWithCloudClientOffer = nil
end

return function(universeId, referralSource, ctx, _, p, p2, p3, flag: boolean?)
	local v = useRoactService(RoactAnalytics)
	local v2 = useRoactService(AppUpdateService)
	local v3 = useRoactService(AppEventIngestService)

	local v4 = useDispatch()
	local v5 = useSelector(function(p4)
		return p4.GameDetails[universeId]
	end)

	local v6 = nil
	local v7 = nil

	if FFlagMigrateGameInfoToStore then
		v7 = GameHydrationReact.useGameInfo(universeId)
	else
		v6 = useGameInfosSelector(universeId)
	end

	local v8 = useGameProductInfoSelector(universeId)
	local v9 = useSelector(function(p4)
		return p4.PlayabilityStatus[universeId]
	end)

	local experienceIconUrl = GameHydrationReact.useGameIcon(universeId)

	local pageName = useRouteName()
	local v10

	if GetFFlagIsSquadEnabled() then
		v10 = React.useContext(SquadExternalContractContext)
	else
		v10 = nil
	end

	local placeId = v5 and v5.rootPlaceId

	if not placeId then
		local v11

		if FFlagMigrateGameInfoToStore then
			v11 = v7 and v7.rootPlaceId
		else
			v11 = v6 and v6.placeId
		end

		placeId = v11 or nil
	end

	local v11

	if GetFFlagLuaAppEnableVirtualEventPlaceId() and p3 ~= "0" then
		v11 = p3 or placeId
	else
		v11 = placeId
	end

	local experienceName = v5 and v5.name

	if not experienceName then
		local v12

		if FFlagMigrateGameInfoToStore then
			v12 = v7 and v7.name
		else
			v12 = v6 and v6.name
		end

		experienceName = v12 or nil
	end

	local v12

	if FFlagLuaAppPlayButtonPrivatePT then
		local v13 = v5 and v5.creator and v5.creator.id

		if not v13 then
			local v14

			if FFlagMigrateGameInfoToStore then
				v14 = v7 and v7.creator and v7.creator.id
			else
				v14 = v6 and v6.creatorId
			end

			v13 = v14 or nil
		end

		if v13 ~= nil then
			v12 = tostring(v13)
		end
	end

	local v13 = usePlayButtonLaunchGame(universeId, v11, placeId, referralSource, ctx, p, p2)
	local v14

	if FFlagLuaAppCloudClientPlayButtonOffer then
		v14 = usePlayButtonLaunchWithCloudClientOffer(universeId, v11, placeId, v9, pageName, v13)
	end

	local v15

	if FFlagLuaAppPlayableUxTreatment then
		local v16

		if FFlagLuaAppCloudClientPlayButtonOffer then
			v16 = v14
		else
			v16 = v13
		end

		v15 = usePlayButtonLaunchWithUxTreatment(v9, universeId, v16, pageName)
	end

	if not FFlagLuaAppPlayableUxTreatment then
		v15 = if FFlagLuaAppCloudClientPlayButtonOffer then v14 else v13
	end

	local v16 = usePlayButtonLaunchAfterSeventeenPlusUpsell(v9, universeId, v15, pageName)

	if FFlagLuaAppCloudClientPlayButtonOffer then
		v13 = v14
	end

	local v17 = useAgeVerificationOverlayCallback(universeId, v13, v16)

	local v18 = React.useCallback(function(p4, p5: string?)
		local v18

		if game:GetEngineFeature("VoiceChatSupported") then
			v18 = function()
				local v19

				if FFlagLuaAppDemoModePlayButtonTelemetry then
					v19 = p5
				end

				v17(p4, v19)
			end
		else
			v18 = function()
				local v19

				if FFlagLuaAppDemoModePlayButtonTelemetry then
					v19 = p5
				end

				v16(p4, v19)
			end
		end

		HandleUpdate(v4, v2, engineFeature, v, ctx, v18)
	end, { v, v2, engineFeature, ctx, v17, v16, v4 })

	local v19 = useRoactService(RoactNetworking)
	local v20 = FFlagLuaAppLaunchWhenLoadingForce or FFlagLuaAppLaunchWhenLoadingEdp and flag == true
	local v21

	if FFlagLuaAppPlayButtonPrivatePT then
		local v22 = React.useCallback(function(callback, p4: string?)
			local v22

			if v11 ~= nil then
				v22 = tonumber(v11)
			end

			if v22 == nil then
				DiscoveryEventErrorLogger.reportError(
					"PlaytestLaunchMissingPlaceId",
					`Cannot launch private Playtest without a valid placeId for universeId {universeId}`
				)

				return
			end

			local v23

			if FFlagLuaAppPrivatePlaytestEarlyTesting or FFlagLuaAppPrivatePlaytestWithoutBuildMode then
				v23 = launchPlaytestWithLoadingState(v22, p, nil, nil, true)
			else
				v23 = launchPlaytestWithLoadingState(v22, p, true)
			end

			if v23 and callback ~= nil then
				if not FFlagLuaAppDemoModePlayButtonTelemetry then
					p4 = nil
				end

				callback(p4)
			end
		end, { v11, p, universeId })

		if FFlagLuaAppPlayButtonPrivatePTEnableSingleButton then
			v22 = v18
		end

		v21 = usePrivatePlaytestLaunchWithUpsell(v9, tostring(universeId), v22, ctx, pageName, v12)
	else
		v21 = nil
	end

	local useCallback = React.useCallback
	local function fn(playButtonState, p4, p5)
		joinGamePlayButton(v.InfluxDb, "playButtonClicked", {
			isUniversalApp = true,
			referralSource = referralSource,
			placeId = placeId,
			buttonState = playButtonState and playButtonState or "Invalid",
			ctx = ctx
		})

		if referralSource == PlayButtonReferralSource.ExperienceDetailsLink then
			local placeId2

			if GetFFlagLuaAppEnableVirtualEventPlaceId() then
				placeId2 = v11
			else
				placeId2 = placeId
			end

			GamePlayButtonShareLinkAnalytics(v, {
				placeId = placeId2,
				playButtonState = playButtonState,
				universeId = universeId
			})
		end

		if playButtonState == PlayButtonStates.Playable or playButtonState == PlayButtonStates.ActionNeeded then
			if FFlagLuaAppPlayButtonPrivatePTEnableSingleButton then
				local privatePlaytestInfo = v9 and v9.privatePlaytestInfo or nil

				if playButtonState == PlayButtonStates.ActionNeeded and privatePlaytestInfo ~= nil then
					v21(p4, "PlaytestPlayButtonClick")

					return
				end
			end

			v18(p4)
		elseif playButtonState == PlayButtonStates.PaidAccess then
			local price = v8 and v8.price or nil
			local productId = v8 and v8.productId or nil
			local sellerId = v8 and v8.sellerId or nil
			local universeId2 = v8 and v8.universeId or nil
			local function onFlowComplete()
				v4(CloseCentralOverlay())
			end
			local function onPurchaseSuccess()
				v4(FetchGamePlayabilityAndProductInfo.Fetch(v19, universeId2))
			end
			local function initiateLegacyPurchaseFlow() -- 2 equivalent calls inferred from this helper
				v4(OpenCentralOverlayForPurchaseGame(universeId2, experienceName, price, productId, sellerId, {
					pageName
				}))
			end

			if FFlagShipUnifiedPurchaseFlowToPaidAccess then
				v4(OpenCentralOverlayForUnifiedPurchasePrompt({
					productPayload = {
						universeId = universeId2,
						kind = "Experience",
						experienceName = experienceName,
						experienceIconUrl = experienceIconUrl
					},
					purchaseCallbacks = {
						onFlowComplete = onFlowComplete,
						onPurchaseSuccess = onPurchaseSuccess
					},
					purchaseAnalyticsMetadata = { surface = ProductPurchaseSurface.PaidAccess }
				}))
			else
				getIsUserEligibleForUnifiedPurchaseFlow(v19):andThen(function(p6)
					if p6 then
						v4(OpenCentralOverlayForUnifiedPurchasePrompt({
							productPayload = {
								universeId = universeId2,
								kind = "Experience",
								experienceName = experienceName,
								experienceIconUrl = experienceIconUrl
							},
							purchaseCallbacks = {
								onFlowComplete = onFlowComplete,
								onPurchaseSuccess = onPurchaseSuccess
							},
							purchaseAnalyticsMetadata = {
								surface = ProductPurchaseSurface.PaidAccess
							}
						}))
					else
						initiateLegacyPurchaseFlow() -- inferred equivalent call
					end
				end):catch(function(_)
					initiateLegacyPurchaseFlow() -- inferred equivalent call
				end)
			end
		elseif playButtonState == PlayButtonStates.DemoMode then
			if FFlagLuaAppDemoModePlayButtonTelemetry then
				v18(p4, "DemoPlayButtonClick")
			else
				v18(p4)
			end
		elseif FFlagLuaAppPlayButtonPrivatePTEnableDualButton and playButtonState == PlayButtonStates.Playtest then
			v21(p4, "PlaytestPlayButtonClick")
		elseif playButtonState == PlayButtonStates.FiatPaidAccess then
			if placeId and v8 and v8.fiatBasePriceId then
				v4(ApiPostPreparePurchase.Fetch(v19, placeId, universeId, v8.fiatBasePriceId))

				unlockPlayIntent(v3, {
					universeId = universeId,
					upsellName = "FiatPurchase",
					playabilityStatus = v9 and v9.playabilityStatus or nil,
					pageName = pageName
				})
			end
		elseif playButtonState == PlayButtonStates.Loading then
			local v22 = {
				universeId = universeId,
				playButtonState = playButtonState,
				playabilityStatus = v9 and v9.playabilityStatus or nil,
				pageName = 0
			}
			local pageName2

			if FFlagLuaAppPlayButtonLoadingDurationTelemetry then
				pageName2 = pageName
			end

			v22.pageName = pageName2
			invalidPlayIntent(ctx, v22)

			if v20 then
				v18(p4)
			end
		elseif GetFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.PlayableWithParty then
			if placeId then
				local default

				if FFlagEnableSquadRegroupExperimentation then
					default = SquadExperienceInviteSource.Default
				end

				local v22

				if FFlagEnablePrivatePartyStartJoin and p5 and p5.isPrivateParty then
					v22 = SquadExperienceInviteType.PlayWithPartyInPrivatePartyServer
				end

				v4(CreateExperienceInvite(placeId, v10, default, v22))
			end
		elseif playButtonState == PlayButtonStates.WaitingForParty then
			local v22 = {
				universeId = universeId,
				playButtonState = playButtonState,
				playabilityStatus = v9 and v9.playabilityStatus or nil,
				pageName = 0
			}
			local pageName2

			if FFlagLuaAppPlayButtonLoadingDurationTelemetry then
				pageName2 = pageName
			end

			v22.pageName = pageName2
			invalidPlayIntent(ctx, v22)
		elseif
			playButtonState == PlayButtonStates.UnplayableOther
			or FFlagEnableGameJoinEarlyAccess and playButtonState == PlayButtonStates.EarlyAccessLocked
		then
			local v22 = {
				universeId = universeId,
				playButtonState = playButtonState,
				playabilityStatus = v9 and v9.playabilityStatus or nil,
				pageName = 0
			}
			local pageName2

			if FFlagLuaAppPlayButtonLoadingDurationTelemetry then
				pageName2 = pageName
			end

			v22.pageName = pageName2
			invalidPlayIntent(ctx, v22)
		else
			error(`invalid play button state {playButtonState}!`)
		end
	end

	local v22

	if GetFFlagLuaAppEnableVirtualEventPlaceId() or FFlagLuaAppPlayButtonPrivatePT then
		v22 = v11
	end

	local v23

	if FFlagLuaAppPlayButtonPrivatePT then
		v23 = p
	end

	local v24

	if FFlagLuaAppPlayButtonPrivatePT then
		v24 = v21
	end

	local v25

	if GetFFlagIsSquadEnabled() then
		v25 = v10
	end

	local v26 = {
		v,
		v2,
		engineFeature,
		universeId,
		v22,
		placeId,
		experienceName,
		referralSource,
		ctx,
		v18,
		v8,
		pageName,
		v23,
		v24,
		v25,
		v9,
		nil,
		nil,
		nil,
		nil,
		nil
	}
	local v27

	if FFlagLuaAppLaunchWhenLoadingForce or FFlagLuaAppLaunchWhenLoadingEdp then
		v27 = v20
	end

	v26[17], v26[18], v26[19], v26[20], v26[21] = v4, v3, experienceIconUrl, v19, v27
	return (useCallback(fn, v26))
end
