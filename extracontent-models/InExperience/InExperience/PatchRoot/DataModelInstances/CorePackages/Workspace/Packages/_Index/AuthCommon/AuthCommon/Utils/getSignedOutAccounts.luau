local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
require(AuthCommon.Utils.PreviousAccountEntry)
local parent = AuthCommon.Parent
local Cryo = require(parent.Cryo)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagShowInvoluntarilySignedOutAccounts = SharedFlags.GetFFlagShowInvoluntarilySignedOutAccounts
local SharedFlags2 = require(parent.SharedFlags)
local FFlagFixPreviousAccountsListEntries = SharedFlags2.FFlagFixPreviousAccountsListEntries

local function subarray(list, p, p2)
	local result = {}

	for i = p, p2 do
		table.insert(result, list[i])
	end

	return result
end

local function getSignedOutAccounts(p: number, p2, flag: boolean?)
	local previousAccountsList = AppStorageUtilities.getPreviousAccountsList()
	local fFlagShowInvoluntarilySignedOutAccounts = GetFFlagShowInvoluntarilySignedOutAccounts()

	local values = Cryo.Dictionary.values(previousAccountsList)
	local filtered = Cryo.List.filter(values, function(data)
		if FFlagFixPreviousAccountsListEntries then
			local userId = data.userId

			if userId == nil or userId == "" then
				return false
			end
		end

		if not fFlagShowInvoluntarilySignedOutAccounts then
			return data.signOutTimestamp
		end

		local v

		if p2 == nil or data.userId == nil then
			v = false
		else
			v = p2[data.userId] == true
		end

		local v2 = flag == true and data.showInAccountPicker == false
		return not (v or v2)
	end)
	local sorted

	if fFlagShowInvoluntarilySignedOutAccounts then
		sorted = Cryo.List.sort(filtered, function(p3, p4): boolean
			return (p3.signOutTimestamp or p3.signInTimestamp or 0) > (p4.signOutTimestamp or p4.signInTimestamp or 0)
		end)
	else
		sorted = Cryo.List.sort(filtered, function(p3, p4): boolean
			return p3.signOutTimestamp > p4.signOutTimestamp
		end)
	end

	if not sorted then
		return {}
	end

	local result = {}

	for i = 1, math.min(p, #sorted) do
		table.insert(result, sorted[i])
	end

	return result
end

return getSignedOutAccounts
