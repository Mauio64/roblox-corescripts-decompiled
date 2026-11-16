local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local function useScrollToTopAfterRestore()
	local ref = React.useRef(nil)

	local scrollToTopAfterRestore = React.useCallback(function()
		local current = ref.current

		if current == nil then
			return
		end

		task.defer(function()
			if ref.current ~= current then
				return
			end

			current.CanvasPosition = Vector2.new(0, 0)
		end)
	end, {})

	return React.useMemo(function()
		return { scrollingFrameRef = ref, scrollToTopAfterRestore = scrollToTopAfterRestore }
	end, { ref, scrollToTopAfterRestore })
end

return useScrollToTopAfterRestore
