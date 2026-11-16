local UserInputService = game:GetService("UserInputService")
local parent = script.Parent.Parent.Parent
local React = require(parent.React)

return function(props)
	local ref = React.createRef()
	local state, setState = React.useState(false)
	React.useEffect(function()
		if not (props.swipeEnabled and props.swipeCallback) then
			setState(false)

			return nil
		end

		local touchStartedConnection = UserInputService.TouchStarted:Connect(function(p)
			local current = ref and ref.current

			if not current then
				return
			end

			local v = Vector2.new(p.Position.X, p.Position.Y) - current.AbsolutePosition

			if v.X >= 0 and v.Y >= 0 and v.X <= current.AbsoluteSize.X and v.Y <= current.AbsoluteSize.Y then
				setState(true)
			end
		end)
		local touchEndedConnection = UserInputService.TouchEnded:Connect(function()
			setState(false)
		end)
		local touchSwipeConnection

		if state then
			touchSwipeConnection = UserInputService.TouchSwipe:Connect(function(p)
				if state then
					props.swipeCallback(p)
				end
			end)
		else
			touchSwipeConnection = nil
		end

		return function()
			touchStartedConnection:Disconnect()
			touchEndedConnection:Disconnect()

			if touchSwipeConnection then
				touchSwipeConnection:Disconnect()
			end
		end
	end, { props.swipeEnabled, props.swipeCallback, ref, state })

	return React.createElement("Frame", {
		Size = props.Size,
		AutomaticSize = props.AutomaticSize,
		BackgroundTransparency = 1,
		Active = true,
		ref = ref
	}, props.children)
end
