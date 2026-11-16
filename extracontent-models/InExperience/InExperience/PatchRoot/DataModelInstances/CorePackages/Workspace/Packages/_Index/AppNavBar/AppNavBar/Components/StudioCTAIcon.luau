local CoreGui = game:GetService("CoreGui")

local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local UIBlox = require(parent2.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Localization = require(parent2.Localization)
local Promise = require(parent2.Promise)
local RobloxAppHooks = require(parent2.RobloxAppHooks)
local RoactUtils = require(parent2.RoactUtils)
local RoactServiceTags = require(parent2.RoactServiceTags)

local ControlState = UIBlox.Core.Control.Enum.ControlState
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation

local Foundation = require(parent2.Foundation)
local Image = Foundation.Image
local SharedFlags = require(parent2.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation

local useLocalization = Localization.Hooks.useLocalization
local useRoactService = RobloxAppHooks.useRoactService
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local AppEventIngestService = RoactServiceTags.AppEventIngestService

local Constants = require(parent.Constants)

local image = FFlagCoreUiMigrateUIBloxToFoundation and "icons/logo/studiologo" or Images["icons/logo/studiologo"]

local engineFeature = game:GetEngineFeature("WebViewRedesignEnabled")

local function StudioCTAIcon(p)
	local theme = useStyle().Theme

	local state, setState = React.useState(false)
	local v = useRoactService(AppEventIngestService)

	local v2 = useLocalization({
		titleText = "CommonUI.Features.StudioCTA.Tooltip.Title",
		bodyText = "CommonUI.Features.StudioCTA.Tooltip.Body"
	})

	local ref = React.useRef(nil)

	useEffectOnce(function()
		v:setRBXEventStream(Constants.STUDIO_CTA_EVENT_CONTEXT, Constants.STUDIO_CTA_EVENT_NAME_MOUNT)
	end, {})

	if p.controlState == ControlState.Hover or p.controlState == ControlState.Selected then
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

	local v3 = { headerText = v2.titleText, bodyText = v2.bodyText }

	local v4 = {
		preferredOrientation = TooltipOrientation.Top,
		guiTarget = CoreGui,
		active = 0,
		DisplayOrder = 10
	}

	if engineFeature then
		state = p.showTooltip and state
	end

	v4.active = state

	return withTooltip(v3, v4, function(p2)
		if FFlagCoreUiMigrateUIBloxToFoundation then
			return React.createElement(Image, {
				Size = UDim2.fromScale(1, 1),
				Image = image,
				ScaleType = Enum.ScaleType.Fit,
				imageStyle = { Color3 = theme.IconEmphasis.Color, Transparency = 0 },
				onAbsoluteSizeChanged = p2,
				onAbsolutePositionChanged = p2
			})
		end

		return React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Image = image,
			ScaleType = Enum.ScaleType.Fit,
			ImageColor3 = theme.IconEmphasis.Color,
			[React.Change.AbsoluteSize] = p2,
			[React.Change.AbsolutePosition] = p2
		})
	end)
end

return StudioCTAIcon
