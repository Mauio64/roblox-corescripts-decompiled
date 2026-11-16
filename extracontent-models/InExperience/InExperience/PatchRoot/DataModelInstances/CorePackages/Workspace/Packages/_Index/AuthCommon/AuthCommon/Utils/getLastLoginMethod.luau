local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)

local function getLastLoginMethod(p: string)
	local previousAccountsList = AppStorageUtilities.getPreviousAccountsList()

	for _, previousAccount in previousAccountsList do
		if previousAccount.userIdentifier == p then
			return previousAccount.loginMethod
		end
	end

	return nil
end

return getLastLoginMethod
