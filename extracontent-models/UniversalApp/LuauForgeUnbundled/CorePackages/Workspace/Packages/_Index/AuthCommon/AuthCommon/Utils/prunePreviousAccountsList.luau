local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Cryo")
local defineFastInt = game:DefineFastInt("DefaultMaxPruneAccounts", 50)
require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/PreviousAccountEntry")

local function prunePreviousAccountsList(): boolean
	local previousAccountsList = AppStorageUtilities.getPreviousAccountsList()
	local values = Cryo.Dictionary.values(previousAccountsList)
	local filtered = Cryo.List.filter(values, function(p2): boolean
		return p2.signOutTimestamp == nil
	end)

	local filtered2 = Cryo.List.filter(values, function(p2): boolean
		return p2.signOutTimestamp ~= nil
	end)

	if #filtered2 <= defineFastInt then
		return true
	end

	local sorted = Cryo.List.sort(filtered2, function(p2, p3): boolean
		return p2.signOutTimestamp > p3.signOutTimestamp
	end)
	local count = 0
	local v5 = {}

	for i, v6 in ipairs(sorted) do
		if defineFastInt <= count then
			break
		end

		if v6.userId then
			v5[v6.userId] = v6
		end

		count += 1
	end

	for i, v6 in ipairs(filtered) do
		if v6.userId then
			v5[v6.userId] = v6
		end
	end

	AppStorageUtilities.setPreviousAccountsList(v5)
	return true
end

return prunePreviousAccountsList
