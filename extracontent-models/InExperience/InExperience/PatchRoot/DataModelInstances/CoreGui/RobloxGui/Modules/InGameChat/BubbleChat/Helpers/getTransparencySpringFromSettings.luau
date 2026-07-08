local CorePackages = game:GetService("CorePackages")
local Otter = require(CorePackages.Packages.Otter)

local function getTransparencySpringFromSettings(p1) -- line: 5
	-- upvalues: Otter (copy)
	local TransparencyAnimation = p1.TransparencyAnimation

	if not TransparencyAnimation.Enabled then
		return Otter.instant
	end

	local t1 = {
		dampingRatio = TransparencyAnimation.SpringDampingRatio,
		frequency = TransparencyAnimation.SpringFrequency
	}

	return function(p2) -- line: 15
		-- upvalues: Otter (copy), t1 (copy)
		return Otter.spring(p2, t1)
	end
end

return getTransparencySpringFromSettings
