local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("AppSplitView").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens

local function VisualPaneResizer(t1: {[any]: any}) -- line: 22
	-- upvalues: useTokens (copy), React (copy)
	local v9 = useTokens()
	local v10 = t1.Name or "PaneResizer"
	local v11 = t1.lineTopInset or 0

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = false,
		Name = v10,
		Position = t1.position,
		Size = UDim2.new(0, t1.hitWidth, 1, 0),
		ZIndex = t1.ZIndex
	}, {
		Line = React.createElement("Frame", {
			Name = "Line",
			BorderSizePixel = 0,
			Active = false,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, v11),
			Size = UDim2.new(0, 1, 1, -v11),
			BackgroundColor3 = v9.Color.Stroke.Emphasis.Color3,
			BackgroundTransparency = v9.Color.Stroke.Emphasis.Transparency
		})
	})
end
local function InteractivePaneResizer(t2: {[any]: any}) -- line: 49
	-- upvalues: useTokens (copy), React (copy), UserInputService (copy)
	local v13 = useTokens()
	local v14 = t2.Name or "PaneResizer"
	local v15 = t2.lineTopInset or 0
	local v16, v17 = React.useBinding(false)
	local v18 = React.useRef(t2.onDrag)
	local v19 = React.useRef(t2.onDragStart)
	local v20 = React.useRef(t2.onDragEnd)

	v18.current = t2.onDrag
	v19.current = t2.onDragStart
	v20.current = t2.onDragEnd

	local v21 = React.useRef(false)
	local v22 = React.useRef(false)
	local v23 = React.useCallback(function() -- line: 65
		-- upvalues: v17 (copy), v21 (copy), v22 (copy)
		v17(v21.current or v22.current)
	end, {})
	local v24 = React.useCallback(function(_, p2) -- line: 69
		-- upvalues: v21 (copy), v23 (copy), v19 (copy), UserInputService (copy), v18 (copy), v20 (copy)
		if p2.UserInputType ~= Enum.UserInputType.MouseButton1 and p2.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local p2Position = p2.Position

		v21.current = true
		v23()

		if v19.current then
			v19.current()
		end

		local connection = nil
		local connection2 = UserInputService.InputChanged:Connect(function(input) -- line: 87
			-- upvalues: v18 (copy), p2Position (ref)
			if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			if v18.current then
				local v42 = input.Position - p2Position

				p2Position = input.Position
				v18.current(Vector2.new(v42.X, v42.Y))
			end
		end)

		connection = p2.Changed:Connect(function(property: string) -- line: 101
			-- upvalues: p2 (copy), connection2 (ref), connection (ref), v21 (copy), v23 (copy), v20 (copy)
			if property == "UserInputState" and p2.UserInputState == Enum.UserInputState.End then
				if connection2 then
					connection2:Disconnect()
				end

				if connection then
					connection:Disconnect()
				end

				v21.current = false
				v23()

				if v20.current then
					v20.current()
				end
			end
		end)
	end, { v23 })
	local v25 = React.useCallback(function(_, _) -- line: 118
		-- upvalues: v22 (copy), v23 (copy)
		v22.current = true
		v23()
	end, { v23 })
	local v26 = React.useCallback(function(_, _) -- line: 122
		-- upvalues: v22 (copy), v23 (copy)
		v22.current = false
		v23()
	end, { v23 })
	local v27 = v16:map(function(p7) -- line: 127
		-- upvalues: v13 (copy)
		if p7 then
			return v13.Color.System.Emphasis.Color3
		end

		return v13.Color.Stroke.Emphasis.Color3
	end)
	local v28 = v16:map(function(p8) -- line: 130
		-- upvalues: v13 (copy)
		if p8 then
			return v13.Color.System.Emphasis.Transparency
		end

		return v13.Color.Stroke.Emphasis.Transparency
	end)

	return React.createElement("TextButton", {
		Name = v14,
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = true,
		Position = t2.position,
		Size = UDim2.new(0, t2.hitWidth, 1, 0),
		ZIndex = t2.ZIndex,
		[React.Event.InputBegan] = v24,
		[React.Event.MouseEnter] = v25,
		[React.Event.MouseLeave] = v26
	}, {
		Line = React.createElement("Frame", {
			Name = "Line",
			BorderSizePixel = 0,
			Active = false,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, v15),
			Size = UDim2.new(0, 1, 1, -v15),
			BackgroundColor3 = v27,
			BackgroundTransparency = v28
		})
	})
end
local function PaneResizer(t3: {[any]: any}) -- line: 161
	-- upvalues: React (copy), VisualPaneResizer (copy), InteractivePaneResizer (copy)
	if t3.interactive == false then
		return React.createElement(VisualPaneResizer, t3)
	end

	return React.createElement(InteractivePaneResizer, t3)
end

return React.memo(PaneResizer)
