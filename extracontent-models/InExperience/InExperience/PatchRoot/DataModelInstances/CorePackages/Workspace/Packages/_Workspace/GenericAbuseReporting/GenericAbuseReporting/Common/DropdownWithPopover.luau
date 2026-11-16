local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local CoreGui = game:GetService("CoreGui")

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local UIBlox = require(parent.UIBlox)

local AppFocusRoot = FocusNavigationUtils.AppFocusRoot
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local OverlayProvider = Foundation.OverlayProvider
local Popover = Foundation.Popover
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ScrollView = Foundation.ScrollView
local Text = Foundation.Text
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View

local SideModalDropdownButton = require(GenericAbuseReporting.Common.SideModalDropdownButton)
local useScrollbarOffset = require(GenericAbuseReporting.Common.useScrollbarOffset)

local function DropdownWithPopover(props)
	local v = useLayerCollector()
	local v2 = useTokens()
	local absoluteSize = v.absoluteSize
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState({})
	local state3, setState3 = React.useState(Vector2.new(0, 0))
	local state4, setState4 = React.useState(Vector2.new(0, 0))
	local state5, setState5 = React.useState(Vector2.new(0, 0))
	local state6, setState6 = React.useState(Vector2.new(0, 0))
	local v3 = useScrollbarOffset(state5, state6)

	local v4 = ReactFocusNavigation.useFocusGuiObject()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local vrCentralOverlay = CoreGui:FindFirstChild("VRCentralOverlay")
	local centralOverlay_SurfaceGui

	if vrCentralOverlay then
		centralOverlay_SurfaceGui = vrCentralOverlay:FindFirstChild("CentralOverlay_SurfaceGui")
	else
		centralOverlay_SurfaceGui = nil
	end

	local onPressedOutside = React.useCallback(function()
		if not centralOverlay_SurfaceGui then
			v4(ref.current)
		end

		setState(false)
	end, { ref.current, v4, centralOverlay_SurfaceGui })

	local v5 = React.useMemo(function()
		local children = {}

		for _, cellData in ipairs(props.cellDatas) do
			local function onActivated()
				local onChange = props.onChange
				local v5

				if cellData.value == nil then
					v5 = cellData.text
				else
					v5 = cellData.value
				end

				onChange(v5)
				setState2(cellData)
				onPressedOutside()
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
	end, { props.cellDatas, state2, props.onChange, onPressedOutside })

	local onActivated = React.useCallback(function()
		setState(not state)
	end, { state })

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v6 = {
		tag = "size-full-0 auto-y",
		ref = ref,
		onAbsoluteSizeChanged = function(p)
			setState3(p.AbsoluteSize)
		end,
		LayoutOrder = props.layoutOrder
	}

	local createElement3 = React.createElement
	local root = Popover.Root

	local createElement4 = React.createElement
	local anchor = Popover.Anchor

	local createElement5 = React.createElement
	local v7 = {
		Size = UDim2.new(0, state3.X, 0, state3.Y)
	}

	local createElement6 = React.createElement
	local text

	if state2.text and #state2.text > 0 then
		text = state2.text
	else
		text = props.placeholder
	end

	local children = {
		Anchor = createElement4(anchor, nil, createElement5(View, v7, {
			DropdownButton = createElement6(SideModalDropdownButton, {
				onActivated = onActivated,
				text = text,
				isDropdownError = props.errorState
			})
		})),
		Content = 0
	}

	local createElement7 = React.createElement
	local content = Popover.Content
	local v8 = {
		align = PopoverAlign.Center,
		side = PopoverSide.Bottom,
		hasArrow = false,
		onPressedOutside = onPressedOutside,
		selection = { Selectable = true }
	}

	local createElement8 = React.createElement

	local createElement9 = React.createElement
	local surfaceIdentifier

	if state then
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ModerationOverlay
	else
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
	end

	children.Content = createElement7(content, v8, {
		DropdownPopup = createElement8(View, { tag = "auto-xy" }, {
			AppFocusRoot = createElement9(AppFocusRoot, {
				surfaceIdentifier = surfaceIdentifier,
				isIsolated = state,
				customEventHandlers = {
					[FocusNavigationEventNameEnum.NavigateBack] = {
						handler = InputHandlers.onRelease(onPressedOutside)
					}
				}
			}, { React.createElement(ScrollView, {
					Size = UDim2.new(
						0,
						math.min(absoluteSize.X, state4.X + v3),
						0,
						(math.min(absoluteSize.Y, state4.Y))
					),
					scroll = {
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(1, 0, 0, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y,
						scrollBarVisibility = ScrollBarVisibility.Always
					},
					onAbsoluteCanvasSizeChanged = function(p)
						setState5(p.AbsoluteCanvasSize)
					end,
					onAbsoluteWindowSizeChanged = function(p)
						setState6(p.AbsoluteWindowSize)
					end,
					gradientHeight = 15
				}, {
					BaseMenu = React.createElement(View, {
						Size = UDim2.new(0, state3.X + v2.Stroke.Standard * 2, 0, 0),
						onAbsoluteSizeChanged = function(p)
							setState4(p.AbsoluteSize)
						end,
						tag = "auto-y col align-y-center gap-xsmall padding-xsmall",
						ref = ref2
					}, v5)
				}) })
		})
	})
	return createElement(OverlayProvider, { gui = centralOverlay_SurfaceGui }, {
		DropdownWithPopover = createElement2(View, v6, {
			Popover = createElement3(root, { isOpen = state }, children)
		})
	})
end

return React.memo(DropdownWithPopover)
