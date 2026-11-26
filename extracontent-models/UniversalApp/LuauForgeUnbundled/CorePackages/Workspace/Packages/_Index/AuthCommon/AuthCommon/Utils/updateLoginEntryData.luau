local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Cryo")

local function updateLoginEntryData(p2, p3): boolean
	local previousAccountsList = AppStorageUtilities.getPreviousAccountsList()
	local previousAccount = previousAccountsList[p2]

	if previousAccount then
		previousAccountsList[p2] = Cryo.Dictionary.join(previousAccount, p3)
	end

	AppStorageUtilities.setPreviousAccountsList(previousAccountsList)
	return true
end

return updateLoginEntryData
