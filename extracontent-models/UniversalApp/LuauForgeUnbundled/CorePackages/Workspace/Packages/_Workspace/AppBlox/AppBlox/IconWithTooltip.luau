local CoreGui = game:GetService("CoreGui")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local interactable = UIBlox.Core.Control.Interactable
local withHoverTooltip = UIBlox.App.Dialog.TooltipV2.withHoverTooltip
local controlState = UIBlox.Core.Control.Enum.ControlState
local useCursor = UIBlox.App.SelectionCursor.useCursor
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Style").useDesignTokens
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation").Hooks.useTokens
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RobloxAppEnums").UiMode

local getFFlagTenFootUiSupportSortHeaderTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags").GetFFlagTenFootUiSupportSortHeaderTooltip
local fFlagSduiComponentsUseFoundationTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags").FFlagSduiComponentsUseFoundationTokens

game:DefineFastInt("TooltipHitboxMinSize", 26)

local defineFastFlag = game:DefineFastFlag("LuaAppGateTooltipPositionTracking", false)

local iconsactionsinfo = images["icons/actions/info"]
local vector2 = Vector2.new(
	game:GetFastInt("TooltipHitboxMinSize"),
	game:GetFastInt("TooltipHitboxMinSize")
)

local function IconWithTooltip(data)
	local v5 = useUiModeInfo()
	local v6 = if fFlagSduiComponentsUseFoundationTokens then useTokens() else useDesignTokens()

	local ref = if defineFastFlag then React.useRef(false) else nil

	local ref2 = if defineFastFlag then React.useRef(nil) else nil

	local color3 = v6.Color.Content.Emphasis.Color3
	local size_600 = v6.Size.Size_600
	local circle, size_0

	if getFFlagTenFootUiSupportSortHeaderTooltip() then
		circle = v6.Radius.Circle
		size_0 = v6.Size.Size_0
	end

	local v7

	if getFFlagTenFootUiSupportSortHeaderTooltip() then
		v7 = useCursor(UDim.new(0, circle), size_0)
	else
		v7 = nil
	end

	local v8 = v5.uiMode == uiMode.VR

	if
		v5.uiMode == uiMode.VR and not data.supportVR
		or v5.uiMode == uiMode.TenFoot and not data.supportTenFootUi
	then
		return nil
	end

	local v9 = { bodyText = data.hoverText, useLargeDropShadow = true }

	local v10 = {
		preferredOrientation = data.tooltipOrientation,
		guiTarget = CoreGui,
		DisplayOrder = 10,
		delayTime = 0.2,
		triggerPointName = data.triggerPointName,
		disabled = v8
	}

	local size = data.size or UDim2.new(0, size_600, 0, size_600)
	return withHoverTooltip(v9, v10, function(callback, callback2)
		local v11, onStateChanged

		if defineFastFlag then
			v11 = function(p2)
				if ref.current then
					callback(p2)
				end
			end
			onStateChanged = function(p2, p3)
				ref.current = p3 == controlState.Hover or p3 == controlState.Selected

				if ref.current and ref2.current then
					callback(ref2.current)
				end

				callback2(p2, p3)
			end
		else
			onStateChanged = callback2
			v11 = callback
		end

		local createElement = React.createElement
		local v13 = {
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			Size = size,
			BackgroundTransparency = 1,
			LayoutOrder = data.layoutOrder,
			AnchorPoint = data.anchorPoint,
			Position = data.position,
			ref = if defineFastFlag then ref2 else nil
		}

		local v15 = if getFFlagTenFootUiSupportSortHeaderTooltip() then v7 else nil
		v13.SelectionImageObject = v15
		v13[React.Change.AbsolutePosition] = v11
		v13[React.Change.AbsoluteSize] = v11
		return createElement("Frame", v13, {
			TooltipIcon = React.createElement(imageSetLabel, {
				Size = size,
				BackgroundTransparency = 1,
				Image = data.icon or iconsactionsinfo,
				ImageColor3 = data.color or color3,
				ZIndex = 0
			}),
			Hitbox = React.createElement(interactable, {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				onStateChanged = onStateChanged,
				[React.Event.Activated] = data.onActivateTooltip,
				ZIndex = 1,
				Selectable = data.selectable
			}, {
				UISizeConstraint = React.createElement("UISizeConstraint", {
					MinSize = vector2
				})
			})
		})
	end)
end

return IconWithTooltip
