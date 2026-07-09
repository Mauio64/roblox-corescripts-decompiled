local AuthCommon = script:FindFirstAncestor("AuthCommon")
local LoginResult = require(AuthCommon.Models.LoginResult)
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)

require(AuthCommon.Utils.PreviousAccountEntry)

local prunePreviousAccountsList = require(AuthCommon.Utils.prunePreviousAccountsList)
local AuthCommonParent = AuthCommon.Parent
local Cryo = require(AuthCommonParent.Cryo)

local function recordLogin(p1, s1: string, s2: string?) -- line: 10
	-- upvalues: AppStorageUtilities (copy), LoginResult (copy), Cryo (copy), prunePreviousAccountsList (copy)
	if p1.user.id == nil or p1.user.id == "0" then
		return false
	end

	if p1.user.name == nil or p1.user.name == "" then
		return false
	end

	local v11 = AppStorageUtilities.getPreviousAccountsList()

	if s2 == nil then
		s2 = p1.user.name
	end

	local timestamp = os.time()
	local v13 = LoginResult.hasTwoStepData(p1)

	if v13 then
		timestamp = nil
	end

	local t1 = {
		showInAccountPicker = true,
		userId = p1.user.id,
		userIdentifier = s2,
		loginMethod = s1,
		username = p1.user.name,
		signInTimestamp = timestamp
	}
	local v15 = v11[p1.user.id]

	if v15 ~= nil then
		if not v13 then
			t1.signOutTimestamp = Cryo.None
		end

		v11[p1.user.id] = Cryo.Dictionary.join(v15, t1)
	else
		v11[p1.user.id] = t1
	end

	AppStorageUtilities.setPreviousAccountsList(v11)
	prunePreviousAccountsList()

	return true
end

return recordLogin
