local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Foundation")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/UIBlox")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/ReactFocusNavigation")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Style").GetTextSize

local useStyle = UIBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local icon = Foundation.Icon
local image = Foundation.Image
local keyLabel = UIBlox.App.Menu.KeyLabel
local keyLabelUtilities = UIBlox.App.Menu.KeyLabelUtilities
local stateLayer = UIBlox.Core.Control.StateLayer
local shortcut = UIBlox.App.Navigation.Shortcut

local IconWithHoldAnimation = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Components/AppShortcut/IconWithHoldAnimation")

local fFlagShortcutBarPlatformGamepadIcons = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Flags").FFlagShortcutBarPlatformGamepadIcons
local defineFastFlag = game:DefineFastFlag("ShortcutUseDispatchSyntheticEvent", false)

local function getKeyLabelsWidth(items, p2)
	local keyLabelsWidth = 0

	for k, item in items do
		keyLabelsWidth += keyLabelUtilities.getKeyLabelWidth(item, p2)
	end

	return keyLabelsWidth
end

local function useOnShortcutActivated(item)
	if not defineFastFlag then
		local v5 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
		return (React.useMemo(function()
			return function()
				local selection = v5._engineInterface.getSelection()

				if not selection then
					return
				end

				local v6 = v5.activeEventMap:getValue()[item.inputKeyCode]

				if v6 ~= item.eventName then
					return
				end

				v5._eventPropagationService:propagateEvent(
					selection,
					v6,
					{
						KeyCode = item.inputKeyCode,
						UserInputState = Enum.UserInputState.Begin
					},
					false
				)

				task.wait(0.1)
				v5._eventPropagationService:propagateEvent(
					selection,
					v6,
					{
						KeyCode = item.inputKeyCode,
						UserInputState = Enum.UserInputState.End
					},
					false
				)
			end
		end, { v5, item.inputKeyCode, item.eventName }))
	end

	local v5 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
	local v6 = ReactFocusNavigation.useDispatchSyntheticEvent()

	return (React.useCallback(function()
		if item.hasProgress then
			v6(item.eventName, v5.focusedGuiObject:getValue(), {
				UserInputState = Enum.UserInputState.Begin,
				KeyCode = item.inputKeyCode,
				UserInputType = Enum.UserInputType.None,
				immediateDispatch = true
			})
		else
			v6(item.eventName, v5.focusedGuiObject:getValue(), {
				UserInputState = Enum.UserInputState.End,
				KeyCode = item.inputKeyCode,
				UserInputType = Enum.UserInputType.None,
				immediateDispatch = true
			})
		end
	end, { item.hasProgress, item.eventName, item.inputKeyCode, v5, v6 }))
end

function LUAUFORGE_MODULE_GLOBALS_bSC_AppShortcut(p2)
	local layoutOrder = p2.layoutOrder
	local item = p2.item

	local v5 = useStyle()
	local v6 = useTokens()

	local v7 = typeof(item.icon) == "table"
	local v8, v9

	if item.hasProgress then
		v8 = v6.Size.Size_1300 / 2
		v9 = v6.Size.Size_1300 / 2
	elseif v7 then
		local icon2 = item.icon
		local font = v5.Font
		v8 = 0

		for k, v10 in icon2 do
			v8 += keyLabelUtilities.getKeyLabelWidth(v10, font)
		end

		v9 = v6.Size.Size_900
	else
		v8 = v6.Size.Size_600
		v9 = v6.Size.Size_600
	end

	local v10 = React.useMemo(function()
		local xSmall = v6.Gap.XSmall
		local labelMedium = v6.Typography.LabelMedium
		local vector2 = Vector2.new(1e999, 1e999)

		local textSize = getTextSize(
			item.text,
			math.floor(labelMedium.FontSize),
			labelMedium.Font,
			vector2,
			{ addTemporaryPadding = false }
		)

		local v11 = v8 + xSmall + textSize.X
		return UDim2.new(0, v11, 1, 0)
	end, { v6, v8, item.text })

	local v11 = React.useMemo(function()
		return v10 + UDim2.fromOffset(v6.Size.Size_100 * 2, 0)
	end, { v10, v6 })

	local v12 = React.useMemo(function()
		if not v7 then
			return nil
		end

		local children = {
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center
			})
		}

		for k, v13 in item.icon do
			children["KeyLabel_" .. tostring(k)] = React.createElement(keyLabel, {
				LayoutOrder = k,
				keyCode = v13,
				iconThemeKey = "IconEmphasis"
			})
		end

		return children
	end, { v7, item.icon, v6 })

	local useCallback = React.useCallback
	local function fn(p3)
		if item.hasProgress then
			return React.createElement(IconWithHoldAnimation, {
				layoutOrder = p3.layoutOrder,
				size = UDim2.fromOffset(v8, v9),
				progress = item.progress,
				icon = item.icon,
				iconSize = v6.Size.Size_900 / 2
			})
		end

		local createElement = React.createElement

		local v14 = {
			LayoutOrder = p3.layoutOrder,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(v8, v9)
		}
		local v15

		if v7 then
			v15 = v12
		elseif fFlagShortcutBarPlatformGamepadIcons and item.isPlatformIcon then
			v15 = {
				Icon = React.createElement(image, {
					Image = item.icon,
					imageStyle = v6.Color.Content.Default,
					tag = "size-full"
				})
			}
		else
			v15 = {
				Icon = React.createElement(icon, {
					name = item.icon,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5)
				})
			}
		end

		return createElement("Frame", v14, v15)
	end

	local hasProgress = item.hasProgress
	local progress = item.progress
	local icon2 = item.icon
	local isPlatformIcon = if fFlagShortcutBarPlatformGamepadIcons then item.isPlatformIcon else nil
	local v15 = useCallback(fn, {
		hasProgress,
		progress,
		icon2,
		isPlatformIcon,
		if fFlagShortcutBarPlatformGamepadIcons then v6 else nil,
		v8,
		v9,
		v7,
		v12,
		v6.Size.Size_900
	})

	local v16 = useOnShortcutActivated(item)

	return React.createElement(
		"Frame",
		{ LayoutOrder = layoutOrder, BackgroundTransparency = 1, Size = v10 },
		{
			ShortcutFrame = React.createElement(
				"Frame",
				{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 2 },
				{
					Shortcut = React.createElement(shortcut, {
						size = UDim2.fromScale(1, 1),
						automaticSize = Enum.AutomaticSize.None,
						iconLabelGap = v6.Gap.XSmall,
						publicProps = item,
						labelTextSize = v6.Typography.LabelMedium.FontSize,
						labelColorStyle = v6.Color.Label,
						labelFontStyle = v6.Typography.LabelMedium,
						renderIcon = v15
					})
				}
			),
			StateLayer = React.createElement(stateLayer, {
				selectable = false,
				cornerRadius = UDim.new(0, v6.Radius.Medium),
				size = v11,
				zIndex = 1,
				onActivated = v16
			})
		}
	)
end

return React.memo(LUAUFORGE_MODULE_GLOBALS_bSC_AppShortcut)
