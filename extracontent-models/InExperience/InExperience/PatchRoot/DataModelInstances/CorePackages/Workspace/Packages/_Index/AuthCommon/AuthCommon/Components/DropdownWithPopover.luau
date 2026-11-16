local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local AppFocusRoot = FocusNavigationUtils.AppFocusRoot
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local Popover = Foundation.Popover
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ScrollView = Foundation.ScrollView
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local SideModalDropdownButton = require(AuthCommon.Components.SideModalDropdownButton)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local function selectScreenSize(p)
	return p.ScreenSize
end

local function DropdownWithPopover(props)
	local v = useTokens()
	local v2 = useSelector(selectScreenSize)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState({})
	local state3, setState3 = React.useState(Vector2.new(0, 0))
	local state4, setState4 = React.useState(Vector2.new(0, 0))

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v3 = useLastInputMode() == "Focus"
	local v4 = ReactFocusNavigation.useFocusGuiObject()

	React.useEffect(function()
		if props.value == nil then
			setState2({})

			return
		end

		for _, cellData in ipairs(props.cellDatas) do
			if cellData.value == props.value then
				setState2(cellData)
				break
			end
		end
	end, { props.value, props.cellDatas })

	local v5 = React.useCallback(function()
		if v4 and v3 then
			v4(ref.current)
		end

		setState(false)
	end, { ref.current, v3, v4 })

	React.useEffect(function()
		if v4 and props.focusOnMount then
			v4(ref.current)
		end
	end, { ref.current, v4, props.focusOnMount })

	React.useEffect(function()
		if props.onDropdownOpened then
			props.onDropdownOpened(state)
		end
	end, { state, props.onDropdownOpened })

	local v6 = React.useMemo(function()
		local children = {}

		for _, cellData in ipairs(props.cellDatas) do
			local function onActivated()
				props.onChange(cellData.value)
				v5()
			end

			table.insert(children, React.createElement(View, {
				onActivated = onActivated,
				selection = { Selectable = true },
				tag = {
					["size-full-0"] = true,
					["auto-y"] = true,
					["padding-small"] = true,
					["radius-medium"] = true,
					["bg-shift-200"] = state2 == cellData
				}
			}, {
				TextContainer = React.createElement(View, { tag = "size-full-0 auto-y" }, {
					Text = React.createElement(Text, {
						Text = cellData.text,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = true,
						tag = "auto-xy"
					})
				})
			}))
		end

		return children
	end, { props.cellDatas, state2, props.onChange, v5 })

	local onActivated = React.useCallback(function()
		setState(not state)
	end, { state })

	local createElement = React.createElement
	local v7 = {
		tag = "size-full-0 auto-y",
		ref = ref,
		onAbsoluteSizeChanged = function(p)
			setState3(p.AbsoluteSize)
		end,
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = React.createElement
	local root = Popover.Root

	local createElement3 = React.createElement
	local anchor = Popover.Anchor

	local createElement4 = React.createElement
	local v8 = {
		Size = UDim2.new(0, state3.X, 0, state3.Y)
	}

	local createElement5 = React.createElement
	local text

	if state2.text and #state2.text > 0 then
		text = state2.text
	else
		text = not props.placeholder and "" or props.placeholder
	end

	local children = {
		Anchor = createElement3(anchor, nil, createElement4(View, v8, {
			DropdownButton = createElement5(SideModalDropdownButton, {
				onActivated = onActivated,
				text = text,
				isDropdownError = props.errorState,
				backgroundColorToken = props.backgroundColorToken,
				height = props.dropdownHeight,
				fixSizeToParent = props.fixSizeToParent
			})
		})),
		Content = 0
	}

	local createElement6 = React.createElement
	local content = Popover.Content
	local v9 = {
		align = PopoverAlign.Center,
		side = PopoverSide.Bottom,
		hasArrow = false,
		selection = { Selectable = true }
	}

	local createElement7 = React.createElement

	local createElement8 = React.createElement
	local surfaceIdentifier

	if state then
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ModerationOverlay
	else
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
	end

	children.Content = createElement6(content, v9, {
		DropdownPopup = createElement7(View, { tag = "auto-xy" }, {
			AppFocusRoot = createElement8(AppFocusRoot, {
				surfaceIdentifier = surfaceIdentifier,
				isIsolated = state,
				customEventHandlers = {
					[FocusNavigationEventNameEnum.NavigateBack] = {
						handler = InputHandlers.onRelease(v5)
					}
				}
			}, { React.createElement(ScrollView, {
					Size = UDim2.new(
						0,
						math.min(v2.X, state4.X),
						0,
						(math.min(500, v2.Y - (props.topOffset or 0), state4.Y))
					),
					scroll = {
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(1, 0, 0, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y,
						scrollBarVisibility = ScrollBarVisibility.Always
					},
					gradientHeight = 15
				}, {
					BaseMenu = React.createElement(View, {
						Size = UDim2.new(0, state3.X + v.Stroke.Standard * 2, 0, 0),
						onAbsoluteSizeChanged = function(p)
							setState4(p.AbsoluteSize)
						end,
						tag = "auto-y col align-y-center gap-xsmall padding-xsmall",
						ref = ref2
					}, v6)
				}) })
		})
	})
	return createElement(View, v7, {
		Popover = createElement2(root, { isOpen = state }, children)
	})
end

return React.memo(DropdownWithPopover)
