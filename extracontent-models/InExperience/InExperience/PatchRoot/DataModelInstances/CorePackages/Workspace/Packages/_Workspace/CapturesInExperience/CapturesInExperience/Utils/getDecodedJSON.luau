local HttpService = game:GetService("HttpService")

local function getDecodedJSON(json: string)
	local success, result = pcall(function()
		return HttpService:JSONDecode(json)
	end)

	if success then
		return result
	end

	if _G.__TEST_SUITE_PACKAGE__ or _G.__TESTEZ_RUNNING_TEST__ then
		return nil
	end

	warn(debug.traceback("Failed to decode JSON: " .. json))
	return nil
end

return getDecodedJSON
