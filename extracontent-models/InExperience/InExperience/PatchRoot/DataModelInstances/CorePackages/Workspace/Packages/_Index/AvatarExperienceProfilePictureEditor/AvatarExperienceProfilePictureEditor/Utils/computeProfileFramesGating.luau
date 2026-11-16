local function shouldShowProfileFrames(flag: boolean, flag2: boolean, flag3: boolean) -- 1 equivalent call inferred from this helper
	return not not flag and (not flag2 or flag3)
end

local function computeProfileFramesGating(flag: boolean, flag2: boolean, flag3: boolean, flag4: boolean, ampAccessError: boolean)
	local shouldShowFrames = shouldShowProfileFrames(flag, flag2, flag3) -- inferred equivalent call
	return {
		shouldShowFrames = shouldShowFrames,
		shouldShowUpsell = shouldShowFrames and flag4 and not ampAccessError,
		canEquipFrame = shouldShowFrames and flag3 and not ampAccessError,
		ampAccessError = ampAccessError
	}
end

return computeProfileFramesGating
