local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local AuthCommonParent = AuthCommon.Parent
local Cryo = require(AuthCommonParent.Cryo)
local v5 = game:DefineFastInt("DefaultMaxPruneAccounts", 50)

require(AuthCommon.Utils.PreviousAccountEntry)

local function prunePreviousAccountsList() -- line: 10
	-- upvalues: AppStorageUtilities (copy), Cryo (copy), v5 (copy)
	local v7 = AppStorageUtilities.getPreviousAccountsList()
	local v8 = Cryo.Dictionary.values(v7)
	local v9 = Cryo.List.filter(v8, function(p1) -- line: 13
		return p1.signOutTimestamp == nil
	end)
	local v10 = Cryo.List.filter(v8, function(p2) -- line: 16
		return p2.signOutTimestamp ~= nil
	end)

	if #v10 <= v5 then
		return true
	end

	local v11 = Cryo.List.sort(v10, function(p3, p4) -- line: 28
		return p3.signOutTimestamp > p4.signOutTimestamp
	end)
	local t1 = {}
	local n1 = 0

	for _, v in ipairs(v11) do
		if n1 >= v5 then
			break
		end

		if v.userId then
			t1[v.userId] = v
		end

		n1 += 1
	end

	for _, v in ipairs(v9) do
		if v.userId then
			t1[v.userId] = v
		end
	end

	AppStorageUtilities.setPreviousAccountsList(t1)

	return true
end

return prunePreviousAccountsList
