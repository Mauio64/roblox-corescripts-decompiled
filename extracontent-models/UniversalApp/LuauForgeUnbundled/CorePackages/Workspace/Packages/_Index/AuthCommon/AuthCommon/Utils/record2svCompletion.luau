local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Cryo")

local function record2svCompletion(p2): boolean
	if p2 == nil or p2 == "0" then
		return false
	end

	local previousAccountsList = AppStorageUtilities.getPreviousAccountsList()
	local previousAccount = previousAccountsList[p2]

	if not previousAccount then
		return false
	end

	previousAccountsList[p2] = Cryo.Dictionary.join(previousAccount, {
		signInTimestamp = os.time()
	})
	AppStorageUtilities.setPreviousAccountsList(previousAccountsList)
	return true
end

return record2svCompletion
