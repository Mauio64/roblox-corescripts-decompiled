local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ReactRoblox")
local GuiService = game:GetService("GuiService")

local useTokens = Foundation.Hooks.useTokens

local function sameSnapPoints(list, list2): boolean
	if #list ~= #list2 then
		return false
	end

	for k, item in list do
		if list2[k] ~= item then
			return false
		end
	end

	return true
end

local function useSheetBounds(props, state, sheet, content, p2, callback)
	local v5 = useTokens()
	local onBoundsChanged = props.onBoundsChanged
	React.useEffect(function()
		if props.isOpen and sheet ~= nil and content ~= nil and state ~= nil then
			local function updateBounds()
				local absolutePosition = state.AbsolutePosition

				if sheet.AbsoluteSize.X < state.AbsoluteSize.X - 1 then
					local v8 = if sheet.AbsoluteSize.X > 0 then sheet.AbsolutePosition.X else nil
					onBoundsChanged(nil, v8)
					local v9 = sheet.AbsolutePosition - absolutePosition
					callback({
						rect = Rect.new(v9, v9 + sheet.AbsoluteSize),
						areaSize = state.AbsoluteSize
					})
				else
					local v6 = content.AbsoluteSize.Y > 0
					local v8 = if v6 then content.AbsolutePosition.Y - v5.Padding.Medium else nil
					onBoundsChanged(v8, nil)
					local v9 = state.AbsoluteSize.Y - p2
					callback(v6 and {
						rect = Rect.new(
							Vector2.new(0, (math.max(0, v9 - v5.Size.Size_800))),
							state.AbsoluteSize
						),
						areaSize = state.AbsoluteSize
					} or nil)
				end
			end
			updateBounds()
			local connections = {}

			for k, v6 in { sheet, content, state } do
				table.insert(
					connections,
					v6:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateBounds)
				)
				table.insert(connections, v6:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateBounds))
			end

			return function()
				for k, connection in connections do
					connection:Disconnect()
				end

				onBoundsChanged(nil, nil)
				callback(nil)
			end
		end

		onBoundsChanged(nil, nil)
		callback(nil)
		return nil
	end, { props.isOpen, sheet, content, state, p2, v5, onBoundsChanged, callback })
end

local function LibraryChatSheetOverlay(props)
	local v5 = Foundation.Hooks.useOverlay()
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState({})
	React.useLayoutEffect(function()
		if v5 == nil then
			return nil
		end

		local screenGui = v5:FindFirstAncestorWhichIsA("ScreenGui") or v5
		local function updateLayout()
			setState({
				originY = v5.AbsolutePosition.Y,
				screenHeight = screenGui.AbsoluteSize.Y,
				availableHeight = v5.AbsoluteSize.Y,
				isBottomSheet = GuiService.ViewportDisplaySize == Enum.DisplaySize.Small and screenGui.AbsoluteSize.X <= screenGui.AbsoluteSize.Y
			})
		end
		updateLayout()
		local v6 = {
			v5:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateLayout),
			v5:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLayout),
			screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLayout),
			GuiService:GetPropertyChangedSignal("ViewportDisplaySize"):Connect(updateLayout)
		}

		return function()
			for k, connection in v6 do
				connection:Disconnect()
			end
		end
	end, { v5 })
	local state4, setState4 = React.useState(nil)
	local v6, v7 = React.useBinding(nil)
	local v8 = React.useCallback(function(p2, p3)
		setState3({ sheet = p2, content = p3 })
	end, {})
	local state5, setState5 = React.useState(nil)

	local v9 = (props.top == nil or state == nil) and 0 or math.max(0, props.top - state.originY)
	local v10 = state == nil and 0 or state.screenHeight
	local v11 = state == nil and 0 or state.availableHeight
	local v12 = props.snapPoints

	if v10 > 0 then
		v12 = {}

		for k, snapPoint in props.snapPoints do
			table.insert(v12, (math.max(2, (math.min(snapPoint * v10, v11 - v9)))))
		end
	end

	local ref = React.useRef(v12)
	local current = ref.current
	local v13

	if #current == #v12 then
		local flag = true

		for k, v15 in current do
			if v12[k] ~= v15 then
				v13 = false
				flag = false
				break
			end
		end

		if flag then
			v13 = true
		end
	else
		v13 = false
	end

	if not v13 then
		ref.current = v12
	end

	local current2 = ref.current
	useSheetBounds(props, state4, state3.sheet, state3.content, state5 or current2[1], v7)
	local v14 = not (state == nil) and state.isBottomSheet
	local sheet = props.renderSheet(current2, v8, setState5)
	local v15 = v14 and 0 or v9
	local createElement = React.createElement
	local fragment = React.Fragment
	local v18

	if v5 ~= nil then
		v18 = ReactRoblox.createPortal(React.createElement(Foundation.View, {
			ref = setState4,
			Position = UDim2.fromOffset(0, v15),
			Size = UDim2.new(1, 0, 1, -v15),
			backgroundStyle = { Transparency = 1 }
		}, {
			Window = React.createElement(Foundation.View, {
				Position = v6:map(function(p2)
					if p2 then
						return (UDim2.fromOffset(p2.rect.Min.X, p2.rect.Min.Y))
					end

					return (UDim2.new())
				end),
				Size = v6:map(function(p2)
					if p2 then
						return (UDim2.fromOffset(p2.rect.Width, p2.rect.Height))
					end

					return (UDim2.fromScale(1, 1))
				end),
				backgroundStyle = { Transparency = 1 },
				tag = "clip"
			}, {
				Host = React.createElement(Foundation.View, {
					ref = setState2,
					Position = v6:map(function(p2)
						if p2 then
							return (UDim2.fromOffset(-p2.rect.Min.X, -p2.rect.Min.Y))
						end

						return (UDim2.new())
					end),
					Size = v6:map(function(p2)
						if p2 then
							return (UDim2.fromOffset(p2.areaSize.X, p2.areaSize.Y))
						end

						return (UDim2.fromScale(1, 1))
					end),
					backgroundStyle = { Transparency = 1 },
					testId = "Library.ChatOverlay"
				})
			})
		}), v5)
	end

	local v19 = if state2 ~= nil then React.createElement(Foundation.OverlayProvider, {
		gui = state2
	}, sheet) else nil
	return createElement(fragment, nil, { Inset = v18, Sheet = v19 })
end

return LibraryChatSheetOverlay
