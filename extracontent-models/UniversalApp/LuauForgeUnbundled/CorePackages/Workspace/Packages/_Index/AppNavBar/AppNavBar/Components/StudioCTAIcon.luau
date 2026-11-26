local CoreGui = game:GetService("CoreGui")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/Localization")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/Promise")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/RobloxAppHooks")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/RoactUtils")
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/RoactServiceTags")

local controlState = UIBlox.Core.Control.Enum.ControlState
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation

local image = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/Foundation").Image
local fFlagCoreUiMigrateUIBloxToFoundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/SharedFlags").FFlagCoreUiMigrateUIBloxToFoundation

local useLocalization = Localization.Hooks.useLocalization
local useRoactService = RobloxAppHooks.useRoactService
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local appEventIngestService = RoactServiceTags.AppEventIngestService

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Constants")

local v5 = fFlagCoreUiMigrateUIBloxToFoundation and "icons/logo/studiologo"
	or images["icons/logo/studiologo"]

local engineFeature = game:GetEngineFeature("WebViewRedesignEnabled")

local function StudioCTAIcon(p2)
	local theme = useStyle().Theme

	local state, setState = React.useState(false)
	local v6 = useRoactService(appEventIngestService)

	local v7 = useLocalization({
		titleText = "CommonUI.Features.StudioCTA.Tooltip.Title",
		bodyText = "CommonUI.Features.StudioCTA.Tooltip.Body"
	})

	local ref = React.useRef(nil)

	useEffectOnce(function()
		v6:setRBXEventStream(Constants.STUDIO_CTA_EVENT_CONTEXT, Constants.STUDIO_CTA_EVENT_NAME_MOUNT)
	end, {})

	if p2.controlState == controlState.Hover or p2.controlState == controlState.Selected then
		if not ref.current then
			ref.current = Promise.delay(0.4):andThenCall(function()
				ref.current = nil
				setState(true)
			end)
		end
	else
		if ref.current then
			ref.current:cancel()
			ref.current = nil
		end

		if state then
			setState(false)
		end
	end

	local v8 = { headerText = v7.titleText, bodyText = v7.bodyText }

	local v9 = {
		preferredOrientation = tooltipOrientation.Top,
		guiTarget = CoreGui,
		active = 0,
		DisplayOrder = 10
	}

	if engineFeature then
		state = p2.showTooltip and state
	end

	v9.active = state

	return withTooltip(v8, v9, function(p3)
		if fFlagCoreUiMigrateUIBloxToFoundation then
			return React.createElement(image, {
				Size = UDim2.fromScale(1, 1),
				Image = v5,
				ScaleType = Enum.ScaleType.Fit,
				imageStyle = { Color3 = theme.IconEmphasis.Color, Transparency = 0 },
				onAbsoluteSizeChanged = p3,
				onAbsolutePositionChanged = p3
			})
		end

		return React.createElement(imageSetLabel, {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Image = v5,
			ScaleType = Enum.ScaleType.Fit,
			ImageColor3 = theme.IconEmphasis.Color,
			[React.Change.AbsoluteSize] = p3,
			[React.Change.AbsolutePosition] = p3
		})
	end)
end

return StudioCTAIcon
