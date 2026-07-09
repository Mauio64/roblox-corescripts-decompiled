local t1 = {}

t1.__index = t1
t1.Kind = {
	Unknown = "Unknown",
	RequestFailure = "Request Failed",
	RequireExternalRetry = "Require External Retry",
	LuaTimeout = "Lua Timeout",
	InvalidJson = "Invalid Json"
}

function t1.new(s1: string, s2: string, s3: string, n1: number?) -- line: 21
	-- upvalues: t1 (copy)
	assert(type(s1) == "string", "Expected targetUrl to be a string")
	assert(type(s2) == "string", "Expected errKind to be a string")
	assert(type(s3) == "string", "Expected errMessage to be a string")

	local t2 = {
		targetUrl = s1,
		kind = s2,
		message = s3
	}

	if n1 then
		assert(type(n1) == "number", "Expected statusCode to be a number")
		t2.StatusCode = n1
	end

	setmetatable(t2, t1)

	return t2
end
function t1.__tostring(p1) -- line: 42
	local v8 = table.concat({
		"HttpError :",
		string.format("\tTarget Url - %s", p1.targetUrl),
		string.format("\tKind - %s", p1.kind),
		string.format("\tMessage - %s", p1.message)
	}, "\n")

	if p1.StatusCode then
		v8 = table.concat({
			v8,
			string.format("\tStatus Code - %s", p1.StatusCode)
		}, "\n")
	end

	return v8
end

return t1
