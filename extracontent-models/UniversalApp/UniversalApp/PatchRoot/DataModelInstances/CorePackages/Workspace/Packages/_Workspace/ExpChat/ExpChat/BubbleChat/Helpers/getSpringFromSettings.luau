local Parent = script:FindFirstAncestor("ExpChat").Parent
local Otter = require(Parent.Otter)

local function getSpringFromSettings(p1, s1: string) -- line: 7
	-- upvalues: Otter (copy)
	local v6 = if s1 ~= "size" then p1.TransparencyAnimation else p1.SizeAnimation

	if v6.Enabled == false then
		return Otter.instant
	end

	local t1 = {
		dampingRatio = v6.SpringDampingRatio,
		frequency = v6.SpringFrequency
	}

	return function(p2) -- line: 25
		-- upvalues: Otter (copy), t1 (copy)
		return Otter.spring(p2, t1)
	end
end

return getSpringFromSettings
