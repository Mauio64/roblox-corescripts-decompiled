local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)

return function(s1: string) -- line: 4
	-- upvalues: AppStorageUtilities (copy)
	local v4 = AppStorageUtilities.getPreviousAccountsList()

	if v4[s1] ~= nil then
		v4[s1] = nil
		AppStorageUtilities.setPreviousAccountsList(v4)
		AppStorageUtilities.flush()
	end
end
