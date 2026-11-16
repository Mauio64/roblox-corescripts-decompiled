local CorePackages = game:GetService("CorePackages")

local Otter = require(CorePackages.Packages.Otter)

local function getTransparencySpringFromSettings(p)
	local transparencyAnimation = p.TransparencyAnimation

	if not transparencyAnimation.Enabled then
		return Otter.instant
	end

	local v = {
		dampingRatio = transparencyAnimation.SpringDampingRatio,
		frequency = transparencyAnimation.SpringFrequency
	}

	return function(p2)
		return Otter.spring(p2, v)
	end
end

return getTransparencySpringFromSettings
