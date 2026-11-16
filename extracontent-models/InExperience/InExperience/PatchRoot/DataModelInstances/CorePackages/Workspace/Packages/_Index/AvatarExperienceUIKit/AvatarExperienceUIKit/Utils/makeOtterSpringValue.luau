local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local ReactOtter = require(parent.ReactOtter)
local getUserSettings = require(script.Parent.getUserSettings)

local function makeOtterSpringValue(p: number, p2)
	if getUserSettings().ReducedMotion then
		return ReactOtter.instant(p)
	end

	return ReactOtter.spring(p, p2)
end

return makeOtterSpringValue
