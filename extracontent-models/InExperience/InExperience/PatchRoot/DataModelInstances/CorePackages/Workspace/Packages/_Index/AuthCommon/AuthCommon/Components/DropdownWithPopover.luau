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
local FFlagUseBirthdayDropdownForGamepad = require(AuthCommonParent.SharedFlags).FFlagUseBirthdayDropdownForGamepad

local function selectScreenSize(p1) -- line: 54
	return p1.ScreenSize
end
local function DropdownWithPopover(t1: {[any]: any}) -- line: 58
	-- upvalues: useTokens (copy), useSelector (copy), selectScreenSize (copy), React (copy), FFlagUseBirthdayDropdownForGamepad (copy), useLastInputMode (copy), ReactFocusNavigation (copy), View (copy), FoundationText (copy), Popover (copy), SideModalDropdownButton (copy), PopoverAlign (copy), PopoverSide (copy), AppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), ScrollView (copy), ScrollBarVisibility (copy)
	local v27 = useTokens()
	local v28 = useSelector(selectScreenSize)
	local v29, v30 = React.useState(false)
	local v31, v32 = React.useState({})
	local v33, v34 = React.useState(Vector2.new(0, 0))
	local v35, v36 = React.useState(Vector2.new(0, 0))
	local v37 = React.useRef(nil)
	local v38 = React.useRef(nil)
	local v39 = if not FFlagUseBirthdayDropdownForGamepad then nil else useLastInputMode() == "Focus"
	local v40 = if not FFlagUseBirthdayDropdownForGamepad then nil else ReactFocusNavigation.useFocusGuiObject()

	React.useEffect(function() -- line: 72
		-- upvalues: t1 (copy), v32 (copy)
		if t1.value ~= nil then
			for _, v in ipairs(t1.cellDatas) do
				if v.value == t1.value then
					v32(v)

					return
				end
			end

			return
		end

		v32({})
	end, {
		t1.value,
		t1.cellDatas
	})

	local v41 = React.useCallback(function() -- line: 86
		-- upvalues: FFlagUseBirthdayDropdownForGamepad (copy), v40 (copy), v39 (copy), v37 (copy), v30 (copy)
		if FFlagUseBirthdayDropdownForGamepad and (v40 and v39) then
			v40(v37.current)
		end

		v30(false)
	end, {
		v37.current,
		v39
	})

	React.useEffect(function() -- line: 93
		-- upvalues: FFlagUseBirthdayDropdownForGamepad (copy), v40 (copy), t1 (copy), v37 (copy)
		if FFlagUseBirthdayDropdownForGamepad and (v40 and t1.focusOnMount) then
			v40(v37.current)
		end
	end, { v37.current })
	React.useEffect(function() -- line: 99
		-- upvalues: t1 (copy), v29 (copy)
		if t1.onDropdownOpened then
			t1.onDropdownOpened(v29)
		end
	end, { v29 })

	local v42 = React.useMemo(function() -- line: 106
		-- upvalues: t1 (copy), v41 (copy), React (copy), View (copy), v31 (copy), FoundationText (copy)
		local t2 = {}

		for _, v in ipairs(t1.cellDatas) do
			table.insert(t2, React.createElement(View, {
				onActivated = function() -- line: 109
					-- upvalues: t1 (copy), v (copy), v41 (copy)
					t1.onChange(v.value)
					v41()
				end,
				selection = {
					Selectable = true
				},
				tag = {
					["size-full-0"] = true,
					["auto-y"] = true,
					["padding-small"] = true,
					["radius-medium"] = true,
					["bg-shift-200"] = v == v31
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
		v31,
		t1.onChange,
		v41
	})
	local v43 = React.useCallback(function() -- line: 147
		-- upvalues: v30 (copy), v29 (copy)
		v30(not v29)
	end, { v29 })

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		ref = v37,
		onAbsoluteSizeChanged = function(p2) -- line: 154
			-- upvalues: v34 (copy)
			v34(p2.AbsoluteSize)
		end,
		LayoutOrder = t1.layoutOrder
	}, {
		Popover = React.createElement(Popover.Root, {
			isOpen = v29
		}, {
			Anchor = React.createElement(Popover.Anchor, nil, React.createElement(View, {
				Size = UDim2.new(0, v33.X, 0, v33.Y)
			}, {
				DropdownButton = React.createElement(SideModalDropdownButton, {
					onActivated = v43,
					text = if not v31.text or not (#v31.text > 0) then not t1.placeholder and "" or t1.placeholder else v31.text,
					isDropdownError = t1.errorState,
					backgroundColorToken = if not FFlagUseBirthdayDropdownForGamepad then nil else t1.backgroundColorToken,
					height = if not FFlagUseBirthdayDropdownForGamepad then nil else t1.dropdownHeight,
					fixSizeToParent = if not FFlagUseBirthdayDropdownForGamepad then nil else t1.fixSizeToParent
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
						surfaceIdentifier = if not v29 then FocusNavigableSurfaceIdentifierEnum.PopUp else FocusNavigableSurfaceIdentifierEnum.ModerationOverlay,
						isIsolated = v29,
						customEventHandlers = {
							[FocusNavigationEventNameEnum.NavigateBack] = {
								handler = InputHandlers.onRelease(v41)
							}
						}
					}, { React.createElement(ScrollView, {
						gradientHeight = 15,
						Size = UDim2.new(0, math.min(v28.X, v35.X), 0, (math.min(500, v28.Y - (t1.topOffset or 0), v35.Y))),
						scroll = {
							AutomaticCanvasSize = Enum.AutomaticSize.Y,
							CanvasSize = UDim2.new(1, 0, 0, 0),
							ScrollingDirection = Enum.ScrollingDirection.Y,
							scrollBarVisibility = ScrollBarVisibility.Always
						}
					}, {
						BaseMenu = React.createElement(View, {
							tag = "auto-y col align-y-center gap-xsmall padding-xsmall",
							Size = UDim2.new(0, v33.X + v27.Stroke.Standard * 2, 0, 0),
							onAbsoluteSizeChanged = function(p3) -- line: 231
								-- upvalues: v36 (copy)
								v36(p3.AbsoluteSize)
							end,
							ref = v38
						}, v42)
					}) })
				})
			})
		})
	})
end

return React.memo(DropdownWithPopover)
