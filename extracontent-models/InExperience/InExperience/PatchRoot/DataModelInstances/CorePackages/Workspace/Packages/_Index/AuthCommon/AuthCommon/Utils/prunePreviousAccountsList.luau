local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local parent = AuthCommon.Parent
local Cryo = require(parent.Cryo)
local defineFastInt = game:DefineFastInt("DefaultMaxPruneAccounts", 50)
require(AuthCommon.Utils.PreviousAccountEntry)

local function prunePreviousAccountsList(): boolean
	local previousAccountsList = AppStorageUtilities.getPreviousAccountsList()
	local values = Cryo.Dictionary.values(previousAccountsList)
	local filtered = Cryo.List.filter(values, function(p): boolean
		return p.signOutTimestamp == nil
	end)

	local filtered2 = Cryo.List.filter(values, function(p): boolean
		return p.signOutTimestamp ~= nil
	end)

	if #filtered2 <= defineFastInt then
		return true
	end

	local sorted = Cryo.List.sort(filtered2, function(p, p2): boolean
		return p.signOutTimestamp > p2.signOutTimestamp
	end)
	local count = 0
	local v = {}

	for _, v2 in ipairs(sorted) do
		if defineFastInt <= count then
			break
		end

		if v2.userId then
			v[v2.userId] = v2
		end

		count += 1
	end

	for _, v2 in ipairs(filtered) do
		if v2.userId then
			v[v2.userId] = v2
		end
	end

	AppStorageUtilities.setPreviousAccountsList(v)
	return true
end

return prunePreviousAccountsList
