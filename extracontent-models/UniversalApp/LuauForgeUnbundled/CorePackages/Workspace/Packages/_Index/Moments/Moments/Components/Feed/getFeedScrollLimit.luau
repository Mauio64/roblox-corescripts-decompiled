local function getFeedScrollLimit(p2, p3, callback)
	if p2 and not p3 then
		return nil
	end

	local v5 = callback()

	if v5.getIsInfiniteScrollEnabled(false) then
		return nil
	end

	return (v5.getMaxMomentsBeforeEndState(false))
end

return getFeedScrollLimit
