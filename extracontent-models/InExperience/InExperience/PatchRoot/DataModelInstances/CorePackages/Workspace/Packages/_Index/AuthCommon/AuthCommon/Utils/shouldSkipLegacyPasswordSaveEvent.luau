local AuthCommon = script:FindFirstAncestor("AuthCommon")

local isIosAuthServiceEnabled = require(AuthCommon.Utils.isIosAuthServiceEnabled)

local function shouldSkipLegacyPasswordSaveEvent(flag: boolean)
	return flag and isIosAuthServiceEnabled()
end

return shouldSkipLegacyPasswordSaveEvent
