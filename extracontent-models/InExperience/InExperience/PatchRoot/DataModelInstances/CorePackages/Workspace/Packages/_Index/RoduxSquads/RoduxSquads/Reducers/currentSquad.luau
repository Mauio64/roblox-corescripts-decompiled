local RoduxSquads = script:FindFirstAncestor("RoduxSquads")
local RoduxSquadsParent = RoduxSquads.Parent
local Cryo = require(RoduxSquadsParent.Cryo)
local Rodux = require(RoduxSquadsParent.Rodux)
local CurrentSquadUpdated = require(RoduxSquads.Actions).CurrentSquadUpdated
local SelfPermissionUpdated = require(RoduxSquads.Actions).SelfPermissionUpdated
local SquadModel = require(RoduxSquads.Models).SquadModel
local PersistStorage = require(RoduxSquads.Persists.PersistStorage)
local createPersistReducer = require(RoduxSquads.Persists.PersistReducer).createPersistReducer

require(script.Parent.Parent.RoduxSquadsTypes)

local FFlagEnableSquadRegroupExperimentation = require(RoduxSquadsParent.SharedFlags).FFlagEnableSquadRegroupExperimentation

return function(p1) -- line: 19
	-- upvalues: Cryo (copy), FFlagEnableSquadRegroupExperimentation (copy), createPersistReducer (copy), PersistStorage (copy), Rodux (copy), SquadModel (copy), CurrentSquadUpdated (copy), SelfPermissionUpdated (copy)
	local NetworkingSquads = p1.NetworkingSquads

	local function v13(p2, p3) -- line: 21
		-- upvalues: Cryo (copy), FFlagEnableSquadRegroupExperimentation (copy)
		if p2 == nil or p2.squadId ~= p3.squadId then
			if p3.deletedAtTime and p3.deletedAtTime ~= "" then
				return p2
			end

			if not p2 or p2.parentChannelId ~= p3.parentChannelId then
				return p3
			end

			if p2.createdAtTime < p3.createdAtTime then
				return p3
			end
		else
			if p3.deletedAtTime and p3.deletedAtTime ~= "" then
				return nil
			end

			if p2.updatedAtTime < p3.updatedAtTime then
				return p3
			end

			if p2.updatedAtTime == p3.updatedAtTime then
				if p2.parentChannelId ~= p3.parentChannelId then
					return p3
				end

				local v16 = Cryo.List.sort(Cryo.List.map(p2.members, function(p4) -- line: 50
					return p4.userId
				end))
				local v17 = Cryo.List.sort(Cryo.List.map(p3.members, function(p5) -- line: 53
					return p5.userId
				end))
				local v18 = Cryo.List.sort(Cryo.List.map(p2.invitees, function(p6) -- line: 58
					return tostring(p6.userId) .. tostring(p6.invitedAtTimestampMs)
				end))
				local v19 = Cryo.List.sort(Cryo.List.map(p3.invitees, function(p7) -- line: 62
					return tostring(p7.userId) .. tostring(p7.invitedAtTimestampMs)
				end))

				if not Cryo.List.equals(v16, v17) or not Cryo.List.equals(v18, v19) then
					return p3
				end

				if FFlagEnableSquadRegroupExperimentation then
					local selfPermissions = p2.selfPermissions
					local selfPermissions2 = p3.selfPermissions

					if selfPermissions == nil ~= (selfPermissions2 == nil) then
						return p3
					end

					if selfPermissions and selfPermissions2 and not Cryo.Dictionary.equals(selfPermissions, selfPermissions2) then
						return p3
					end
				end
			end
		end

		return p2
	end

	return createPersistReducer(Cryo.Dictionary.join({
		storage = PersistStorage.new("currentSquadStore")
	}, p1.currentSquad or {}), Rodux.createReducer(nil, {
		[NetworkingSquads.CreateOrJoinSquad.Succeeded.name] = function(p8, p9) -- line: 99
			-- upvalues: v13 (copy), SquadModel (copy)
			local groupUp = p9.responseBody.groupUp

			return (v13(p8, SquadModel.format(groupUp)))
		end,
		[NetworkingSquads.GetSquadActive.Succeeded.name] = function(p10, p11) -- line: 107
			-- upvalues: v13 (copy), SquadModel (copy)
			local groupUp = p11.responseBody.groupUp

			if groupUp then
				return (v13(p10, SquadModel.format(groupUp)))
			end

			return nil
		end,
		[NetworkingSquads.GetSquadFromSquadId.Succeeded.name] = function(p12, p13) -- line: 120
			-- upvalues: v13 (copy), SquadModel (copy)
			local groupUp = p13.responseBody.groupUp
			local v31 = p12 and p12.squadId

			if groupUp and v31 == groupUp.groupUpId then
				return (v13(p12, SquadModel.format(groupUp)))
			end

			return p12
		end,
		[NetworkingSquads.JoinSquad.Succeeded.name] = function(p14, p15) -- line: 135
			-- upvalues: v13 (copy), SquadModel (copy)
			local groupUp = p15.responseBody.groupUp

			return (v13(p14, SquadModel.format(groupUp)))
		end,
		[NetworkingSquads.LeaveSquad.Succeeded.name] = function(p16, p17) -- line: 143
			local groupUpId = p17.postBody.groupUpId

			if p16 and groupUpId == p16.squadId then
				return nil
			end

			return p16
		end,
		[NetworkingSquads.ActOnPartyNudge.Succeeded.name] = function(p18, p19) -- line: 151
			-- upvalues: v13 (copy), SquadModel (copy)
			local groupUp = p19.responseBody.groupUp

			if groupUp then
				return (v13(p18, SquadModel.format(groupUp)))
			end

			return p18
		end,
		[CurrentSquadUpdated.name] = function(p20, p21) -- line: 163
			-- upvalues: v13 (copy), SquadModel (copy)
			local squad = p21.payload.squad

			if not squad then
				return nil
			end

			return (v13(p20, SquadModel.format(squad)))
		end,
		[SelfPermissionUpdated.name] = function(p22, p23) -- line: 175
			-- upvalues: FFlagEnableSquadRegroupExperimentation (copy), Cryo (copy)
			if not FFlagEnableSquadRegroupExperimentation then
				return p22
			end

			if p22 == nil then
				return p22
			end

			local v46 = p23.payload and p23.payload.selfPermissions

			if v46 == nil then
				return p22
			end

			local v47 = p22.selfPermissions or {}
			local v48 = Cryo.Dictionary.join(v47, v46)

			return (Cryo.Dictionary.join(p22, {
				selfPermissions = v48
			}))
		end
	}))
end
