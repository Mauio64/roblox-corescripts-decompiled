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
local GetFFlagChromeMusicWindowTopbarReappearsOnGamepad = require(Songbird.Parent.SharedFlags).GetFFlagChromeMusicWindowTopbarReappearsOnGamepad
local createNextOrder = ReactUtils.createNextOrder
local usePrevious = ReactUtils.usePrevious
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState

local function useUnfocusKeybind(b1: boolean) -- line: 28
	-- upvalues: useEffect (copy), GuiService (copy), ContextActionService (copy)
	useEffect(function() -- line: 29
		-- upvalues: b1 (copy), GuiService (copy), ContextActionService (copy)
		if b1 then
			local function unfocus(_: string, p1) -- line: 31
				-- upvalues: GuiService (copy)
				if p1 == Enum.UserInputState.End then
					GuiService.SelectedCoreObject = nil

					return Enum.ContextActionResult.Sink
				end

				return Enum.ContextActionResult.Pass
			end

			ContextActionService:BindCoreAction("UnfocusMusicWindow", unfocus, false, Enum.KeyCode.ButtonB)

			return function() -- line: 42
				-- upvalues: ContextActionService (copy)
				ContextActionService:UnbindCoreAction("UnfocusMusicWindow")
			end
		end

		return nil
	end, { b1 })
end

local t1 = {
	autoCollapseSeconds = 3,
	isSubMenuOpen = false,
	isFocused = false,
	onToggleSubMenu = function() -- line: 70
	end
}

local function ChromeWindowFrame(t2: {[any]: any}) -- line: 75
	-- upvalues: Cryo (copy), t1 (copy), Foundation (copy), useRef (copy), Responsive (copy), GetFFlagChromeMusicWindowTopbarReappearsOnGamepad (copy), usePrevious (copy), getFFlagSongbirdPopoverSubmenu (copy), constants (copy), createNextOrder (copy), useState (copy), useCallback (copy), useEffect (copy), RunService (copy), GuiService (copy), ContextActionService (copy), React (copy), CollapsibleFrame (copy)
	local v25 = Cryo.Dictionary.join(t1, t2)
	local v26 = Foundation.Hooks.useTokens()
	local v27 = useRef(nil)
	local v28 = useRef(nil)
	local v29 = Responsive.useLastInput()
	local v30 = if not GetFFlagChromeMusicWindowTopbarReappearsOnGamepad() then nil else usePrevious(v29)
	local v31 = true

	if not getFFlagSongbirdPopoverSubmenu() and (typeof(v25.overflowButtonRef) == "table" and v25.overflowButtonRef.current) then
		local v32 = v25.overflowButtonRef.current.AbsolutePosition + Vector2.new(v26.Gap.Small + constants.SUBMENU_WIDTH, 0)
		local ScreenGui = v25.overflowButtonRef.current:FindFirstAncestorOfClass("ScreenGui")

		v31 = v32.X < ScreenGui.AbsoluteSize.X
	end

	local v34 = createNextOrder()
	local v35 = useRef(nil)
	local v36, v37 = useState(true)
	local v38 = useCallback(function() -- line: 101
		-- upvalues: v25 (copy)
		if v25.onClose then
			v25.onClose()
		end
	end, { v25.onClose })
	local v39 = useCallback(function(p2) -- line: 108
		-- upvalues: v35 (copy), v37 (copy), Foundation (copy)
		v35.current = nil
		v37(true)

		if p2 == Foundation.Enums.ControlState.Default then
			v35.current = os.time()
		end
	end, {})

	useEffect(function() -- line: 124
		-- upvalues: v29 (copy), Responsive (copy), v25 (copy), RunService (copy), v35 (copy), v37 (copy)
		if v29 ~= Responsive.Input.Pointer then
			return
		end

		if v25.autoCollapseSeconds and v25.autoCollapseSeconds > 0 then
			local connection = RunService.Heartbeat:Connect(function() -- line: 132
				-- upvalues: v35 (copy), v25 (copy), v37 (copy)
				if v35.current and os.time() - v35.current >= v25.autoCollapseSeconds then
					v37(false)
				end
			end)

			return function() -- line: 140
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end

		return nil
	end, {
		v25.autoCollapseSeconds,
		v29
	})

	local v40, v41 = useState(Vector2.new(1e999, 1e999))
	local v42 = useCallback(function(p3) -- line: 148
		-- upvalues: v41 (copy)
		v41(p3.AbsoluteSize)
	end, {})

	useEffect(function() -- line: 152
		-- upvalues: v28 (copy), v25 (copy)
		local current = v28.current

		if current then
			local function onSelectionChanged(_: boolean, _, p5) -- line: 156
				-- upvalues: current (copy), v25 (copy)
				if not current:IsAncestorOf(p5) and v25.onUnfocus then
					v25.onUnfocus()
				end
			end

			local connection = current.SelectionChanged:Connect(onSelectionChanged)

			return function() -- line: 166
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end

		return nil
	end, { v25.onUnfocus })
	useEffect(function() -- line: 173
		-- upvalues: v25 (copy), GuiService (copy), v27 (copy)
		if v25.isFocused then
			GuiService.SelectedCoreObject = v27.current
		end
	end, { v25.isFocused })

	local isFocused = v25.isFocused

	useEffect(function() -- line: 29
		-- upvalues: isFocused (copy), GuiService (copy), ContextActionService (copy)
		if isFocused then
			local function unfocus(_: string, p6) -- line: 31
				-- upvalues: GuiService (copy)
				if p6 == Enum.UserInputState.End then
					GuiService.SelectedCoreObject = nil

					return Enum.ContextActionResult.Sink
				end

				return Enum.ContextActionResult.Pass
			end

			ContextActionService:BindCoreAction("UnfocusMusicWindow", unfocus, false, Enum.KeyCode.ButtonB)

			return function() -- line: 42
				-- upvalues: ContextActionService (copy)
				ContextActionService:UnbindCoreAction("UnfocusMusicWindow")
			end
		end

		return nil
	end, { isFocused })

	if GetFFlagChromeMusicWindowTopbarReappearsOnGamepad() then
		useEffect(function() -- line: 185
			-- upvalues: v30 (copy), v29 (copy), Responsive (copy), v37 (copy)
			if v30 and (v29 ~= v30 and v29 ~= Responsive.Input.Pointer) then
				v37(true)
			end
		end, {
			v29,
			v30
		})
	end

	return React.createElement(Foundation.View, {
		tag = "auto-xy",
		sizeConstraint = {
			MaxSize = if not v25.maxSize then nil else v25.maxSize
		},
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		selectionGroup = {
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop
		},
		onStateChanged = v39,
		ref = if not getFFlagSongbirdPopoverSubmenu() then nil else v28
	}, {
		WindowFrame = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y bg-over-media-100 radius-medium col gap-xxsmall stroke-emphasis"
		}, {
			CollapsibleTitleBar = React.createElement(CollapsibleFrame, {
				isCollapsed = not v36,
				LayoutOrder = v34()
			}, {
				TitleBar = React.createElement(Foundation.View, {
					tag = "size-full-0 auto-y row flex-between items-center"
				}, {
					Actions = React.createElement(Foundation.View, {
						tag = "auto-xy row",
						LayoutOrder = v34(),
						onAbsoluteSizeChanged = v42
					}, {
						CloseButton = React.createElement(Foundation.IconButton, {
							icon = Foundation.Enums.IconName.X,
							layoutOrder = v34(),
							size = Foundation.Enums.IconSize.Medium,
							onActivated = v38,
							ref = v27
						})
					}),
					CenterAlignedTitle = React.createElement(Foundation.View, {
						tag = "size-full-0 shrink auto-y",
						LayoutOrder = v34()
					}, {
						Title = React.createElement(Foundation.Text, {
							tag = "size-full-0 text-title-medium content-emphasis",
							Text = v25.title,
							fontStyle = v26.Typography.TitleMedium,
							Position = UDim2.new(0, -v40.X / 2, 0, 0)
						})
					})
				})
			}),
			Divider = if not v36 then nil else React.createElement(Foundation.View, {
				backgroundStyle = v26.Color.Stroke.Emphasis,
				Size = UDim2.new(1, 0, 0, 1),
				LayoutOrder = v34()
			}),
			Content = React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y row flex-between items-center padding-left-small padding-y-small",
				LayoutOrder = v34()
			}, {
				Body = React.createElement(Foundation.View, {
					tag = "size-full-0 auto-y shrink clip",
					LayoutOrder = v34()
				}, v25.children),
				Actions = React.createElement(Foundation.View, {
					tag = "auto-xy row flex-between items-center",
					LayoutOrder = v34()
				}, {
					CustomActions = if not v25.actions then nil else React.createElement(Foundation.View, {
						tag = "row auto-xy",
						LayoutOrder = v34()
					}, v25.actions),
					OverflowButton = if not getFFlagSongbirdPopoverSubmenu() then if not v25.submenu or v29 == Responsive.Input.Directional then nil else React.createElement(Foundation.IconButton, {
						icon = "icons/common/overflow",
						size = Foundation.Enums.IconSize.Medium,
						onActivated = v25.onToggleSubMenu,
						LayoutOrder = v34(),
						ref = v25.overflowButtonRef
					}) else if not v25.menuItems or v29 == Responsive.Input.Directional then nil else React.createElement(Foundation.IconButton, {
						icon = "icons/common/overflow",
						size = Foundation.Enums.IconSize.Medium,
						onActivated = v25.onToggleSubMenu,
						LayoutOrder = v34()
					})
				})
			})
		}),
		SubMenu = if not getFFlagSongbirdPopoverSubmenu() then if not v25.submenu or not v25.isSubMenuOpen then nil else React.createElement(Foundation.View, {
			tag = "auto-xy bg-over-media-200 radius-medium padding-small",
			Position = if not v31 then UDim2.new(1, -constants.SUBMENU_WIDTH - constants.ICON_BUTTON_WIDTH / 2, 1, 0) + UDim2.fromOffset(v26.Gap.Small / 2, v26.Gap.Small) else UDim2.fromScale(1, 0) + UDim2.fromOffset(v26.Gap.Small, 0)
		}, v25.submenu) else nil,
		OverflowMenu = if not getFFlagSongbirdPopoverSubmenu() or not v25.menuItems then nil else React.createElement(Foundation.Menu, {
			isOpen = v25.isSubMenuOpen,
			items = v25.menuItems,
			side = Foundation.Enums.PopoverSide.Right,
			align = Foundation.Enums.PopoverAlign.Center,
			anchorRef = v28,
			onPressedOutside = v25.onToggleSubMenu
		})
	})
end

return ChromeWindowFrame
