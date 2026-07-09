local HttpService = game:GetService("HttpService")

local function getDecodedJSON(s1: string) -- line: 3
	-- upvalues: HttpService (copy)
	local ok, result = pcall(function() -- line: 4
		-- upvalues: HttpService (copy), s1 (copy)
		return HttpService:JSONDecode(s1)
	end)

	if ok then
		return result
	end

	if _G.__TEST_SUITE_PACKAGE__ or _G.__TESTEZ_RUNNING_TEST__ then
		return nil
	end

	warn(debug.traceback("Failed to decode JSON: " .. s1))

	return nil
end

return getDecodedJSON
