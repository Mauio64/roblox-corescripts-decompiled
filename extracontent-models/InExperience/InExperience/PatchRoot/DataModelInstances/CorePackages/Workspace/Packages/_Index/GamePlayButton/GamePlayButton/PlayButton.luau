local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local parent = GamePlayButton.Parent
local IXPService = game:GetService("IXPService")

local tutils = require(parent.tutils)
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local UIBlox = require(parent.UIBlox)
local MenuDirection = UIBlox.App.Menu.MenuDirection

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local GameProductInfoRodux = require(parent.GameProductInfoRodux)
local GamesProductInfoReducer = GameProductInfoRodux.GamesProductInfoReducer

local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local useOnPlayButtonCallback = require(script.Parent.useOnPlayButtonCallback)
local useOnPlaySquadButtonCallback = require(script.Parent.useOnPlaySquadButtonCallback)
local usePlayButtonState = require(script.Parent.usePlayButtonState)
local useEarlyAccessCaption = require(script.Parent.EarlyAccess.useEarlyAccessCaption)
local LegacyPlayButton = require(script.Parent.LegacyPlayButton)
local PlayButtonGroupView = require(script.Parent.PlayButtonGroupView)
local PlayButtonStates = require(script.Parent.PlayButtonStates)

local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local RoactAppExperiment = require(parent.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment

local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppUnifyPlayButtonAllSurfacesIxp = SharedFlags2.FFlagLuaAppUnifyPlayButtonAllSurfacesIxp
local defineFastFlag = game:DefineFastFlag("LuaAppFixPlayButtonDefaultLaunchSource", false)

local defineFastFlag2 = game:DefineFastFlag("LuaAppHidePlayButtonOptionalTextForDualButtons", false)

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppUnifiedPlayButtonSquadMenuDirection = SharedFlags3.FFlagLuaAppUnifiedPlayButtonSquadMenuDirection

local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonLoadingDurationTelemetry = SharedFlags4.FFlagLuaAppPlayButtonLoadingDurationTelemetry
local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppUpdatePlayButtonText = SharedFlags5.FFlagLuaAppUpdatePlayButtonText
local SharedFlags6 = require(parent.SharedFlags)
local FFlagEnableGameJoinEarlyAccess = SharedFlags6.FFlagEnableGameJoinEarlyAccess
local SharedFlags7 = require(parent.SharedFlags)
local FFlagLuaAppLogExposurePlayButtonUX = SharedFlags7.FFlagLuaAppLogExposurePlayButtonUX

local SharedFlags8 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce = SharedFlags8.FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce
local SharedFlags9 = require(parent.SharedFlags)
local FFlagLuaAppLaunchWhenLoadingEdp = SharedFlags9.FFlagLuaAppLaunchWhenLoadingEdp
local SharedFlags10 = require(parent.SharedFlags)
local FFlagLuaAppLaunchWhenLoadingForce = SharedFlags10.FFlagLuaAppLaunchWhenLoadingForce

local SharedFlags11 = require(parent.SharedFlags)
local FFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP = SharedFlags11.FFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP
local SharedFlags12 = require(parent.SharedFlags)
local FIntLuaAppPlayButtonSecondaryButtonGap = SharedFlags12.FIntLuaAppPlayButtonSecondaryButtonGap
local SharedFlags13 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonPrivatePT = SharedFlags13.FFlagLuaAppPlayButtonPrivatePT

local FStringR20UniverseId = require(GamePlayButton.Flags.FStringR20UniverseId)

local usePlayOnReleaseAfterUnmount = require(script.Parent.usePlayOnReleaseAfterUnmount)

local function fn() end

local function PlayButton(props)
	local ref = React.useRef(false)
	React.useEffect(function()
		ref.current = true
		return function()
			ref.current = false
		end
	end, {})

	local v = useRoactService(RoactNetworking)
	local gameProductInfo = useSelector(function(p)
		if props.universeId then
			return p[GamesProductInfoReducer.key][props.universeId]
		end

		return nil
	end, tutils.shallowEqual)

	local eventContext = FFlagLuaAppPlayButtonLoadingDurationTelemetry and (props.eventContext or "PlayButton") or nil

	local v2 = useBreakpointXOrSmaller(Responsive.Keys.Small)

	local universeId = props.universeId
	local fetchDelayInSeconds = props.fetchDelayInSeconds
	local isPlayableWhenLoading = props.isPlayableWhenLoading
	local v3

	if FFlagLuaAppPlayButtonLoadingDurationTelemetry then
		v3 = eventContext
	end

	local v4

	if FFlagEnableGameJoinEarlyAccess then
		v4 = props.enableEarlyAccessState
	end

	local v5 = usePlayButtonState(
		v,
		universeId,
		fetchDelayInSeconds,
		isPlayableWhenLoading,
		FFlagLuaAppPlayButtonLoadingDurationTelemetry and true or nil,
		v3,
		v4
	)

	local playButtonState = v5.playButtonState
	local secondaryPlayButtonState = v5.secondaryPlayButtonState

	if secondaryPlayButtonState ~= nil then
		local v6 = playButtonState == PlayButtonStates.UnplayableOther
		local v7 = secondaryPlayButtonState == PlayButtonStates.UnplayableOther

		if props.preferSecondaryPlayButton == true or v2 and v6 then
			playButtonState = secondaryPlayButtonState
			secondaryPlayButtonState = nil
		elseif v2 and v7 then
			secondaryPlayButtonState = nil
		end
	end

	local earlyAccessCaption, earlyAccessPending

	if FFlagEnableGameJoinEarlyAccess then
		local earlyAccess = v5.earlyAccess
		earlyAccessCaption = useEarlyAccessCaption(earlyAccess)

		if earlyAccess then
			earlyAccessPending = earlyAccess.isPendingUnlock == true
		else
			earlyAccessPending = false
		end
	end

	local shouldLaunchWhenLoading = FFlagLuaAppLaunchWhenLoadingForce
		or FFlagLuaAppLaunchWhenLoadingEdp and props.launchWhenLoading == true

	local universeId2 = props.universeId
	local referralSource = props.referralSource
	local eventContext2 = not FFlagLuaAppPlayButtonLoadingDurationTelemetry and (props.eventContext or "PlayButton")
		or eventContext

	local launchSource = props.launchSource or defineFastFlag and "UnknownLaunchSource" or "LuaGameCard"
	local experienceJoinData = props.experienceJoinData
	local placeId = props.placeId
	local v6

	if FFlagLuaAppLaunchWhenLoadingEdp or FFlagLuaAppLaunchWhenLoadingForce then
		v6 = props.launchWhenLoading
	end

	local v7 = useOnPlayButtonCallback(
		universeId2,
		referralSource,
		eventContext2,
		nil,
		launchSource,
		experienceJoinData,
		placeId,
		v6
	)
	local squadButtonMenuDirection

	if FFlagLuaAppUnifiedPlayButtonSquadMenuDirection and props.squadButtonMenuDirection ~= nil then
		squadButtonMenuDirection = props.squadButtonMenuDirection
	else
		squadButtonMenuDirection = MenuDirection.Up
	end

	local v8 = useOnPlaySquadButtonCallback(
		squadButtonMenuDirection,
		playButtonState,
		props.referralSource,
		props.universeId
	)

	local shouldLaunchOnReleaseAfterUnmount = FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce
		or props.launchOnReleaseAfterUnmount == true

	local v9 = React.useCallback(function(p: string?)
		if not (p ~= nil and (shouldLaunchOnReleaseAfterUnmount or ref.current)) then
			return
		end

		if props.onActivated then
			props.onActivated()
		end

		if
			props.onPurchaseRequiredCallback
			and (p == PlayButtonStates.PaidAccess or p == PlayButtonStates.FiatPaidAccess)
		then
			props.onPurchaseRequiredCallback()
		else
			v7(p, props.reportExperienceLaunched)
		end
	end, {
		v7,
		props.onPurchaseRequiredCallback,
		props.reportExperienceLaunched,
		props.onActivated,
		shouldLaunchOnReleaseAfterUnmount
	})

	local onPlayButtonActivated = React.useCallback(function()
		v9(playButtonState)
	end, { v9, playButtonState })

	local onSecondaryPlayButtonActivated = React.useCallback(function()
		v9(secondaryPlayButtonState)
	end, { v9, secondaryPlayButtonState })

	local v10 = usePlayOnReleaseAfterUnmount(onPlayButtonActivated)
	local playButtonRef

	if shouldLaunchOnReleaseAfterUnmount and v10 then
		playButtonRef = v10.playButtonRef
	end

	local loadingCaptureRef

	if shouldLaunchOnReleaseAfterUnmount and v10 then
		loadingCaptureRef = v10.loadingCaptureRef
	end

	if shouldLaunchOnReleaseAfterUnmount then
		onPlayButtonActivated = v10.onActivated
	end

	local onPlaySquadButtonActivated = React.useCallback(function(p)
		if not ref.current then
			return
		end

		if props.onActivated then
			props.onActivated()
		end

		v8(p)
	end, { v8, props.onActivated })

	React.useEffect(function()
		local onRegisterActivation = props.onRegisterActivation

		if onRegisterActivation == nil then
			return
		end

		return onRegisterActivation(onPlayButtonActivated)
	end, { props.onRegisterActivation, onPlayButtonActivated })

	local localized = useLocalization({
		join = "Feature.ExperienceDetails.PlayButtonText.ActionNeeded",
		play = FFlagLuaAppUpdatePlayButtonText and "Feature.ExperienceDetails.PlayButtonText.Play" or nil,
		playDemo = "Feature.ExperienceDetails.PlayButtonText.PlayDemo",
		playtest = FFlagLuaAppPlayButtonPrivatePT and "Feature.ExperienceDetails.PlayButtonText.Playtest" or nil,
		unlock = "Feature.ExperienceDetails.PlayButtonText.Unlock",
		joinWithParty = "Feature.Squads.Action.JoinWithParty",
		unavailable = "Feature.ExperienceDetails.PlayButtonText.Unavailable",
		waitingForParty = "Feature.Squads.Action.WaitingForParty",
		earlyAccess = FFlagEnableGameJoinEarlyAccess and "Feature.VirtualEvents.Label.EarlyAccess" or nil
	})
	local hasJoinTextPlayableButtonIxp, hasIconPlayButtonIxp, hasPlayButtonLoadingSkeletonIxp

	if FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		hasJoinTextPlayableButtonIxp, hasIconPlayButtonIxp, hasPlayButtonLoadingSkeletonIxp = useUserExperiment(
			{ AppUserLayers.PlayButtonUXExposureLayer },
			function(p)
				local v11 = p[AppUserLayers.PlayButtonUXExposureLayer] or {}
				return v11.HasJoinTextButton, v11.HasIconPlayButton, v11.HasPlayButtonLoadingSkeleton
			end,
			true
		)
	end

	if FFlagLuaAppLogExposurePlayButtonUX then
		React.useEffect(function()
			IXPService:LogUserLayerExposure(AppUserLayers.PlayButtonUXExposureLayer)
		end, {})
	end

	local tokens = useTokens()

	if FFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP and props.shouldUseModuleLegacyPlayButtonView then
		local price = gameProductInfo and gameProductInfo.price or 0
		local localizedFiatPrice = gameProductInfo and gameProductInfo.localizedFiatPrice or ""

		if secondaryPlayButtonState == nil then
			local createElement = React.createElement
			local v11 = {
				Size = UDim2.new(props.width or UDim.new(1, 0), UDim.new(1, 0)),
				LayoutOrder = props.LayoutOrder,
				playButtonState = playButtonState,
				price = price,
				localizedFiatPrice = localizedFiatPrice,
				onPlayButtonActivated = onPlayButtonActivated,
				onPlaySquadButtonActivated = 0,
				testId = 0
			}

			if not GetFFlagIsSquadEnabled() then
				onPlaySquadButtonActivated = nil
			end

			v11.onPlaySquadButtonActivated = onPlaySquadButtonActivated
			v11.testId = props.testId
			return createElement(LegacyPlayButton, v11)
		else
			local udim = UDim2.new(0.5, -FIntLuaAppPlayButtonSecondaryButtonGap / 2, 1, 0)

			local createElement = React.createElement
			local v11 = {
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
					Padding = UDim.new(0, FIntLuaAppPlayButtonSecondaryButtonGap)
				}),
				PlayButton = 0,
				SecondaryPlayButton = 0
			}

			local createElement2 = React.createElement
			local v12 = {
				Size = udim,
				LayoutOrder = 1,
				playButtonState = playButtonState,
				price = price,
				localizedFiatPrice = localizedFiatPrice,
				onPlayButtonActivated = onPlayButtonActivated,
				onPlaySquadButtonActivated = 0,
				testId = 0
			}
			local onPlaySquadButtonActivated2

			if GetFFlagIsSquadEnabled() then
				onPlaySquadButtonActivated2 = onPlaySquadButtonActivated
			end

			v12.onPlaySquadButtonActivated = onPlaySquadButtonActivated2
			v12.testId = props.testId
			children.PlayButton = createElement2(LegacyPlayButton, v12)

			local createElement3 = React.createElement
			local v13 = {
				Size = udim,
				LayoutOrder = 2,
				playButtonState = secondaryPlayButtonState,
				price = price,
				localizedFiatPrice = localizedFiatPrice,
				onPlayButtonActivated = onSecondaryPlayButtonActivated or fn,
				onPlaySquadButtonActivated = 0,
				testId = 0
			}

			if not GetFFlagIsSquadEnabled() then
				onPlaySquadButtonActivated = nil
			end

			v13.onPlaySquadButtonActivated = onPlaySquadButtonActivated
			local testId

			if props.testId then
				testId = `{props.testId}--secondary`
			end

			v13.testId = testId
			children.SecondaryPlayButton = createElement3(LegacyPlayButton, v13)
			return createElement("Frame", v11, children)
		end
	else
		local showEarlyAccessTooltip

		if FFlagEnableGameJoinEarlyAccess then
			if props.enableEarlyAccessPlusTooltip == true then
				if v2 then
					if FStringR20UniverseId == "" then
						showEarlyAccessTooltip = false
					else
						showEarlyAccessTooltip = tostring(props.universeId) == FStringR20UniverseId
					end
				else
					showEarlyAccessTooltip = v2
				end
			else
				showEarlyAccessTooltip = false
			end
		end

		local hideOptionalText = props.hideOptionalText
		local hideOptionalText2 = defineFastFlag2 and v2 and secondaryPlayButtonState ~= nil and true
			or hideOptionalText
		local createElement = React.createElement
		local v11 = {}
		v11.playButtonState = playButtonState
		v11.secondaryPlayButtonState = secondaryPlayButtonState

		if not FFlagEnableGameJoinEarlyAccess then
			showEarlyAccessTooltip = nil
		end

		v11.showEarlyAccessTooltip = showEarlyAccessTooltip

		if not FFlagEnableGameJoinEarlyAccess then
			earlyAccessCaption = nil
		end

		v11.earlyAccessCaption = earlyAccessCaption

		if not FFlagEnableGameJoinEarlyAccess then
			earlyAccessPending = nil
		end

		v11.earlyAccessPending = earlyAccessPending
		v11.gameProductInfo = gameProductInfo
		v11.localized = localized
		v11.tokens = tokens
		v11.hasJoinTextPlayableButtonIxp = hasJoinTextPlayableButtonIxp
		v11.hasIconPlayButtonIxp = hasIconPlayButtonIxp
		v11.hasPlayButtonLoadingSkeletonIxp = hasPlayButtonLoadingSkeletonIxp
		v11.onPlayButtonActivated = onPlayButtonActivated
		v11.onSecondaryPlayButtonActivated = onSecondaryPlayButtonActivated
		v11.onPlaySquadButtonActivated = onPlaySquadButtonActivated
		v11.playButtonCaptureRef = playButtonRef
		v11.loadingCaptureRef = loadingCaptureRef
		v11.shouldLaunchWhenLoading = shouldLaunchWhenLoading
		v11.shouldLaunchOnReleaseAfterUnmount = shouldLaunchOnReleaseAfterUnmount
		v11.squadButtonMenuDirection = squadButtonMenuDirection
		v11.playableText = props.playableText
		v11.fiatText = props.fiatText
		v11.hidePlayableIcon = props.hidePlayableIcon
		v11.hideOptionalText = hideOptionalText2
		v11.buttonSize = props.buttonSize
		v11.width = props.width
		v11.expandWidthForSecondaryPlayButton = props.expandWidthForSecondaryPlayButton
		v11.fillBehavior = props.fillBehavior
		v11.useUIBloxButton = props.useUIBloxButton
		v11.hideIfUnplayable = props.hideIfUnplayable
		v11.hideIfLoading = props.hideIfLoading
		v11.LayoutOrder = props.LayoutOrder
		v11.Position = props.Position
		v11.tag = props.tag
		v11.testId = props.testId
		return createElement(PlayButtonGroupView, v11)
	end
end

return React.memo(PlayButton)
