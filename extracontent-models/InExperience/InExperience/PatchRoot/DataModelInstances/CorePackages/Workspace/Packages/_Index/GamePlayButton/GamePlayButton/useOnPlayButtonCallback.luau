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
local FFlagLuaAppPlayButtonPrivatePT = SharedFlags12.FFlagLuaAppPlayButtonPrivatePT
local SharedFlags13 = require(parent.SharedFlags)
local FFlagLuaAppPrivatePlaytestEarlyTesting = SharedFlags13.FFlagLuaAppPrivatePlaytestEarlyTesting

local SharedFlags14 = require(parent.SharedFlags)
local FFlagLuaAppPrivatePlaytestWithoutBuildMode = SharedFlags14.FFlagLuaAppPrivatePlaytestWithoutBuildMode

local SharedFlags15 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonPrivatePTEnableSingleButton = SharedFlags15.FFlagLuaAppPlayButtonPrivatePTEnableSingleButton

local SharedFlags16 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonPrivatePTEnableDualButton = SharedFlags16.FFlagLuaAppPlayButtonPrivatePTEnableDualButton
local SharedFlags17 = require(parent.SharedFlags)
local FFlagLuaAppCloudClientPlayButtonOffer = SharedFlags17.FFlagLuaAppCloudClientPlayButtonOffer
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

	local v6 = GameHydrationReact.useGameInfo(universeId)
	local v7 = useGameProductInfoSelector(universeId)
	local v8 = useSelector(function(p4)
		return p4.PlayabilityStatus[universeId]
	end)

	local experienceIconUrl = GameHydrationReact.useGameIcon(universeId)

	local pageName = useRouteName()
	local v9

	if GetFFlagIsSquadEnabled() then
		v9 = React.useContext(SquadExternalContractContext)
	else
		v9 = nil
	end

	local rootPlaceId = v5 and v5.rootPlaceId

	if not rootPlaceId then
		if v6 then
			rootPlaceId = v6.rootPlaceId or nil
		else
			rootPlaceId = nil
		end
	end

	local v10

	if GetFFlagLuaAppEnableVirtualEventPlaceId() and p3 ~= "0" then
		v10 = p3 or rootPlaceId
	else
		v10 = rootPlaceId
	end

	local name = v5 and v5.name

	if not name then
		if v6 then
			name = v6.name or nil
		else
			name = nil
		end
	end

	local v11

	if FFlagLuaAppPlayButtonPrivatePT then
		local id = v5 and v5.creator and v5.creator.id or v6 and v6.creator and v6.creator.id or nil

		if id ~= nil then
			v11 = tostring(id)
		end
	end

	local v12 = usePlayButtonLaunchGame(universeId, v10, rootPlaceId, referralSource, ctx, p, p2)
	local v13

	if FFlagLuaAppCloudClientPlayButtonOffer then
		v13 = usePlayButtonLaunchWithCloudClientOffer(universeId, v10, rootPlaceId, v8, pageName, v12)
	end

	local v14

	if FFlagLuaAppPlayableUxTreatment then
		local v15

		if FFlagLuaAppCloudClientPlayButtonOffer then
			v15 = v13
		else
			v15 = v12
		end

		v14 = usePlayButtonLaunchWithUxTreatment(v8, universeId, v15, pageName)
	end

	if not FFlagLuaAppPlayableUxTreatment then
		v14 = if FFlagLuaAppCloudClientPlayButtonOffer then v13 else v12
	end

	local v15 = usePlayButtonLaunchAfterSeventeenPlusUpsell(v8, universeId, v14, pageName)

	if FFlagLuaAppCloudClientPlayButtonOffer then
		v12 = v13
	end

	local v16 = useAgeVerificationOverlayCallback(universeId, v12, v15)

	local v17 = React.useCallback(function(p4, p5: string?)
		local v17

		if game:GetEngineFeature("VoiceChatSupported") then
			v17 = function()
				local v18

				if FFlagLuaAppDemoModePlayButtonTelemetry then
					v18 = p5
				end

				v16(p4, v18)
			end
		else
			v17 = function()
				local v18

				if FFlagLuaAppDemoModePlayButtonTelemetry then
					v18 = p5
				end

				v15(p4, v18)
			end
		end

		HandleUpdate(v4, v2, engineFeature, v, ctx, v17)
	end, { v, v2, engineFeature, ctx, v16, v15, v4 })

	local v18 = useRoactService(RoactNetworking)
	local v19 = FFlagLuaAppLaunchWhenLoadingForce or FFlagLuaAppLaunchWhenLoadingEdp and flag == true
	local v20

	if FFlagLuaAppPlayButtonPrivatePT then
		local v21 = React.useCallback(function(callback, p4: string?)
			local v21

			if v10 ~= nil then
				v21 = tonumber(v10)
			end

			if v21 == nil then
				DiscoveryEventErrorLogger.reportError(
					"PlaytestLaunchMissingPlaceId",
					`Cannot launch private Playtest without a valid placeId for universeId {universeId}`
				)

				return
			end

			local v22

			if FFlagLuaAppPrivatePlaytestEarlyTesting or FFlagLuaAppPrivatePlaytestWithoutBuildMode then
				v22 = launchPlaytestWithLoadingState(v21, p, nil, nil, true)
			else
				v22 = launchPlaytestWithLoadingState(v21, p, true)
			end

			if v22 and callback ~= nil then
				if not FFlagLuaAppDemoModePlayButtonTelemetry then
					p4 = nil
				end

				callback(p4)
			end
		end, { v10, p, universeId })

		if FFlagLuaAppPlayButtonPrivatePTEnableSingleButton then
			v21 = v17
		end

		v20 = usePrivatePlaytestLaunchWithUpsell(v8, tostring(universeId), v21, ctx, pageName, v11)
	else
		v20 = nil
	end

	local useCallback = React.useCallback
	local function fn(playButtonState, p4, p5)
		joinGamePlayButton(v.InfluxDb, "playButtonClicked", {
			isUniversalApp = true,
			referralSource = referralSource,
			placeId = rootPlaceId,
			buttonState = playButtonState and playButtonState or "Invalid",
			ctx = ctx
		})

		if referralSource == PlayButtonReferralSource.ExperienceDetailsLink then
			local placeId

			if GetFFlagLuaAppEnableVirtualEventPlaceId() then
				placeId = v10
			else
				placeId = rootPlaceId
			end

			GamePlayButtonShareLinkAnalytics(v, {
				placeId = placeId,
				playButtonState = playButtonState,
				universeId = universeId
			})
		end

		if playButtonState == PlayButtonStates.Playable or playButtonState == PlayButtonStates.ActionNeeded then
			if FFlagLuaAppPlayButtonPrivatePTEnableSingleButton then
				local privatePlaytestInfo = v8 and v8.privatePlaytestInfo or nil

				if playButtonState == PlayButtonStates.ActionNeeded and privatePlaytestInfo ~= nil then
					v20(p4, "PlaytestPlayButtonClick")

					return
				end
			end

			v17(p4)
		elseif playButtonState == PlayButtonStates.PaidAccess then
			local price = v7 and v7.price or nil
			local productId = v7 and v7.productId or nil
			local sellerId = v7 and v7.sellerId or nil
			local universeId2 = v7 and v7.universeId or nil
			local function onFlowComplete()
				v4(CloseCentralOverlay())
			end
			local function onPurchaseSuccess()
				v4(FetchGamePlayabilityAndProductInfo.Fetch(v18, universeId2))
			end
			local function initiateLegacyPurchaseFlow() -- 2 equivalent calls inferred from this helper
				v4(OpenCentralOverlayForPurchaseGame(universeId2, name, price, productId, sellerId, { pageName }))
			end

			if FFlagShipUnifiedPurchaseFlowToPaidAccess then
				v4(OpenCentralOverlayForUnifiedPurchasePrompt({
					productPayload = {
						universeId = universeId2,
						kind = "Experience",
						experienceName = name,
						experienceIconUrl = experienceIconUrl
					},
					purchaseCallbacks = {
						onFlowComplete = onFlowComplete,
						onPurchaseSuccess = onPurchaseSuccess
					},
					purchaseAnalyticsMetadata = { surface = ProductPurchaseSurface.PaidAccess }
				}))
			else
				getIsUserEligibleForUnifiedPurchaseFlow(v18):andThen(function(p6)
					if p6 then
						v4(OpenCentralOverlayForUnifiedPurchasePrompt({
							productPayload = {
								universeId = universeId2,
								kind = "Experience",
								experienceName = name,
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
				v17(p4, "DemoPlayButtonClick")
			else
				v17(p4)
			end
		elseif FFlagLuaAppPlayButtonPrivatePTEnableDualButton and playButtonState == PlayButtonStates.Playtest then
			v20(p4, "PlaytestPlayButtonClick")
		elseif playButtonState == PlayButtonStates.FiatPaidAccess then
			if rootPlaceId and v7 and v7.fiatBasePriceId then
				v4(ApiPostPreparePurchase.Fetch(v18, rootPlaceId, universeId, v7.fiatBasePriceId))

				unlockPlayIntent(v3, {
					universeId = universeId,
					upsellName = "FiatPurchase",
					playabilityStatus = v8 and v8.playabilityStatus or nil,
					pageName = pageName
				})
			end
		elseif playButtonState == PlayButtonStates.Loading then
			local v21 = {
				universeId = universeId,
				playButtonState = playButtonState,
				playabilityStatus = v8 and v8.playabilityStatus or nil,
				pageName = 0
			}
			local pageName2

			if FFlagLuaAppPlayButtonLoadingDurationTelemetry then
				pageName2 = pageName
			end

			v21.pageName = pageName2
			invalidPlayIntent(ctx, v21)

			if v19 then
				v17(p4)
			end
		elseif GetFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.PlayableWithParty then
			if rootPlaceId then
				local default

				if FFlagEnableSquadRegroupExperimentation then
					default = SquadExperienceInviteSource.Default
				end

				local v21

				if FFlagEnablePrivatePartyStartJoin and p5 and p5.isPrivateParty then
					v21 = SquadExperienceInviteType.PlayWithPartyInPrivatePartyServer
				end

				v4(CreateExperienceInvite(rootPlaceId, v9, default, v21))
			end
		elseif playButtonState == PlayButtonStates.WaitingForParty then
			local v21 = {
				universeId = universeId,
				playButtonState = playButtonState,
				playabilityStatus = v8 and v8.playabilityStatus or nil,
				pageName = 0
			}
			local pageName2

			if FFlagLuaAppPlayButtonLoadingDurationTelemetry then
				pageName2 = pageName
			end

			v21.pageName = pageName2
			invalidPlayIntent(ctx, v21)
		elseif
			playButtonState == PlayButtonStates.UnplayableOther
			or FFlagEnableGameJoinEarlyAccess and playButtonState == PlayButtonStates.EarlyAccessLocked
		then
			local v21 = {
				universeId = universeId,
				playButtonState = playButtonState,
				playabilityStatus = v8 and v8.playabilityStatus or nil,
				pageName = 0
			}
			local pageName2

			if FFlagLuaAppPlayButtonLoadingDurationTelemetry then
				pageName2 = pageName
			end

			v21.pageName = pageName2
			invalidPlayIntent(ctx, v21)
		else
			error(`invalid play button state {playButtonState}!`)
		end
	end

	local v21

	if GetFFlagLuaAppEnableVirtualEventPlaceId() or FFlagLuaAppPlayButtonPrivatePT then
		v21 = v10
	end

	local v22

	if FFlagLuaAppPlayButtonPrivatePT then
		v22 = p
	end

	local v24

	if FFlagLuaAppPlayButtonPrivatePT then
		v24 = v20
	end

	local v25

	if GetFFlagIsSquadEnabled() then
		v25 = v9
	end

	local v23 = {
		v,
		v2,
		engineFeature,
		universeId,
		v21,
		rootPlaceId,
		name,
		referralSource,
		ctx,
		v17,
		v7,
		pageName,
		v22,
		v24,
		v25,
		v8,
		nil,
		nil,
		nil,
		nil,
		nil
	}
	local v26

	if FFlagLuaAppLaunchWhenLoadingForce or FFlagLuaAppLaunchWhenLoadingEdp then
		v26 = v19
	end

	v23[17], v23[18], v23[19], v23[20], v23[21] = v4, v3, experienceIconUrl, v18, v26
	return (useCallback(fn, v23))
end
