local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

local function useSheetContentScrollingFrame(flag: boolean)
	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	local v = React.useCallback(function(scrollingFrame)
		local current = ref.current

		if scrollingFrame ~= nil and (current == nil or current.scrollingFrame ~= scrollingFrame) then
			ref.current = {
				scrollingFrame = scrollingFrame,
				canvasSize = scrollingFrame.CanvasSize
			}
		end

		setState(scrollingFrame)
	end, {})

	React.useLayoutEffect(function()
		local current = ref.current

		if not flag and current ~= nil and current.scrollingFrame == state then
			current.scrollingFrame.CanvasSize = current.canvasSize
		end
	end, { flag, state })

	return state, v
end

return useSheetContentScrollingFrame
