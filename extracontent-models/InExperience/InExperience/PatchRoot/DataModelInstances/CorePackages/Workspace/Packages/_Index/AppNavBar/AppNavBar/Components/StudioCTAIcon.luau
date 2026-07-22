local CoreGui = game:GetService("CoreGui")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local UIBlox = require(ParentParentParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Localization = require(ParentParentParent.Localization)
local Promise = require(ParentParentParent.Promise)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local RoactUtils = require(ParentParentParent.RoactUtils)
local RoactServiceTags = require(ParentParentParent.RoactServiceTags)
local ControlState = UIBlox.Core.Control.Enum.ControlState
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local Image = require(ParentParentParent.Foundation).Image
local FFlagCoreUiMigrateUIBloxToFoundation = require(ParentParentParent.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local useLocalization = Localization.Hooks.useLocalization
local useRoactService = RobloxAppHooks.useRoactService
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local Constants = require(ParentParent.Constants)
local v24 = if not FFlagCoreUiMigrateUIBloxToFoundation then Images["icons/logo/studiologo"] else "icons/logo/studiologo"
local EngineFeature = game:GetEngineFeature("WebViewRedesignEnabled")

local function StudioCTAIcon(t1: {[any]: any}) -- line: 48
	-- upvalues: useStyle (copy), React (copy), useRoactService (copy), AppEventIngestService (copy), useLocalization (copy), useEffectOnce (copy), Constants (copy), ControlState (copy), Promise (copy), TooltipOrientation (copy), CoreGui (copy), EngineFeature (copy), withTooltip (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Image (copy), v24 (copy), ImageSetLabel (copy)
	local Theme = useStyle().Theme
	local v29, v30 = React.useState(false)
	local v31 = useRoactService(AppEventIngestService)
	local v32 = useLocalization({
		titleText = "CommonUI.Features.StudioCTA.Tooltip.Title",
		bodyText = "CommonUI.Features.StudioCTA.Tooltip.Body"
	})
	local v33 = React.useRef(nil)

	useEffectOnce(function() -- line: 63
		-- upvalues: v31 (copy), Constants (copy)
		v31:setRBXEventStream(Constants.STUDIO_CTA_EVENT_CONTEXT, Constants.STUDIO_CTA_EVENT_NAME_MOUNT)
	end, {})

	if t1.controlState == ControlState.Hover or t1.controlState == ControlState.Selected then
		if not v33.current then
			v33.current = Promise.delay(0.4):andThenCall(function() -- line: 71
				-- upvalues: v33 (copy), v30 (copy)
				v33.current = nil
				v30(true)
			end)
		end
	else
		if v33.current then
			v33.current:cancel()
			v33.current = nil
		end

		if v29 then
			v30(false)
		end
	end

	local t2 = {
		headerText = v32.titleText,
		bodyText = v32.bodyText
	}
	local t3 = {
		DisplayOrder = 10,
		preferredOrientation = TooltipOrientation.Top,
		guiTarget = CoreGui,
		active = if not EngineFeature then v29 else t1.showTooltip and v29
	}

	return withTooltip(t2, t3, function(p1) -- line: 99
		-- upvalues: FFlagCoreUiMigrateUIBloxToFoundation (copy), React (copy), Image (copy), v24 (copy), Theme (ref), ImageSetLabel (copy)
		if FFlagCoreUiMigrateUIBloxToFoundation then
			return React.createElement(Image, {
				Size = UDim2.fromScale(1, 1),
				Image = v24,
				ScaleType = Enum.ScaleType.Fit,
				imageStyle = {
					Transparency = 0,
					Color3 = Theme.IconEmphasis.Color
				},
				onAbsoluteSizeChanged = p1,
				onAbsolutePositionChanged = p1
			})
		end

		return React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Image = v24,
			ScaleType = Enum.ScaleType.Fit,
			ImageColor3 = Theme.IconEmphasis.Color,
			[React.Change.AbsoluteSize] = p1,
			[React.Change.AbsolutePosition] = p1
		})
	end)
end

return StudioCTAIcon
