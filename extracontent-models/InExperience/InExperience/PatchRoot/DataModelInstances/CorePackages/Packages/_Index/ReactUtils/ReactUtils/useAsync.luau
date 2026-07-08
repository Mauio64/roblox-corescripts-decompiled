local Parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(Parent.React)

local function useAsync(p1: ((...any) -> ...any), t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy)
	local v6, v7 = React.useState({
		status = "loading"
	})

	React.useEffect(function() -- line: 22
		-- upvalues: v7 (copy), p1 (copy)
		v7({
			status = "loading"
		})

		local thread = task.spawn(function() -- line: 27
			-- upvalues: v7 (copy), p1 (copy)
			xpcall(function() -- line: 28
				-- upvalues: v7 (copy), p1 (copy)
				v7({
					status = "ok",
					value = p1()
				})
			end, function(err) -- line: 33
				-- upvalues: v7 (copy)
				v7({
					status = "error",
					problem = err
				})
			end)
		end)

		return function() -- line: 41
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, t1)

	return v6
end

return useAsync
