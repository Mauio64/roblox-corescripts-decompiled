local parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local GuiService = game:GetService("GuiService")

local useTokens = Foundation.Hooks.useTokens

local function sameSnapPoints(current, list): boolean -- 1 equivalent call inferred from this helper
	if #current ~= #list then
		return false
	end

	for k, item in current do
		if list[k] ~= item then
			return false
		end
	end

	return true
end

local function useSheetBounds(props, state, sheet, content, p: number, callback)
	local v = useTokens()
	local onBoundsChanged = props.onBoundsChanged
	React.useEffect(function()
		if props.isOpen and sheet ~= nil and content ~= nil and state ~= nil then
			local function updateBounds()
				local absolutePosition = state.AbsolutePosition

				if sheet.AbsoluteSize.X < state.AbsoluteSize.X - 1 then
					local v2

					if sheet.AbsoluteSize.X > 0 then
						v2 = sheet.AbsolutePosition.X
					end

					onBoundsChanged(nil, v2)
					local v3 = sheet.AbsolutePosition - absolutePosition
					callback({
						rect = Rect.new(v3, v3 + sheet.AbsoluteSize),
						areaSize = state.AbsoluteSize
					})
				else
					local v2 = content.AbsoluteSize.Y > 0
					local v3

					if v2 then
						v3 = content.AbsolutePosition.Y - v.Padding.Medium
					end

					onBoundsChanged(v3, nil)
					local v4 = state.AbsoluteSize.Y - p
					callback(v2 and {
						rect = Rect.new(Vector2.new(0, (math.max(0, v4 - v.Size.Size_800))), state.AbsoluteSize),
						areaSize = state.AbsoluteSize
					} or nil)
				end
			end
			updateBounds()
			local connections = {}

			for _, v2 in { sheet, content, state } do
				table.insert(connections, v2:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateBounds))
				table.insert(connections, v2:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateBounds))
			end

			return function()
				for _, connection in connections do
					connection:Disconnect()
				end

				onBoundsChanged(nil, nil)
				callback(nil)
			end
		end

		onBoundsChanged(nil, nil)
		callback(nil)
		return nil
	end, { props.isOpen, sheet, content, state, p, v, onBoundsChanged, callback })
end

local function LibraryChatSheetOverlay(props)
	local v = Foundation.Hooks.useOverlay()
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState({})
	React.useLayoutEffect(function()
		if v == nil then
			return nil
		end

		local screenGui = v:FindFirstAncestorWhichIsA("ScreenGui") or v
		local function updateLayout()
			setState({
				originY = v.AbsolutePosition.Y,
				screenHeight = screenGui.AbsoluteSize.Y,
				availableHeight = v.AbsoluteSize.Y,
				isBottomSheet = GuiService.ViewportDisplaySize == Enum.DisplaySize.Small and screenGui.AbsoluteSize.X <= screenGui.AbsoluteSize.Y
			})
		end
		updateLayout()
		local v2 = {
			v:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateLayout),
			v:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLayout),
			screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLayout),
			GuiService:GetPropertyChangedSignal("ViewportDisplaySize"):Connect(updateLayout)
		}

		return function()
			for _, connection in v2 do
				connection:Disconnect()
			end
		end
	end, { v })
	local state4, setState4 = React.useState(nil)
	local v2, v3 = React.useBinding(nil)
	local v4 = React.useCallback(function(sheet, content)
		setState3({ sheet = sheet, content = content })
	end, {})
	local state5, setState5 = React.useState(nil)

	local v5 = (props.top == nil or state == nil) and 0 or math.max(0, props.top - state.originY)
	local v6 = state == nil and 0 or state.screenHeight
	local v7 = state == nil and 0 or state.availableHeight
	local current2 = props.snapPoints

	if v6 > 0 then
		current2 = {}

		for _, snapPoint in props.snapPoints do
			table.insert(current2, (math.max(2, (math.min(snapPoint * v6, v7 - v5)))))
		end
	end

	local ref = React.useRef(current2)

	if not sameSnapPoints(ref.current, current2) then -- inferred equivalent call
		ref.current = current2
	end

	local current = ref.current
	useSheetBounds(props, state4, state3.sheet, state3.content, state5 or current[1], v3)
	local v8 = not (state == nil) and state.isBottomSheet
	local sheet = props.renderSheet(current, v4, setState5)
	local v9 = v8 and 0 or v5
	local createElement = React.createElement
	local fragment = React.Fragment
	local inset

	if v ~= nil then
		inset = ReactRoblox.createPortal(React.createElement(Foundation.View, {
			ref = setState4,
			Position = UDim2.fromOffset(0, v9),
			Size = UDim2.new(1, 0, 1, -v9),
			backgroundStyle = { Transparency = 1 }
		}, {
			Window = React.createElement(Foundation.View, {
				Position = v2:map(function(p)
					if p then
						return (UDim2.fromOffset(p.rect.Min.X, p.rect.Min.Y))
					end

					return (UDim2.new())
				end),
				Size = v2:map(function(p)
					if p then
						return (UDim2.fromOffset(p.rect.Width, p.rect.Height))
					end

					return (UDim2.fromScale(1, 1))
				end),
				backgroundStyle = { Transparency = 1 },
				tag = "clip"
			}, {
				Host = React.createElement(Foundation.View, {
					ref = setState2,
					Position = v2:map(function(p)
						if p then
							return (UDim2.fromOffset(-p.rect.Min.X, -p.rect.Min.Y))
						end

						return (UDim2.new())
					end),
					Size = v2:map(function(p)
						if p then
							return (UDim2.fromOffset(p.areaSize.X, p.areaSize.Y))
						end

						return (UDim2.fromScale(1, 1))
					end),
					backgroundStyle = { Transparency = 1 },
					testId = "Library.ChatOverlay"
				})
			})
		}), v)
	end

	local sheet2

	if state2 ~= nil then
		sheet2 = React.createElement(Foundation.OverlayProvider, { gui = state2 }, sheet)
	end

	return createElement(fragment, nil, { Inset = inset, Sheet = sheet2 })
end

return LibraryChatSheetOverlay
