local function advanceHistoryScroll(state, canvasHeight: number, historicalCount: number)
	local canvasHeight2 = state.canvasHeight
	local v = not canvasHeight2 and 0 or canvasHeight - canvasHeight2
	local v2 = state.historicalCount < historicalCount

	state.canvasHeight = canvasHeight
	state.historicalCount = historicalCount
	return if v2 and v > 0 then v else 0
end

return advanceHistoryScroll
