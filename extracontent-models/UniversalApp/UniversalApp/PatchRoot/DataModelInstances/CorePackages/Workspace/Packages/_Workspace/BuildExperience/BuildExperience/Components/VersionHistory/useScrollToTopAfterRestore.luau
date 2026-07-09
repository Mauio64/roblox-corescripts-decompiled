local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)

local function useScrollToTopAfterRestore() -- line: 6
	-- upvalues: React (copy)
	local v4 = React.useRef(nil)
	local v5 = React.useCallback(function() -- line: 9
		-- upvalues: v4 (copy)
		local current = v4.current

		if current == nil then
			return
		end

		task.defer(function() -- line: 15
			-- upvalues: v4 (copy), current (copy)
			if v4.current ~= current then
				return
			end

			current.CanvasPosition = Vector2.new(0, 0)
		end)
	end, {})

	return React.useMemo(function() -- line: 24
		-- upvalues: v4 (copy), v5 (copy)
		return {
			scrollingFrameRef = v4,
			scrollToTopAfterRestore = v5
		}
	end, {
		v4,
		v5
	})
end

return useScrollToTopAfterRestore
