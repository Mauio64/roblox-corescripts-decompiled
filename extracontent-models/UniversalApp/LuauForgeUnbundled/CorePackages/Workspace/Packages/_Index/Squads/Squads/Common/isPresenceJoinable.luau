local presenceType = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies").RoduxPresence.Enums.PresenceType

local FFlagSquadMemberJoinDialogAndOverflowMenu = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadMemberJoinDialogAndOverflowMenu")
local fFlagSquadsPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Flags").FFlagSquadsPresenceStoreMigration
local presenceType2

if fFlagSquadsPresenceStoreMigration then
	presenceType2 = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/DataHydration").Presence.PresenceEnums.PresenceType
else
	presenceType2 = nil
end

local function isPresenceJoinable(data): boolean
	if not data then
		return false
	end

	local v5 = if fFlagSquadsPresenceStoreMigration then presenceType2.InGame else presenceType.InGame

	if data.userPresenceType ~= v5 or data.gameId == game.JobId then
		return false
	end

	if FFlagSquadMemberJoinDialogAndOverflowMenu then
		return data.placeId ~= nil and data.placeId ~= ""
	elseif fFlagSquadsPresenceStoreMigration then
		return data.placeId ~= ""
	else
		return data.placeId ~= nil
	end
end

return isPresenceJoinable
