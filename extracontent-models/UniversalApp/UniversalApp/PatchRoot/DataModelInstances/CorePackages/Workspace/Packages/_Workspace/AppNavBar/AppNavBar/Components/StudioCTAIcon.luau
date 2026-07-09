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
local useLocalization = Localization.Hooks.useLocalization
local useRoactService = RobloxAppHooks.useRoactService
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local Constants = require(ParentParent.Constants)
local v22 = Images["icons/logo/studiologo"]
local EngineFeature = game:GetEngineFeature("WebViewRedesignEnabled")

local function StudioCTAIcon(t1: {[any]: any}) -- line: 41
	-- upvalues: useStyle (copy), React (copy), useRoactService (copy), AppEventIngestService (copy), useLocalization (copy), useEffectOnce (copy), Constants (copy), ControlState (copy), Promise (copy), TooltipOrientation (copy), CoreGui (copy), EngineFeature (copy), withTooltip (copy), ImageSetLabel (copy), v22 (copy)
	local Theme = useStyle().Theme
	local v27, v28 = React.useState(false)
	local v29 = useRoactService(AppEventIngestService)
	local v30 = useLocalization({
		titleText = "CommonUI.Features.StudioCTA.Tooltip.Title",
		bodyText = "CommonUI.Features.StudioCTA.Tooltip.Body"
	})
	local v31 = React.useRef(nil)

	useEffectOnce(function() -- line: 56
		-- upvalues: v29 (copy), Constants (copy)
		v29:setRBXEventStream(Constants.STUDIO_CTA_EVENT_CONTEXT, Constants.STUDIO_CTA_EVENT_NAME_MOUNT)
	end, {})

	if t1.controlState == ControlState.Hover or t1.controlState == ControlState.Selected then
		if not v31.current then
			v31.current = Promise.delay(0.4):andThenCall(function() -- line: 64
				-- upvalues: v31 (copy), v28 (copy)
				v31.current = nil
				v28(true)
			end)
		end
	else
		if v31.current then
			v31.current:cancel()
			v31.current = nil
		end

		if v27 then
			v28(false)
		end
	end

	local t2 = {
		headerText = v30.titleText,
		bodyText = v30.bodyText
	}
	local t3 = {
		DisplayOrder = 10,
		preferredOrientation = TooltipOrientation.Top,
		guiTarget = CoreGui,
		active = if not EngineFeature then v27 else t1.showTooltip and v27
	}

	return withTooltip(t2, t3, function(p1) -- line: 92
		-- upvalues: React (copy), ImageSetLabel (copy), v22 (copy), Theme (ref)
		return React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Image = v22,
			ScaleType = Enum.ScaleType.Fit,
			ImageColor3 = Theme.IconEmphasis.Color,
			[React.Change.AbsoluteSize] = p1,
			[React.Change.AbsolutePosition] = p1
		})
	end)
end

return StudioCTAIcon
