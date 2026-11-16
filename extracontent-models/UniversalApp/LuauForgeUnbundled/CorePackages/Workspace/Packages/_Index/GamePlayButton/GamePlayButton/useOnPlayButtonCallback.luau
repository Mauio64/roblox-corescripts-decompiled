local ApiPostPreparePurchase = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/ApiPostPreparePurchase")
local GamePlayButtonShareLinkAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/GamePlayButtonShareLinkAnalytics")
local OpenCentralOverlayForPurchaseGame = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/OpenCentralOverlayForPurchaseGame")
local module4 = require("@luauforge/bundled/bEW")
local PlayButtonReferralSource = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonReferralSource")
local PlayButtonStates = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonStates")
require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonTypes")

local usePlayButtonLaunchAfterSeventeenPlusUpsell = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonLaunchChecks/usePlayButtonLaunchAfterSeventeenPlusUpsell")
local usePlayButtonLaunchGame = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonLaunchChecks/usePlayButtonLaunchGame")

local usePlayButtonLaunchWithUxTreatment = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonLaunchChecks/usePlayButtonLaunchWithUxTreatment")

local useAgeVerificationOverlayCallback = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonLaunchChecks/useAgeVerificationOverlayCallback")

local usePrivatePlaytestLaunchWithUpsell = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonLaunchChecks/usePrivatePlaytestLaunchWithUpsell")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useRouteName = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Navigation").useRouteName
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxAppHooks").useRoactService
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactServiceTags")
local roactAnalytics = RoactServiceTags.RoactAnalytics
local roactNetworking = RoactServiceTags.RoactNetworking
local appUpdateService = RoactServiceTags.AppUpdateService
local joinGamePlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryAnalytics").Points.joinGamePlayButton
local unlockPlayIntent = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryAnalytics").Events.unlockPlayIntent
local invalidPlayIntent = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryAnalytics").Events.invalidPlayIntent
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactServiceTags").AppEventIngestService
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryUtils").DiscoveryEventErrorLogger
local handleUpdate = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxAppUpdate").HandleUpdate
local launchPlaytestWithLoadingState = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/BuildExperiencePlaytestLaunch/launchPlaytestWithLoadingState")
local useGameProductInfoSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameProductInfoRodux").useGameProductInfoSelector
local useGameInfosSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameInfosRodux").useGameInfosSelector
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameHydrationReact")
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/CentralOverlay").Thunks.CloseCentralOverlay
local fetchGamePlayabilityAndProductInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameDetailRodux").FetchGamePlayabilityAndProductInfo
local PurchasePromptLite = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/PurchasePromptLite")
local productPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local getIsUserEligibleForUnifiedPurchaseFlow = PurchasePromptLite.getIsUserEligibleForUnifiedPurchaseFlow
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").GetFFlagIsSquadEnabled
local getFFlagLuaAppEnableVirtualEventPlaceId = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").GetFFlagLuaAppEnableVirtualEventPlaceId
local fFlagShipUnifiedPurchaseFlowToPaidAccess = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagShipUnifiedPurchaseFlowToPaidAccess
local createExperienceInvite = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/Squads/Thunks").CreateExperienceInvite

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local squadExperienceInviteType = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/SquadsCore/Enums").SquadExperienceInviteType
local squadExperienceInviteSource = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/SquadsCore/Enums").SquadExperienceInviteSource
require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/PlayabilityRodux")

local engineFeature = game:GetEngineFeature("CanPerformBinaryUpdateEnabled")
local fFlagEnableSquadRegroupExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagEnableSquadRegroupExperimentation
local fFlagLuaAppPlayableUxTreatment = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayableUxTreatment
local fFlagEnablePrivatePartyStartJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagEnablePrivatePartyStartJoin

local fFlagLuaAppPlayButtonLoadingDurationTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonLoadingDurationTelemetry
local fFlagLuaAppLaunchWhenLoadingEdp = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppLaunchWhenLoadingEdp
local fFlagEnableGameJoinEarlyAccess = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagEnableGameJoinEarlyAccess
local fFlagLuaAppLaunchWhenLoadingForce = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppLaunchWhenLoadingForce
local fFlagLuaAppDemoModePlayButtonTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppDemoModePlayButtonTelemetry
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagMigrateGameInfoToStore
local fFlagLuaAppPlayButtonPrivatePT = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonPrivatePT
local fFlagLuaAppPrivatePlaytestEarlyTesting = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPrivatePlaytestEarlyTesting

local fFlagLuaAppPrivatePlaytestWithoutBuildMode = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPrivatePlaytestWithoutBuildMode

local fFlagLuaAppPlayButtonPrivatePTEnableSingleButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonPrivatePTEnableSingleButton

local fFlagLuaAppPlayButtonPrivatePTEnableDualButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonPrivatePTEnableDualButton
local fFlagLuaAppCloudClientPlayButtonOffer = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppCloudClientPlayButtonOffer

local v5 = if fFlagLuaAppCloudClientPlayButtonOffer then require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonLaunchChecks/usePlayButtonLaunchWithCloudClientOffer") else nil

return function(universeId, p2, p3, p4, p5, p6, p7, p8)
	local v6 = useRoactService(roactAnalytics)
	local v7 = useRoactService(appUpdateService)
	local v8 = useRoactService(appEventIngestService)

	local v9 = useDispatch()
	local v10 = useSelector(function(p9)
		return p9.GameDetails[universeId]
	end)

	local v11 = nil
	local v12 = nil

	if fFlagMigrateGameInfoToStore then
		v12 = GameHydrationReact.useGameInfo(universeId)
	else
		v11 = useGameInfosSelector(universeId)
	end

	local v13 = useGameProductInfoSelector(universeId)
	local v14 = useSelector(function(p9)
		return p9.PlayabilityStatus[universeId]
	end)

	local v15 = GameHydrationReact.useGameIcon(universeId)

	local v16 = useRouteName()
	local v17

	if getFFlagIsSquadEnabled() then
		v17 = React.useContext(squadExternalContractContext)
	else
		v17 = nil
	end

	local v18 = v10 and v10.rootPlaceId

	if not v18 then
		v18 = (if fFlagMigrateGameInfoToStore then v12 and v12.rootPlaceId else v11 and v11.placeId) or nil
	end

	local v19 = if getFFlagLuaAppEnableVirtualEventPlaceId() and p7 ~= "0" then p7 or v18 else v18

	local v20 = v10 and v10.name

	if not v20 then
		v20 = (if fFlagMigrateGameInfoToStore then v12 and v12.name else v11 and v11.name) or nil
	end

	local v21

	if fFlagLuaAppPlayButtonPrivatePT then
		local v22 = v10 and v10.creator and v10.creator.id

		if not v22 then
			v22 = (if fFlagMigrateGameInfoToStore then v12 and v12.creator and v12.creator.id else v11 and v11.creatorId)
				or nil
		end

		if v22 ~= nil then
			v21 = tostring(v22)
		end
	end

	local v22 = usePlayButtonLaunchGame(universeId, v19, v18, p2, p3, p5, p6)
	local v23

	if fFlagLuaAppCloudClientPlayButtonOffer then
		v23 = v5(universeId, v19, v18, v14, v16, v22)
	end

	local v24

	if fFlagLuaAppPlayableUxTreatment then
		local v26 = if fFlagLuaAppCloudClientPlayButtonOffer then v23 else v22
		v24 = usePlayButtonLaunchWithUxTreatment(v14, universeId, v26, v16)
	end

	if not fFlagLuaAppPlayableUxTreatment then
		v24 = if fFlagLuaAppCloudClientPlayButtonOffer then v23 else v22
	end

	local v26 = usePlayButtonLaunchAfterSeventeenPlusUpsell(v14, universeId, v24, v16)

	if fFlagLuaAppCloudClientPlayButtonOffer then
		v22 = v23
	end

	local v28 = useAgeVerificationOverlayCallback(universeId, v22, v26)

	local v29 = React.useCallback(function(p9, p10)
		local v30

		if game:GetEngineFeature("VoiceChatSupported") then
			v30 = function()
				v28(p9, if fFlagLuaAppDemoModePlayButtonTelemetry then p10 else nil)
			end
		else
			v30 = function()
				v26(p9, if fFlagLuaAppDemoModePlayButtonTelemetry then p10 else nil)
			end
		end

		handleUpdate(v9, v7, engineFeature, v6, p3, v30)
	end, { v6, v7, engineFeature, p3, v28, v26, v9 })

	local v30 = useRoactService(roactNetworking)
	local v31 = fFlagLuaAppLaunchWhenLoadingForce or fFlagLuaAppLaunchWhenLoadingEdp and p8 == true
	local v32

	if fFlagLuaAppPlayButtonPrivatePT then
		local v33 = React.useCallback(function(callback, p9)
			local v34 = if v19 ~= nil then tonumber(v19) else nil

			if v34 == nil then
				discoveryEventErrorLogger.reportError(
					"PlaytestLaunchMissingPlaceId",
					`Cannot launch private Playtest without a valid placeId for universeId {universeId}`
				)

				return
			end

			local v35

			if fFlagLuaAppPrivatePlaytestEarlyTesting or fFlagLuaAppPrivatePlaytestWithoutBuildMode then
				v35 = launchPlaytestWithLoadingState(v34, p5, nil, nil, true)
			else
				v35 = launchPlaytestWithLoadingState(v34, p5, true)
			end

			if v35 and callback ~= nil then
				if not fFlagLuaAppDemoModePlayButtonTelemetry then
					p9 = nil
				end

				callback(p9)
			end
		end, { v19, p5, universeId })

		if fFlagLuaAppPlayButtonPrivatePTEnableSingleButton then
			v33 = v29
		end

		v32 = usePrivatePlaytestLaunchWithUpsell(v14, tostring(universeId), v33, p3, v16, v21)
	else
		v32 = nil
	end

	local useCallback = React.useCallback
	local function fn(playButtonState, p9, p10)
		joinGamePlayButton(v6.InfluxDb, "playButtonClicked", {
			isUniversalApp = true,
			referralSource = p2,
			placeId = v18,
			buttonState = playButtonState and playButtonState or "Invalid",
			ctx = p3
		})

		if p2 == PlayButtonReferralSource.ExperienceDetailsLink then
			local v36 = if getFFlagLuaAppEnableVirtualEventPlaceId() then v19 else v18
			GamePlayButtonShareLinkAnalytics(v6, {
				placeId = v36,
				playButtonState = playButtonState,
				universeId = universeId
			})
		end

		if playButtonState == PlayButtonStates.Playable or playButtonState == PlayButtonStates.ActionNeeded then
			if fFlagLuaAppPlayButtonPrivatePTEnableSingleButton then
				local privatePlaytestInfo = v14 and v14.privatePlaytestInfo or nil

				if playButtonState == PlayButtonStates.ActionNeeded and privatePlaytestInfo ~= nil then
					v32(p9, "PlaytestPlayButtonClick")

					return
				end
			end

			v29(p9)
		elseif playButtonState == PlayButtonStates.PaidAccess then
			local price = v13 and v13.price or nil
			local productId = v13 and v13.productId or nil
			local sellerId = v13 and v13.sellerId or nil
			local universeId2 = v13 and v13.universeId or nil
			local function onFlowComplete()
				v9(closeCentralOverlay())
			end
			local function onPurchaseSuccess()
				v9(fetchGamePlayabilityAndProductInfo.Fetch(v30, universeId2))
			end
			local function initiateLegacyPurchaseFlow()
				v9(OpenCentralOverlayForPurchaseGame(universeId2, v20, price, productId, sellerId, { v16 }))
			end

			if fFlagShipUnifiedPurchaseFlowToPaidAccess then
				v9(module4({
					productPayload = {
						universeId = universeId2,
						kind = "Experience",
						experienceName = v20,
						experienceIconUrl = v15
					},
					purchaseCallbacks = {
						onFlowComplete = onFlowComplete,
						onPurchaseSuccess = onPurchaseSuccess
					},
					purchaseAnalyticsMetadata = {
						surface = productPurchaseSurface.PaidAccess
					}
				}))
			else
				getIsUserEligibleForUnifiedPurchaseFlow(v30):andThen(function(p11)
					if p11 then
						v9(module4({
							productPayload = {
								universeId = universeId2,
								kind = "Experience",
								experienceName = v20,
								experienceIconUrl = v15
							},
							purchaseCallbacks = {
								onFlowComplete = onFlowComplete,
								onPurchaseSuccess = onPurchaseSuccess
							},
							purchaseAnalyticsMetadata = {
								surface = productPurchaseSurface.PaidAccess
							}
						}))
					else
						v9(OpenCentralOverlayForPurchaseGame(universeId2, v20, price, productId, sellerId, { v16 }))
					end
				end):catch(function(p11)
					v9(OpenCentralOverlayForPurchaseGame(universeId2, v20, price, productId, sellerId, { v16 }))
				end)
			end
		elseif playButtonState == PlayButtonStates.DemoMode then
			if fFlagLuaAppDemoModePlayButtonTelemetry then
				v29(p9, "DemoPlayButtonClick")
			else
				v29(p9)
			end
		elseif fFlagLuaAppPlayButtonPrivatePTEnableDualButton and playButtonState == PlayButtonStates.Playtest then
			v32(p9, "PlaytestPlayButtonClick")
		elseif playButtonState == PlayButtonStates.FiatPaidAccess then
			if v18 and v13 and v13.fiatBasePriceId then
				v9(ApiPostPreparePurchase.Fetch(v30, v18, universeId, v13.fiatBasePriceId))

				unlockPlayIntent(v8, {
					universeId = universeId,
					upsellName = "FiatPurchase",
					playabilityStatus = v14 and v14.playabilityStatus or nil,
					pageName = v16
				})
			end
		elseif playButtonState == PlayButtonStates.Loading then
			invalidPlayIntent(p3, {
				universeId = universeId,
				playButtonState = playButtonState,
				playabilityStatus = v14 and v14.playabilityStatus or nil,
				pageName = if fFlagLuaAppPlayButtonLoadingDurationTelemetry then v16 else nil
			})

			if v31 then
				v29(p9)
			end
		elseif getFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.PlayableWithParty then
			if v18 then
				local default

				if fFlagEnableSquadRegroupExperimentation then
					default = squadExperienceInviteSource.Default
				end

				local v37 = if fFlagEnablePrivatePartyStartJoin and p10 and p10.isPrivateParty then squadExperienceInviteType.PlayWithPartyInPrivatePartyServer else nil
				v9(createExperienceInvite(v18, v17, default, v37))
			end
		elseif playButtonState == PlayButtonStates.WaitingForParty then
			invalidPlayIntent(p3, {
				universeId = universeId,
				playButtonState = playButtonState,
				playabilityStatus = v14 and v14.playabilityStatus or nil,
				pageName = if fFlagLuaAppPlayButtonLoadingDurationTelemetry then v16 else nil
			})
		elseif
			playButtonState == PlayButtonStates.UnplayableOther
			or fFlagEnableGameJoinEarlyAccess and playButtonState == PlayButtonStates.EarlyAccessLocked
		then
			invalidPlayIntent(p3, {
				universeId = universeId,
				playButtonState = playButtonState,
				playabilityStatus = v14 and v14.playabilityStatus or nil,
				pageName = if fFlagLuaAppPlayButtonLoadingDurationTelemetry then v16 else nil
			})
		else
			error(`invalid play button state {playButtonState}!`)
		end
	end

	local v35

	if getFFlagLuaAppEnableVirtualEventPlaceId() or fFlagLuaAppPlayButtonPrivatePT then
		v35 = v19
	end

	local v36 = if fFlagLuaAppPlayButtonPrivatePT then p5 else nil
	local v37 = if fFlagLuaAppPlayButtonPrivatePT then v32 else nil
	local v38 = if getFFlagIsSquadEnabled() then v17 else nil
	local v33 = {
		v6,
		v7,
		engineFeature,
		universeId,
		v35,
		v18,
		v20,
		p2,
		p3,
		v29,
		v13,
		v16,
		v36,
		v37,
		v38,
		v14,
		nil,
		nil,
		nil,
		nil,
		nil
	}
	local v39 = if fFlagLuaAppLaunchWhenLoadingForce or fFlagLuaAppLaunchWhenLoadingEdp then v31 else nil
	v33[17], v33[18], v33[19], v33[20], v33[21] = v9, v8, v15, v30, v39
	return (useCallback(fn, v33))
end
