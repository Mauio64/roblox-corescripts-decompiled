local t1 = {}

t1.__index = t1

function t1.new(p1, p2, p3, p4) -- line: 8
	-- upvalues: t1 (copy)
	assert(type(p1) == "string", "Expected url to be a string")
	assert(type(p2) == "string" or type(p2) == "table", "Expected response to be a string or table")
	assert(type(p3) == "number", "Expected responseTimeMs to be a number")
	assert(type(p4) == "number", "Expected statusCode to be a number")

	local t2 = {
		requestUrl = p1,
		responseTimeMs = p3,
		responseCode = p4,
		responseBody = p2
	}

	setmetatable(t2, t1)

	return t2
end
function t1.__tostring(p5) -- line: 25
	return table.concat({
		"HttpResponse :",
		string.format("\tRequested Url - %s", p5.requestUrl),
		string.format("\tCode - %s", (tostring(p5.responseCode))),
		string.format("\tBody - %s", (tostring(p5.responseBody))),
		string.format("\tTime(ms) - %s", (tostring(p5.responseTimeMs)))
	}, "\n")
end

return t1
