local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)

return function(p: string)
	local previousAccountsList = AppStorageUtilities.getPreviousAccountsList()

	if previousAccountsList[p] ~= nil then
		previousAccountsList[p] = nil
		AppStorageUtilities.setPreviousAccountsList(previousAccountsList)
		AppStorageUtilities.flush()
	end
end
