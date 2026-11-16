local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local SocialService = game:GetService("SocialService")

local SharedFlags = require(parent.SharedFlags)

local validateSquadId = require(SquadsCore.Common.validateSquadId)

local class = {}
class.__index = class

local FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled

function class.new()
	return (setmetatable({ isLeaveSquadPending = false, lastFiredSquadId = "" }, class))
end

function class:setLeaveSquadPendingAndFireEvent(flag: boolean, flag2: boolean)
	if self:_setLeaveSquadPending(flag) then
		self:fireSquadChangeEvent(nil, flag2)
	end
end

function class:fireSquadChangeEvent(value: string?, flag: boolean)
	local lastFiredSquadId = value or ""
	assert(lastFiredSquadId == "" or validateSquadId(lastFiredSquadId), "Try to fire with wrong squadId")

	if lastFiredSquadId ~= "" then
		self:_setLeaveSquadPending(false)
	end

	if (not self.isLeaveSquadPending or lastFiredSquadId ~= "") and self.lastFiredSquadId ~= lastFiredSquadId then
		self.lastFiredSquadId = lastFiredSquadId
		local v

		if FFlagPartyDevAPIToRespectThirdPartySettingsEnabled then
			v = not flag
		end

		SocialService:UpdatePlayerPartyData(lastFiredSquadId, v)
	end
end

function class:_setLeaveSquadPending(isLeaveSquadPending: boolean): boolean
	if self.isLeaveSquadPending == isLeaveSquadPending then
		return false
	end

	self.isLeaveSquadPending = isLeaveSquadPending
	return true
end

class.default = class.new()
return class.default
