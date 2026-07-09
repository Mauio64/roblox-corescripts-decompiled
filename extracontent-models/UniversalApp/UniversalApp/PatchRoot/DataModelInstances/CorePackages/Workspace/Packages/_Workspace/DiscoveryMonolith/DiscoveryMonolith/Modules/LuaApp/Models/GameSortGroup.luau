local t1 = {
	new = function() -- line: 10
		return {
			sorts = {},
			pageId = ""
		}
	end
}

function t1.mock() -- line: 18
	-- upvalues: t1 (copy)
	local v2 = t1.new()

	v2.sorts = {}
	v2.pageId = "73261389094"

	return v2
end

return t1
