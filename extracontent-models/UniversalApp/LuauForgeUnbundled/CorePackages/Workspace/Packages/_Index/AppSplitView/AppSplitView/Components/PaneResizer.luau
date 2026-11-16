local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppSplitView/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppSplitView/Foundation").Hooks.useTokens

local function VisualPaneResizer(props)
	local v5 = useTokens()
	local name = props.Name or "PaneResizer"
	local lineTopInset = props.lineTopInset or 0

	return React.createElement("Frame", {
		Name = name,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = false,
		Position = props.position,
		Size = UDim2.new(0, props.hitWidth, 1, 0),
		ZIndex = props.ZIndex
	}, {
		Line = React.createElement("Frame", {
			Name = "Line",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, lineTopInset),
			Size = UDim2.new(0, 1, 1, -lineTopInset),
			BackgroundColor3 = v5.Color.Stroke.Emphasis.Color3,
			BackgroundTransparency = v5.Color.Stroke.Emphasis.Transparency,
			BorderSizePixel = 0,
			Active = false
		})
	})
end

local function InteractivePaneResizer(props)
	local v5 = useTokens()
	local name = props.Name or "PaneResizer"
	local lineTopInset = props.lineTopInset or 0

	local v6, v7 = React.useBinding(false)

	local ref = React.useRef(props.onDrag)
	local ref2 = React.useRef(props.onDragStart)
	local ref3 = React.useRef(props.onDragEnd)
	ref.current = props.onDrag
	ref2.current = props.onDragStart
	ref3.current = props.onDragEnd

	local ref4 = React.useRef(false)
	local ref5 = React.useRef(false)
	local v8 = React.useCallback(function()
		v7(ref4.current or ref5.current)
	end, {})

	local v9 = React.useCallback(function(p2, data)
		if
			data.UserInputType ~= Enum.UserInputType.MouseButton1
			and data.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end

		local position = data.Position
		ref4.current = true
		v8()

		if ref2.current then
			ref2.current()
		end

		local changedConnection = nil

		local inputChangedConnection = UserInputService.InputChanged:Connect(function(input)
			if
				input.UserInputType ~= Enum.UserInputType.MouseMovement
				and input.UserInputType ~= Enum.UserInputType.Touch
			then
				return
			end

			if ref.current then
				local v10 = input.Position - position
				position = input.Position
				ref.current(Vector2.new(v10.X, v10.Y))
			end
		end)

		changedConnection = data.Changed:Connect(function(p3)
			if p3 == "UserInputState" and data.UserInputState == Enum.UserInputState.End then
				if inputChangedConnection then
					inputChangedConnection:Disconnect()
				end

				if changedConnection then
					changedConnection:Disconnect()
				end

				ref4.current = false
				v8()

				if ref3.current then
					ref3.current()
				end
			end
		end)
	end, { v8 })

	local v10 = React.useCallback(function(p2, p3)
		ref5.current = true
		v8()
	end, { v8 })
	local v11 = React.useCallback(function(p2, p3)
		ref5.current = false
		v8()
	end, { v8 })

	local mapped = v6:map(function(p2)
		if p2 then
			return v5.Color.System.Emphasis.Color3
		end

		return v5.Color.Stroke.Emphasis.Color3
	end)

	local mapped2 = v6:map(function(p2)
		if p2 then
			return v5.Color.System.Emphasis.Transparency
		end

		return v5.Color.Stroke.Emphasis.Transparency
	end)

	return React.createElement("TextButton", {
		Name = name,
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = true,
		Position = props.position,
		Size = UDim2.new(0, props.hitWidth, 1, 0),
		ZIndex = props.ZIndex,
		[React.Event.InputBegan] = v9,
		[React.Event.MouseEnter] = v10,
		[React.Event.MouseLeave] = v11
	}, {
		Line = React.createElement("Frame", {
			Name = "Line",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, lineTopInset),
			Size = UDim2.new(0, 1, 1, -lineTopInset),
			BackgroundColor3 = mapped,
			BackgroundTransparency = mapped2,
			BorderSizePixel = 0,
			Active = false
		})
	})
end

local function PaneResizer(p2)
	if p2.interactive == false then
		return React.createElement(VisualPaneResizer, p2)
	end

	return React.createElement(InteractivePaneResizer, p2)
end

return React.memo(PaneResizer)
