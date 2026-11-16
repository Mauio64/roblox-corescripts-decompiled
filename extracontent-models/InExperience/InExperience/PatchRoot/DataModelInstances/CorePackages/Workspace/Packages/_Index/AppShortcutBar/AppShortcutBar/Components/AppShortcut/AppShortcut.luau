local AppShortcutBar = script:FindFirstAncestor("AppShortcutBar")
local parent = AppShortcutBar.Parent

local TextService = game:GetService("TextService")

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local UIBlox = require(parent.UIBlox)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useStyle = UIBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local Icon = Foundation.Icon
local Image = Foundation.Image
local KeyLabel = UIBlox.App.Menu.KeyLabel
local KeyLabelUtilities = UIBlox.App.Menu.KeyLabelUtilities
local StateLayer = UIBlox.Core.Control.StateLayer
local Shortcut = UIBlox.App.Navigation.Shortcut

local IconWithHoldAnimation = require(script.Parent.IconWithHoldAnimation)

local Flags = require(AppShortcutBar.Flags)
local FFlagShortcutBarPlatformGamepadIcons = Flags.FFlagShortcutBarPlatformGamepadIcons
local defineFastFlag = game:DefineFastFlag("ShortcutUseDispatchSyntheticEvent", false)

local function getKeyLabelsWidth(items, p)
	local keyLabelsWidth = 0

	for _, item in items do
		keyLabelsWidth += KeyLabelUtilities.getKeyLabelWidth(item, p)
	end

	return keyLabelsWidth
end

local function useOnShortcutActivated(item)
	if not defineFastFlag then
		local v = React.useContext(ReactFocusNavigation.FocusNavigationContext)
		return (React.useMemo(function()
			return function()
				local selection = v._engineInterface.getSelection()

				if not selection then
					return
				end

				local v2 = v.activeEventMap:getValue()[item.inputKeyCode]

				if v2 ~= item.eventName then
					return
				end

				v._eventPropagationService:propagateEvent(
					selection,
					v2,
					{ KeyCode = item.inputKeyCode, UserInputState = Enum.UserInputState.Begin },
					false
				)

				task.wait(0.1)
				v._eventPropagationService:propagateEvent(
					selection,
					v2,
					{ KeyCode = item.inputKeyCode, UserInputState = Enum.UserInputState.End },
					false
				)
			end
		end, { v, item.inputKeyCode, item.eventName }))
	end

	local v = React.useContext(ReactFocusNavigation.FocusNavigationContext)
	local v2 = ReactFocusNavigation.useDispatchSyntheticEvent()

	return (React.useCallback(function()
		if item.hasProgress then
			v2(item.eventName, v.focusedGuiObject:getValue(), {
				UserInputState = Enum.UserInputState.Begin,
				KeyCode = item.inputKeyCode,
				UserInputType = Enum.UserInputType.None,
				immediateDispatch = true
			})
		else
			v2(item.eventName, v.focusedGuiObject:getValue(), {
				UserInputState = Enum.UserInputState.End,
				KeyCode = item.inputKeyCode,
				UserInputType = Enum.UserInputType.None,
				immediateDispatch = true
			})
		end
	end, { item.hasProgress, item.eventName, item.inputKeyCode, v, v2 }))
end

function AppShortcut(p)
	local layoutOrder = p.layoutOrder
	local item = p.item

	local v = useStyle()
	local v2 = useTokens()

	local v3 = typeof(item.icon) == "table"
	local v4, v5

	if item.hasProgress then
		v4 = v2.Size.Size_1300 / 2
		v5 = v2.Size.Size_1300 / 2
	elseif v3 then
		local icon = item.icon
		local font = v.Font
		v4 = 0

		for _, v6 in icon do
			v4 += KeyLabelUtilities.getKeyLabelWidth(v6, font)
		end

		v5 = v2.Size.Size_900
	else
		v4 = v2.Size.Size_600
		v5 = v2.Size.Size_600
	end

	local size = React.useMemo(function()
		local xSmall = v2.Gap.XSmall
		local labelMedium = v2.Typography.LabelMedium
		local vector2 = Vector2.new(1e999, 1e999)
		local v6

		if FoundationFontFaceMigration then
			v6 = GetTextSize(item.text, math.floor(labelMedium.FontSize), labelMedium.Font, vector2, {
				addTemporaryPadding = false
			})
		else
			v6 = TextService:GetTextSize(item.text, math.floor(labelMedium.FontSize), labelMedium.Font, vector2)
		end

		local v7 = v4 + xSmall + v6.X
		return UDim2.new(0, v7, 1, 0)
	end, { v2, v4, item.text })

	local size2 = React.useMemo(function()
		return size + UDim2.fromOffset(v2.Size.Size_100 * 2, 0)
	end, { size, v2 })

	local v6 = React.useMemo(function()
		if not v3 then
			return nil
		end

		local children = {
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center
			})
		}

		for k, keyCode in item.icon do
			children["KeyLabel_" .. tostring(k)] = React.createElement(KeyLabel, {
				LayoutOrder = k,
				keyCode = keyCode,
				iconThemeKey = "IconEmphasis"
			})
		end

		return children
	end, { v3, item.icon, v2 })

	local useCallback = React.useCallback
	local function fn(p2)
		if item.hasProgress then
			return React.createElement(IconWithHoldAnimation, {
				layoutOrder = p2.layoutOrder,
				size = UDim2.fromOffset(v4, v5),
				progress = item.progress,
				icon = item.icon,
				iconSize = v2.Size.Size_900 / 2
			})
		end

		local createElement = React.createElement

		local v7 = {
			LayoutOrder = p2.layoutOrder,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(v4, v5)
		}
		local v8

		if v3 then
			v8 = v6
		elseif FFlagShortcutBarPlatformGamepadIcons and item.isPlatformIcon then
			v8 = {
				Icon = React.createElement(Image, {
					Image = item.icon,
					imageStyle = v2.Color.Content.Default,
					tag = "size-full"
				})
			}
		else
			v8 = {
				Icon = React.createElement(Icon, {
					name = item.icon,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5)
				})
			}
		end

		return createElement("Frame", v7, v8)
	end

	local hasProgress = item.hasProgress
	local progress = item.progress
	local icon = item.icon
	local isPlatformIcon

	if FFlagShortcutBarPlatformGamepadIcons then
		isPlatformIcon = item.isPlatformIcon
	end

	local v7

	if FFlagShortcutBarPlatformGamepadIcons then
		v7 = v2
	end

	local v8

	if FoundationFontFaceMigration then
		v8 = v2.Size.Size_900
	end

	local renderIcon = useCallback(fn, {
		hasProgress,
		progress,
		icon,
		isPlatformIcon,
		v7,
		v4,
		v5,
		v3,
		v6,
		v8
	})

	local onActivated = useOnShortcutActivated(item)

	return React.createElement("Frame", {
		LayoutOrder = layoutOrder,
		BackgroundTransparency = 1,
		Size = size
	}, {
		ShortcutFrame = React.createElement(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 2 },
			{
				Shortcut = React.createElement(Shortcut, {
					size = UDim2.fromScale(1, 1),
					automaticSize = Enum.AutomaticSize.None,
					iconLabelGap = v2.Gap.XSmall,
					publicProps = item,
					labelTextSize = v2.Typography.LabelMedium.FontSize,
					labelColorStyle = v2.Color.Label,
					labelFontStyle = v2.Typography.LabelMedium,
					renderIcon = renderIcon
				})
			}
		),
		StateLayer = React.createElement(StateLayer, {
			selectable = false,
			cornerRadius = UDim.new(0, v2.Radius.Medium),
			size = size2,
			zIndex = 1,
			onActivated = onActivated
		})
	})
end

return React.memo(AppShortcut)
