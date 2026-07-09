local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("AppSplitView").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens

local function PaneResizer(t1: {[any]: any}) -- line: 19
	-- upvalues: useTokens (copy), React (copy), UserInputService (copy)
	local v7 = useTokens()
	local v8, v9 = React.useBinding(false)
	local v10 = React.useRef(t1.onDrag)
	local v11 = React.useRef(t1.onDragStart)
	local v12 = React.useRef(t1.onDragEnd)

	v10.current = t1.onDrag
	v11.current = t1.onDragStart
	v12.current = t1.onDragEnd

	local v13 = React.useRef(false)
	local v14 = React.useRef(false)
	local v15 = React.useCallback(function() -- line: 33
		-- upvalues: v9 (copy), v13 (copy), v14 (copy)
		v9(v13.current or v14.current)
	end, {})
	local v16 = React.useCallback(function(_, p2) -- line: 37
		-- upvalues: v13 (copy), v15 (copy), v11 (copy), UserInputService (copy), v10 (copy), v12 (copy)
		if p2.UserInputType ~= Enum.UserInputType.MouseButton1 and p2.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local p2Position = p2.Position

		v13.current = true
		v15()

		if v11.current then
			v11.current()
		end

		local connection = nil
		local connection2 = UserInputService.InputChanged:Connect(function(input) -- line: 55
			-- upvalues: v10 (copy), p2Position (ref)
			if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			if v10.current then
				local v33 = input.Position - p2Position

				p2Position = input.Position
				v10.current(Vector2.new(v33.X, v33.Y))
			end
		end)

		connection = p2.Changed:Connect(function(property: string) -- line: 69
			-- upvalues: p2 (copy), connection2 (ref), connection (ref), v13 (copy), v15 (copy), v12 (copy)
			if property == "UserInputState" and p2.UserInputState == Enum.UserInputState.End then
				if connection2 then
					connection2:Disconnect()
				end

				if connection then
					connection:Disconnect()
				end

				v13.current = false
				v15()

				if v12.current then
					v12.current()
				end
			end
		end)
	end, { v15 })
	local v17 = React.useCallback(function(_, _) -- line: 86
		-- upvalues: v14 (copy), v15 (copy)
		v14.current = true
		v15()
	end, { v15 })
	local v18 = React.useCallback(function(_, _) -- line: 90
		-- upvalues: v14 (copy), v15 (copy)
		v14.current = false
		v15()
	end, { v15 })
	local v19 = v8:map(function(p7) -- line: 95
		-- upvalues: v7 (copy)
		if p7 then
			return v7.Color.System.Emphasis.Color3
		end

		return v7.Color.Stroke.Emphasis.Color3
	end)
	local v20 = v8:map(function(p8) -- line: 98
		-- upvalues: v7 (copy)
		if p8 then
			return v7.Color.System.Emphasis.Transparency
		end

		return v7.Color.Stroke.Emphasis.Transparency
	end)

	return React.createElement("TextButton", {
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = true,
		Position = t1.position,
		Size = UDim2.new(0, t1.hitWidth, 1, 0),
		ZIndex = t1.ZIndex,
		[React.Event.InputBegan] = v16,
		[React.Event.MouseEnter] = v17,
		[React.Event.MouseLeave] = v18
	}, {
		Line = React.createElement("Frame", {
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			Size = UDim2.new(0, v7.Stroke.Thicker, 1, 0),
			BackgroundColor3 = v19,
			BackgroundTransparency = v20
		})
	})
end

return React.memo(PaneResizer)
