local CoreGui = game:GetService("CoreGui")
local Parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Interactable = UIBlox.Core.Control.Interactable
local withHoverTooltip = UIBlox.App.Dialog.TooltipV2.withHoverTooltip
local useCursor = UIBlox.App.SelectionCursor.useCursor
local useDesignTokens = require(Parent.Style).useDesignTokens
local useUiModeInfo = require(Parent.RobloxAppHooks).useUiModeInfo
local UiMode = require(Parent.RobloxAppEnums).UiMode
local GetFFlagTenFootUiSupportSortHeaderTooltip = require(Parent.SharedFlags).GetFFlagTenFootUiSupportSortHeaderTooltip
local FFlagLuaAppFixCursorHooks = require(Parent.SharedFlags).FFlagLuaAppFixCursorHooks

game:DefineFastInt("TooltipHitboxMinSize", 26)

local v15 = Images["icons/actions/info"]
local vector2 = Vector2.new(game:GetFastInt("TooltipHitboxMinSize"), game:GetFastInt("TooltipHitboxMinSize"))

local function IconWithTooltip(t1: {[any]: any}) -- line: 42
	-- upvalues: useUiModeInfo (copy), useDesignTokens (copy), GetFFlagTenFootUiSupportSortHeaderTooltip (copy), FFlagLuaAppFixCursorHooks (copy), useCursor (copy), UiMode (copy), CoreGui (copy), withHoverTooltip (copy), React (copy), ImageSetLabel (copy), v15 (copy), Interactable (copy), vector2 (copy)
	local v19 = useUiModeInfo()
	local v20 = useDesignTokens()
	local EmphasisColor3 = v20.Color.Content.Emphasis.Color3
	local Size_600 = v20.Size.Size_600
	local Circle = nil
	local Size_0 = nil

	if GetFFlagTenFootUiSupportSortHeaderTooltip() then
		Circle = v20.Radius.Circle
		Size_0 = v20.Size.Size_0
	end

	local v25 = if not FFlagLuaAppFixCursorHooks or not GetFFlagTenFootUiSupportSortHeaderTooltip() then nil else useCursor(UDim.new(0, Circle), Size_0)
	local v26 = v19.uiMode == UiMode.VR

	if v19.uiMode == UiMode.VR and not t1.supportVR then
		return nil
	end

	if v19.uiMode == UiMode.TenFoot and not t1.supportTenFootUi then
		return nil
	end

	local t2 = {
		useLargeDropShadow = true,
		bodyText = t1.hoverText
	}
	local t3 = {
		DisplayOrder = 10,
		delayTime = 0.2,
		preferredOrientation = t1.tooltipOrientation,
		guiTarget = CoreGui,
		triggerPointName = t1.triggerPointName,
		disabled = v26
	}
	local v29 = t1.size or UDim2.new(0, Size_600, 0, Size_600)

	return withHoverTooltip(t2, t3, function(p1, p2) -- line: 81
		-- upvalues: React (copy), v29 (copy), t1 (copy), FFlagLuaAppFixCursorHooks (copy), GetFFlagTenFootUiSupportSortHeaderTooltip (copy), v25 (copy), useCursor (copy), Circle (ref), Size_0 (ref), ImageSetLabel (copy), v15 (copy), EmphasisColor3 (copy), Interactable (copy), vector2 (copy)
		return React.createElement("Frame", {
			Size = v29,
			BackgroundTransparency = 1,
			LayoutOrder = t1.layoutOrder,
			AnchorPoint = t1.anchorPoint,
			Position = t1.position,
			SelectionImageObject = if not FFlagLuaAppFixCursorHooks or not GetFFlagTenFootUiSupportSortHeaderTooltip() then if not GetFFlagTenFootUiSupportSortHeaderTooltip() then nil else useCursor(UDim.new(0, Circle), Size_0) else v25,
			[React.Change.AbsolutePosition] = p1,
			[React.Change.AbsoluteSize] = p1
		}, {
			TooltipIcon = React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				ZIndex = 0,
				Size = v29,
				Image = t1.icon or v15,
				ImageColor3 = t1.color or EmphasisColor3
			}),
			Hitbox = React.createElement(Interactable, {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				onStateChanged = p2,
				[React.Event.Activated] = t1.onActivateTooltip,
				ZIndex = 1,
				Selectable = t1.selectable
			}, {
				UISizeConstraint = React.createElement("UISizeConstraint", {
					MinSize = vector2
				})
			})
		})
	end)
end

return IconWithTooltip
