local v1 = newproxy(true)

getmetatable(v1).__tostring = function() -- line: 10
	return "UsageGraphSentinel"
end

return {
	UsageGraphKey = v1,
	getUsageGraph = function(p1) -- line: 14
		-- upvalues: v1 (copy)
		return table.clone(p1[v1])
	end
}
