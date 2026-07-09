local UserInputService = game:GetService("UserInputService")
local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), UserInputService (copy)
	local v5 = React.createRef()
	local v6, v7 = React.useState(false)

	React.useEffect(function() -- line: 23
		-- upvalues: t1 (copy), UserInputService (copy), v5 (copy), v7 (copy), v6 (copy)
		if t1.swipeEnabled and t1.swipeCallback then
			local connection = UserInputService.TouchStarted:Connect(function(p1) -- line: 29
				-- upvalues: v5 (copy), v7 (copy)
				local v12 = v5 and v5.current

				if not v12 then
					return
				end

				local v13 = Vector2.new(p1.Position.X, p1.Position.Y) - v12.AbsolutePosition

				if v13.X >= 0 and v13.Y >= 0 and v13.X <= v12.AbsoluteSize.X and v13.Y <= v12.AbsoluteSize.Y then
					v7(true)
				end
			end)
			local connection2 = UserInputService.TouchEnded:Connect(function() -- line: 46
				-- upvalues: v7 (copy)
				v7(false)
			end)
			local v10 = if not v6 then nil else UserInputService.TouchSwipe:Connect(function(p2) -- line: 50
				-- upvalues: v6 (copy), t1 (copy)
				if v6 then
					t1.swipeCallback(p2)
				end
			end)

			return function() -- line: 57
				-- upvalues: connection (copy), connection2 (copy), v10 (copy)
				connection:Disconnect()
				connection2:Disconnect()

				if v10 then
					v10:Disconnect()
				end
			end
		end

		v7(false)

		return nil
	end, {
		t1.swipeEnabled,
		t1.swipeCallback,
		v5,
		v6
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Active = true,
		Size = t1.Size,
		AutomaticSize = t1.AutomaticSize,
		ref = v5
	}, t1.children)
end
