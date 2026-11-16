local function shouldShowProfileFrames(p2, p3, p4)
	if not p2 then
		return false
	end

	if p3 then
		return p4
	end

	return true
end

local function computeProfileFramesGating(p2, p3, p4, p5, p6)
	local v5 = if p2 then not p3 or p4 else false
	return {
		shouldShowFrames = v5,
		shouldShowUpsell = v5 and p5 and not p6,
		canEquipFrame = v5 and p4 and not p6,
		ampAccessError = p6
	}
end

return computeProfileFramesGating
