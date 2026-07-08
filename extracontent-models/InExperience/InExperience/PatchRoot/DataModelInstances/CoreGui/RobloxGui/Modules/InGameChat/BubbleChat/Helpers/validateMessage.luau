local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local Constants = require(script.Parent.Parent.Constants)
local maybeAssert = require(script.Parent.maybeAssert)

local function validateMessageText(p1) -- line: 15
	-- upvalues: maybeAssert (copy), t (copy), Constants (copy)
	maybeAssert(t.string(p1))

	if utf8.len(p1) == nil then
		return false
	end

	local v7 = utf8.len(utf8.nfcnormalize(p1))

	if v7 > Constants.MAX_MESSAGE_LENGTH then
		return false, v7
	end

	return true
end

return validateMessageText
