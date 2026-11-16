local GameTile = script:FindFirstAncestor("GameTile")

local parent = GameTile.Parent
local IXPService = game:GetService("IXPService")
local Cryo = require(parent.Cryo)
local RoactServices = require(parent.RoactServices)
local roactServices = RoactServices.RoactServices
local RoactServiceTags = require(parent.RoactServiceTags)
local AppSessionService = RoactServiceTags.AppSessionService
local RoactNetworking = RoactServiceTags.RoactNetworking
local Roact = require(parent.Roact)
local React = require(parent.React)
local RoactRodux = require(parent.RoactRodux)
local t = require(parent.t)
local Foundation = require(parent.Foundation)
local ButtonSize = Foundation.Enums.ButtonSize
local UIBlox = require(parent.UIBlox)
local ExperienceActionRow = UIBlox.App.Tile.ExperienceActionRow
local Images = UIBlox.App.ImageSet.Images
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local MenuDirection = UIBlox.App.Menu.MenuDirection
local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local SessionType = RobloxAppSessionization.SessionType
local Localization = require(parent.Localization)
local withLocalization = Localization.withLocalization
local GamePlayButton = require(parent.GamePlayButton)
local PlayButton = GamePlayButton.PlayButton
local PlayButtonStates = GamePlayButton.PlayButtonStates
local usePlayButtonState = GamePlayButton.usePlayButtonState
local useOnPlaySquadButtonCallback = GamePlayButton.useOnPlaySquadButtonCallback
local useOnPlayButtonCallback = GamePlayButton.useOnPlayButtonCallback
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local GameProductInfoRodux = require(parent.GameProductInfoRodux)
local GamesProductInfoReducer = GameProductInfoRodux.GamesProductInfoReducer
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local CentralOverlay = require(parent.CentralOverlay)
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local RoactAppExperiment = require(parent.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local SharedFlags2 = require(parent.SharedFlags)
local FFlagDebugEnablePopForcePicker = SharedFlags2.FFlagDebugEnablePopForcePicker

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppEnablePlayableStateWhenLoading = SharedFlags3.FFlagLuaAppEnablePlayableStateWhenLoading

local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppSupportDisablePlayableWhenLoading = SharedFlags4.FFlagLuaAppSupportDisablePlayableWhenLoading

local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppDisablePlayableWhenLoadingForce = SharedFlags5.FFlagLuaAppDisablePlayableWhenLoadingForce
local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonLoadingPrimary = SharedFlags6.FFlagLuaAppPlayButtonLoadingPrimary
local SharedFlags7 = require(parent.SharedFlags)
local FFlagLuaAppUnifyPlayButtonTile = SharedFlags7.FFlagLuaAppUnifyPlayButtonTile
local SharedFlags8 = require(parent.SharedFlags)
local FFlagLuaAppUnifyPlayButtonTileIxp = SharedFlags8.FFlagLuaAppUnifyPlayButtonTileIxp
local SharedFlags9 = require(parent.SharedFlags)
local FFlagLuaAppUnifyPlayButtonAllSurfacesIxp = SharedFlags9.FFlagLuaAppUnifyPlayButtonAllSurfacesIxp
local SharedFlags10 = require(parent.SharedFlags)
local GetFFlagUIBloxUseFoundationButton = SharedFlags10.UIBlox.GetFFlagUIBloxUseFoundationButton

local SharedFlags11 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonOptOutFoundationButton = SharedFlags11.FFlagLuaAppPlayButtonOptOutFoundationButton

local SharedFlags12 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonLoadingDurationTelemetry = SharedFlags12.FFlagLuaAppPlayButtonLoadingDurationTelemetry
local SharedFlags13 = require(parent.SharedFlags)
local FFlagLuaAppTextOnlyPlayButton = SharedFlags13.FFlagLuaAppTextOnlyPlayButton
local SharedFlags14 = require(parent.SharedFlags)
local FFlagLuaAppIconTextPlayButton = SharedFlags14.FFlagLuaAppIconTextPlayButton
local SharedFlags15 = require(parent.SharedFlags)
local FFlagLuaAppUpdatePlayButtonText = SharedFlags15.FFlagLuaAppUpdatePlayButtonText
local SharedFlags16 = require(parent.SharedFlags)
local FFlagLuaAppLogExposurePlayButtonUX = SharedFlags16.FFlagLuaAppLogExposurePlayButtonUX
local SharedFlags17 = require(parent.SharedFlags)
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags17.FFlagLuaAppDemoModePlayButtonTelemetry
local SharedFlags18 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonPrivatePT = SharedFlags18.FFlagLuaAppPlayButtonPrivatePT

local defineFastFlag = game:DefineFastFlag("LuaAppFixAppExperienceActionRowLoadingState", false)

local GameTileExperimentation = require(GameTile.GameTileExperimentation)
local v = FFlagLuaAppUnifyPlayButtonTile and 40 or nil
local extended = Roact.PureComponent:extend("AppExperienceActionRow")

local strictInterface = t.strictInterface
local v2 = {
	universeId = t.string,
	launchExperienceEventContext = t.optional(t.string),
	referralSource = t.optional(t.string),
	launchSource = t.string,
	reportExperienceLaunched = t.optional(t.callback),
	entry = t.table,
	openGameDetails = t.callback,
	horizontalPadding = t.optional(t.number),
	verticalPadding = t.optional(t.number),
	height = t.optional(t.number),
	fetchDelayInSeconds = t.optional(t.number),
	index = t.optional(t.number),
	showButtonText = t.optional(t.boolean),
	width = 0,
	placeIdOverride = 0,
	launchDataOverride = 0,
	price = 0,
	centralOverlayType = 0,
	closeCentralOverlay = 0,
	playButtonState = 0,
	playabilityStatus = 0,
	onPlayButtonActivated = 0,
	onPlaySquadButtonActivated = 0,
	sessionService = 0,
	isUnifiedGameTileEnabled = 0,
	hasUnifiedPlayButtonIxp = 0,
	unifyToUIBloxIxp = 0
}
local width

if FFlagLuaAppUnifyPlayButtonTile then
	width = t.optional(t.UDim)
end

v2.width = width
v2.placeIdOverride = t.optional(t.string)
v2.launchDataOverride = t.optional(t.string)

v2.price = t.optional(t.number)
v2.centralOverlayType = t.optional(t.string)

v2.closeCentralOverlay = t.optional(t.callback)

v2.playButtonState = t.string
v2.playabilityStatus = t.optional(t.table)
v2.onPlayButtonActivated = t.callback
v2.onPlaySquadButtonActivated = t.optional(t.callback)

v2.sessionService = t.optional(t.union(t.Instance, t.table))

v2.isUnifiedGameTileEnabled = t.optional(t.boolean)
local hasUnifiedPlayButtonIxp2

if FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
	hasUnifiedPlayButtonIxp2 = t.optional(t.boolean)
end

v2.hasUnifiedPlayButtonIxp = hasUnifiedPlayButtonIxp2
local unifyToUIBloxIxp

if FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
	unifyToUIBloxIxp = t.optional(t.boolean)
end

v2.unifyToUIBloxIxp = unifyToUIBloxIxp
extended.validateProps = strictInterface(v2)

local function modifyPlayButtonState(p) -- 1 equivalent call inferred from this helper
	if p == PlayButtonStates.Loading then
		return PlayButtonStates.Playable
	end

	return p
end

function extended:init()
	function self.onPlayPressed()
		if self:requiresPurchase() or self:requiresFiatPurchase() then
			self.props.openGameDetails()
		elseif self:isButtonEnabled() then
			SetGamePlaySession(self.props.sessionService, SessionType.StructuralIdentifier.GamePlayFromHoverTile, true)
			local v3

			if self.props.reportExperienceLaunched then
				v3 = self.reportExperienceLaunched
			end

			self.props.onPlayButtonActivated(self.props.playButtonState, v3)
		end
	end

	function self.reportExperienceLaunched(p: string?)
		if FFlagLuaAppUnifyPlayButtonTile then
			SetGamePlaySession(self.props.sessionService, SessionType.StructuralIdentifier.GamePlayFromHoverTile, true)
		end

		local reportExperienceLaunched = self.props.reportExperienceLaunched
		local entry = self.props.entry
		local referralSource = self.props.referralSource
		local launchSource = self.props.launchSource
		local launchExperienceEventContext = self.props.launchExperienceEventContext
		local index = self.props.index

		if not FFlagLuaAppDemoModePlayButtonTelemetry then
			p = nil
		end

		reportExperienceLaunched(entry, referralSource, launchSource, launchExperienceEventContext, index, p)
	end
end

function extended.willUnmount(p)
	if GetFFlagIsSquadEnabled() and p.props.centralOverlayType == CentralOverlayType.GameDetailsSquad then
		p.props.closeCentralOverlay()
	end
end

function extended:render()
	if FFlagLuaAppUnifyPlayButtonTile then
		local isUnifiedGameTileEnabled = self.props.isUnifiedGameTileEnabled

		local hasUnifiedPlayButtonIxp = FFlagLuaAppUnifyPlayButtonAllSurfacesIxp
			and self.props.hasUnifiedPlayButtonIxp
			or FFlagLuaAppUnifyPlayButtonTileIxp and GameTileExperimentation.getIsPlayButtonMigrationEnabled()

		if
			isUnifiedGameTileEnabled
			and (not (FFlagLuaAppUnifyPlayButtonTileIxp or FFlagLuaAppUnifyPlayButtonAllSurfacesIxp) or hasUnifiedPlayButtonIxp)
		then
			local horizontalPadding = self.props.horizontalPadding or 0
			local verticalPadding = self.props.verticalPadding or 0

			return withLocalization({ buyText = "Feature.ExperienceDetails.PlayButtonText.Buy" })(function(p)
				return Roact.createElement(PlayButton, {
					universeId = self.props.universeId,
					placeId = self.props.placeIdOverride,
					referralSource = self.props.referralSource,
					eventContext = self.props.launchExperienceEventContext,
					launchSource = self.props.launchSource,
					experienceJoinData = self.props.launchDataOverride and {
						launchData = self.props.launchDataOverride
					} or nil,
					reportExperienceLaunched = self.reportExperienceLaunched,
					fiatText = p.buyText,
					hideOptionalText = not self.props.showButtonText,
					buttonSize = ButtonSize.Medium,
					isPlayableWhenLoading = true,
					useUIBloxButton = self.props.unifyToUIBloxIxp,
					onPurchaseRequiredCallback = self.props.openGameDetails,
					preferSecondaryPlayButton = true,
					fillBehavior = not self.props.width and "Fill" or nil,
					width = self.props.width,
					Position = UDim2.new(0, horizontalPadding, 1, -verticalPadding - v)
				})
			end)
		end
	end

	local appExperienceActionRow = withLocalization({
		unlockText = "Feature.ExperienceDetails.PlayButtonText.Unlock",
		unavailableText = "Feature.ExperienceDetails.PlayButtonText.Unavailable",
		buyText = "Feature.ExperienceDetails.PlayButtonText.Buy",
		playDemoText = "Feature.ExperienceDetails.PlayButtonText.PlayDemo",
		playtestText = FFlagLuaAppPlayButtonPrivatePT and "Feature.ExperienceDetails.PlayButtonText.Playtest" or nil,
		playText = (FFlagLuaAppTextOnlyPlayButton or FFlagLuaAppIconTextPlayButton) and (FFlagLuaAppUpdatePlayButtonText and "Feature.ExperienceDetails.PlayButtonText.Play" or "Feature.ExperienceDetails.PlayButtonText.ActionNeeded") or nil
	})(function(p)
		local createElement = Roact.createElement
		local v3 = {
			isActionable = self:isButtonEnabled(),
			buttonLoading = 0,
			text = 0,
			icon = 0,
			buttonType = 0,
			onPlayPressed = 0,
			onOverflowPressed = 0,
			horizontalPadding = 0,
			verticalPadding = 0,
			height = 0,
			DO_NOT_USE_useUIBloxButton = 0
		}
		local buttonLoading

		if FFlagLuaAppSupportDisablePlayableWhenLoading then
			buttonLoading = self.props.playButtonState == PlayButtonStates.Loading
		end

		v3.buttonLoading = buttonLoading

		v3.text = self:getButtonText(p)
		v3.icon = self:getButtonIcon()
		v3.buttonType = self:getButtonType()
		v3.onPlayPressed = self.onPlayPressed
		local onOverflowPressed

		if GetFFlagIsSquadEnabled() and self:isOverflowButtonVisible() then
			onOverflowPressed = self.props.onPlaySquadButtonActivated
		end

		v3.onOverflowPressed = onOverflowPressed

		v3.horizontalPadding = self.props.horizontalPadding
		v3.verticalPadding = self.props.verticalPadding
		v3.height = self.props.height
		v3.DO_NOT_USE_useUIBloxButton = (GetFFlagUIBloxUseFoundationButton() or FFlagLuaAppPlayButtonOptOutFoundationButton)
			and true
			or nil
		return createElement(ExperienceActionRow, v3)
	end)

	if not FFlagDebugEnablePopForcePicker then
		return appExperienceActionRow
	end

	local PopForcePicker = require(parent.GamePlayButton.PopForcePicker)

	return Roact.createElement(
		"Frame",
		{
			Name = "PopForcePickerWrapper",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		},
		{
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 8)
			}),
			PlaySlot = Roact.createElement(
				"Frame",
				{ LayoutOrder = 1, Size = UDim2.fromScale(0, 1), BackgroundTransparency = 1 },
				{
					Flex = Roact.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill }),
					AppExperienceActionRow = appExperienceActionRow
				}
			),
			PopForcePickerAnchor = Roact.createElement("Frame", {
				LayoutOrder = 2,
				Size = UDim2.fromOffset(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, {
				Picker = Roact.createElement(PopForcePicker, { compact = true })
			})
		}
	)
end

function extended:isOverflowButtonVisible()
	return GetFFlagIsSquadEnabled()
		and (self.props.playButtonState == PlayButtonStates.PlayableWithParty or self.props.playButtonState == PlayButtonStates.WaitingForParty)
end

function extended:isButtonEnabled()
	if
		FFlagLuaAppEnablePlayableStateWhenLoading
		and self.props.playabilityStatus == nil
		and GetFFlagIsSquadEnabled()
		and self.props.playButtonState == PlayButtonStates.WaitingForParty
	then
		return false
	end

	return (self.props.playabilityStatus == nil or self.props.playButtonState == PlayButtonStates.Playable or not FFlagLuaAppSupportDisablePlayableWhenLoading and self.props.playButtonState == PlayButtonStates.Loading or GetFFlagIsSquadEnabled() and self.props.playButtonState == PlayButtonStates.PlayableWithParty)
		and true
		or self:isActionNeeded()
		or self:requiresPurchase()
		or self:requiresFiatPurchase()
		or self.props.playButtonState == PlayButtonStates.DemoMode
		or FFlagLuaAppPlayButtonPrivatePT and self.props.playButtonState == PlayButtonStates.Playtest
end

function extended:requiresFiatPurchase(): boolean
	return self.props.playButtonState == PlayButtonStates.FiatPaidAccess
end

function extended:requiresPurchase(): boolean
	return self.props.playButtonState == PlayButtonStates.PaidAccess
end

function extended:isActionNeeded(): boolean
	return self.props.playButtonState == PlayButtonStates.ActionNeeded
end

function extended:getButtonText(data)
	if self.props.showButtonText and not self:isButtonEnabled() then
		if GetFFlagIsSquadEnabled() and self.props.playButtonState == PlayButtonStates.WaitingForParty then
			return nil
		end

		return data.unavailableText
	end

	if self:isActionNeeded() then
		return data.unlockText
	end

	if self:requiresPurchase() then
		return (tostring(self.props.price or "--"))
	end

	if self:requiresFiatPurchase() then
		return data.buyText
	end

	if self.props.playButtonState == PlayButtonStates.DemoMode then
		return data.playDemoText
	end

	if FFlagLuaAppPlayButtonPrivatePT and self.props.playButtonState == PlayButtonStates.Playtest then
		return data.playtestText
	end

	if
		(FFlagLuaAppTextOnlyPlayButton or FFlagLuaAppIconTextPlayButton)
		and self.props.playButtonState == PlayButtonStates.Playable
	then
		return data.playText
	end

	return nil
end

function extended:getButtonType()
	if
		FFlagLuaAppSupportDisablePlayableWhenLoading
		and (defineFastFlag or not FFlagLuaAppPlayButtonLoadingPrimary)
		and self.props.playButtonState == PlayButtonStates.Loading
	then
		if not defineFastFlag then
			return ButtonType.Secondary
		end

		if FFlagLuaAppPlayButtonLoadingPrimary then
			return ButtonType.PrimaryContextual
		end
	else
		if
			self.props.playButtonState == PlayButtonStates.DemoMode
			or FFlagLuaAppPlayButtonPrivatePT and self.props.playButtonState == PlayButtonStates.Playtest
		then
			return ButtonType.PrimarySystem
		end

		if self:isButtonEnabled() then
			return ButtonType.PrimaryContextual
		end
	end

	return ButtonType.Secondary
end

function extended:getButtonIcon()
	if FFlagLuaAppSupportDisablePlayableWhenLoading and self.props.playButtonState == PlayButtonStates.Loading then
		return nil
	end

	if self:requiresPurchase() then
		return Images["icons/common/robux"]
	end

	if
		self:requiresFiatPurchase()
		or self.props.playButtonState == PlayButtonStates.DemoMode
		or FFlagLuaAppPlayButtonPrivatePT and self.props.playButtonState == PlayButtonStates.Playtest
		or self:isActionNeeded()
	then
		return nil
	end

	if FFlagLuaAppTextOnlyPlayButton and self.props.playButtonState == PlayButtonStates.Playable then
		return nil
	end

	if
		self:isButtonEnabled()
		or GetFFlagIsSquadEnabled() and self.props.playButtonState == PlayButtonStates.WaitingForParty
	then
		return Images["icons/common/play"]
	end

	return Images["icons/status/unavailable"]
end

local v3 = RoactRodux.connect(function(p, p2)
	local universeId = p2.universeId
	local v3

	if p[GamesProductInfoReducer.key] then
		v3 = p[GamesProductInfoReducer.key][universeId]
	end

	local price

	if v3 ~= nil then
		price = v3.price
	end

	local centralOverlayType

	if GetFFlagIsSquadEnabled() then
		centralOverlayType = p.CentralOverlay.OverlayType
	end

	return { price = price, centralOverlayType = centralOverlayType }
end, function(callback)
	return {
		closeCentralOverlay = function()
			return callback(CloseCentralOverlay())
		end
	}
end)(function(props)
	local v3 = useRoactService(RoactNetworking)

	local universeId = props.universeId
	local fetchDelayInSeconds = props.fetchDelayInSeconds
	local v4

	if FFlagLuaAppPlayButtonLoadingDurationTelemetry then
		v4 = props.launchExperienceEventContext
	end

	local v5 = usePlayButtonState(
		v3,
		universeId,
		fetchDelayInSeconds,
		FFlagLuaAppEnablePlayableStateWhenLoading and true or nil,
		FFlagLuaAppPlayButtonLoadingDurationTelemetry and true or nil,
		v4
	)

	local v6 = props.launchDataOverride and { launchData = props.launchDataOverride } or nil

	local onPlayButtonActivated = useOnPlayButtonCallback(
		props.universeId,
		props.referralSource,
		props.launchExperienceEventContext or "PlayButton",
		nil,
		props.launchSource or "UnknownLaunchSource",
		v6,
		props.placeIdOverride
	)
	local onPlaySquadButtonActivated

	if GetFFlagIsSquadEnabled() then
		onPlaySquadButtonActivated = useOnPlaySquadButtonCallback(
			MenuDirection.Up,
			v5.playButtonState,
			props.referralSource,
			props.universeId
		)
	end

	local hasUnifiedPlayButtonIxp, unifyToUIBloxIxp2

	if FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		hasUnifiedPlayButtonIxp, unifyToUIBloxIxp2 = useUserExperiment(
			{ AppUserLayers.PlayButtonUXExposureLayer },
			function(p)
				local v7 = p[AppUserLayers.PlayButtonUXExposureLayer] or {}
				return v7.HasUnifiedPlayButton, v7.UnifyToUIBlox
			end,
			true
		)
	end

	if FFlagLuaAppLogExposurePlayButtonUX then
		React.useEffect(function()
			IXPService:LogUserLayerExposure(AppUserLayers.PlayButtonUXExposureLayer)
		end, {})
	end

	local v7

	if FFlagLuaAppSupportDisablePlayableWhenLoading then
		local v8 = useAppPolicy(function(p)
			return p.getDisablePlayableWhenLoading()
		end)

		v7 = FFlagLuaAppDisablePlayableWhenLoadingForce or v8
	end

	local playButtonState

	if FFlagLuaAppEnablePlayableStateWhenLoading or FFlagLuaAppSupportDisablePlayableWhenLoading and v7 then
		playButtonState = v5.playButtonState
	else
		playButtonState = v5.playButtonState
		playButtonState = modifyPlayButtonState(playButtonState) -- inferred equivalent call
	end

	if v5.secondaryPlayButtonState ~= nil then
		playButtonState = v5.secondaryPlayButtonState
	end

	local join = Cryo.Dictionary.join
	local v8 = {
		playabilityStatus = v5.playabilityStatus,
		onPlayButtonActivated = onPlayButtonActivated,
		onPlaySquadButtonActivated = onPlaySquadButtonActivated,
		playButtonState = playButtonState,
		hasUnifiedPlayButtonIxp = 0,
		unifyToUIBloxIxp = 0
	}

	if not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		hasUnifiedPlayButtonIxp = nil
	end

	v8.hasUnifiedPlayButtonIxp = hasUnifiedPlayButtonIxp

	if not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		unifyToUIBloxIxp2 = nil
	end

	v8.unifyToUIBloxIxp = unifyToUIBloxIxp2
	local v9 = join(props, v8)

	return Roact.createElement(extended, v9)
end)

return (roactServices.connect({ sessionService = AppSessionService })(v3))
