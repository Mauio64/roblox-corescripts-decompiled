local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ViewRecyclerReact")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRowTypes")
local createCommentsListRevealTracker = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/CommentsList/createCommentsListRevealTracker")

local function useCommentsListReveal(p2, current, current2)
	local ref = React.useRef(current)
	ref.current = current
	local ref2 = React.useRef(current2)
	ref2.current = current2

	local v5 = React.useState(function()
		return createCommentsListRevealTracker({
			layout = p2,
			getItemKey = function(p3)
				local v6 = ref.current[p3]

				if v6 == nil then
					return nil
				end

				return v6.key
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
		local thread = task.delay(1, v5.reveal)
		return function()
			v5.destroy()
			pcall(task.cancel, thread)
		end
	end, { v5 })

	return v5
end

return useCommentsListReveal
