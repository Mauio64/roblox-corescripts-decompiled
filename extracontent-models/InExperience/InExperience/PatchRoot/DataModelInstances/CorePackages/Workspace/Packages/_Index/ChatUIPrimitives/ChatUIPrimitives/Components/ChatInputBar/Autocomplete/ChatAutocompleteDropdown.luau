local Parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useMenuItemCursor = require(script.Parent.useMenuItemCursor)
local v5 = game:DefineFastInt("ChatAutocompleteMaxVisibleEntries", 3)

local function ChatAutocompleteDropdown(t1: {[any]: any}) -- line: 38
	-- upvalues: Foundation (copy), useMenuItemCursor (copy), React (copy), v5 (copy)
	local v8 = Foundation.Hooks.useTokens()
	local v9 = useMenuItemCursor()
	local v10 = React.useRef(nil)
	local v11, v12 = React.useState(0)

	React.useEffect(function() -- line: 45
		-- upvalues: t1 (copy), v12 (copy)
		local current = t1.anchorRef.current

		if not current or not current:IsA("GuiObject") then
			return
		end

		v12(current.AbsoluteSize.X)

		local connection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 51
			-- upvalues: v12 (copy), current (copy)
			v12(current.AbsoluteSize.X)
		end)

		return function() -- line: 54
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { t1.anchorRef })

	local XXSmall = v8.Padding.XXSmall

	React.useEffect(function() -- line: 65
		-- upvalues: v10 (copy), t1 (copy), XXSmall (copy)
		local current = v10.current

		if not current or (not t1.isOpen or t1.keyboardIndex < 1) then
			return
		end

		local v23 = (t1.keyboardIndex - 1) * (40 + XXSmall)
		local v24 = v23 + 40
		local AbsoluteWindowSizeY = current.AbsoluteWindowSize.Y
		local CanvasPositionY = current.CanvasPosition.Y

		if v24 > CanvasPositionY + AbsoluteWindowSizeY then
			current.CanvasPosition = Vector2.new(0, v24 - AbsoluteWindowSizeY)

			return
		end

		if v23 < CanvasPositionY then
			current.CanvasPosition = Vector2.new(0, v23)
		end
	end, {
		t1.keyboardIndex,
		t1.isOpen,
		XXSmall
	})

	local v14 = React.useMemo(function() -- line: 83
		-- upvalues: t1 (copy), React (copy), Foundation (copy), v8 (copy), v9 (copy)
		local t2 = {}

		if not t1.isOpen or not t1.renderEntry then
			return t2
		end

		local renderEntry = t1.renderEntry

		for v29, v30 in t1.results do
			local v31 = v29 == t1.selectedIndex

			t2["entry_" .. tostring(v29)] = React.createElement(Foundation.View, {
				Size = UDim2.new(1, 0, 0, 40),
				LayoutOrder = v29,
				cornerRadius = UDim.new(0, v8.Radius.Medium),
				backgroundStyle = if not v31 then nil else v8.Color.ActionSoftEmphasis.Background,
				stateLayer = {
					affordance = Foundation.Enums.StateLayerAffordance.None
				},
				selection = {
					Selectable = true
				},
				cursor = v9,
				padding = {
					left = UDim.new(0, 12),
					right = UDim.new(0, 12),
					top = UDim.new(0, 10),
					bottom = UDim.new(0, 10)
				},
				onActivated = function() -- line: 111
					-- upvalues: t1 (copy), v29 (copy)
					t1.onSelect(v29)
				end,
				onStateChanged = function(p1) -- line: 114
					-- upvalues: t1 (copy), v29 (copy)
					if p1 == "Hover" then
						t1.onHover(v29)
					end
				end
			}, {
				content = renderEntry(v30, v31)
			})
		end

		return t2
	end, {
		t1.isOpen,
		t1.results,
		t1.selectedIndex,
		t1.renderEntry,
		t1.onSelect,
		t1.onHover,
		v9,
		v8
	})
	local v15 = v5
	local v16 = math.min(#t1.results, v15)
	local v17 = v15 < #t1.results
	local v18 = if t1.isOpen then if not v17 then v16 * 40 + math.max(0, v16 - 1) * XXSmall else v16 * 40 + v16 * XXSmall + 20 else 0
	local v19 = not (v11 > 0) and 280 or v11

	return React.createElement(Foundation.Popover.Root, {
		isOpen = t1.isOpen
	}, {
		Anchor = React.createElement(Foundation.Popover.Anchor, {
			anchorRef = t1.anchorRef
		}),
		Content = React.createElement(Foundation.Popover.Content, {
			hasArrow = false,
			side = {
				offset = 0,
				position = t1.side or Foundation.Enums.PopoverSide.Top
			},
			align = Foundation.Enums.PopoverAlign.Center,
			backgroundStyle = v8.Color.Surface.Surface_200,
			radius = Foundation.Enums.Radius.Medium,
			onPressedOutside = t1.onDismiss
		}, React.createElement(Foundation.View, {
			tag = "padding-small",
			Size = UDim2.fromOffset(v19, v18 + 16)
		}, {
			scrollView = React.createElement(Foundation.ScrollView, {
				Size = UDim2.new(1, 0, 0, v18),
				scrollingFrameRef = v10,
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.fromScale(0, 0),
					scrollBarVisibility = Foundation.Enums.Visibility.Always,
					VerticalScrollBarInset = Enum.ScrollBarInset.Always
				}
			}, {
				list = React.createElement(Foundation.View, {
					tag = "col gap-xxsmall auto-y",
					Size = UDim2.fromScale(1, 0)
				}, v14)
			})
		}))
	})
end

return React.memo(ChatAutocompleteDropdown)
