local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(parent.React)
local useAXAnimateScrollFrame = require(script.Parent.useAXAnimateScrollFrame)

local function AnimatedScrollingFrame(p, callback)
	local ref = React.useRef(nil)
	useAXAnimateScrollFrame(ref)
	local ref2 = React.useCallback(function(current)
		ref.current = current

		if typeof(callback) == "table" then
			callback.current = current
		elseif typeof(callback) == "function" then
			callback(current)
		end
	end, { callback })

	local clone = table.clone(p)
	clone.children = nil
	clone.ref = ref2
	return React.createElement("ScrollingFrame", clone, p.children)
end

return React.forwardRef(AnimatedScrollingFrame)
