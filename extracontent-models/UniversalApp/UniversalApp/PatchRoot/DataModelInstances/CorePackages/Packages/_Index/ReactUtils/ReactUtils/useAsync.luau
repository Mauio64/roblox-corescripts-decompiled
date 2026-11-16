local parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(parent.React)

local function useAsync(callback, p)
	local state, setState = React.useState({ status = "loading" })

	React.useEffect(function()
		setState({ status = "loading" })

		local thread = task.spawn(function()
			xpcall(function()
				setState({ status = "ok", value = callback() })
			end, function(problem)
				setState({ status = "error", problem = problem })
			end)
		end)

		return function()
			task.cancel(thread)
		end
	end, p)

	return state
end

return useAsync
