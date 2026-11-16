local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local parent = AuthCommon.Parent
local Cryo = require(parent.Cryo)

local function updateLoginEntryData(p: string, p2): boolean
	local previousAccountsList = AppStorageUtilities.getPreviousAccountsList()
	local previousAccount = previousAccountsList[p]

	if previousAccount then
		previousAccountsList[p] = Cryo.Dictionary.join(previousAccount, p2)
	end

	AppStorageUtilities.setPreviousAccountsList(previousAccountsList)
	return true
end

return updateLoginEntryData
