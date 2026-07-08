local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local useAXAnimateScrollFrame = require(script.Parent.useAXAnimateScrollFrame)

local function AnimatedScrollingFrame(p1, p2) -- line: 8
	-- upvalues: React (copy), useAXAnimateScrollFrame (copy)
	local v7 = React.useRef(nil)

	useAXAnimateScrollFrame(v7)

	local v8 = React.useCallback(function(p3) -- line: 11
		-- upvalues: v7 (copy), p2 (copy)
		v7.current = p3

		if typeof(p2) == "table" then
			p2.current = p3

			return
		end

		if typeof(p2) == "function" then
			p2(p3)
		end
	end, { p2 })
	local v9 = table.clone(p1)

	v9.children = nil
	v9.ref = v8

	return React.createElement("ScrollingFrame", v9, p1.children)
end

return React.forwardRef(AnimatedScrollingFrame)
