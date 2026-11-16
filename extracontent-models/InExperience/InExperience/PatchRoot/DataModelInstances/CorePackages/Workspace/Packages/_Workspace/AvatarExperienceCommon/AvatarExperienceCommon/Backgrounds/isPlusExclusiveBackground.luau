local getTemporaryPlusBackgroundIds = require(script.Parent.getTemporaryPlusBackgroundIds)

local function isPlusExclusiveBackground(p, flag: boolean?)
	if flag ~= nil then
		return flag
	end

	local temporaryPlusBackgroundIds, v = getTemporaryPlusBackgroundIds()

	if v then
		return p ~= nil
	end

	return p ~= nil and temporaryPlusBackgroundIds[tostring(p)] == true
end

return isPlusExclusiveBackground
