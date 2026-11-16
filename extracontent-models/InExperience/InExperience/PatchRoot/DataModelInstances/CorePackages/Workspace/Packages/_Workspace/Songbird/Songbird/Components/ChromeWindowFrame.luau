local Songbird = script:FindFirstAncestor("Songbird")

local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

local Cryo = require(Songbird.Parent.Cryo)
local Foundation = require(Songbird.Parent.Foundation)
local React = require(Songbird.Parent.React)
local ReactUtils = require(Songbird.Parent.ReactUtils)
local Responsive = require(Songbird.Parent.Responsive)
local CollapsibleFrame = require(Songbird.Components.CollapsibleFrame)
local constants = require(Songbird.constants)

local getFFlagSongbirdPopoverSubmenu = require(Songbird.Flags.getFFlagSongbirdPopoverSubmenu)

local SharedFlags = require(Songbird.Parent.SharedFlags)
local GetFFlagChromeMusicWindowTopbarReappearsOnGamepad = SharedFlags.GetFFlagChromeMusicWindowTopbarReappearsOnGamepad

local createNextOrder = ReactUtils.createNextOrder
local usePrevious = ReactUtils.usePrevious
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState

local function useUnfocusKeybind(isFocused: boolean) -- 1 equivalent call inferred from this helper
	useEffect(function()
		if not isFocused then
			return nil
		end

		local function unfocus(_: string, p)
			if p ~= Enum.UserInputState.End then
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
end

local v = {
	autoCollapseSeconds = 3,
	isSubMenuOpen = false,
	isFocused = false,
	onToggleSubMenu = function() end
}

local function ChromeWindowFrame(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = Foundation.Hooks.useTokens()
	local ref = useRef(nil)
	local anchorRef = useRef(nil)

	local v3 = Responsive.useLastInput()
	local v4

	if GetFFlagChromeMusicWindowTopbarReappearsOnGamepad() then
		v4 = usePrevious(v3)
	else
		v4 = nil
	end

	local v5

	if
		getFFlagSongbirdPopoverSubmenu()
		or typeof(joined.overflowButtonRef) ~= "table"
		or not joined.overflowButtonRef.current
	then
		v5 = true
	else
		local v6 = joined.overflowButtonRef.current.AbsolutePosition + Vector2.new(v2.Gap.Small + constants.SUBMENU_WIDTH, 0)
		local screenGui = joined.overflowButtonRef.current:FindFirstAncestorOfClass("ScreenGui")
		v5 = v6.X < screenGui.AbsoluteSize.X
	end

	local nextOrder = createNextOrder()

	local v6 = useRef(nil)
	local state, setState = useState(true)

	local onActivated = useCallback(function()
		if joined.onClose then
			joined.onClose()
		end
	end, { joined.onClose })

	local onStateChanged = useCallback(function(p2)
		v6.current = nil
		setState(true)

		if p2 == Foundation.Enums.ControlState.Default then
			v6.current = os.time()
		end
	end, {})

	useEffect(function()
		if v3 ~= Responsive.Input.Pointer then
			return
		end

		if joined.autoCollapseSeconds and joined.autoCollapseSeconds > 0 then
			local heartbeatConnection = RunService.Heartbeat:Connect(function()
				if v6.current and os.time() - v6.current >= joined.autoCollapseSeconds then
					setState(false)
				end
			end)

			return function()
				heartbeatConnection:Disconnect()
			end
		end

		return nil
	end, { joined.autoCollapseSeconds, v3 })

	local state2, setState2 = useState(Vector2.new(1e999, 1e999))
	local onAbsoluteSizeChanged = useCallback(function(p2)
		setState2(p2.AbsoluteSize)
	end, {})

	useEffect(function()
		local current = anchorRef.current

		if not current then
			return nil
		end

		local function onSelectionChanged(_: boolean, _, descendant)
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
			GuiService.SelectedCoreObject = ref.current
		end
	end, { joined.isFocused })

	useUnfocusKeybind(joined.isFocused) -- inferred equivalent call

	if GetFFlagChromeMusicWindowTopbarReappearsOnGamepad() then
		useEffect(function()
			if v4 and v3 ~= v4 and v3 ~= Responsive.Input.Pointer then
				setState(true)
			end
		end, { v3, v4 })
	end

	local createElement = React.createElement
	local view = Foundation.View
	local maxSize

	if joined.maxSize then
		maxSize = joined.maxSize
	end

	local v7 = {
		tag = "auto-xy",
		sizeConstraint = { MaxSize = maxSize },
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		selectionGroup = {
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop
		},
		onStateChanged = onStateChanged,
		ref = 0
	}
	local ref2

	if getFFlagSongbirdPopoverSubmenu() then
		ref2 = anchorRef
	end

	v7.ref = ref2

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v8 = {
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
							onAbsoluteSizeChanged = onAbsoluteSizeChanged
						},
						{
							CloseButton = React.createElement(Foundation.IconButton, {
								icon = Foundation.Enums.IconName.X,
								layoutOrder = nextOrder(),
								size = Foundation.Enums.IconSize.Medium,
								onActivated = onActivated,
								ref = ref
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
								fontStyle = v2.Typography.TitleMedium,
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
	local divider

	if state then
		divider = React.createElement(Foundation.View, {
			backgroundStyle = v2.Color.Stroke.Emphasis,
			Size = UDim2.new(1, 0, 0, 1),
			LayoutOrder = nextOrder()
		})
	end

	v8.Divider = divider

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local v9 = {
		tag = "size-full-0 auto-y row flex-between items-center padding-left-small padding-y-small",
		LayoutOrder = nextOrder()
	}
	local v10 = {
		Body = React.createElement(
			Foundation.View,
			{ tag = "size-full-0 auto-y shrink clip", LayoutOrder = nextOrder() },
			joined.children
		),
		Actions = 0
	}

	local createElement4 = React.createElement
	local view4 = Foundation.View
	local v11 = { tag = "auto-xy row flex-between items-center", LayoutOrder = nextOrder() }
	local customActions

	if joined.actions then
		customActions = React.createElement(
			Foundation.View,
			{ tag = "row auto-xy", LayoutOrder = nextOrder() },
			joined.actions
		)
	end

	local overflowButton

	if getFFlagSongbirdPopoverSubmenu() then
		if joined.menuItems and v3 ~= Responsive.Input.Directional then
			overflowButton = React.createElement(Foundation.IconButton, {
				icon = "icons/common/overflow",
				size = Foundation.Enums.IconSize.Medium,
				onActivated = joined.onToggleSubMenu,
				LayoutOrder = nextOrder()
			})
		end
	elseif joined.submenu and v3 ~= Responsive.Input.Directional then
		overflowButton = React.createElement(Foundation.IconButton, {
			icon = "icons/common/overflow",
			size = Foundation.Enums.IconSize.Medium,
			onActivated = joined.onToggleSubMenu,
			LayoutOrder = nextOrder(),
			ref = joined.overflowButtonRef
		})
	end

	v10.Actions = createElement4(view4, v11, {
		CustomActions = customActions,
		OverflowButton = overflowButton
	})
	v8.Content = createElement3(view3, v9, v10)
	local v12 = {
		WindowFrame = createElement2(
			view2,
			{
				tag = "size-full-0 auto-y bg-over-media-100 radius-medium col gap-xxsmall stroke-emphasis"
			},
			v8
		),
		SubMenu = 0,
		OverflowMenu = 0
	}
	local subMenu

	if not (getFFlagSongbirdPopoverSubmenu() or not (joined.submenu and joined.isSubMenuOpen)) then
		local createElement5 = React.createElement
		local view5 = Foundation.View
		local position

		if v5 then
			position = UDim2.fromScale(1, 0) + UDim2.fromOffset(v2.Gap.Small, 0)
		else
			position = UDim2.new(1, -constants.SUBMENU_WIDTH - constants.ICON_BUTTON_WIDTH / 2, 1, 0) + UDim2.fromOffset(v2.Gap.Small / 2, v2.Gap.Small)
		end

		subMenu = createElement5(
			view5,
			{ tag = "auto-xy bg-over-media-200 radius-medium padding-small", Position = position },
			joined.submenu
		)
	end

	v12.SubMenu = subMenu
	local overflowMenu

	if getFFlagSongbirdPopoverSubmenu() and joined.menuItems then
		overflowMenu = React.createElement(Foundation.Menu, {
			isOpen = joined.isSubMenuOpen,
			items = joined.menuItems,
			side = Foundation.Enums.PopoverSide.Right,
			align = Foundation.Enums.PopoverAlign.Center,
			anchorRef = anchorRef,
			onPressedOutside = joined.onToggleSubMenu
		})
	end

	v12.OverflowMenu = overflowMenu
	return createElement(view, v7, v12)
end

return ChromeWindowFrame
