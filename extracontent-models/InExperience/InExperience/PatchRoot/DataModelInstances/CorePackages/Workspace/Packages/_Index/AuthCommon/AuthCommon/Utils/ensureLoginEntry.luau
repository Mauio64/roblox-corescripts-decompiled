local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
require(AuthCommon.Utils.PreviousAccountEntry)
local prunePreviousAccountsList = require(AuthCommon.Utils.prunePreviousAccountsList)
local parent = AuthCommon.Parent
local Cryo = require(parent.Cryo)
local SharedFlags = require(parent.SharedFlags)
local FFlagFixPreviousAccountsListEntries = SharedFlags.FFlagFixPreviousAccountsListEntries

local function ensureLoginEntry(userId: string, p): boolean
	if userId == nil or userId == "" or userId == "0" or userId == "-1" then
		return false
	end

	if p.username == nil or p.username == "" then
		return false
	end

	local displayName

	if p.displayName and p.displayName ~= "nil" then
		displayName = p.displayName
	end

	local previousAccountsList = AppStorageUtilities.getPreviousAccountsList()
	local previousAccount = previousAccountsList[userId]

	if previousAccount then
		local v = { username = p.username, displayName = displayName }

		if FFlagFixPreviousAccountsListEntries then
			v.userId = userId
		end

		previousAccountsList[userId] = Cryo.Dictionary.join(previousAccount, v)
		AppStorageUtilities.setPreviousAccountsList(previousAccountsList)
		return true
	end

	previousAccountsList[userId] = {
		userId = userId,
		userIdentifier = p.username,
		username = p.username,
		displayName = displayName,
		signInTimestamp = os.time(),
		showInAccountPicker = true
	}
	AppStorageUtilities.setPreviousAccountsList(previousAccountsList)
	prunePreviousAccountsList()
	return true
end

return ensureLoginEntry
