local CorePackages = game:GetService("CorePackages")

local Otter = require(CorePackages.Packages.Otter)

local function getSizeSpringFromSettings(p)
	local sizeAnimation = p.SizeAnimation

	if not sizeAnimation.Enabled then
		return Otter.instant
	end

	local v = {
		dampingRatio = sizeAnimation.SpringDampingRatio,
		frequency = sizeAnimation.SpringFrequency
	}

	return function(p2)
		return Otter.spring(p2, v)
	end
end

return getSizeSpringFromSettings
