local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local AuthCommonParent = AuthCommon.Parent
local Cryo = require(AuthCommonParent.Cryo)

local function updateLoginEntryData(s1: string, t1: {[any]: any}) -- line: 7
	-- upvalues: AppStorageUtilities (copy), Cryo (copy)
	local v8 = AppStorageUtilities.getPreviousAccountsList()
	local v9 = v8[s1]

	if v9 then
		v8[s1] = Cryo.Dictionary.join(v9, t1)
	end

	AppStorageUtilities.setPreviousAccountsList(v8)

	return true
end

return updateLoginEntryData
