local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)

require(AuthCommon.Utils.PreviousAccountEntry)

local User = require(AuthCommon.Thunks.User)
local AuthCommonParent = AuthCommon.Parent
local Cryo = require(AuthCommonParent.Cryo)
local prunePreviousAccountsList = require(AuthCommon.Utils.prunePreviousAccountsList)

local function recordSignOut(t1: {[any]: any}?, b1: boolean?) -- line: 16
	-- upvalues: User (copy), AppStorageUtilities (copy), Cryo (copy), prunePreviousAccountsList (copy)
	local v10 = b1 or true
	local v11

	if not t1 then
		v11 = User.fromLocalStorage()

		if v11 == nil or v11.userId == -1 then
			return
		end

		if v11.username == nil or v11.username == "" then
			return
		end
	else
		v11 = {
			userId = t1.user_id,
			username = t1.username,
			displayName = t1.display_name
		}
	end

	local v12 = AppStorageUtilities.getPreviousAccountsList()
	local str = tostring(v11.userId)
	local v14 = v12[str]

	if v14 then
		v12[str] = Cryo.Dictionary.join(v14, {
			userId = str,
			username = v11.username,
			displayName = (not v11.displayName or v11.displayName == "nil") and "" or v11.displayName,
			signOutTimestamp = os.time(),
			showInAccountPicker = v10
		})
		AppStorageUtilities.setPreviousAccountsList(v12)
		prunePreviousAccountsList()

		return true
	end

	v12[str] = {
		loginMethod = nil,
		signInTimestamp = nil,
		userId = str,
		username = v11.username,
		userIdentifier = v11.username,
		displayName = (not v11.displayName or v11.displayName == "nil") and "" or v11.displayName,
		signOutTimestamp = os.time(),
		showInAccountPicker = v10
	}
	AppStorageUtilities.setPreviousAccountsList(v12)
	prunePreviousAccountsList()

	return true
end

return recordSignOut
