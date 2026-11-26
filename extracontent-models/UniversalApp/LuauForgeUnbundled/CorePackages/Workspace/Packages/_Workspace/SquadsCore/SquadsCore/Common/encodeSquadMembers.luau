local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Cryo")

local encodeUserIds = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/encodeUserIds")

local function encodeSquadMembers(options)
	return encodeUserIds((Cryo.List.map(options or {}, function(p2)
		return p2.userId
	end)))
end

return encodeSquadMembers
