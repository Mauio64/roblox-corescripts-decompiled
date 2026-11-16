local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/ReactUtils")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Responsive")
local CollapsibleFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/CollapsibleFrame")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/constants")

local getFFlagSongbirdPopoverSubmenu = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Flags/getFFlagSongbirdPopoverSubmenu")

local getFFlagChromeMusicWindowTopbarReappearsOnGamepad = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/SharedFlags").GetFFlagChromeMusicWindowTopbarReappearsOnGamepad

local createNextOrder = ReactUtils.createNextOrder
local usePrevious = ReactUtils.usePrevious
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState

local function useUnfocusKeybind(p2)
	useEffect(function()
		if not p2 then
			return nil
		end

		local function unfocus(p3, p4)
			if p4 ~= Enum.UserInputState.End then
				return Enum.ContextActionResult.Pass
			end

			GuiService.SelectedCoreObject = nil

			return Enum.ContextActionResult.Sink
		end

		ContextActionService:BindCoreAction("UnfocusMusicWindow", unfocus, false, Enum.KeyCode.ButtonB)

		return function()
			ContextActionService:UnbindCoreAction("UnfocusMusicWindow")
		end
	end, { p2 })
end

local v5 = {
	autoCollapseSeconds = 3,
	isSubMenuOpen = false,
	isFocused = false,
	onToggleSubMenu = function() end
}

local function ChromeWindowFrame(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = Foundation.Hooks.useTokens()
	local v7 = useRef(nil)
	local v8 = useRef(nil)

	local v9 = Responsive.useLastInput()
	local v10 = if getFFlagChromeMusicWindowTopbarReappearsOnGamepad() then usePrevious(v9) else nil
	local v11

	if getFFlagSongbirdPopoverSubmenu() or typeof(joined.overflowButtonRef) ~= "table" or not joined.overflowButtonRef.current then
		v11 = true
	else
		local v12 = joined.overflowButtonRef.current.AbsolutePosition + Vector2.new(v6.Gap.Small + constants.SUBMENU_WIDTH, 0)
		local screenGui = joined.overflowButtonRef.current:FindFirstAncestorOfClass("ScreenGui")
		v11 = v12.X < screenGui.AbsoluteSize.X
	end

	local nextOrder = createNextOrder()

	local v12 = useRef(nil)
	local state, setState = useState(true)

	local v13 = useCallback(function()
		if joined.onClose then
			joined.onClose()
		end
	end, { joined.onClose })

	local v14 = useCallback(function(p3)
		v12.current = nil
		setState(true)

		if p3 == Foundation.Enums.ControlState.Default then
			v12.current = os.time()
		end
	end, {})

	useEffect(function()
		if v9 ~= Responsive.Input.Pointer then
			return
		end

		if joined.autoCollapseSeconds and joined.autoCollapseSeconds > 0 then
			local heartbeatConnection = RunService.Heartbeat:Connect(function()
				if v12.current and os.time() - v12.current >= joined.autoCollapseSeconds then
					setState(false)
				end
			end)

			return function()
				heartbeatConnection:Disconnect()
			end
		end

		return nil
	end, { joined.autoCollapseSeconds, v9 })

	local state2, setState2 = useState(Vector2.new(1e999, 1e999))
	local v15 = useCallback(function(p3)
		setState2(p3.AbsoluteSize)
	end, {})

	useEffect(function()
		local current = v8.current

		if not current then
			return nil
		end

		local function onSelectionChanged(p3, p4, descendant)
			if not current:IsAncestorOf(descendant) and joined.onUnfocus then
				joined.onUnfocus()
			end
		end

		local selectionChangedConnection = current.SelectionChanged:Connect(onSelectionChanged)

		return function()
			selectionChangedConnection:Disconnect()
		end
	end, { joined.onUnfocus })

	useEffect(function()
		if joined.isFocused then
			GuiService.SelectedCoreObject = v7.current
		end
	end, { joined.isFocused })

	local isFocused = joined.isFocused
	useEffect(function()
		if not isFocused then
			return nil
		end

		local function unfocus(p3, p4)
			if p4 ~= Enum.UserInputState.End then
				return Enum.ContextActionResult.Pass
			end

			GuiService.SelectedCoreObject = nil

			return Enum.ContextActionResult.Sink
		end

		ContextActionService:BindCoreAction("UnfocusMusicWindow", unfocus, false, Enum.KeyCode.ButtonB)

		return function()
			ContextActionService:UnbindCoreAction("UnfocusMusicWindow")
		end
	end, { isFocused })

	if getFFlagChromeMusicWindowTopbarReappearsOnGamepad() then
		useEffect(function()
			if v10 and v9 ~= v10 and v9 ~= Responsive.Input.Pointer then
				setState(true)
			end
		end, { v9, v10 })
	end

	local createElement = React.createElement
	local view = Foundation.View

	local v18 = if joined.maxSize then joined.maxSize else nil
	local v16 = {
		tag = "auto-xy",
		sizeConstraint = { MaxSize = v18 },
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		selectionGroup = {
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop
		},
		onStateChanged = v14,
		ref = 0
	}

	local v19 = if getFFlagSongbirdPopoverSubmenu() then v8 else nil
	v16.ref = v19

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v22 = {
		CollapsibleTitleBar = React.createElement(CollapsibleFrame, {
			isCollapsed = not state,
			LayoutOrder = nextOrder()
		}, {
			TitleBar = React.createElement(
				Foundation.View,
				{ tag = "size-full-0 auto-y row flex-between items-center" },
				{
					Actions = React.createElement(
						Foundation.View,
						{
							tag = "auto-xy row",
							LayoutOrder = nextOrder(),
							onAbsoluteSizeChanged = v15
						},
						{
							CloseButton = React.createElement(Foundation.IconButton, {
								icon = Foundation.Enums.IconName.X,
								layoutOrder = nextOrder(),
								size = Foundation.Enums.IconSize.Medium,
								onActivated = v13,
								ref = v7
							})
						}
					),
					CenterAlignedTitle = React.createElement(
						Foundation.View,
						{ tag = "size-full-0 shrink auto-y", LayoutOrder = nextOrder() },
						{
							Title = React.createElement(Foundation.Text, {
								tag = "size-full-0 text-title-medium content-emphasis",
								Text = joined.title,
								fontStyle = v6.Typography.TitleMedium,
								Position = UDim2.new(0, -state2.X / 2, 0, 0)
							})
						}
					)
				}
			)
		}),
		Divider = 0,
		Content = 0
	}

	local v23 = if state then React.createElement(Foundation.View, {
		backgroundStyle = v6.Color.Stroke.Emphasis,
		Size = UDim2.new(1, 0, 0, 1),
		LayoutOrder = nextOrder()
	}) else nil
	v22.Divider = v23

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local v24 = {
		tag = "size-full-0 auto-y row flex-between items-center padding-left-small padding-y-small",
		LayoutOrder = nextOrder()
	}
	local v25 = {
		Body = React.createElement(
			Foundation.View,
			{ tag = "size-full-0 auto-y shrink clip", LayoutOrder = nextOrder() },
			joined.children
		),
		Actions = 0
	}

	local createElement4 = React.createElement
	local view4 = Foundation.View
	local v26 = {
		tag = "auto-xy row flex-between items-center",
		LayoutOrder = nextOrder()
	}

	local v28 = if joined.actions then React.createElement(
		Foundation.View,
		{ tag = "row auto-xy", LayoutOrder = nextOrder() },
		joined.actions
	) else nil
	local v29

	if getFFlagSongbirdPopoverSubmenu() then
		if joined.menuItems and v9 ~= Responsive.Input.Directional then
			v29 = React.createElement(Foundation.IconButton, {
				icon = "icons/common/overflow",
				size = Foundation.Enums.IconSize.Medium,
				onActivated = joined.onToggleSubMenu,
				LayoutOrder = nextOrder()
			})
		end
	elseif joined.submenu and v9 ~= Responsive.Input.Directional then
		v29 = React.createElement(Foundation.IconButton, {
			icon = "icons/common/overflow",
			size = Foundation.Enums.IconSize.Medium,
			onActivated = joined.onToggleSubMenu,
			LayoutOrder = nextOrder(),
			ref = joined.overflowButtonRef
		})
	end

	v25.Actions = createElement4(view4, v26, {
		CustomActions = v28,
		OverflowButton = v29
	})
	v22.Content = createElement3(view3, v24, v25)
	local v20 = {
		WindowFrame = createElement2(
			view2,
			{
				tag = "size-full-0 auto-y bg-over-media-100 radius-medium col gap-xxsmall stroke-emphasis"
			},
			v22
		),
		SubMenu = 0,
		OverflowMenu = 0
	}
	local v30

	if not (getFFlagSongbirdPopoverSubmenu() or not (joined.submenu and joined.isSubMenuOpen)) then
		local createElement5 = React.createElement
		local view5 = Foundation.View

		local v32 = if v11 then UDim2.fromScale(1, 0) + UDim2.fromOffset(v6.Gap.Small, 0) else UDim2.new(
			1,
			-constants.SUBMENU_WIDTH - constants.ICON_BUTTON_WIDTH / 2,
			1,
			0
		) + UDim2.fromOffset(v6.Gap.Small / 2, v6.Gap.Small)
		v30 = createElement5(
			view5,
			{
				tag = "auto-xy bg-over-media-200 radius-medium padding-small",
				Position = v32
			},
			joined.submenu
		)
	end

	v20.SubMenu = v30

	local v31 = if getFFlagSongbirdPopoverSubmenu() and joined.menuItems then React.createElement(Foundation.Menu, {
		isOpen = joined.isSubMenuOpen,
		items = joined.menuItems,
		side = Foundation.Enums.PopoverSide.Right,
		align = Foundation.Enums.PopoverAlign.Center,
		anchorRef = v8,
		onPressedOutside = joined.onToggleSubMenu
	}) else nil
	v20.OverflowMenu = v31
	return createElement(view, v16, v20)
end

return ChromeWindowFrame
