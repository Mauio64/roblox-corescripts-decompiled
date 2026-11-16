local parent = script:FindFirstAncestor("ExpChat").Parent
local Otter = require(parent.Otter)

local function getSpringFromSettings(p, p2: string)
	local v

	if p2 == "size" then
		v = p.SizeAnimation
	else
		v = p.TransparencyAnimation
	end

	if v.Enabled == false then
		return Otter.instant
	end

	local v2 = { dampingRatio = v.SpringDampingRatio, frequency = v.SpringFrequency }

	return function(p3)
		return Otter.spring(p3, v2)
	end
end

return getSpringFromSettings
