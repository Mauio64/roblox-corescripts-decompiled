local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local function useScrollToTopAfterRestore()
	local ref = React.useRef(nil)

	local v5 = React.useCallback(function()
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
		return { scrollingFrameRef = ref, scrollToTopAfterRestore = v5 }
	end, { ref, v5 })
end

return useScrollToTopAfterRestore
