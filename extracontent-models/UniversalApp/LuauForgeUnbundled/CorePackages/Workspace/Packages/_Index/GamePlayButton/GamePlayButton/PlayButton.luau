local IXPService = game:GetService("IXPService")

local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/tutils")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Responsive")
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxAppHooks").useRoactService
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Localization").Hooks.useLocalization

local menuDirection = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/UIBlox").App.Menu.MenuDirection

local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Foundation").Hooks.useTokens

local gamesProductInfoReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameProductInfoRodux").GamesProductInfoReducer

local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactServiceTags").RoactNetworking
local useOnPlayButtonCallback = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/useOnPlayButtonCallback")
local useOnPlaySquadButtonCallback = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/useOnPlaySquadButtonCallback")
local usePlayButtonState = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/usePlayButtonState")
local useEarlyAccessCaption = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/EarlyAccess/useEarlyAccessCaption")
local LegacyPlayButton = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/LegacyPlayButton")
local PlayButtonGroupView = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonGroupView")
local PlayButtonStates = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonStates")

local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/ExperimentLayers").AppUserLayers
local useUserExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactAppExperiment").useUserExperiment

local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").GetFFlagIsSquadEnabled
local fFlagLuaAppUnifyPlayButtonAllSurfacesIxp = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppUnifyPlayButtonAllSurfacesIxp
local defineFastFlag = game:DefineFastFlag("LuaAppFixPlayButtonDefaultLaunchSource", false)

local defineFastFlag2 = game:DefineFastFlag("LuaAppHidePlayButtonOptionalTextForDualButtons", false)

local fFlagLuaAppUnifiedPlayButtonSquadMenuDirection = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppUnifiedPlayButtonSquadMenuDirection

local fFlagLuaAppPlayButtonLoadingDurationTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonLoadingDurationTelemetry
local fFlagLuaAppUpdatePlayButtonText = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppUpdatePlayButtonText
local fFlagEnableGameJoinEarlyAccess = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagEnableGameJoinEarlyAccess
local fFlagLuaAppLogExposurePlayButtonUX = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppLogExposurePlayButtonUX

local fFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce
local fFlagLuaAppLaunchWhenLoadingEdp = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppLaunchWhenLoadingEdp
local fFlagLuaAppLaunchWhenLoadingForce = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppLaunchWhenLoadingForce

local fFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP
local fIntLuaAppPlayButtonSecondaryButtonGap = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FIntLuaAppPlayButtonSecondaryButtonGap
local fFlagLuaAppPlayButtonPrivatePT = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonPrivatePT

local FStringR20UniverseId = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/Flags/FStringR20UniverseId")

local usePlayOnReleaseAfterUnmount = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/usePlayOnReleaseAfterUnmount")

local function fn() end

local function PlayButton(props)
	local ref = React.useRef(false)
	React.useEffect(function()
		ref.current = true
		return function()
			ref.current = false
		end
	end, {})

	local v5 = useRoactService(roactNetworking)
	local v6 = useSelector(function(p2)
		if props.universeId then
			return p2[gamesProductInfoReducer.key][props.universeId]
		end

		return nil
	end, tutils.shallowEqual)

	local eventContext = fFlagLuaAppPlayButtonLoadingDurationTelemetry
		and (props.eventContext or "PlayButton")
		or nil

	local v7 = useBreakpointXOrSmaller(Responsive.Keys.Small)

	local universeId = props.universeId
	local fetchDelayInSeconds = props.fetchDelayInSeconds
	local isPlayableWhenLoading = props.isPlayableWhenLoading
	local v10 = if fFlagLuaAppPlayButtonLoadingDurationTelemetry then eventContext else nil
	local v11 = if fFlagEnableGameJoinEarlyAccess then props.enableEarlyAccessState else nil
	local v12 = usePlayButtonState(
		v5,
		universeId,
		fetchDelayInSeconds,
		isPlayableWhenLoading,
		fFlagLuaAppPlayButtonLoadingDurationTelemetry and true or nil,
		v10,
		v11
	)

	local v13 = v12.playButtonState
	local secondaryPlayButtonState = v12.secondaryPlayButtonState

	if secondaryPlayButtonState ~= nil then
		local v14 = v13 == PlayButtonStates.UnplayableOther
		local v15 = secondaryPlayButtonState == PlayButtonStates.UnplayableOther

		if props.preferSecondaryPlayButton == true or v7 and v14 then
			v13 = secondaryPlayButtonState
			secondaryPlayButtonState = nil
		elseif v7 and v15 then
			secondaryPlayButtonState = nil
		end
	end

	local v14, v15

	if fFlagEnableGameJoinEarlyAccess then
		local earlyAccess = v12.earlyAccess
		v14 = useEarlyAccessCaption(earlyAccess)
		v15 = if earlyAccess then earlyAccess.isPendingUnlock == true else false
	end

	local v16 = fFlagLuaAppLaunchWhenLoadingForce
		or fFlagLuaAppLaunchWhenLoadingEdp and props.launchWhenLoading == true

	local universeId2 = props.universeId
	local referralSource = props.referralSource
	local eventContext2 = not fFlagLuaAppPlayButtonLoadingDurationTelemetry
		and (props.eventContext or "PlayButton")
		or eventContext

	local launchSource = props.launchSource or defineFastFlag and "UnknownLaunchSource" or "LuaGameCard"
	local experienceJoinData = props.experienceJoinData
	local placeId = props.placeId
	local v19

	if fFlagLuaAppLaunchWhenLoadingEdp or fFlagLuaAppLaunchWhenLoadingForce then
		v19 = props.launchWhenLoading
	end

	local v20 = useOnPlayButtonCallback(
		universeId2,
		referralSource,
		eventContext2,
		nil,
		launchSource,
		experienceJoinData,
		placeId,
		v19
	)
	local v21

	if fFlagLuaAppUnifiedPlayButtonSquadMenuDirection and props.squadButtonMenuDirection ~= nil then
		v21 = props.squadButtonMenuDirection
	else
		v21 = menuDirection.Up
	end

	local v22 = useOnPlaySquadButtonCallback(v21, v13, props.referralSource, props.universeId)

	local v23 = fFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce
		or props.launchOnReleaseAfterUnmount == true

	local v24 = React.useCallback(function(p2)
		if not (p2 ~= nil and (v23 or ref.current)) then
			return
		end

		if props.onActivated then
			props.onActivated()
		end

		if
			props.onPurchaseRequiredCallback
			and (p2 == PlayButtonStates.PaidAccess or p2 == PlayButtonStates.FiatPaidAccess)
		then
			props.onPurchaseRequiredCallback()
		else
			v20(p2, props.reportExperienceLaunched)
		end
	end, {
		v20,
		props.onPurchaseRequiredCallback,
		props.reportExperienceLaunched,
		props.onActivated,
		v23
	})

	local v25 = React.useCallback(function()
		v24(v13)
	end, { v24, v13 })

	local v26 = React.useCallback(function()
		v24(secondaryPlayButtonState)
	end, { v24, secondaryPlayButtonState })

	local v27 = usePlayOnReleaseAfterUnmount(v25)

	local playButtonRef = if v23 and v27 then v27.playButtonRef else nil

	local loadingCaptureRef = if v23 and v27 then v27.loadingCaptureRef else nil

	if v23 then
		v25 = v27.onActivated
	end

	local v28 = React.useCallback(function(p2)
		if not ref.current then
			return
		end

		if props.onActivated then
			props.onActivated()
		end

		v22(p2)
	end, { v22, props.onActivated })

	React.useEffect(function()
		local onRegisterActivation = props.onRegisterActivation

		if onRegisterActivation == nil then
			return
		end

		return onRegisterActivation(v25)
	end, { props.onRegisterActivation, v25 })

	local v29 = useLocalization({
		join = "Feature.ExperienceDetails.PlayButtonText.ActionNeeded",
		play = fFlagLuaAppUpdatePlayButtonText and "Feature.ExperienceDetails.PlayButtonText.Play" or nil,
		playDemo = "Feature.ExperienceDetails.PlayButtonText.PlayDemo",
		playtest = fFlagLuaAppPlayButtonPrivatePT and "Feature.ExperienceDetails.PlayButtonText.Playtest" or nil,
		unlock = "Feature.ExperienceDetails.PlayButtonText.Unlock",
		joinWithParty = "Feature.Squads.Action.JoinWithParty",
		unavailable = "Feature.ExperienceDetails.PlayButtonText.Unavailable",
		waitingForParty = "Feature.Squads.Action.WaitingForParty",
		earlyAccess = fFlagEnableGameJoinEarlyAccess and "Feature.VirtualEvents.Label.EarlyAccess" or nil
	})
	local v30, v31, v32

	if fFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		v30, v31, v32 = useUserExperiment({ appUserLayers.PlayButtonUXExposureLayer }, function(p2)
			local v33 = p2[appUserLayers.PlayButtonUXExposureLayer] or {}
			return v33.HasJoinTextButton, v33.HasIconPlayButton, v33.HasPlayButtonLoadingSkeleton
		end, true)
	end

	if fFlagLuaAppLogExposurePlayButtonUX then
		React.useEffect(function()
			IXPService:LogUserLayerExposure(appUserLayers.PlayButtonUXExposureLayer)
		end, {})
	end

	local v33 = useTokens()

	if
		fFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP
		and props.shouldUseModuleLegacyPlayButtonView
	then
		local price = v6 and v6.price or 0
		local localizedFiatPrice = v6 and v6.localizedFiatPrice or ""

		if secondaryPlayButtonState == nil then
			local createElement = React.createElement
			local v35 = {
				Size = UDim2.new(props.width or UDim.new(1, 0), UDim.new(1, 0)),
				LayoutOrder = props.LayoutOrder,
				playButtonState = v13,
				price = price,
				localizedFiatPrice = localizedFiatPrice,
				onPlayButtonActivated = v25,
				onPlaySquadButtonActivated = 0,
				testId = 0
			}

			if not getFFlagIsSquadEnabled() then
				v28 = nil
			end

			v35.onPlaySquadButtonActivated = v28
			v35.testId = props.testId
			return createElement(LegacyPlayButton, v35)
		else
			local udim = UDim2.new(0.5, -fIntLuaAppPlayButtonSecondaryButtonGap / 2, 1, 0)

			local createElement = React.createElement
			local v35 = {
				Size = UDim2.new(props.width or UDim.new(1, 0), UDim.new(1, 0)),
				LayoutOrder = props.LayoutOrder,
				Position = props.Position,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}

			local children = {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, fIntLuaAppPlayButtonSecondaryButtonGap)
				}),
				PlayButton = 0,
				SecondaryPlayButton = 0
			}

			local createElement2 = React.createElement
			local v37 = {
				Size = udim,
				LayoutOrder = 1,
				playButtonState = v13,
				price = price,
				localizedFiatPrice = localizedFiatPrice,
				onPlayButtonActivated = v25,
				onPlaySquadButtonActivated = 0,
				testId = 0
			}

			local v38 = if getFFlagIsSquadEnabled() then v28 else nil
			v37.onPlaySquadButtonActivated = v38
			v37.testId = props.testId
			children.PlayButton = createElement2(LegacyPlayButton, v37)

			local createElement3 = React.createElement
			local v40 = {
				Size = udim,
				LayoutOrder = 2,
				playButtonState = secondaryPlayButtonState,
				price = price,
				localizedFiatPrice = localizedFiatPrice,
				onPlayButtonActivated = v26 or fn,
				onPlaySquadButtonActivated = 0,
				testId = 0
			}

			if not getFFlagIsSquadEnabled() then
				v28 = nil
			end

			v40.onPlaySquadButtonActivated = v28
			local v41 = if props.testId then `{props.testId}--secondary` else nil
			v40.testId = v41
			children.SecondaryPlayButton = createElement3(LegacyPlayButton, v40)
			return createElement("Frame", v35, children)
		end
	else
		local v34

		if fFlagEnableGameJoinEarlyAccess then
			if props.enableEarlyAccessPlusTooltip == true then
				v34 = if v7 then not (FStringR20UniverseId == "") and tostring(props.universeId) == FStringR20UniverseId else v7
			else
				v34 = false
			end
		end

		local hideOptionalText = props.hideOptionalText
		local v35 = defineFastFlag2 and v7 and secondaryPlayButtonState ~= nil and true or hideOptionalText
		local createElement = React.createElement
		local v37 = {}
		v37.playButtonState = v13
		v37.secondaryPlayButtonState = secondaryPlayButtonState

		if not fFlagEnableGameJoinEarlyAccess then
			v34 = nil
		end

		v37.showEarlyAccessTooltip = v34

		if not fFlagEnableGameJoinEarlyAccess then
			v14 = nil
		end

		v37.earlyAccessCaption = v14

		if not fFlagEnableGameJoinEarlyAccess then
			v15 = nil
		end

		v37.earlyAccessPending = v15
		v37.gameProductInfo = v6
		v37.localized = v29
		v37.tokens = v33
		v37.hasJoinTextPlayableButtonIxp = v30
		v37.hasIconPlayButtonIxp = v31
		v37.hasPlayButtonLoadingSkeletonIxp = v32
		v37.onPlayButtonActivated = v25
		v37.onSecondaryPlayButtonActivated = v26
		v37.onPlaySquadButtonActivated = v28
		v37.playButtonCaptureRef = playButtonRef
		v37.loadingCaptureRef = loadingCaptureRef
		v37.shouldLaunchWhenLoading = v16
		v37.shouldLaunchOnReleaseAfterUnmount = v23
		v37.squadButtonMenuDirection = v21
		v37.playableText = props.playableText
		v37.fiatText = props.fiatText
		v37.hidePlayableIcon = props.hidePlayableIcon
		v37.hideOptionalText = v35
		v37.buttonSize = props.buttonSize
		v37.width = props.width
		v37.expandWidthForSecondaryPlayButton = props.expandWidthForSecondaryPlayButton
		v37.fillBehavior = props.fillBehavior
		v37.useUIBloxButton = props.useUIBloxButton
		v37.hideIfUnplayable = props.hideIfUnplayable
		v37.hideIfLoading = props.hideIfLoading
		v37.LayoutOrder = props.LayoutOrder
		v37.Position = props.Position
		v37.tag = props.tag
		v37.testId = props.testId
		return createElement(PlayButtonGroupView, v37)
	end
end

return React.memo(PlayButton)
