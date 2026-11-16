local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local Cryo = require(parent.Cryo)

local function record2svCompletion(p: string): boolean
	if p == nil or p == "0" then
		return false
	end

	local previousAccountsList = AppStorageUtilities.getPreviousAccountsList()
	local previousAccount = previousAccountsList[p]

	if not previousAccount then
		return false
	end

	previousAccountsList[p] = Cryo.Dictionary.join(previousAccount, { signInTimestamp = os.time() })
	AppStorageUtilities.setPreviousAccountsList(previousAccountsList)
	return true
end

return record2svCompletion
