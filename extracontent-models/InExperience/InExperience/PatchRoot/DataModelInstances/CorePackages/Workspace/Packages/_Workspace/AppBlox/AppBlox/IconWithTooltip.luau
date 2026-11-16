local CoreGui = game:GetService("CoreGui")
local parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Interactable = UIBlox.Core.Control.Interactable
local withHoverTooltip = UIBlox.App.Dialog.TooltipV2.withHoverTooltip
local ControlState = UIBlox.Core.Control.Enum.ControlState
local useCursor = UIBlox.App.SelectionCursor.useCursor
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local RobloxAppEnums = require(parent.RobloxAppEnums)
local UiMode = RobloxAppEnums.UiMode

local SharedFlags = require(parent.SharedFlags)
local GetFFlagTenFootUiSupportSortHeaderTooltip = SharedFlags.GetFFlagTenFootUiSupportSortHeaderTooltip
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiComponentsUseFoundationTokens = SharedFlags2.FFlagSduiComponentsUseFoundationTokens

game:DefineFastInt("TooltipHitboxMinSize", 26)

local defineFastFlag = game:DefineFastFlag("LuaAppGateTooltipPositionTracking", false)

local iconsactionsinfo = Images["icons/actions/info"]
local vector2 = Vector2.new(game:GetFastInt("TooltipHitboxMinSize"), game:GetFastInt("TooltipHitboxMinSize"))

local function IconWithTooltip(data)
	local v = useUiModeInfo()
	local v2

	if FFlagSduiComponentsUseFoundationTokens then
		v2 = useTokens()
	else
		v2 = useDesignTokens()
	end

	local ref

	if defineFastFlag then
		ref = React.useRef(false)
	else
		ref = nil
	end

	local ref2

	if defineFastFlag then
		ref2 = React.useRef(nil)
	else
		ref2 = nil
	end

	local color3 = v2.Color.Content.Emphasis.Color3
	local size_600 = v2.Size.Size_600
	local circle, size_0

	if GetFFlagTenFootUiSupportSortHeaderTooltip() then
		circle = v2.Radius.Circle
		size_0 = v2.Size.Size_0
	end

	local v3

	if GetFFlagTenFootUiSupportSortHeaderTooltip() then
		v3 = useCursor(UDim.new(0, circle), size_0)
	else
		v3 = nil
	end

	local disabled = v.uiMode == UiMode.VR

	if v.uiMode == UiMode.VR and not data.supportVR or v.uiMode == UiMode.TenFoot and not data.supportTenFootUi then
		return nil
	end

	local v4 = { bodyText = data.hoverText, useLargeDropShadow = true }

	local v5 = {
		preferredOrientation = data.tooltipOrientation,
		guiTarget = CoreGui,
		DisplayOrder = 10,
		delayTime = 0.2,
		triggerPointName = data.triggerPointName,
		disabled = disabled
	}

	local size = data.size or UDim2.new(0, size_600, 0, size_600)
	return withHoverTooltip(v4, v5, function(callback, callback2)
		local v6, onStateChanged

		if defineFastFlag then
			v6 = function(p)
				if ref.current then
					callback(p)
				end
			end
			onStateChanged = function(p, p2)
				ref.current = p2 == ControlState.Hover or p2 == ControlState.Selected

				if ref.current and ref2.current then
					callback(ref2.current)
				end

				callback2(p, p2)
			end
		else
			onStateChanged = callback2
			v6 = callback
		end

		local createElement = React.createElement
		local v7 = {
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			Size = size,
			BackgroundTransparency = 1,
			LayoutOrder = data.layoutOrder,
			AnchorPoint = data.anchorPoint,
			Position = data.position
		}
		local ref3

		if defineFastFlag then
			ref3 = ref2
		end

		v7.ref = ref3
		local selectionImageObject

		if GetFFlagTenFootUiSupportSortHeaderTooltip() then
			selectionImageObject = v3
		end

		v7.SelectionImageObject = selectionImageObject
		v7[React.Change.AbsolutePosition] = v6
		v7[React.Change.AbsoluteSize] = v6
		return createElement("Frame", v7, {
			TooltipIcon = React.createElement(ImageSetLabel, {
				Size = size,
				BackgroundTransparency = 1,
				Image = data.icon or iconsactionsinfo,
				ImageColor3 = data.color or color3,
				ZIndex = 0
			}),
			Hitbox = React.createElement(Interactable, {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				onStateChanged = onStateChanged,
				[React.Event.Activated] = data.onActivateTooltip,
				ZIndex = 1,
				Selectable = data.selectable
			}, {
				UISizeConstraint = React.createElement("UISizeConstraint", { MinSize = vector2 })
			})
		})
	end)
end

return IconWithTooltip
