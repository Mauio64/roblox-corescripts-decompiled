local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local Result = require(Parent.Result)
local t1 = {
	new = function() -- line: 17
		return {}
	end
}

function t1.fromTextSearchEntryJson(t2: {[any]: any}) -- line: 22
	-- upvalues: Result (copy), t1 (copy)
	if type(t2) ~= "table" then
		return Result.error("TextSearchEntry.fromTextSearchEntryJson expects textSearchEntryJson to be a table")
	end

	if type(t2.name) ~= "string" then
		return Result.error("TextSearchEntry.fromTextSearchEntryJson expects textSearchEntryJson.name to be a string")
	end

	if t2.contentType ~= "Text" then
		return Result.error("TextSearchEntry.fromTextSearchEntryJson expects textSearchEntryJson.contentType to be 'Text'")
	end

	local v5 = t1.new()

	v5.text = t2.name

	return Result.success(v5)
end

return t1
