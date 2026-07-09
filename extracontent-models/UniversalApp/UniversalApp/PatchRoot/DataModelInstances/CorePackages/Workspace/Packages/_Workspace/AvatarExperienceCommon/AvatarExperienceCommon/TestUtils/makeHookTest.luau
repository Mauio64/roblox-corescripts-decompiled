local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)

local function makeHookTest(p1, p2) -- line: 5
	-- upvalues: React (copy)
	return function() -- line: 6
		-- upvalues: p1 (copy), p2 (copy), React (copy)
		local v6 = p1()

		p2(v6)

		return React.createElement("Frame")
	end
end

return makeHookTest
