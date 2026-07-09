local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local ReactOtter = require(Parent.ReactOtter)
local getUserSettings = require(script.Parent.getUserSettings)

local function makeOtterSpringValue(n1: number, p1) -- line: 8
	-- upvalues: getUserSettings (copy), ReactOtter (copy)
	if getUserSettings().ReducedMotion then
		return ReactOtter.instant(n1)
	end

	return ReactOtter.spring(n1, p1)
end

return makeOtterSpringValue
