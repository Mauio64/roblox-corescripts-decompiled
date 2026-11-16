local defineFastInt = game:DefineFastInt("AXHeadRefinementTooltipExpirationDurationDays", 7)

local function getShouldShowAdjustmentTooltipFromTime(data): boolean
	if data.prevTime then
		return (data.expirationDurationSeconds or defineFastInt * 24 * 60 * 60) <= os.difftime(data.currentTime, data.prevTime)
	end

	return true
end

return getShouldShowAdjustmentTooltipFromTime
