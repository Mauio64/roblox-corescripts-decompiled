local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)

require(AuthCommon.Utils.PreviousAccountEntry)

local AuthCommonParent = AuthCommon.Parent
local Cryo = require(AuthCommonParent.Cryo)
local GetFFlagShowInvoluntarilySignedOutAccounts = require(AuthCommonParent.SharedFlags).GetFFlagShowInvoluntarilySignedOutAccounts

local function subarray(p1, p2, p3) -- line: 12
	local t1 = {}

	for i = p2, p3 do
		table.insert(t1, p1[i])
	end

	return t1
end
local function getSignedOutAccounts(n1: number, t2: {[any]: any}?, b1: boolean?) -- line: 20
	-- upvalues: AppStorageUtilities (copy), GetFFlagShowInvoluntarilySignedOutAccounts (copy), Cryo (copy)
	local v16 = AppStorageUtilities.getPreviousAccountsList()
	local v17 = GetFFlagShowInvoluntarilySignedOutAccounts()
	local v18 = Cryo.Dictionary.values(v16)
	local v19 = Cryo.List.filter(v18, function(p4) -- line: 29
		-- upvalues: v17 (copy), t2 (copy), b1 (copy)
		if not v17 then
			return p4.signOutTimestamp
		end

		local v24 = t2 ~= nil and (p4.userId ~= nil and t2[p4.userId] == true)
		local v25 = b1 == true and p4.showInAccountPicker == false

		return not v24 and not v25
	end)
	local v20 = if not v17 then Cryo.List.sort(v19, function(p5, p6) -- line: 52
		return p5.signOutTimestamp > p6.signOutTimestamp
	end) else Cryo.List.sort(v19, function(p7, p8) -- line: 43
		return (p7.signOutTimestamp or (p7.signInTimestamp or 0)) > (p8.signOutTimestamp or (p8.signInTimestamp or 0))
	end)

	if v20 then
		local t3 = {}

		for i = 1, math.min(n1, #v20) do
			table.insert(t3, v20[i])
		end

		return t3
	end

	return {}
end

return getSignedOutAccounts
