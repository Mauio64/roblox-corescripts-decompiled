local CorePackages = game:GetService("CorePackages")
local Otter = require(CorePackages.Packages.Otter)

local function getSizeSpringFromSettings(p1) -- line: 5
	-- upvalues: Otter (copy)
	local SizeAnimation = p1.SizeAnimation

	if not SizeAnimation.Enabled then
		return Otter.instant
	end

	local t1 = {
		dampingRatio = SizeAnimation.SpringDampingRatio,
		frequency = SizeAnimation.SpringFrequency
	}

	return function(p2) -- line: 15
		-- upvalues: Otter (copy), t1 (copy)
		return Otter.spring(p2, t1)
	end
end

return getSizeSpringFromSettings
