local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local useMenuItemCursor = require(script.Parent.useMenuItemCursor)

local defineFastInt = game:DefineFastInt("ChatAutocompleteMaxVisibleEntries", 3)

local function ChatAutocompleteDropdown(props)
	local v = Foundation.Hooks.useTokens()
	local cursor = useMenuItemCursor()
	local ref = React.useRef(nil)

	local state, setState = React.useState(0)
	React.useEffect(function()
		local current = props.anchorRef.current

		if current and current:IsA("GuiObject") then
			setState(current.AbsoluteSize.X)
			local absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				setState(current.AbsoluteSize.X)
			end)
			return function()
				absoluteSizeChangedConnection:Disconnect()
			end
		end
	end, { props.anchorRef })

	local xxSmall = v.Padding.XXSmall
	React.useEffect(function()
		local current = ref.current

		if not current or not props.isOpen or props.keyboardIndex < 1 then
			return
		end

		local v2 = (props.keyboardIndex - 1) * (40 + xxSmall)
		local v3 = v2 + 40
		local y = current.AbsoluteWindowSize.Y
		local y2 = current.CanvasPosition.Y

		if y2 + y < v3 then
			current.CanvasPosition = Vector2.new(0, v3 - y)
		elseif v2 < y2 then
			current.CanvasPosition = Vector2.new(0, v2)
		end
	end, { props.keyboardIndex, props.isOpen, xxSmall })

	local v2 = React.useMemo(function()
		local children = {}

		if not (props.isOpen and props.renderEntry) then
			return children
		end

		local renderEntry = props.renderEntry

		for k, result in props.results do
			local v2 = k == props.selectedIndex

			local v3 = "entry_" .. tostring(k)
			local createElement = React.createElement
			local view = Foundation.View
			local v4 = {
				Size = UDim2.new(1, 0, 0, 40),
				LayoutOrder = k,
				cornerRadius = UDim.new(0, v.Radius.Medium),
				backgroundStyle = 0,
				stateLayer = 0,
				selection = 0,
				cursor = 0,
				padding = 0,
				onActivated = 0,
				onStateChanged = 0
			}
			local backgroundStyle

			if v2 then
				backgroundStyle = v.Color.ActionSoftEmphasis.Background
			end

			v4.backgroundStyle = backgroundStyle

			v4.stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }

			v4.selection = { Selectable = true }
			v4.cursor = cursor
			v4.padding = {
				left = UDim.new(0, 12),
				right = UDim.new(0, 12),
				top = UDim.new(0, 10),
				bottom = UDim.new(0, 10)
			}

			function v4.onActivated()
				props.onSelect(k)
			end
			function v4.onStateChanged(p)
				if p == "Hover" then
					props.onHover(k)
				end
			end

			children[v3] = createElement(view, v4, { content = renderEntry(result, v2) })
		end

		return children
	end, {
		props.isOpen,
		props.results,
		props.selectedIndex,
		props.renderEntry,
		props.onSelect,
		props.onHover,
		cursor,
		v
	})

	local v3 = defineFastInt
	local v4 = math.min(#props.results, v3)
	local v5 = v3 < #props.results
	local v6

	if props.isOpen then
		if v5 then
			v6 = v4 * 40 + v4 * xxSmall + 20
		else
			v6 = v4 * 40 + math.max(0, v4 - 1) * xxSmall
		end
	else
		v6 = 0
	end

	local v7 = not (state > 0) and 280 or state
	return React.createElement(Foundation.Popover.Root, { isOpen = props.isOpen }, {
		Anchor = React.createElement(Foundation.Popover.Anchor, { anchorRef = props.anchorRef }),
		Content = React.createElement(Foundation.Popover.Content, {
			side = {
				position = props.side or Foundation.Enums.PopoverSide.Top,
				offset = 0
			},
			align = Foundation.Enums.PopoverAlign.Center,
			hasArrow = false,
			backgroundStyle = v.Color.Surface.Surface_200,
			radius = Foundation.Enums.Radius.Medium,
			onPressedOutside = props.onDismiss
		}, React.createElement(Foundation.View, {
			tag = "padding-small",
			Size = UDim2.fromOffset(v7, v6 + 16)
		}, {
			scrollView = React.createElement(Foundation.ScrollView, {
				Size = UDim2.new(1, 0, 0, v6),
				scrollingFrameRef = ref,
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.fromScale(0, 0),
					scrollBarVisibility = Foundation.Enums.Visibility.Always,
					VerticalScrollBarInset = Enum.ScrollBarInset.Always
				}
			}, {
				list = React.createElement(
					Foundation.View,
					{ tag = "col gap-xxsmall auto-y", Size = UDim2.fromScale(1, 0) },
					v2
				)
			})
		}))
	})
end

return (React.memo(ChatAutocompleteDropdown))
