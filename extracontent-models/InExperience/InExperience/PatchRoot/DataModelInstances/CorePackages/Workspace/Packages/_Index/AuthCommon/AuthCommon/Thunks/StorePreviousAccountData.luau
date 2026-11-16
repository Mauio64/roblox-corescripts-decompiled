local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local User = require(AuthCommon.Thunks.User)
local parent = AuthCommon.Parent
local Cryo = require(parent.Cryo)
local SharedFlags = require(parent.SharedFlags)
local FFlagFixPreviousAccountsListEntries = SharedFlags.FFlagFixPreviousAccountsListEntries

return function()
	local v = User.fromLocalStorage()

	if v == nil or v.userId == -1 or (v.username == nil or v.username == "") then
		return
	end

	local previousAccountsList = AppStorageUtilities.getPreviousAccountsList()
	local userId = tostring(v.userId)
	local v2 = {
		username = v.username,
		displayName = (not v.displayName or v.displayName == "nil") and "" or v.displayName,
		timestamp = os.time()
	}

	if FFlagFixPreviousAccountsListEntries then
		v2.userId = userId
		previousAccountsList[userId] = Cryo.Dictionary.join(previousAccountsList[userId] or {}, v2)
	else
		previousAccountsList[userId] = v2
	end

	AppStorageUtilities.setPreviousAccountsList(previousAccountsList)
	AppStorageUtilities.flush()
end
