local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")
local User = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Thunks/User")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Cryo")
local fFlagFixPreviousAccountsListEntries = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagFixPreviousAccountsListEntries

return function()
	local v5 = User.fromLocalStorage()

	if v5 == nil or v5.userId == -1 or (v5.username == nil or v5.username == "") then
		return
	end

	local previousAccountsList = AppStorageUtilities.getPreviousAccountsList()
	local userId = tostring(v5.userId)
	local v6 = {
		username = v5.username,
		displayName = (not v5.displayName or v5.displayName == "nil") and "" or v5.displayName,
		timestamp = os.time()
	}

	if fFlagFixPreviousAccountsListEntries then
		v6.userId = userId
		previousAccountsList[userId] = Cryo.Dictionary.join(previousAccountsList[userId] or {}, v6)
	else
		previousAccountsList[userId] = v6
	end

	AppStorageUtilities.setPreviousAccountsList(previousAccountsList)
	AppStorageUtilities.flush()
end
