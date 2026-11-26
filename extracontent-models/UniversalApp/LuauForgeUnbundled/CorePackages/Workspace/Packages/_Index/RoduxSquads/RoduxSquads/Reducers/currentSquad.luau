local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/Cryo")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/Rodux")
local currentSquadUpdated = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Actions").CurrentSquadUpdated
local selfPermissionUpdated = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Actions").SelfPermissionUpdated
local squadModel = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Models").SquadModel
local PersistStorage = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Persists/PersistStorage")
local createPersistReducer = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Persists/PersistReducer").createPersistReducer

require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/RoduxSquadsTypes")

local fFlagEnableSquadRegroupExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/SharedFlags").FFlagEnableSquadRegroupExperimentation

return function(p2)
	local networkingSquads = p2.NetworkingSquads
	local function fn(data, formatted)
		if data == nil or data.squadId ~= formatted.squadId then
			if formatted.deletedAtTime and formatted.deletedAtTime ~= "" then
				return data
			end

			if
				not data
				or data.parentChannelId ~= formatted.parentChannelId
				or data.createdAtTime < formatted.createdAtTime
			then
				return formatted
			end
		else
			if formatted.deletedAtTime and formatted.deletedAtTime ~= "" then
				return nil
			end

			if data.updatedAtTime < formatted.updatedAtTime then
				return formatted
			end

			if data.updatedAtTime == formatted.updatedAtTime then
				if data.parentChannelId ~= formatted.parentChannelId then
					return formatted
				end

				local sorted = Cryo.List.sort(Cryo.List.map(data.members, function(p3)
					return p3.userId
				end))

				local sorted2 = Cryo.List.sort(Cryo.List.map(formatted.members, function(p3)
					return p3.userId
				end))

				local sorted3 = Cryo.List.sort(Cryo.List.map(data.invitees, function(p3)
					return tostring(p3.userId) .. tostring(p3.invitedAtTimestampMs)
				end))

				local sorted4 = Cryo.List.sort(Cryo.List.map(formatted.invitees, function(p3)
					return tostring(p3.userId) .. tostring(p3.invitedAtTimestampMs)
				end))

				if not (Cryo.List.equals(sorted, sorted2) and Cryo.List.equals(sorted3, sorted4)) then
					return formatted
				end

				if fFlagEnableSquadRegroupExperimentation then
					local selfPermissions = data.selfPermissions
					local selfPermissions2 = formatted.selfPermissions

					if
						(selfPermissions == nil) ~= (selfPermissions2 == nil)
						or selfPermissions
						and selfPermissions2
						and not Cryo.Dictionary.equals(selfPermissions, selfPermissions2)
					then
						return formatted
					end
				end
			end
		end

		return data
	end

	return createPersistReducer(
		Cryo.Dictionary.join({
			storage = PersistStorage.new("currentSquadStore")
		}, p2.currentSquad or {}),
		Rodux.createReducer(nil, {
			[networkingSquads.CreateOrJoinSquad.Succeeded.name] = function(p3, p4)
				local groupUp = p4.responseBody.groupUp
				return fn(p3, squadModel.format(groupUp))
			end,
			[networkingSquads.GetSquadActive.Succeeded.name] = function(p3, p4)
				local groupUp = p4.responseBody.groupUp

				if groupUp then
					return fn(p3, squadModel.format(groupUp))
				end

				return nil
			end,
			[networkingSquads.GetSquadFromSquadId.Succeeded.name] = function(p3, p4)
				local groupUp = p4.responseBody.groupUp
				local squadId = p3 and p3.squadId

				if groupUp and groupUp.groupUpId == squadId then
					return fn(p3, squadModel.format(groupUp))
				end

				return p3
			end,
			[networkingSquads.JoinSquad.Succeeded.name] = function(p3, p4)
				local groupUp = p4.responseBody.groupUp
				return fn(p3, squadModel.format(groupUp))
			end,
			[networkingSquads.LeaveSquad.Succeeded.name] = function(p3, p4)
				local groupUpId = p4.postBody.groupUpId

				if p3 and p3.squadId == groupUpId then
					return nil
				end

				return p3
			end,
			[networkingSquads.ActOnPartyNudge.Succeeded.name] = function(p3, p4)
				local groupUp = p4.responseBody.groupUp

				if groupUp then
					return fn(p3, squadModel.format(groupUp))
				end

				return p3
			end,
			[currentSquadUpdated.name] = function(p3, p4)
				local squad = p4.payload.squad

				if squad then
					return fn(p3, squadModel.format(squad))
				end

				return nil
			end,
			[selfPermissionUpdated.name] = function(p3, p4)
				if not fFlagEnableSquadRegroupExperimentation then
					return p3
				end

				if p3 == nil then
					return nil
				end

				local selfPermissions = p4.payload and p4.payload.selfPermissions

				if selfPermissions == nil then
					return p3
				end

				local selfPermissions2 = p3.selfPermissions or {}
				local joined2 = Cryo.Dictionary.join(selfPermissions2, selfPermissions)
				return (Cryo.Dictionary.join(p3, { selfPermissions = joined2 }))
			end
		})
	)
end
