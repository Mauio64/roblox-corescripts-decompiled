local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local Signals = require(AvatarExperienceCommonParent.Signals)

require(AvatarExperienceCommon.Hooks.useSelectorSignal)

local function v4(p1, p2) -- line: 9
	return p1 == p2
end
local function createSelectorSignal(p3, p4, p5) -- line: 14
	-- upvalues: Signals (copy), v4 (copy)
	local v11 = p3:getState()
	local v12, v13 = Signals.createSignal(v11)

	p3.changed:connect(v13)

	return Signals.createComputed(function(p6) -- line: 20
		-- upvalues: p4 (copy), v12 (copy)
		return p4(v12(p6))
	end, p5 or v4)
end

return createSelectorSignal
