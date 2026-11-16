local usageGraphKey = newproxy(true)
getmetatable(usageGraphKey).__tostring = function(): string
	return "UsageGraphSentinel"
end

return {
	UsageGraphKey = usageGraphKey,
	getUsageGraph = function(p)
		return table.clone(p[usageGraphKey])
	end
}
