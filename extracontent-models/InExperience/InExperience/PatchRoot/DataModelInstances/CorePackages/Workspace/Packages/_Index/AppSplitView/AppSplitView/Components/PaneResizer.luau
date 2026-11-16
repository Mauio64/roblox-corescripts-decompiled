local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("AppSplitView").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local function VisualPaneResizer(props)
	local v = useTokens()
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
			BackgroundColor3 = v.Color.Stroke.Emphasis.Color3,
			BackgroundTransparency = v.Color.Stroke.Emphasis.Transparency,
			BorderSizePixel = 0,
			Active = false
		})
	})
end

local function InteractivePaneResizer(props)
	local v = useTokens()
	local name = props.Name or "PaneResizer"
	local lineTopInset = props.lineTopInset or 0

	local v2, v3 = React.useBinding(false)

	local ref = React.useRef(props.onDrag)
	local ref2 = React.useRef(props.onDragStart)
	local ref3 = React.useRef(props.onDragEnd)
	ref.current = props.onDrag
	ref2.current = props.onDragStart
	ref3.current = props.onDragEnd

	local ref4 = React.useRef(false)
	local ref5 = React.useRef(false)
	local v4 = React.useCallback(function()
		v3(ref4.current or ref5.current)
	end, {})

	local v5 = React.useCallback(function(_, data)
		if data.UserInputType ~= Enum.UserInputType.MouseButton1 and data.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local position = data.Position
		ref4.current = true
		v4()

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
				local v5 = input.Position - position
				position = input.Position
				ref.current(Vector2.new(v5.X, v5.Y))
			end
		end)

		changedConnection = data.Changed:Connect(function(p: string)
			if p == "UserInputState" and data.UserInputState == Enum.UserInputState.End then
				if inputChangedConnection then
					inputChangedConnection:Disconnect()
				end

				if changedConnection then
					changedConnection:Disconnect()
				end

				ref4.current = false
				v4()

				if ref3.current then
					ref3.current()
				end
			end
		end)
	end, { v4 })

	local v6 = React.useCallback(function(_, _)
		ref5.current = true
		v4()
	end, { v4 })
	local v7 = React.useCallback(function(_, _)
		ref5.current = false
		v4()
	end, { v4 })

	local mapped = v2:map(function(p)
		if p then
			return v.Color.System.Emphasis.Color3
		end

		return v.Color.Stroke.Emphasis.Color3
	end)

	local mapped2 = v2:map(function(p)
		if p then
			return v.Color.System.Emphasis.Transparency
		end

		return v.Color.Stroke.Emphasis.Transparency
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
		[React.Event.InputBegan] = v5,
		[React.Event.MouseEnter] = v6,
		[React.Event.MouseLeave] = v7
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

local function PaneResizer(p)
	if p.interactive == false then
		return React.createElement(VisualPaneResizer, p)
	end

	return React.createElement(InteractivePaneResizer, p)
end

return React.memo(PaneResizer)
