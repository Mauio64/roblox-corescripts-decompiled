local function getManualSelectVariant(p: number, value: number?) -- 1 equivalent call inferred from this helper
	if p >= 0 then
		return p
	end

	return value or 0
end

local function resolveBirthdaySelectVariant(flag: boolean, p: number, value: number?, value2: number?)
	local manualSelectVariant = getManualSelectVariant(p, value) -- inferred equivalent call
	return flag and (value2 or 1) <= manualSelectVariant
end

return resolveBirthdaySelectVariant
