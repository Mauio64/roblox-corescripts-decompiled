local ApiPostPreparePurchase = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/ApiPostPreparePurchase")
local GamePlayButtonShareLinkAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/GamePlayButtonShareLinkAnalytics")
local OpenCentralOverlayForPurchaseGame = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/OpenCentralOverlayForPurchaseGame")
local module4 = require("@luauforge/bundled/bGC")
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

	local v11 = GameHydrationReact.useGameInfo(universeId)
	local v12 = useGameProductInfoSelector(universeId)
	local v13 = useSelector(function(p9)
		return p9.PlayabilityStatus[universeId]
	end)

	local v14 = GameHydrationReact.useGameIcon(universeId)

	local v15 = useRouteName()
	local v16

	if getFFlagIsSquadEnabled() then
		v16 = React.useContext(squadExternalContractContext)
	else
		v16 = nil
	end

	local rootPlaceId = v10 and v10.rootPlaceId

	if not rootPlaceId then
		rootPlaceId = if v11 then v11.rootPlaceId or nil else nil
	end

	local v17

	if getFFlagLuaAppEnableVirtualEventPlaceId() and p7 ~= "0" then
		v17 = p7 or rootPlaceId
	else
		v17 = rootPlaceId
	end

	local name = v10 and v10.name

	if not name then
		name = if v11 then v11.name or nil else nil
	end

	local v18

	if fFlagLuaAppPlayButtonPrivatePT then
		local id = v10 and v10.creator and v10.creator.id or v11 and v11.creator and v11.creator.id or nil

		if id ~= nil then
			v18 = tostring(id)
		end
	end

	local v19 = usePlayButtonLaunchGame(universeId, v17, rootPlaceId, p2, p3, p5, p6)
	local v20

	if fFlagLuaAppCloudClientPlayButtonOffer then
		v20 = v5(universeId, v17, rootPlaceId, v13, v15, v19)
	end

	local v21

	if fFlagLuaAppPlayableUxTreatment then
		local v23 = if fFlagLuaAppCloudClientPlayButtonOffer then v20 else v19
		v21 = usePlayButtonLaunchWithUxTreatment(v13, universeId, v23, v15)
	end

	if not fFlagLuaAppPlayableUxTreatment then
		v21 = if fFlagLuaAppCloudClientPlayButtonOffer then v20 else v19
	end

	local v23 = usePlayButtonLaunchAfterSeventeenPlusUpsell(v13, universeId, v21, v15)

	if fFlagLuaAppCloudClientPlayButtonOffer then
		v19 = v20
	end

	local v25 = useAgeVerificationOverlayCallback(universeId, v19, v23)

	local v26 = React.useCallback(function(p9, p10)
		local v27

		if game:GetEngineFeature("VoiceChatSupported") then
			v27 = function()
				v25(p9, if fFlagLuaAppDemoModePlayButtonTelemetry then p10 else nil)
			end
		else
			v27 = function()
				v23(p9, if fFlagLuaAppDemoModePlayButtonTelemetry then p10 else nil)
			end
		end

		handleUpdate(v9, v7, engineFeature, v6, p3, v27)
	end, { v6, v7, engineFeature, p3, v25, v23, v9 })

	local v27 = useRoactService(roactNetworking)
	local v28 = fFlagLuaAppLaunchWhenLoadingForce or fFlagLuaAppLaunchWhenLoadingEdp and p8 == true
	local v29

	if fFlagLuaAppPlayButtonPrivatePT then
		local v30 = React.useCallback(function(callback, p9)
			local v31 = if v17 ~= nil then tonumber(v17) else nil

			if v31 == nil then
				discoveryEventErrorLogger.reportError(
					"PlaytestLaunchMissingPlaceId",
					`Cannot launch private Playtest without a valid placeId for universeId {universeId}`
				)

				return
			end

			local v32

			if fFlagLuaAppPrivatePlaytestEarlyTesting or fFlagLuaAppPrivatePlaytestWithoutBuildMode then
				v32 = launchPlaytestWithLoadingState(v31, p5, nil, nil, true)
			else
				v32 = launchPlaytestWithLoadingState(v31, p5, true)
			end

			if v32 and callback ~= nil then
				if not fFlagLuaAppDemoModePlayButtonTelemetry then
					p9 = nil
				end

				callback(p9)
			end
		end, { v17, p5, universeId })

		if fFlagLuaAppPlayButtonPrivatePTEnableSingleButton then
			v30 = v26
		end

		v29 = usePrivatePlaytestLaunchWithUpsell(v13, tostring(universeId), v30, p3, v15, v18)
	else
		v29 = nil
	end

	local useCallback = React.useCallback
	local function fn(playButtonState, p9, p10)
		joinGamePlayButton(v6.InfluxDb, "playButtonClicked", {
			isUniversalApp = true,
			referralSource = p2,
			placeId = rootPlaceId,
			buttonState = playButtonState and playButtonState or "Invalid",
			ctx = p3
		})

		if p2 == PlayButtonReferralSource.ExperienceDetailsLink then
			local v33 = if getFFlagLuaAppEnableVirtualEventPlaceId() then v17 else rootPlaceId
			GamePlayButtonShareLinkAnalytics(v6, {
				placeId = v33,
				playButtonState = playButtonState,
				universeId = universeId
			})
		end

		if playButtonState == PlayButtonStates.Playable or playButtonState == PlayButtonStates.ActionNeeded then
			if fFlagLuaAppPlayButtonPrivatePTEnableSingleButton then
				local privatePlaytestInfo = v13 and v13.privatePlaytestInfo or nil

				if playButtonState == PlayButtonStates.ActionNeeded and privatePlaytestInfo ~= nil then
					v29(p9, "PlaytestPlayButtonClick")

					return
				end
			end

			v26(p9)
		elseif playButtonState == PlayButtonStates.PaidAccess then
			local price = v12 and v12.price or nil
			local productId = v12 and v12.productId or nil
			local sellerId = v12 and v12.sellerId or nil
			local universeId2 = v12 and v12.universeId or nil
			local function onFlowComplete()
				v9(closeCentralOverlay())
			end
			local function onPurchaseSuccess()
				v9(fetchGamePlayabilityAndProductInfo.Fetch(v27, universeId2))
			end
			local function initiateLegacyPurchaseFlow()
				v9(OpenCentralOverlayForPurchaseGame(universeId2, name, price, productId, sellerId, { v15 }))
			end

			if fFlagShipUnifiedPurchaseFlowToPaidAccess then
				v9(module4({
					productPayload = {
						universeId = universeId2,
						kind = "Experience",
						experienceName = name,
						experienceIconUrl = v14
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
				getIsUserEligibleForUnifiedPurchaseFlow(v27):andThen(function(p11)
					if p11 then
						v9(module4({
							productPayload = {
								universeId = universeId2,
								kind = "Experience",
								experienceName = name,
								experienceIconUrl = v14
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
						v9(OpenCentralOverlayForPurchaseGame(universeId2, name, price, productId, sellerId, { v15 }))
					end
				end):catch(function(p11)
					v9(OpenCentralOverlayForPurchaseGame(universeId2, name, price, productId, sellerId, { v15 }))
				end)
			end
		elseif playButtonState == PlayButtonStates.DemoMode then
			if fFlagLuaAppDemoModePlayButtonTelemetry then
				v26(p9, "DemoPlayButtonClick")
			else
				v26(p9)
			end
		elseif fFlagLuaAppPlayButtonPrivatePTEnableDualButton and playButtonState == PlayButtonStates.Playtest then
			v29(p9, "PlaytestPlayButtonClick")
		elseif playButtonState == PlayButtonStates.FiatPaidAccess then
			if rootPlaceId and v12 and v12.fiatBasePriceId then
				v9(ApiPostPreparePurchase.Fetch(v27, rootPlaceId, universeId, v12.fiatBasePriceId))

				unlockPlayIntent(v8, {
					universeId = universeId,
					upsellName = "FiatPurchase",
					playabilityStatus = v13 and v13.playabilityStatus or nil,
					pageName = v15
				})
			end
		elseif playButtonState == PlayButtonStates.Loading then
			invalidPlayIntent(p3, {
				universeId = universeId,
				playButtonState = playButtonState,
				playabilityStatus = v13 and v13.playabilityStatus or nil,
				pageName = if fFlagLuaAppPlayButtonLoadingDurationTelemetry then v15 else nil
			})

			if v28 then
				v26(p9)
			end
		elseif getFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.PlayableWithParty then
			if rootPlaceId then
				local default

				if fFlagEnableSquadRegroupExperimentation then
					default = squadExperienceInviteSource.Default
				end

				local v34 = if fFlagEnablePrivatePartyStartJoin and p10 and p10.isPrivateParty then squadExperienceInviteType.PlayWithPartyInPrivatePartyServer else nil
				v9(createExperienceInvite(rootPlaceId, v16, default, v34))
			end
		elseif playButtonState == PlayButtonStates.WaitingForParty then
			invalidPlayIntent(p3, {
				universeId = universeId,
				playButtonState = playButtonState,
				playabilityStatus = v13 and v13.playabilityStatus or nil,
				pageName = if fFlagLuaAppPlayButtonLoadingDurationTelemetry then v15 else nil
			})
		elseif
			playButtonState == PlayButtonStates.UnplayableOther
			or fFlagEnableGameJoinEarlyAccess and playButtonState == PlayButtonStates.EarlyAccessLocked
		then
			invalidPlayIntent(p3, {
				universeId = universeId,
				playButtonState = playButtonState,
				playabilityStatus = v13 and v13.playabilityStatus or nil,
				pageName = if fFlagLuaAppPlayButtonLoadingDurationTelemetry then v15 else nil
			})
		else
			error(`invalid play button state {playButtonState}!`)
		end
	end

	local v32

	if getFFlagLuaAppEnableVirtualEventPlaceId() or fFlagLuaAppPlayButtonPrivatePT then
		v32 = v17
	end

	local v33 = if fFlagLuaAppPlayButtonPrivatePT then p5 else nil
	local v34 = if fFlagLuaAppPlayButtonPrivatePT then v29 else nil
	local v35 = if getFFlagIsSquadEnabled() then v16 else nil
	local v30 = {
		v6,
		v7,
		engineFeature,
		universeId,
		v32,
		rootPlaceId,
		name,
		p2,
		p3,
		v26,
		v12,
		v15,
		v33,
		v34,
		v35,
		v13,
		nil,
		nil,
		nil,
		nil,
		nil
	}
	local v36 = if fFlagLuaAppLaunchWhenLoadingForce or fFlagLuaAppLaunchWhenLoadingEdp then v28 else nil
	v30[17], v30[18], v30[19], v30[20], v30[21] = v9, v8, v14, v27, v36
	return (useCallback(fn, v30))
end
