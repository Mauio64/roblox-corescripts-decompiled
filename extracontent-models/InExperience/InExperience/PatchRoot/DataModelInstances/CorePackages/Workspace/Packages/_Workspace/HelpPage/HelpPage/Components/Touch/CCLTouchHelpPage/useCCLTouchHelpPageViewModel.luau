local HelpPage = script:FindFirstAncestor("HelpPage")
local parent = HelpPage.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Display = require(parent.Display)
local SignalsReact = require(parent.SignalsReact)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local Constants = require(HelpPage.Constants)
local BindingConfigs = require(HelpPage.Configs.BindingConfigs)
require(HelpPage.Configs.ConfigTypes)
local useKeybinds = require(HelpPage.Hooks.useKeybinds)
require(HelpPage.Components.Touch.TouchControlList)

require(script.Parent.CCLTouchHelpPageView)

local DeviceOrientationMode = RobloxAppEnums.DeviceOrientationMode

local function createMockLayout(data, size_500: number)
	local v = size_500 / data.Size.Size_400
	local v2 = data.Size.Size_700 * v
	local v3 = v2 / 1.4142135623730951
	local v4 = size_500 * 20
	local vector2 = Vector2.new(v4, v4 / (80 / 37))
	local inset = data.Gap.XSmall * v
	local v5 = vector2 - Vector2.new(inset, inset)

	return {
		size = vector2,
		smallButtonSize = size_500,
		centerButtonSize = size_500 * 1.625,
		inset = inset,
		cornerRadius = data.Radius.Large * v,
		centerButtonPosition = v5 - Vector2.new(
			data.Padding.XLarge * v + size_500 / 2 + v3,
			data.Padding.Medium * v + size_500 / 2 + v3
		),
		slotOffsets = {
			Vector2.new(-v3, -v3),
			Vector2.new(-v3, v3),
			Vector2.new(v3, -v3),
			Vector2.new(-v2, 0),
			Vector2.new(0, -v2),
			Vector2.new(v3, v3)
		},
		topPadding = data.Padding.Medium * v,
		sidePadding = data.Padding.XLarge * v,
		topGap = data.Gap.XSmall * v
	}
end

local function createAbilityControl(id: string, data)
	local disabled = data == nil or data.disabled == true
	local abilityControl = {
		id = id,
		label = not data and "InGame.HelpMenu.GenericAction" or data.label,
		icon = Foundation.Enums.IconName.DiamondSimplified,
		assetId = 0,
		disabled = 0
	}
	local assetId

	if data then
		assetId = data.actionAssetId
	end

	abilityControl.assetId = assetId
	abilityControl.disabled = disabled
	return abilityControl
end

local function useCCLTouchHelpPageViewModel()
	local v = useKeybinds()
	local v2 = Foundation.Hooks.useTokens()
	local v3 = RobloxAppHooks.useDeviceOrientation()
	local v4 = SignalsReact.useSignalState(Display.GetDisplayStore)
	local v5 = SignalsReact.useSignalState(v4.getViewportSize)
	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(0)
	local onSizeChanged = React.useCallback(function(p)
		setState(p.AbsoluteSize.X)
	end, {})
	local onLeftSizeChanged = React.useCallback(function(p)
		setState2(p.AbsoluteSize.Y)
	end, {})
	local onRightSizeChanged = React.useCallback(function(p)
		setState3(p.AbsoluteSize.Y)
	end, {})

	local controls = v.controls or {}
	local leftControls = {}

	for _, v6 in ipairs({
		{ id = "UseTool", icon = Constants.HELP_PAGE.TOUCH_ICONS.TAP },
		{ id = "RotateCamera", icon = Constants.HELP_PAGE.TOUCH_ICONS.ROTATE },
		{ id = "ZoomInOut", icon = Constants.HELP_PAGE.TOUCH_ICONS.ZOOM },
		{ id = "Move", icon = Constants.HELP_PAGE.TOUCH_ICONS.ROTATE }
	}) do
		local v7 = controls[v6.id] or BindingConfigs.Controls[v6.id]

		if v7 then
			table.insert(leftControls, {
				id = v6.id,
				label = v7.label,
				icon = v6.icon,
				disabled = v7.disabled
			})
		end
	end

	local abilityControl = createAbilityControl("AbilityAction1", controls.AbilityAction1)

	local slots = {}

	for i = 2, 7 do
		local id = "AbilityAction" .. i
		local control = controls[id]
		table.insert(slots, createAbilityControl(id, control))
	end

	local rightControls = { abilityControl }

	for _, v6 in ipairs(slots) do
		table.insert(rightControls, v6)
	end

	table.insert(rightControls, {
		id = "MoreActions",
		label = "InGame.HelpMenu.GenericAction",
		icon = Foundation.Enums.IconName.DiamondSimplified
	})

	local mockLayout = createMockLayout(v2, v2.Size.Size_500)
	local v6

	if v3 == DeviceOrientationMode.Portrait then
		v6 = v5.X < Constants.HELP_PAGE.TOUCH_OFFSETS.SMALL_SCREEN_CUTOFF_X
			or v5.Y < Constants.HELP_PAGE.TOUCH_OFFSETS.SMALL_SCREEN_CUTOFF_Y
	else
		v6 = false
	end

	if not v6 then
		state = math.max(0, state * 0.5 - 2 * v2.Gap.Large)
	end

	local v7 = state / (80 / 37)
	local v8 = math.max(v7, state2, state3)
	local v9 = v7 + v2.Gap.Large

	local v10 = {
		abilitiesAvailable = v.abilitiesAvailable == true,
		leftControls = leftControls,
		rightControls = rightControls,
		centerControl = abilityControl,
		slots = slots,
		layout = 0,
		onSizeChanged = 0,
		onLeftSizeChanged = 0,
		onRightSizeChanged = 0,
		mockLayout = 0
	}
	local leftAnchor

	if v6 then
		leftAnchor = Vector2.zero
	else
		leftAnchor = Vector2.new(1, 0)
	end

	local leftPosition

	if v6 then
		leftPosition = UDim2.fromOffset(0, v9)
	else
		leftPosition = UDim2.new(0.25, 0, 0, (v8 - state2) / 2)
	end

	local rightAnchor

	if v6 then
		rightAnchor = Vector2.new(1, 0)
	else
		rightAnchor = Vector2.zero
	end

	local rightPosition

	if v6 then
		rightPosition = UDim2.new(1, 0, 0, v9)
	else
		rightPosition = UDim2.new(0.75, 0, 0, (v8 - state3) / 2)
	end

	v10.layout = {
		leftAnchor = leftAnchor,
		leftPosition = leftPosition,
		rightAnchor = rightAnchor,
		rightPosition = rightPosition,
		columnWidth = v6 and 0.5 or 0.25,
		columnScale = 1,
		diagramSize = Vector2.new(state, v7),
		diagramOffsetY = v6 and 0 or (v8 - v7) / 2,
		topPadding = UDim.new(0, v2.Padding.Small),
		bottomPadding = UDim.new(0, v2.Padding.XXLarge)
	}

	v10.onSizeChanged = onSizeChanged
	v10.onLeftSizeChanged = onLeftSizeChanged
	v10.onRightSizeChanged = onRightSizeChanged
	v10.mockLayout = mockLayout
	return v10
end

return useCCLTouchHelpPageViewModel
