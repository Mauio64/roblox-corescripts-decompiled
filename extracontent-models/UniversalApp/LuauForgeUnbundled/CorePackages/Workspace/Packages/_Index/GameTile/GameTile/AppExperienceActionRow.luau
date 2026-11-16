local IXPService = game:GetService("IXPService")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Cryo")
local roactServices = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactServices").RoactServices
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactServiceTags")
local appSessionService = RoactServiceTags.AppSessionService
local roactNetworking = RoactServiceTags.RoactNetworking
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Roact")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactRodux")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/t")
local buttonSize = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation").Enums.ButtonSize
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UIBlox")
local experienceActionRow = UIBlox.App.Tile.ExperienceActionRow
local images = UIBlox.App.ImageSet.Images
local buttonType = UIBlox.App.Button.Enum.ButtonType
local menuDirection = UIBlox.App.Menu.MenuDirection
local RobloxAppSessionization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppSessionization")
local setGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local sessionType = RobloxAppSessionization.SessionType
local withLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Localization").withLocalization
local GamePlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/GamePlayButton")
local playButton = GamePlayButton.PlayButton
local playButtonStates = GamePlayButton.PlayButtonStates
local usePlayButtonState = GamePlayButton.usePlayButtonState
local useOnPlaySquadButtonCallback = GamePlayButton.useOnPlaySquadButtonCallback
local useOnPlayButtonCallback = GamePlayButton.useOnPlayButtonCallback
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppHooks").useRoactService
local gamesProductInfoReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/GameProductInfoRodux").GamesProductInfoReducer
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppEnums").CentralOverlayType
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/CentralOverlay").Thunks.CloseCentralOverlay
local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/ExperimentLayers").AppUserLayers
local useUserExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactAppExperiment").useUserExperiment
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UniversalAppPolicy").useAppPolicy
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").GetFFlagIsSquadEnabled
local fFlagDebugEnablePopForcePicker = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagDebugEnablePopForcePicker

local fFlagLuaAppEnablePlayableStateWhenLoading = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppEnablePlayableStateWhenLoading

local fFlagLuaAppSupportDisablePlayableWhenLoading = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppSupportDisablePlayableWhenLoading

local fFlagLuaAppDisablePlayableWhenLoadingForce = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppDisablePlayableWhenLoadingForce
local fFlagLuaAppPlayButtonLoadingPrimary = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppPlayButtonLoadingPrimary
local fFlagLuaAppUnifyPlayButtonTile = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppUnifyPlayButtonTile
local fFlagLuaAppUnifyPlayButtonTileIxp = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppUnifyPlayButtonTileIxp
local fFlagLuaAppUnifyPlayButtonAllSurfacesIxp = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppUnifyPlayButtonAllSurfacesIxp
local getFFlagUIBloxUseFoundationButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").UIBlox.GetFFlagUIBloxUseFoundationButton

local fFlagLuaAppPlayButtonOptOutFoundationButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppPlayButtonOptOutFoundationButton

local fFlagLuaAppPlayButtonLoadingDurationTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppPlayButtonLoadingDurationTelemetry
local fFlagLuaAppTextOnlyPlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppTextOnlyPlayButton
local fFlagLuaAppIconTextPlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppIconTextPlayButton
local fFlagLuaAppUpdatePlayButtonText = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppUpdatePlayButtonText
local fFlagLuaAppLogExposurePlayButtonUX = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppLogExposurePlayButtonUX
local fFlagLuaAppDemoModePlayButtonTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppDemoModePlayButtonTelemetry
local fFlagLuaAppPlayButtonPrivatePT = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppPlayButtonPrivatePT

local defineFastFlag = game:DefineFastFlag("LuaAppFixAppExperienceActionRowLoadingState", false)

local GameTileExperimentation = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileExperimentation")
local v5 = fFlagLuaAppUnifyPlayButtonTile and 40 or nil
local extended = Roact.PureComponent:extend("AppExperienceActionRow")

local strictInterface = t.strictInterface
local v6 = {
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
local v7 = if fFlagLuaAppUnifyPlayButtonTile then t.optional(t.UDim) else nil
v6.width = v7
v6.placeIdOverride = t.optional(t.string)
v6.launchDataOverride = t.optional(t.string)

v6.price = t.optional(t.number)
v6.centralOverlayType = t.optional(t.string)

v6.closeCentralOverlay = t.optional(t.callback)

v6.playButtonState = t.string
v6.playabilityStatus = t.optional(t.table)
v6.onPlayButtonActivated = t.callback
v6.onPlaySquadButtonActivated = t.optional(t.callback)

v6.sessionService = t.optional(t.union(t.Instance, t.table))

v6.isUnifiedGameTileEnabled = t.optional(t.boolean)
local v8 = if fFlagLuaAppUnifyPlayButtonAllSurfacesIxp then t.optional(t.boolean) else nil
v6.hasUnifiedPlayButtonIxp = v8
local v9 = if fFlagLuaAppUnifyPlayButtonAllSurfacesIxp then t.optional(t.boolean) else nil
v6.unifyToUIBloxIxp = v9
extended.validateProps = strictInterface(v6)

local function modifyPlayButtonState(p2)
	if p2 == playButtonStates.Loading then
		return playButtonStates.Playable
	end

	return p2
end

function extended:init()
	function self.onPlayPressed()
		if self:requiresPurchase() or self:requiresFiatPurchase() then
			self.props.openGameDetails()
		elseif self:isButtonEnabled() then
			setGamePlaySession(
				self.props.sessionService,
				sessionType.StructuralIdentifier.GamePlayFromHoverTile,
				true
			)

			local v10 = if self.props.reportExperienceLaunched then self.reportExperienceLaunched else nil

			self.props.onPlayButtonActivated(self.props.playButtonState, v10)
		end
	end

	function self.reportExperienceLaunched(p2)
		if fFlagLuaAppUnifyPlayButtonTile then
			setGamePlaySession(
				self.props.sessionService,
				sessionType.StructuralIdentifier.GamePlayFromHoverTile,
				true
			)
		end

		local reportExperienceLaunched = self.props.reportExperienceLaunched
		local entry = self.props.entry
		local referralSource = self.props.referralSource
		local launchSource = self.props.launchSource
		local launchExperienceEventContext = self.props.launchExperienceEventContext
		local index = self.props.index

		if not fFlagLuaAppDemoModePlayButtonTelemetry then
			p2 = nil
		end

		reportExperienceLaunched(
			entry,
			referralSource,
			launchSource,
			launchExperienceEventContext,
			index,
			p2
		)
	end
end

function extended.willUnmount(p2)
	if getFFlagIsSquadEnabled() and p2.props.centralOverlayType == centralOverlayType.GameDetailsSquad then
		p2.props.closeCentralOverlay()
	end
end

function extended:render()
	if fFlagLuaAppUnifyPlayButtonTile then
		local isUnifiedGameTileEnabled = self.props.isUnifiedGameTileEnabled

		local hasUnifiedPlayButtonIxp = fFlagLuaAppUnifyPlayButtonAllSurfacesIxp
			and self.props.hasUnifiedPlayButtonIxp
			or fFlagLuaAppUnifyPlayButtonTileIxp and GameTileExperimentation.getIsPlayButtonMigrationEnabled()

		if
			isUnifiedGameTileEnabled
			and (not (fFlagLuaAppUnifyPlayButtonTileIxp or fFlagLuaAppUnifyPlayButtonAllSurfacesIxp) or hasUnifiedPlayButtonIxp)
		then
			local horizontalPadding = self.props.horizontalPadding or 0
			local verticalPadding = self.props.verticalPadding or 0

			return withLocalization({
				buyText = "Feature.ExperienceDetails.PlayButtonText.Buy"
			})(function(p2)
				return Roact.createElement(playButton, {
					universeId = self.props.universeId,
					placeId = self.props.placeIdOverride,
					referralSource = self.props.referralSource,
					eventContext = self.props.launchExperienceEventContext,
					launchSource = self.props.launchSource,
					experienceJoinData = self.props.launchDataOverride and {
						launchData = self.props.launchDataOverride
					} or nil,
					reportExperienceLaunched = self.reportExperienceLaunched,
					fiatText = p2.buyText,
					hideOptionalText = not self.props.showButtonText,
					buttonSize = buttonSize.Medium,
					isPlayableWhenLoading = true,
					useUIBloxButton = self.props.unifyToUIBloxIxp,
					onPurchaseRequiredCallback = self.props.openGameDetails,
					preferSecondaryPlayButton = true,
					fillBehavior = not self.props.width and "Fill" or nil,
					width = self.props.width,
					Position = UDim2.new(0, horizontalPadding, 1, -verticalPadding - v5)
				})
			end)
		end
	end

	local v10 = withLocalization({
		unlockText = "Feature.ExperienceDetails.PlayButtonText.Unlock",
		unavailableText = "Feature.ExperienceDetails.PlayButtonText.Unavailable",
		buyText = "Feature.ExperienceDetails.PlayButtonText.Buy",
		playDemoText = "Feature.ExperienceDetails.PlayButtonText.PlayDemo",
		playtestText = fFlagLuaAppPlayButtonPrivatePT and "Feature.ExperienceDetails.PlayButtonText.Playtest" or nil,
		playText = (fFlagLuaAppTextOnlyPlayButton or fFlagLuaAppIconTextPlayButton) and (fFlagLuaAppUpdatePlayButtonText and "Feature.ExperienceDetails.PlayButtonText.Play" or "Feature.ExperienceDetails.PlayButtonText.ActionNeeded") or nil
	})(function(p2)
		local createElement = Roact.createElement
		local v12 = {
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

		local v13 = if fFlagLuaAppSupportDisablePlayableWhenLoading then self.props.playButtonState == playButtonStates.Loading else nil
		v12.buttonLoading = v13

		v12.text = self:getButtonText(p2)
		v12.icon = self:getButtonIcon()
		v12.buttonType = self:getButtonType()
		v12.onPlayPressed = self.onPlayPressed
		local v14 = if getFFlagIsSquadEnabled() and self:isOverflowButtonVisible() then self.props.onPlaySquadButtonActivated else nil
		v12.onOverflowPressed = v14

		v12.horizontalPadding = self.props.horizontalPadding
		v12.verticalPadding = self.props.verticalPadding
		v12.height = self.props.height
		v12.DO_NOT_USE_useUIBloxButton = (getFFlagUIBloxUseFoundationButton() or fFlagLuaAppPlayButtonOptOutFoundationButton)
			and true
			or nil
		return createElement(experienceActionRow, v12)
	end)

	if not fFlagDebugEnablePopForcePicker then
		return v10
	end

	local PopForcePicker = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GamePlayButton/PopForcePicker")

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
				{
					LayoutOrder = 1,
					Size = UDim2.fromScale(0, 1),
					BackgroundTransparency = 1
				},
				{
					Flex = Roact.createElement("UIFlexItem", {
						FlexMode = Enum.UIFlexMode.Fill
					}),
					AppExperienceActionRow = v10
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
	return getFFlagIsSquadEnabled()
		and (self.props.playButtonState == playButtonStates.PlayableWithParty or self.props.playButtonState == playButtonStates.WaitingForParty)
end

function extended:isButtonEnabled()
	if
		fFlagLuaAppEnablePlayableStateWhenLoading
		and self.props.playabilityStatus == nil
		and getFFlagIsSquadEnabled()
		and self.props.playButtonState == playButtonStates.WaitingForParty
	then
		return false
	end

	return (self.props.playabilityStatus == nil or self.props.playButtonState == playButtonStates.Playable or not fFlagLuaAppSupportDisablePlayableWhenLoading and self.props.playButtonState == playButtonStates.Loading or getFFlagIsSquadEnabled() and self.props.playButtonState == playButtonStates.PlayableWithParty)
		and true
		or self:isActionNeeded()
		or self:requiresPurchase()
		or self:requiresFiatPurchase()
		or self.props.playButtonState == playButtonStates.DemoMode
		or fFlagLuaAppPlayButtonPrivatePT and self.props.playButtonState == playButtonStates.Playtest
end

function extended:requiresFiatPurchase(): boolean
	return self.props.playButtonState == playButtonStates.FiatPaidAccess
end

function extended:requiresPurchase(): boolean
	return self.props.playButtonState == playButtonStates.PaidAccess
end

function extended:isActionNeeded(): boolean
	return self.props.playButtonState == playButtonStates.ActionNeeded
end

function extended:getButtonText(data)
	if self.props.showButtonText and not self:isButtonEnabled() then
		if getFFlagIsSquadEnabled() and self.props.playButtonState == playButtonStates.WaitingForParty then
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

	if self.props.playButtonState == playButtonStates.DemoMode then
		return data.playDemoText
	end

	if fFlagLuaAppPlayButtonPrivatePT and self.props.playButtonState == playButtonStates.Playtest then
		return data.playtestText
	end

	if
		(fFlagLuaAppTextOnlyPlayButton or fFlagLuaAppIconTextPlayButton)
		and self.props.playButtonState == playButtonStates.Playable
	then
		return data.playText
	end

	return nil
end

function extended:getButtonType()
	if
		fFlagLuaAppSupportDisablePlayableWhenLoading
		and (defineFastFlag or not fFlagLuaAppPlayButtonLoadingPrimary)
		and self.props.playButtonState == playButtonStates.Loading
	then
		if not defineFastFlag then
			return buttonType.Secondary
		end

		if fFlagLuaAppPlayButtonLoadingPrimary then
			return buttonType.PrimaryContextual
		end
	else
		if
			self.props.playButtonState == playButtonStates.DemoMode
			or fFlagLuaAppPlayButtonPrivatePT and self.props.playButtonState == playButtonStates.Playtest
		then
			return buttonType.PrimarySystem
		end

		if self:isButtonEnabled() then
			return buttonType.PrimaryContextual
		end
	end

	return buttonType.Secondary
end

function extended:getButtonIcon()
	if
		fFlagLuaAppSupportDisablePlayableWhenLoading
		and self.props.playButtonState == playButtonStates.Loading
	then
		return nil
	end

	if self:requiresPurchase() then
		return images["icons/common/robux"]
	end

	if
		self:requiresFiatPurchase()
		or self.props.playButtonState == playButtonStates.DemoMode
		or fFlagLuaAppPlayButtonPrivatePT and self.props.playButtonState == playButtonStates.Playtest
		or self:isActionNeeded()
	then
		return nil
	end

	if fFlagLuaAppTextOnlyPlayButton and self.props.playButtonState == playButtonStates.Playable then
		return nil
	end

	if
		self:isButtonEnabled()
		or getFFlagIsSquadEnabled() and self.props.playButtonState == playButtonStates.WaitingForParty
	then
		return images["icons/common/play"]
	end

	return images["icons/status/unavailable"]
end

local v10 = RoactRodux.connect(function(p2, p3)
	local universeId = p3.universeId
	local v11

	if p2[gamesProductInfoReducer.key] then
		v11 = p2[gamesProductInfoReducer.key][universeId]
	end

	local v13 = if v11 ~= nil then v11.price else nil
	local v14 = if getFFlagIsSquadEnabled() then p2.CentralOverlay.OverlayType else nil
	return { price = v13, centralOverlayType = v14 }
end, function(callback)
	return {
		closeCentralOverlay = function()
			return callback(closeCentralOverlay())
		end
	}
end)(function(props)
	local v11 = useRoactService(roactNetworking)

	local universeId = props.universeId
	local fetchDelayInSeconds = props.fetchDelayInSeconds
	local v15

	if fFlagLuaAppPlayButtonLoadingDurationTelemetry then
		v15 = props.launchExperienceEventContext
	end

	local v16 = usePlayButtonState(
		v11,
		universeId,
		fetchDelayInSeconds,
		fFlagLuaAppEnablePlayableStateWhenLoading and true or nil,
		fFlagLuaAppPlayButtonLoadingDurationTelemetry and true or nil,
		v15
	)

	local v17 = props.launchDataOverride and { launchData = props.launchDataOverride } or nil

	local v18 = useOnPlayButtonCallback(
		props.universeId,
		props.referralSource,
		props.launchExperienceEventContext or "PlayButton",
		nil,
		props.launchSource or "UnknownLaunchSource",
		v17,
		props.placeIdOverride
	)
	local v19

	if getFFlagIsSquadEnabled() then
		v19 = useOnPlaySquadButtonCallback(
			menuDirection.Up,
			v16.playButtonState,
			props.referralSource,
			props.universeId
		)
	end

	local v20, v21

	if fFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		v20, v21 = useUserExperiment({ appUserLayers.PlayButtonUXExposureLayer }, function(p2)
			local v22 = p2[appUserLayers.PlayButtonUXExposureLayer] or {}
			return v22.HasUnifiedPlayButton, v22.UnifyToUIBlox
		end, true)
	end

	if fFlagLuaAppLogExposurePlayButtonUX then
		React.useEffect(function()
			IXPService:LogUserLayerExposure(appUserLayers.PlayButtonUXExposureLayer)
		end, {})
	end

	local v22

	if fFlagLuaAppSupportDisablePlayableWhenLoading then
		local v23 = useAppPolicy(function(p2)
			return p2.getDisablePlayableWhenLoading()
		end)

		v22 = fFlagLuaAppDisablePlayableWhenLoadingForce or v23
	end

	local v23

	if
		fFlagLuaAppEnablePlayableStateWhenLoading
		or fFlagLuaAppSupportDisablePlayableWhenLoading and v22
	then
		v23 = v16.playButtonState
	else
		v23 = v16.playButtonState

		if v23 == playButtonStates.Loading then
			v23 = playButtonStates.Playable
		end
	end

	if v16.secondaryPlayButtonState ~= nil then
		v23 = v16.secondaryPlayButtonState
	end

	local join = Cryo.Dictionary.join
	local v24 = {
		playabilityStatus = v16.playabilityStatus,
		onPlayButtonActivated = v18,
		onPlaySquadButtonActivated = v19,
		playButtonState = v23,
		hasUnifiedPlayButtonIxp = 0,
		unifyToUIBloxIxp = 0
	}

	if not fFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		v20 = nil
	end

	v24.hasUnifiedPlayButtonIxp = v20

	if not fFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		v21 = nil
	end

	v24.unifyToUIBloxIxp = v21
	local v25 = join(props, v24)

	return Roact.createElement(extended, v25)
end)

return (roactServices.connect({ sessionService = appSessionService })(v10))
