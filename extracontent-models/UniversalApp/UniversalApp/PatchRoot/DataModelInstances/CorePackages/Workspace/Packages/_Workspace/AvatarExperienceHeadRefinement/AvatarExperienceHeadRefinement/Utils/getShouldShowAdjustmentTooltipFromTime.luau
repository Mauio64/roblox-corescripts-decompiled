local v1 = game:DefineFastInt("AXHeadRefinementTooltipExpirationDurationDays", 7)

local function getShouldShowAdjustmentTooltipFromTime(t1: {[any]: any}) -- line: 4
	-- upvalues: v1 (copy)
	if not t1.prevTime then
		return true
	end

	return (t1.expirationDurationSeconds or v1 * 24 * 60 * 60) <= os.difftime(t1.currentTime, t1.prevTime)
end

return getShouldShowAdjustmentTooltipFromTime
