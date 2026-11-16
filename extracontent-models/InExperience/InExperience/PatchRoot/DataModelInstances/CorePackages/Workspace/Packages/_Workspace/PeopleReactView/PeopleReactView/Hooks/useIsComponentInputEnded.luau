local parent = script:FindFirstAncestor("PeopleReactView").Parent

local React = require(parent.React)

return function(p)
	local state, setState = React.useState(false)

	React.useEffect(function()
		local inputBeganConnection, inputEndedConnection

		if p.current then
			inputBeganConnection = p.current.InputBegan:Connect(function()
				setState(false)
			end)
			inputEndedConnection = p.current.InputEnded:Connect(function()
				setState(true)
			end)
		else
			inputBeganConnection = nil
			inputEndedConnection = nil
		end

		return function()
			if inputBeganConnection then
				inputBeganConnection:Disconnect()
			end

			if inputEndedConnection then
				inputEndedConnection:Disconnect()
			end
		end
	end, {})

	return state
end
