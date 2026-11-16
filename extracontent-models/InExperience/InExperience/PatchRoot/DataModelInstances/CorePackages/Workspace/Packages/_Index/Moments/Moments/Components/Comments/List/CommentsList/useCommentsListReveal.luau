local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)
require(parent.ViewRecycler)

require(script.Parent.Parent.Rows.CommentRowTypes)
local createCommentsListRevealTracker = require(script.Parent.createCommentsListRevealTracker)

local function useCommentsListReveal(layout, current, current2)
	local ref = React.useRef(current)
	ref.current = current
	local ref2 = React.useRef(current2)
	ref2.current = current2

	local v = React.useState(function()
		return createCommentsListRevealTracker({
			layout = layout,
			getItemKey = function(p: number)
				local v = ref.current[p]
				return if v ~= nil then v.key else nil
			end,
			onReady = function()
				local current3 = ref2.current

				if current3 ~= nil then
					current3()
				end
			end
		})
	end)

	React.useEffect(function()
		local thread = task.delay(1, v.reveal)
		return function()
			v.destroy()
			pcall(task.cancel, thread)
		end
	end, { v })

	return v
end

return useCommentsListReveal
