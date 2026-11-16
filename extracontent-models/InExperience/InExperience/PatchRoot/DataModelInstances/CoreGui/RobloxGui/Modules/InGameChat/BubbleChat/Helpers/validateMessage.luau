local CorePackages = game:GetService("CorePackages")

local t = require(CorePackages.Packages.t)
local Constants = require(script.Parent.Parent.Constants)
local maybeAssert = require(script.Parent.maybeAssert)

local function validateMessageText(p)
	maybeAssert(t.string(p))

	if utf8.len(p) == nil then
		return false
	end

	local v = utf8.len(utf8.nfcnormalize(p))

	if Constants.MAX_MESSAGE_LENGTH < v then
		return false, v
	end

	return true
end

return validateMessageText
