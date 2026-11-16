local AuthCommon = script:FindFirstAncestor("AuthCommon")
local LoginResult = require(AuthCommon.Models.LoginResult)
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
require(AuthCommon.Utils.PreviousAccountEntry)
local prunePreviousAccountsList = require(AuthCommon.Utils.prunePreviousAccountsList)
local parent = AuthCommon.Parent
local Cryo = require(parent.Cryo)

local function recordLogin(p, loginMethod: string, userIdentifier: string?): boolean
	if p.user.id == nil or p.user.id == "0" or (p.user.name == nil or p.user.name == "") then
		return false
	end

	local previousAccountsList = AppStorageUtilities.getPreviousAccountsList()

	if userIdentifier == nil then
		userIdentifier = p.user.name
	end

	local now = os.time()
	local twoStepData = LoginResult.hasTwoStepData(p)

	if twoStepData then
		now = nil
	end

	local v = {
		userId = p.user.id,
		userIdentifier = userIdentifier,
		loginMethod = loginMethod,
		username = p.user.name,
		signInTimestamp = now,
		showInAccountPicker = true
	}

	local previousAccount = previousAccountsList[p.user.id]

	if previousAccount == nil then
		previousAccountsList[p.user.id] = v
	else
		if not twoStepData then
			v.signOutTimestamp = Cryo.None
		end

		previousAccountsList[p.user.id] = Cryo.Dictionary.join(previousAccount, v)
	end

	AppStorageUtilities.setPreviousAccountsList(previousAccountsList)
	prunePreviousAccountsList()
	return true
end

return recordLogin
