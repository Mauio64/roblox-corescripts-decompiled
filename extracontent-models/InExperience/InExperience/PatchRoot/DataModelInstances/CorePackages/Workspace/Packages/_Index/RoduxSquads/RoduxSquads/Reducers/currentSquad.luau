local RoduxSquads = script:FindFirstAncestor("RoduxSquads")
local parent = RoduxSquads.Parent
local Cryo = require(parent.Cryo)
local Rodux = require(parent.Rodux)
local Actions = require(RoduxSquads.Actions)
local CurrentSquadUpdated = Actions.CurrentSquadUpdated
local Actions2 = require(RoduxSquads.Actions)
local SelfPermissionUpdated = Actions2.SelfPermissionUpdated
local Models = require(RoduxSquads.Models)
local SquadModel = Models.SquadModel
local PersistStorage = require(RoduxSquads.Persists.PersistStorage)
local PersistReducer = require(RoduxSquads.Persists.PersistReducer)
local createPersistReducer = PersistReducer.createPersistReducer

require(script.Parent.Parent.RoduxSquadsTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableSquadRegroupExperimentation = SharedFlags.FFlagEnableSquadRegroupExperimentation

return function(p)
	local networkingSquads = p.NetworkingSquads
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

				local sorted = Cryo.List.sort(Cryo.List.map(data.members, function(p2)
					return p2.userId
				end))

				local sorted2 = Cryo.List.sort(Cryo.List.map(formatted.members, function(p2)
					return p2.userId
				end))

				local sorted3 = Cryo.List.sort(Cryo.List.map(data.invitees, function(p2)
					return tostring(p2.userId) .. tostring(p2.invitedAtTimestampMs)
				end))

				local sorted4 = Cryo.List.sort(Cryo.List.map(formatted.invitees, function(p2)
					return tostring(p2.userId) .. tostring(p2.invitedAtTimestampMs)
				end))

				if not (Cryo.List.equals(sorted, sorted2) and Cryo.List.equals(sorted3, sorted4)) then
					return formatted
				end

				if FFlagEnableSquadRegroupExperimentation then
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
		}, p.currentSquad or {}),
		Rodux.createReducer(nil, {
			[networkingSquads.CreateOrJoinSquad.Succeeded.name] = function(p2, p3)
				local groupUp = p3.responseBody.groupUp
				return fn(p2, SquadModel.format(groupUp))
			end,
			[networkingSquads.GetSquadActive.Succeeded.name] = function(p2, p3)
				local groupUp = p3.responseBody.groupUp

				if groupUp then
					return fn(p2, SquadModel.format(groupUp))
				end

				return nil
			end,
			[networkingSquads.GetSquadFromSquadId.Succeeded.name] = function(p2, p3)
				local groupUp = p3.responseBody.groupUp
				local squadId = p2 and p2.squadId

				if groupUp and groupUp.groupUpId == squadId then
					return fn(p2, SquadModel.format(groupUp))
				end

				return p2
			end,
			[networkingSquads.JoinSquad.Succeeded.name] = function(p2, p3)
				local groupUp = p3.responseBody.groupUp
				return fn(p2, SquadModel.format(groupUp))
			end,
			[networkingSquads.LeaveSquad.Succeeded.name] = function(p2, p3)
				local groupUpId = p3.postBody.groupUpId

				if p2 and p2.squadId == groupUpId then
					return nil
				end

				return p2
			end,
			[networkingSquads.ActOnPartyNudge.Succeeded.name] = function(p2, p3)
				local groupUp = p3.responseBody.groupUp

				if groupUp then
					return fn(p2, SquadModel.format(groupUp))
				end

				return p2
			end,
			[CurrentSquadUpdated.name] = function(p2, p3)
				local squad = p3.payload.squad

				if squad then
					return fn(p2, SquadModel.format(squad))
				end

				return nil
			end,
			[SelfPermissionUpdated.name] = function(p2, p3)
				if not FFlagEnableSquadRegroupExperimentation then
					return p2
				end

				if p2 == nil then
					return nil
				end

				local selfPermissions = p3.payload and p3.payload.selfPermissions

				if selfPermissions == nil then
					return p2
				end

				local selfPermissions2 = p2.selfPermissions or {}
				local joined = Cryo.Dictionary.join(selfPermissions2, selfPermissions)
				return (Cryo.Dictionary.join(p2, { selfPermissions = joined }))
			end
		})
	)
end
