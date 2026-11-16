local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")
require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/PreviousAccountEntry")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Cryo")

local getFFlagShowInvoluntarilySignedOutAccounts = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagShowInvoluntarilySignedOutAccounts
local fFlagFixPreviousAccountsListEntries = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagFixPreviousAccountsListEntries

local function subarray(list, p2, p3)
	local result = {}

	for i = p2, p3 do
		table.insert(result, list[i])
	end

	return result
end

local function getSignedOutAccounts(p2, p3, p4)
	local previousAccountsList = AppStorageUtilities.getPreviousAccountsList()
	local fFlagShowInvoluntarilySignedOutAccounts = getFFlagShowInvoluntarilySignedOutAccounts()

	local values = Cryo.Dictionary.values(previousAccountsList)
	local filtered = Cryo.List.filter(values, function(data)
		if fFlagFixPreviousAccountsListEntries then
			local userId = data.userId

			if userId == nil or userId == "" then
				return false
			end
		end

		if not fFlagShowInvoluntarilySignedOutAccounts then
			return data.signOutTimestamp
		end

		local v5 = not (p3 == nil or data.userId == nil) and p3[data.userId] == true
		local v6 = p4 == true and data.showInAccountPicker == false
		return not (v5 or v6)
	end)
	local sorted

	if fFlagShowInvoluntarilySignedOutAccounts then
		sorted = Cryo.List.sort(filtered, function(p5, p6): boolean
			return (p5.signOutTimestamp or p5.signInTimestamp or 0) > (p6.signOutTimestamp or p6.signInTimestamp or 0)
		end)
	else
		sorted = Cryo.List.sort(filtered, function(p5, p6): boolean
			return p5.signOutTimestamp > p6.signOutTimestamp
		end)
	end

	if not sorted then
		return {}
	end

	local result = {}

	for i = 1, math.min(p2, #sorted) do
		table.insert(result, sorted[i])
	end

	return result
end

return getSignedOutAccounts
