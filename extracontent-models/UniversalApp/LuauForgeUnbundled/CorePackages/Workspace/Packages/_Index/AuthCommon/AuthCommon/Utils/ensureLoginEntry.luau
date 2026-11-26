local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")
require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/PreviousAccountEntry")
local prunePreviousAccountsList = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/prunePreviousAccountsList")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Cryo")
local fFlagFixPreviousAccountsListEntries = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagFixPreviousAccountsListEntries

local function ensureLoginEntry(userId, p2): boolean
	if userId == nil or userId == "" or userId == "0" or userId == "-1" then
		return false
	end

	if p2.username == nil or p2.username == "" then
		return false
	end

	local displayName = if p2.displayName and p2.displayName ~= "nil" then p2.displayName else nil

	local previousAccountsList = AppStorageUtilities.getPreviousAccountsList()
	local previousAccount = previousAccountsList[userId]

	if previousAccount then
		local v5 = { username = p2.username, displayName = displayName }

		if fFlagFixPreviousAccountsListEntries then
			v5.userId = userId
		end

		previousAccountsList[userId] = Cryo.Dictionary.join(previousAccount, v5)
		AppStorageUtilities.setPreviousAccountsList(previousAccountsList)
		return true
	end

	previousAccountsList[userId] = {
		userId = userId,
		userIdentifier = p2.username,
		username = p2.username,
		displayName = displayName,
		signInTimestamp = os.time(),
		showInAccountPicker = true
	}
	AppStorageUtilities.setPreviousAccountsList(previousAccountsList)
	prunePreviousAccountsList()
	return true
end

return ensureLoginEntry
