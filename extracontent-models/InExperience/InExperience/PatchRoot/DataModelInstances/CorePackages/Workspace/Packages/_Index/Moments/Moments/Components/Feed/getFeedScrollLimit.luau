local function getFeedScrollLimit(flag: boolean, flag2: boolean, callback)
	if flag and not flag2 then
		return nil
	end

	local v = callback()

	if v.getIsInfiniteScrollEnabled(false) then
		return nil
	end

	return (v.getMaxMomentsBeforeEndState(false))
end

return getFeedScrollLimit
