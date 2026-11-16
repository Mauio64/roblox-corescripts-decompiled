local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent
local dependencies = require(Squads.dependencies)

local presenceType = dependencies.RoduxPresence.Enums.PresenceType

local FFlagSquadMemberJoinDialogAndOverflowMenu = require(Squads.Flags.FFlagSquadMemberJoinDialogAndOverflowMenu)
local Flags = require(parent.SquadsCore.Flags)
local FFlagSquadsPresenceStoreMigration = Flags.FFlagSquadsPresenceStoreMigration
local presenceType2

if FFlagSquadsPresenceStoreMigration then
	local DataHydration = require(parent.DataHydration)
	presenceType2 = DataHydration.Presence.PresenceEnums.PresenceType
else
	presenceType2 = nil
end

local function isPresenceJoinable(data): boolean
	if not data then
		return false
	end

	local v

	if FFlagSquadsPresenceStoreMigration then
		v = presenceType2.InGame
	else
		v = presenceType.InGame
	end

	if data.userPresenceType ~= v or data.gameId == game.JobId then
		return false
	end

	if FFlagSquadMemberJoinDialogAndOverflowMenu then
		return data.placeId ~= nil and data.placeId ~= ""
	elseif FFlagSquadsPresenceStoreMigration then
		return data.placeId ~= ""
	else
		return data.placeId ~= nil
	end
end

return isPresenceJoinable
