local RoduxSquads = script:FindFirstAncestor("RoduxSquads")
local Logger = require(RoduxSquads.Logger)
local RoduxSquadsParent = RoduxSquads.Parent
local Cryo = require(RoduxSquadsParent.Cryo)
local Rodux = require(RoduxSquadsParent.Rodux)
local CurrentExperienceInviteUpdated = require(RoduxSquads.Actions).CurrentExperienceInviteUpdated
local CurrentExperienceInviteDismissed = require(RoduxSquads.Actions).CurrentExperienceInviteDismissed
local CurrentExperienceInviteReceived = require(RoduxSquads.Actions).CurrentExperienceInviteReceived
local ExperienceInviteModel = require(RoduxSquads.Models).ExperienceInviteModel

require(script.Parent.Parent.RoduxSquadsTypes)

return function(p1) -- line: 17
	-- upvalues: Cryo (copy), Rodux (copy), Logger (copy), ExperienceInviteModel (copy), CurrentExperienceInviteUpdated (copy), CurrentExperienceInviteReceived (copy), CurrentExperienceInviteDismissed (copy)
	local NetworkingSquads = p1.NetworkingSquads

	local function v12(p2, p3) -- line: 20
		-- upvalues: Cryo (copy)
		if p2 and p2.notification.experienceInviteId == p3.experienceInviteId and (p2.model == nil or p2.model.versionId < p3.versionId) then
			return Cryo.Dictionary.join(p2, {
				model = p3
			})
		end

		return p2
	end

	return Rodux.createReducer(nil, {
		[NetworkingSquads.CreateExperienceInvite.Succeeded.name] = function(p4, p5) -- line: 35
			-- upvalues: Logger (copy)
			local responseBody = p5.responseBody

			Logger:debug("Create experience invite success. ExperienceInviteId: {}", responseBody.experienceInviteId)

			return p4
		end,
		[NetworkingSquads.GetExperienceInvite.Succeeded.name] = function(p6, p7) -- line: 48
			-- upvalues: v12 (copy), ExperienceInviteModel (copy)
			local responseBody = p7.responseBody

			assert(responseBody, "Experience invite must exist.")

			return v12(p6, ExperienceInviteModel.format(responseBody))
		end,
		[NetworkingSquads.VoteForExperienceInvite.Succeeded.name] = function(p8, p9) -- line: 58
			-- upvalues: Logger (copy), v12 (copy), ExperienceInviteModel (copy)
			local responseBody = p9.responseBody

			Logger:debug("Vote experience invite success. ExperienceInviteId: {}", responseBody.experienceInviteId)

			return v12(p8, ExperienceInviteModel.format(responseBody))
		end,
		[CurrentExperienceInviteUpdated.name] = function(p10, p11) -- line: 67
			-- upvalues: v12 (copy), ExperienceInviteModel (copy)
			local experienceInvite = p11.payload.experienceInvite

			assert(experienceInvite, "Experience invite must exist.")

			return v12(p10, ExperienceInviteModel.format(experienceInvite))
		end,
		[CurrentExperienceInviteReceived.name] = function(p12, p13) -- line: 76
			local experienceInviteId = p13.payload.experienceInviteId

			if p12 == nil or experienceInviteId ~= p12.notification.experienceInviteId then
				return {
					notification = {
						experienceInviteId = experienceInviteId,
						membershipEntityId = p13.payload.membershipEntityId,
						notificationId = p13.payload.notificationId,
						isInviter = p13.payload.isInviter
					}
				}
			end

			return p12
		end,
		[CurrentExperienceInviteDismissed.name] = function(p14, p15) -- line: 100
			if p14 and p14.notification.notificationId == p15.payload.notificationId then
				return nil
			end

			return p14
		end
	})
end
