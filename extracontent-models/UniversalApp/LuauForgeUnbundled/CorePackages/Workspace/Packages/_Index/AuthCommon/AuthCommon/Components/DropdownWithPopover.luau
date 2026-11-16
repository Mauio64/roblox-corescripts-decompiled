local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/InputHandlers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactUtils").Hooks.RoactRodux.useSelector

local appFocusRoot = FocusNavigationUtils.AppFocusRoot
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local popover = Foundation.Popover
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide
local scrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local scrollView = Foundation.ScrollView
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View
local SideModalDropdownButton = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/SideModalDropdownButton")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/ReactFocusNavigation")

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function DropdownWithPopover(props)
	local v5 = useTokens()
	local v6 = useSelector(selectScreenSize)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState({})
	local state3, setState3 = React.useState(Vector2.new(0, 0))
	local state4, setState4 = React.useState(Vector2.new(0, 0))

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v7 = useLastInputMode() == "Focus"
	local v8 = ReactFocusNavigation.useFocusGuiObject()

	React.useEffect(function()
		if props.value == nil then
			setState2({})

			return
		end

		for i, cellData in ipairs(props.cellDatas) do
			if cellData.value == props.value then
				setState2(cellData)
				break
			end
		end
	end, { props.value, props.cellDatas })

	local v9 = React.useCallback(function()
		if v8 and v7 then
			v8(ref.current)
		end

		setState(false)
	end, { ref.current, v7, v8 })

	React.useEffect(function()
		if v8 and props.focusOnMount then
			v8(ref.current)
		end
	end, { ref.current, v8, props.focusOnMount })

	React.useEffect(function()
		if props.onDropdownOpened then
			props.onDropdownOpened(state)
		end
	end, { state, props.onDropdownOpened })

	local v10 = React.useMemo(function()
		local children = {}

		for i, cellData in ipairs(props.cellDatas) do
			local function onActivated()
				props.onChange(cellData.value)
				v9()
			end

			table.insert(children, React.createElement(view, {
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
				TextContainer = React.createElement(view, {
					tag = "size-full-0 auto-y"
				}, {
					Text = React.createElement(text, {
						Text = cellData.text,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = true,
						tag = "auto-xy"
					})
				})
			}))
		end

		return children
	end, { props.cellDatas, state2, props.onChange, v9 })

	local v11 = React.useCallback(function()
		setState(not state)
	end, { state })

	local createElement = React.createElement
	local v13 = {
		tag = "size-full-0 auto-y",
		ref = ref,
		onAbsoluteSizeChanged = function(p2)
			setState3(p2.AbsoluteSize)
		end,
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = React.createElement
	local root = popover.Root

	local createElement3 = React.createElement
	local anchor = popover.Anchor

	local createElement4 = React.createElement
	local v18 = {
		Size = UDim2.new(0, state3.X, 0, state3.Y)
	}

	local createElement5 = React.createElement

	local v22 = if state2.text and #state2.text > 0 then state2.text else not props.placeholder and "" or props.placeholder
	local children = {
		Anchor = createElement3(anchor, nil, createElement4(view, v18, {
			DropdownButton = createElement5(SideModalDropdownButton, {
				onActivated = v11,
				text = v22,
				isDropdownError = props.errorState,
				backgroundColorToken = props.backgroundColorToken,
				height = props.dropdownHeight,
				fixSizeToParent = props.fixSizeToParent
			})
		})),
		Content = 0
	}

	local createElement6 = React.createElement
	local content = popover.Content
	local v23 = {
		align = popoverAlign.Center,
		side = popoverSide.Bottom,
		hasArrow = false,
		selection = { Selectable = true }
	}

	local createElement7 = React.createElement

	local createElement8 = React.createElement

	local v30 = if state then focusNavigableSurfaceIdentifierEnum.ModerationOverlay else focusNavigableSurfaceIdentifierEnum.PopUp
	children.Content = createElement6(content, v23, {
		DropdownPopup = createElement7(view, { tag = "auto-xy" }, {
			AppFocusRoot = createElement8(appFocusRoot, {
				surfaceIdentifier = v30,
				isIsolated = state,
				customEventHandlers = {
					[focusNavigationEventNameEnum.NavigateBack] = {
						handler = InputHandlers.onRelease(v9)
					}
				}
			}, { React.createElement(scrollView, {
					Size = UDim2.new(
						0,
						math.min(v6.X, state4.X),
						0,
						(math.min(500, v6.Y - (props.topOffset or 0), state4.Y))
					),
					scroll = {
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(1, 0, 0, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y,
						scrollBarVisibility = scrollBarVisibility.Always
					},
					gradientHeight = 15
				}, {
					BaseMenu = React.createElement(view, {
						Size = UDim2.new(0, state3.X + v5.Stroke.Standard * 2, 0, 0),
						onAbsoluteSizeChanged = function(p2)
							setState4(p2.AbsoluteSize)
						end,
						tag = "auto-y col align-y-center gap-xsmall padding-xsmall",
						ref = ref2
					}, v10)
				}) })
		})
	})
	return createElement(view, v13, {
		Popover = createElement2(root, { isOpen = state }, children)
	})
end

return React.memo(DropdownWithPopover)
