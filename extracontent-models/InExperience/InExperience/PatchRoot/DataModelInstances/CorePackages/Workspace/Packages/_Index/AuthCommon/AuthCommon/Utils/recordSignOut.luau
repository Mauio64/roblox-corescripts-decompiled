local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
require(AuthCommon.Utils.PreviousAccountEntry)
local User = require(AuthCommon.Thunks.User)
local parent = AuthCommon.Parent
local Cryo = require(parent.Cryo)
local prunePreviousAccountsList = require(AuthCommon.Utils.prunePreviousAccountsList)

local function recordSignOut(data, flag: boolean?)
	local showInAccountPicker = flag or true
	local v

	if data then
		v = { userId = data.user_id, username = data.username, displayName = data.display_name }
	else
		v = User.fromLocalStorage()

		if v == nil or v.userId == -1 or (v.username == nil or v.username == "") then
			return
		end
	end

	local previousAccountsList = AppStorageUtilities.getPreviousAccountsList()
	local userId = tostring(v.userId)
	local previousAccount = previousAccountsList[userId]

	if previousAccount then
		previousAccountsList[userId] = Cryo.Dictionary.join(previousAccount, {
			userId = userId,
			username = v.username,
			displayName = (not v.displayName or v.displayName == "nil") and "" or v.displayName,
			signOutTimestamp = os.time(),
			showInAccountPicker = showInAccountPicker
		})
	else
		previousAccountsList[userId] = {
			userId = userId,
			username = v.username,
			userIdentifier = v.username,
			loginMethod = nil,
			signInTimestamp = nil,
			displayName = (not v.displayName or v.displayName == "nil") and "" or v.displayName,
			signOutTimestamp = os.time(),
			showInAccountPicker = showInAccountPicker
		}
	end

	AppStorageUtilities.setPreviousAccountsList(previousAccountsList)
	prunePreviousAccountsList()
	return true
end

return recordSignOut
