local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")
require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/PreviousAccountEntry")
local User = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Thunks/User")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Cryo")
local prunePreviousAccountsList = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/prunePreviousAccountsList")

local function recordSignOut(data, p2)
	local v5 = p2 or true
	local v6

	if data then
		v6 = {
			userId = data.user_id,
			username = data.username,
			displayName = data.display_name
		}
	else
		v6 = User.fromLocalStorage()

		if v6 == nil or v6.userId == -1 or (v6.username == nil or v6.username == "") then
			return
		end
	end

	local previousAccountsList = AppStorageUtilities.getPreviousAccountsList()
	local userId = tostring(v6.userId)
	local previousAccount = previousAccountsList[userId]

	if previousAccount then
		previousAccountsList[userId] = Cryo.Dictionary.join(previousAccount, {
			userId = userId,
			username = v6.username,
			displayName = (not v6.displayName or v6.displayName == "nil") and "" or v6.displayName,
			signOutTimestamp = os.time(),
			showInAccountPicker = v5
		})
	else
		previousAccountsList[userId] = {
			userId = userId,
			username = v6.username,
			userIdentifier = v6.username,
			loginMethod = nil,
			signInTimestamp = nil,
			displayName = (not v6.displayName or v6.displayName == "nil") and "" or v6.displayName,
			signOutTimestamp = os.time(),
			showInAccountPicker = v5
		}
	end

	AppStorageUtilities.setPreviousAccountsList(previousAccountsList)
	prunePreviousAccountsList()
	return true
end

return recordSignOut
