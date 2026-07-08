local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local Cryo = require(AuthCommonParent.Cryo)

local function record2svCompletion(s1: string) -- line: 7
	-- upvalues: AppStorageUtilities (copy), Cryo (copy)
	if s1 == nil or s1 == "0" then
		return false
	end

	local v7 = AppStorageUtilities.getPreviousAccountsList()
	local v8 = v7[s1]

	if v8 then
		v7[s1] = Cryo.Dictionary.join(v8, {
			signInTimestamp = os.time()
		})
		AppStorageUtilities.setPreviousAccountsList(v7)

		return true
	end

	return false
end

return record2svCompletion
