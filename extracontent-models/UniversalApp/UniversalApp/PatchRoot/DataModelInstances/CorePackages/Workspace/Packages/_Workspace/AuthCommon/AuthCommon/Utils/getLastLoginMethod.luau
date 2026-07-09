local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)

local function getLastLoginMethod(s1: string) -- line: 5
	-- upvalues: AppStorageUtilities (copy)
	for _, v6 in (AppStorageUtilities.getPreviousAccountsList()) do
		if s1 == v6.userIdentifier then
			return v6.loginMethod
		end
	end

	return nil
end

return getLastLoginMethod
