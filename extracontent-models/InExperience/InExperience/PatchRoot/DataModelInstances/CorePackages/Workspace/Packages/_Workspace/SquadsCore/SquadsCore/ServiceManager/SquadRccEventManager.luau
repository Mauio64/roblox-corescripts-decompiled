local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local SocialService = game:GetService("SocialService")
local SharedFlags = require(SquadsCoreParent.SharedFlags)
local validateSquadId = require(SquadsCore.Common.validateSquadId)
local t1 = {}

t1.__index = t1

local FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled

function t1.new() -- line: 29
	-- upvalues: t1 (copy)
	return (setmetatable({
		isLeaveSquadPending = false,
		lastFiredSquadId = ""
	}, t1))
end
function t1.setLeaveSquadPendingAndFireEvent(t2: {[any]: any}, b1: boolean, b2: boolean) -- line: 40
	if t2:_setLeaveSquadPending(b1) then
		t2:fireSquadChangeEvent(nil, b2)
	end
end
function t1.fireSquadChangeEvent(t3: {[any]: any}, s1: string?, b3: boolean) -- line: 46
	-- upvalues: validateSquadId (copy), SocialService (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy)
	local v14 = s1 or ""

	assert(v14 == "" or validateSquadId(v14), "Try to fire with wrong squadId")

	if v14 ~= "" then
		t3:_setLeaveSquadPending(false)
	end

	if (not t3.isLeaveSquadPending or v14 ~= "") and v14 ~= t3.lastFiredSquadId then
		t3.lastFiredSquadId = v14
		SocialService:UpdatePlayerPartyData(v14, if not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled then nil else not b3)
	end
end
function t1._setLeaveSquadPending(t4: {[any]: any}, b4: boolean) -- line: 63
	if b4 ~= t4.isLeaveSquadPending then
		t4.isLeaveSquadPending = b4

		return true
	end

	return false
end

t1.default = t1.new()

return t1.default
