local SocialService = game:GetService("SocialService")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SharedFlags")

local validateSquadId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/validateSquadId")

local class = {}
class.__index = class

local fFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled

function class.new()
	return (setmetatable({ isLeaveSquadPending = false, lastFiredSquadId = "" }, class))
end

function class:setLeaveSquadPendingAndFireEvent(p2, p3)
	if self:_setLeaveSquadPending(p2) then
		self:fireSquadChangeEvent(nil, p3)
	end
end

function class:fireSquadChangeEvent(value, p2)
	local v5 = value or ""
	assert(v5 == "" or validateSquadId(v5), "Try to fire with wrong squadId")

	if v5 ~= "" then
		self:_setLeaveSquadPending(false)
	end

	if (not self.isLeaveSquadPending or v5 ~= "") and self.lastFiredSquadId ~= v5 then
		self.lastFiredSquadId = v5
		SocialService:UpdatePlayerPartyData(
			v5,
			if fFlagPartyDevAPIToRespectThirdPartySettingsEnabled then not p2 else nil
		)
	end
end

function class:_setLeaveSquadPending(isLeaveSquadPending): boolean
	if self.isLeaveSquadPending == isLeaveSquadPending then
		return false
	end

	self.isLeaveSquadPending = isLeaveSquadPending
	return true
end

class.default = class.new()
return class.default
