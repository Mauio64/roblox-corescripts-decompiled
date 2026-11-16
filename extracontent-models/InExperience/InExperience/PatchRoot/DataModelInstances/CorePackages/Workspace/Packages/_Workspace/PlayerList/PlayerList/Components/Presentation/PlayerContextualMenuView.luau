local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local React = require(parent2.React)
local SignalsReact = require(parent2.SignalsReact)
local Foundation = require(parent2.Foundation)

local View = Foundation.View
local Divider = Foundation.Divider
local useTokens = Foundation.Hooks.useTokens
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local PlayerContextualMenuStore = require(parent.Common.PlayerContextualMenuStore)
local PlayerContextMenuHeader = require(parent.Components.Presentation.PlayerContextMenuHeader)
local MenuActionRow = require(parent.Components.Presentation.MenuActionRow)
local usePreferredBackgroundStyle = require(parent.Hooks.usePreferredBackgroundStyle)
local Constants = require(parent.Common.Constants)

local useSlideOpenCloseAnimation = require(parent.Hooks.useSlideOpenCloseAnimation)
local useSlideOpenCloseAnimation2 = useSlideOpenCloseAnimation.useSlideOpenCloseAnimation
local MENU_SLIDE_CONFIG = useSlideOpenCloseAnimation.MENU_SLIDE_CONFIG
local MENU_ZOOM_CLOSED_SCALE = useSlideOpenCloseAnimation.MENU_ZOOM_CLOSED_SCALE

local backgroundStyle = { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
local stateLayer = { affordance = StateLayerAffordance.None }

local function fn() end

local function isPositionInsideGuiObject(p, vector3: Vector3): boolean -- 4 equivalent calls inferred from this helper
	local absolutePosition = p.AbsolutePosition
	local absoluteSize = p.AbsoluteSize
	return vector3.X >= absolutePosition.X
		and vector3.X <= absolutePosition.X + absoluteSize.X
		and vector3.Y >= absolutePosition.Y
		and vector3.Y <= absolutePosition.Y + absoluteSize.Y
end

local function isPositionOnMenu(folder, position: Vector3): boolean
	if isPositionInsideGuiObject(folder, position) then -- inferred equivalent call
		return true
	end

	for _, guiObject in folder:GetDescendants() do
		if guiObject:IsA("GuiObject") and guiObject.Visible and isPositionInsideGuiObject(guiObject, position) then -- inferred equivalent call
			return true
		end
	end

	return false
end

local function isPositionOnRow(anchorRow, position: Vector3): boolean
	if not isPositionInsideGuiObject(anchorRow, position) then -- inferred equivalent call
		return false
	end

	local parent3 = anchorRow.Parent

	while parent3 ~= nil and parent3:IsA("GuiObject") do
		if parent3.ClipsDescendants and not isPositionInsideGuiObject(parent3, position) then -- inferred equivalent call
			return false
		end

		parent3 = parent3.Parent
	end

	return true
end

local function isGamepad(): boolean -- 1 equivalent call inferred from this helper
	return UserInputService:GetLastInputType().Name:find("Gamepad") ~= nil
end

local function PlayerContextualMenuView(props)
	local current2 = SignalsReact.useSignalState(PlayerContextualMenuStore.getMenuData)
	local v = useTokens()
	local backgroundStyle2 = usePreferredBackgroundStyle(v.Color.OverMedia.OverMedia_100)

	local ref = React.useRef(current2)

	if current2 ~= nil then
		ref.current = current2
	end

	local v2 = current2 ~= nil
	local v3

	if current2 then
		v3 = current2.player.UserId
	end

	local v4 = useSlideOpenCloseAnimation2(v2, MENU_SLIDE_CONFIG, v3)
	local isInteractable = current2 ~= nil
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local contextActionServiceOverride = props.contextActionServiceOverride
	local v5

	if props.isGamepadOverride == nil then
		v5 = isGamepad() -- inferred equivalent call
	else
		v5 = props.isGamepadOverride
	end

	React.useEffect(function()
		if props.isSmallTouchDevice and isInteractable then
			local v6 = contextActionServiceOverride or ContextActionService
			v6:BindCoreAction("RbxPlayerListReskinGamepadMenuClose", function(_, p, _)
				if p ~= Enum.UserInputState.Begin then
					return Enum.ContextActionResult.Pass
				end

				PlayerContextualMenuStore.closeContextMenu()
				return Enum.ContextActionResult.Sink
			end, false, Enum.KeyCode.ButtonB)
			return function()
				v6:UnbindCoreAction("RbxPlayerListReskinGamepadMenuClose")
			end
		end

		return function() end
	end, { isInteractable, props.isSmallTouchDevice, contextActionServiceOverride })

	local userInputServiceOverride = props.userInputServiceOverride
	React.useEffect(function()
		if not isInteractable then
			return function() end
		end

		local inputBeganConnection = (userInputServiceOverride or UserInputService).InputBegan:Connect(function(input)
			local userInputType = input.UserInputType

			if userInputType ~= Enum.UserInputType.Touch and userInputType ~= Enum.UserInputType.MouseButton1 then
				return
			end

			local current = ref2.current

			if current ~= nil and isPositionOnMenu(current, input.Position) then
				return
			end

			if not props.isSmallTouchDevice then
				local anchorRow = PlayerContextualMenuStore.getAnchorRow()

				if anchorRow ~= nil and isPositionOnRow(anchorRow, input.Position) then
					return
				end
			end

			PlayerContextualMenuStore.closeContextMenu()
		end)
		return function()
			inputBeganConnection:Disconnect()
		end
	end, { isInteractable, userInputServiceOverride, props.isSmallTouchDevice })

	React.useEffect(function()
		if props.isSmallTouchDevice and isInteractable and v5 then
			if ref3.current then
				GuiService.SelectedCoreObject = ref3.current
			end

			return function() end
		end

		return function() end
	end, { isInteractable, props.isSmallTouchDevice, v5 })

	local scale = React.useMemo(function()
		if props.isSmallTouchDevice then
			return v4.offset:map(function(p: number)
				return 1 + (MENU_ZOOM_CLOSED_SCALE - 1) * p
			end)
		end

		return nil
	end, { props.isSmallTouchDevice, v4.offset })

	local transparency = React.useMemo(function()
		if not props.isSmallTouchDevice then
			return nil
		end

		local transparency = v.Color.Stroke.Default.Transparency
		return v4.offset:map(function(p: number)
			return transparency + (1 - transparency) * p
		end)
	end, { props.isSmallTouchDevice, v4.offset, v.Color.Stroke.Default.Transparency })

	if not v4.shouldMount then
		return nil
	end

	local current = ref.current

	if current == nil then
		return nil
	end

	local anchorPosition = current.anchorPosition
	local vector2 = Vector2.new(0.5, 0.5)
	local udim = UDim2.fromScale(0.5, 0.5)

	if not props.isSmallTouchDevice and anchorPosition ~= nil then
		vector2 = Vector2.new(1, 0)
		udim = UDim2.fromOffset(anchorPosition.X - 8, anchorPosition.Y)
	end

	local children = {
		Header = React.createElement(PlayerContextMenuHeader, {
			header = current.header,
			player = current.player,
			layoutOrder = 1
		}),
		HeaderDivider = React.createElement(Divider, { LayoutOrder = 2 })
	}

	for i, item in ipairs(current.items) do
		local formatted = `Action_{tostring(item.key)}`
		local createElement = React.createElement
		local v6 = {
			item = item,
			layoutOrder = 2 + i,
			isInteractable = isInteractable,
			rowRef = 0
		}
		local rowRef

		if i == 1 then
			rowRef = ref3
		end

		v6.rowRef = rowRef
		children[formatted] = createElement(MenuActionRow, v6)
	end

	local v6 = Constants.CONTEXT_MENU_WIDTH * v.Config.UI.Scale
	local children2

	if props.isSmallTouchDevice then
		children2 = table.clone(children)
		children2.UIScale = React.createElement("UIScale", { Scale = scale })

		children2.UIStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = v.Color.Stroke.Default.Color3,
			Transparency = transparency,
			Thickness = v.Stroke.Standard
		})
	else
		children2 = {
			SlideOffset = React.createElement(
				View,
				{
					Position = v4.position,
					Size = UDim2.fromOffset(v6, 0),
					tag = "col align-x-left gap-xxsmall auto-y padding-small stroke-standard stroke-default radius-large",
					backgroundStyle = backgroundStyle2
				},
				children
			)
		}
	end

	local createElement = React.createElement
	local v7 = {
		ZIndex = 10,
		tag = "size-full",
		backgroundStyle = backgroundStyle,
		selection = Constants.NOT_SELECTABLE
	}

	local createElement2 = React.createElement
	local v8 = {
		tag = "size-full",
		ZIndex = 1,
		backgroundStyle = backgroundStyle,
		onActivated = 0,
		stateLayer = 0,
		selection = 0
	}
	local onActivated

	if props.isSmallTouchDevice and isInteractable then
		onActivated = fn
	end

	v8.onActivated = onActivated
	v8.stateLayer = stateLayer
	v8.selection = Constants.NOT_SELECTABLE
	local children3 = { Backdrop = createElement2(View, v8), Menu = 0 }

	local createElement3 = React.createElement
	local v9 = {
		AnchorPoint = vector2,
		Position = udim,
		Size = UDim2.fromOffset(v6, 0),
		ZIndex = 2,
		Visible = true,
		ref = ref2,
		GroupTransparency = 0,
		selectionGroup = 0,
		selection = 0,
		tag = 0,
		backgroundStyle = 0,
		onActivated = 0,
		stateLayer = 0,
		testId = "player-context-menu"
	}
	local groupTransparency

	if props.isSmallTouchDevice then
		groupTransparency = v4.offset
	end

	v9.GroupTransparency = groupTransparency
	local selectionGroup

	if props.isSmallTouchDevice and isInteractable then
		selectionGroup = Constants.CONSOLE_FOCUS_ISOLATE
	end

	v9.selectionGroup = selectionGroup
	v9.selection = Constants.NOT_SELECTABLE
	v9.tag = {
		["auto-y clip"] = not props.isSmallTouchDevice,
		["col align-x-left gap-xxsmall auto-y padding-small radius-large"] = props.isSmallTouchDevice
	}

	if not props.isSmallTouchDevice then
		backgroundStyle2 = nil
	end

	v9.backgroundStyle = backgroundStyle2
	local onActivated2

	if not props.isSmallTouchDevice then
		onActivated2 = fn
	end

	v9.onActivated = onActivated2
	local stateLayer2

	if not props.isSmallTouchDevice then
		stateLayer2 = stateLayer
	end

	v9.stateLayer = stateLayer2
	children3.Menu = createElement3(View, v9, children2)
	return createElement(View, v7, children3)
end

return React.memo(PlayerContextualMenuView)
