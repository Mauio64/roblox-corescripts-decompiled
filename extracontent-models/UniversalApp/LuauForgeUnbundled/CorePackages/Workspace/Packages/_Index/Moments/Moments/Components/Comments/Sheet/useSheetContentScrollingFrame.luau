local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local function useSheetContentScrollingFrame(p2)
	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	local v5 = React.useCallback(function(p3)
		local current = ref.current

		if p3 ~= nil and (current == nil or current.scrollingFrame ~= p3) then
			ref.current = { scrollingFrame = p3, canvasSize = p3.CanvasSize }
		end

		setState(p3)
	end, {})

	React.useLayoutEffect(function()
		local current = ref.current

		if not p2 and current ~= nil and current.scrollingFrame == state then
			current.scrollingFrame.CanvasSize = current.canvasSize
		end
	end, { p2, state })

	return state, v5
end

return useSheetContentScrollingFrame
