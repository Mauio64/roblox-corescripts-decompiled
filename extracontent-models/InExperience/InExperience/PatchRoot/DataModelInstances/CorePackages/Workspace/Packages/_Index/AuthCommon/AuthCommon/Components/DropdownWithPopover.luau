local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local FocusNavigationUtils = require(AuthCommonParent.FocusNavigationUtils)
local Foundation = require(AuthCommonParent.Foundation)
local InputHandlers = require(AuthCommonParent.InputHandlers)
local React = require(AuthCommonParent.React)
local useSelector = require(AuthCommonParent.RoactUtils).Hooks.RoactRodux.useSelector
local AppFocusRoot = FocusNavigationUtils.AppFocusRoot
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local Popover = Foundation.Popover
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ScrollView = Foundation.ScrollView
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local SideModalDropdownButton = require(AuthCommon.Components.SideModalDropdownButton)
local ReactFocusNavigation = require(AuthCommonParent.ReactFocusNavigation)

local function selectScreenSize(p1) -- line: 52
	return p1.ScreenSize
end
local function DropdownWithPopover(t1: {[any]: any}) -- line: 56
	-- upvalues: useTokens (copy), useSelector (copy), selectScreenSize (copy), React (copy), useLastInputMode (copy), ReactFocusNavigation (copy), View (copy), FoundationText (copy), Popover (copy), SideModalDropdownButton (copy), PopoverAlign (copy), PopoverSide (copy), AppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), ScrollView (copy), ScrollBarVisibility (copy)
	local v26 = useTokens()
	local v27 = useSelector(selectScreenSize)
	local v28, v29 = React.useState(false)
	local v30, v31 = React.useState({})
	local v32, v33 = React.useState(Vector2.new(0, 0))
	local v34, v35 = React.useState(Vector2.new(0, 0))
	local v36 = React.useRef(nil)
	local v37 = React.useRef(nil)
	local v38 = useLastInputMode() == "Focus"
	local v39 = ReactFocusNavigation.useFocusGuiObject()

	React.useEffect(function() -- line: 70
		-- upvalues: t1 (copy), v31 (copy)
		if t1.value ~= nil then
			for _, v in ipairs(t1.cellDatas) do
				if v.value == t1.value then
					v31(v)

					return
				end
			end

			return
		end

		v31({})
	end, {
		t1.value,
		t1.cellDatas
	})

	local v40 = React.useCallback(function() -- line: 84
		-- upvalues: v39 (copy), v38 (copy), v36 (copy), v29 (copy)
		if v39 and v38 then
			v39(v36.current)
		end

		v29(false)
	end, {
		v36.current,
		v38,
		v39
	})

	React.useEffect(function() -- line: 91
		-- upvalues: v39 (copy), t1 (copy), v36 (copy)
		if v39 and t1.focusOnMount then
			v39(v36.current)
		end
	end, {
		v36.current,
		v39,
		t1.focusOnMount
	})
	React.useEffect(function() -- line: 97
		-- upvalues: t1 (copy), v28 (copy)
		if t1.onDropdownOpened then
			t1.onDropdownOpened(v28)
		end
	end, {
		v28,
		t1.onDropdownOpened
	})

	local v41 = React.useMemo(function() -- line: 104
		-- upvalues: t1 (copy), v40 (copy), React (copy), View (copy), v30 (copy), FoundationText (copy)
		local t2 = {}

		for _, v in ipairs(t1.cellDatas) do
			table.insert(t2, React.createElement(View, {
				onActivated = function() -- line: 107
					-- upvalues: t1 (copy), v (copy), v40 (copy)
					t1.onChange(v.value)
					v40()
				end,
				selection = {
					Selectable = true
				},
				tag = {
					["size-full-0"] = true,
					["auto-y"] = true,
					["padding-small"] = true,
					["radius-medium"] = true,
					["bg-shift-200"] = v == v30
				}
			}, {
				TextContainer = React.createElement(View, {
					tag = "size-full-0 auto-y"
				}, {
					Text = React.createElement(FoundationText, {
						TextWrapped = true,
						tag = "auto-xy",
						Text = v.text,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				})
			}))
		end

		return t2
	end, {
		t1.cellDatas,
		v30,
		t1.onChange,
		v40
	})
	local v42 = React.useCallback(function() -- line: 145
		-- upvalues: v29 (copy), v28 (copy)
		v29(not v28)
	end, { v28 })

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		ref = v36,
		onAbsoluteSizeChanged = function(p2) -- line: 152
			-- upvalues: v33 (copy)
			v33(p2.AbsoluteSize)
		end,
		LayoutOrder = t1.layoutOrder
	}, {
		Popover = React.createElement(Popover.Root, {
			isOpen = v28
		}, {
			Anchor = React.createElement(Popover.Anchor, nil, React.createElement(View, {
				Size = UDim2.new(0, v32.X, 0, v32.Y)
			}, {
				DropdownButton = React.createElement(SideModalDropdownButton, {
					onActivated = v42,
					text = if not v30.text or not (#v30.text > 0) then not t1.placeholder and "" or t1.placeholder else v30.text,
					isDropdownError = t1.errorState,
					backgroundColorToken = t1.backgroundColorToken,
					height = t1.dropdownHeight,
					fixSizeToParent = t1.fixSizeToParent
				})
			})),
			Content = React.createElement(Popover.Content, {
				hasArrow = false,
				align = PopoverAlign.Center,
				side = PopoverSide.Bottom,
				selection = {
					Selectable = true
				}
			}, {
				DropdownPopup = React.createElement(View, {
					tag = "auto-xy"
				}, {
					AppFocusRoot = React.createElement(AppFocusRoot, {
						surfaceIdentifier = if not v28 then FocusNavigableSurfaceIdentifierEnum.PopUp else FocusNavigableSurfaceIdentifierEnum.ModerationOverlay,
						isIsolated = v28,
						customEventHandlers = {
							[FocusNavigationEventNameEnum.NavigateBack] = {
								handler = InputHandlers.onRelease(v40)
							}
						}
					}, { React.createElement(ScrollView, {
						gradientHeight = 15,
						Size = UDim2.new(0, math.min(v27.X, v34.X), 0, (math.min(500, v27.Y - (t1.topOffset or 0), v34.Y))),
						scroll = {
							AutomaticCanvasSize = Enum.AutomaticSize.Y,
							CanvasSize = UDim2.new(1, 0, 0, 0),
							ScrollingDirection = Enum.ScrollingDirection.Y,
							scrollBarVisibility = ScrollBarVisibility.Always
						}
					}, {
						BaseMenu = React.createElement(View, {
							tag = "auto-y col align-y-center gap-xsmall padding-xsmall",
							Size = UDim2.new(0, v32.X + v26.Stroke.Standard * 2, 0, 0),
							onAbsoluteSizeChanged = function(p3) -- line: 227
								-- upvalues: v35 (copy)
								v35(p3.AbsoluteSize)
							end,
							ref = v37
						}, v41)
					}) })
				})
			})
		})
	})
end

return React.memo(DropdownWithPopover)
