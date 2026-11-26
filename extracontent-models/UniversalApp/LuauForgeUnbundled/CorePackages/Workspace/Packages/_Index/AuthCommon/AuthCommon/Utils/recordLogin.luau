local LoginResult = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Models/LoginResult")
local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")
require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/PreviousAccountEntry")
local prunePreviousAccountsList = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/prunePreviousAccountsList")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Cryo")

local function recordLogin(p2, p3, p4): boolean
	if p2.user.id == nil or p2.user.id == "0" or (p2.user.name == nil or p2.user.name == "") then
		return false
	end

	local previousAccountsList = AppStorageUtilities.getPreviousAccountsList()

	if p4 == nil then
		p4 = p2.user.name
	end

	local now = os.time()
	local twoStepData = LoginResult.hasTwoStepData(p2)

	if twoStepData then
		now = nil
	end

	local v5 = {
		userId = p2.user.id,
		userIdentifier = p4,
		loginMethod = p3,
		username = p2.user.name,
		signInTimestamp = now,
		showInAccountPicker = true
	}

	local previousAccount = previousAccountsList[p2.user.id]

	if previousAccount == nil then
		previousAccountsList[p2.user.id] = v5
	else
		if not twoStepData then
			v5.signOutTimestamp = Cryo.None
		end

		previousAccountsList[p2.user.id] = Cryo.Dictionary.join(previousAccount, v5)
	end

	AppStorageUtilities.setPreviousAccountsList(previousAccountsList)
	prunePreviousAccountsList()
	return true
end

return recordLogin
