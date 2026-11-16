local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/React")

return function(props)
	local ref = React.createRef()
	local state, setState = React.useState(false)
	React.useEffect(function()
		if not (props.swipeEnabled and props.swipeCallback) then
			setState(false)

			return nil
		end

		local touchStartedConnection = UserInputService.TouchStarted:Connect(function(p2)
			local current = ref and ref.current

			if not current then
				return
			end

			local v5 = Vector2.new(p2.Position.X, p2.Position.Y) - current.AbsolutePosition

			if
				v5.X >= 0
				and v5.Y >= 0
				and v5.X <= current.AbsoluteSize.X
				and v5.Y <= current.AbsoluteSize.Y
			then
				setState(true)
			end
		end)
		local touchEndedConnection = UserInputService.TouchEnded:Connect(function()
			setState(false)
		end)
		local touchSwipeConnection

		if state then
			touchSwipeConnection = UserInputService.TouchSwipe:Connect(function(p2)
				if state then
					props.swipeCallback(p2)
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
