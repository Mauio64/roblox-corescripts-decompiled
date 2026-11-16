local Gifting = script:FindFirstAncestor("Gifting")

local FailureReason = require(Gifting.Enums.FailureReason)

local function expectInvalidRequest(callback, object)
	local success, result = pcall(function()
		object:expect()
	end)

	callback(success).toBe(false)
	assert(type(result) == "table", `expected a formatted gift error, got {typeof(result)}`)
	callback(result.failureReason).toBe(FailureReason.InvalidInput)
	callback((type(result.errorMessage))).toBe("string")
end

return expectInvalidRequest
