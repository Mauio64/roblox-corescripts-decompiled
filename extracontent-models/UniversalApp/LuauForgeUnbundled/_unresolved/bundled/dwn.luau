local v5 = {}

function v5.new()
	return { sorts = {}, pageId = "" }
end

function v5.mock()
	local v6 = v5.new()
	v6.sorts = {}
	v6.pageId = "73261389094"

	return v6
end

return v5
