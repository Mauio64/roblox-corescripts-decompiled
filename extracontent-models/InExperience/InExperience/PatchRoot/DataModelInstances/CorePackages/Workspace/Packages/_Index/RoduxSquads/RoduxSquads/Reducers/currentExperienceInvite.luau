local RoduxSquads = script:FindFirstAncestor("RoduxSquads")
local Logger = require(RoduxSquads.Logger)
local parent = RoduxSquads.Parent
local Cryo = require(parent.Cryo)
local Rodux = require(parent.Rodux)
local Actions = require(RoduxSquads.Actions)
local CurrentExperienceInviteUpdated = Actions.CurrentExperienceInviteUpdated
local Actions2 = require(RoduxSquads.Actions)
local CurrentExperienceInviteDismissed = Actions2.CurrentExperienceInviteDismissed
local Actions3 = require(RoduxSquads.Actions)
local CurrentExperienceInviteReceived = Actions3.CurrentExperienceInviteReceived
local Models = require(RoduxSquads.Models)
local ExperienceInviteModel = Models.ExperienceInviteModel

require(script.Parent.Parent.RoduxSquadsTypes)

return function(p)
	local networkingSquads = p.NetworkingSquads

	local function fn(p2, formatted)
		if
			p2
			and p2.notification.experienceInviteId == formatted.experienceInviteId
			and (p2.model == nil or p2.model.versionId < formatted.versionId)
		then
			return Cryo.Dictionary.join(p2, { model = formatted })
		end

		return p2
	end

	return Rodux.createReducer(nil, {
		[networkingSquads.CreateExperienceInvite.Succeeded.name] = function(p2, p3)
			Logger:debug("Create experience invite success. ExperienceInviteId: {}", p3.responseBody.experienceInviteId)

			return p2
		end,
		[networkingSquads.GetExperienceInvite.Succeeded.name] = function(p2, p3)
			local responseBody = p3.responseBody

			assert(responseBody, "Experience invite must exist.")
			return fn(p2, ExperienceInviteModel.format(responseBody))
		end,
		[networkingSquads.VoteForExperienceInvite.Succeeded.name] = function(p2, p3)
			local responseBody = p3.responseBody
			Logger:debug("Vote experience invite success. ExperienceInviteId: {}", responseBody.experienceInviteId)
			return fn(p2, ExperienceInviteModel.format(responseBody))
		end,
		[CurrentExperienceInviteUpdated.name] = function(p2, p3)
			local experienceInvite = p3.payload.experienceInvite
			assert(experienceInvite, "Experience invite must exist.")
			return fn(p2, ExperienceInviteModel.format(experienceInvite))
		end,
		[CurrentExperienceInviteReceived.name] = function(p2, p3)
			local experienceInviteId = p3.payload.experienceInviteId

			if p2 == nil or p2.notification.experienceInviteId ~= experienceInviteId then
				return {
					notification = {
						experienceInviteId = experienceInviteId,
						membershipEntityId = p3.payload.membershipEntityId,
						notificationId = p3.payload.notificationId,
						isInviter = p3.payload.isInviter
					}
				}
			end

			return p2
		end,
		[CurrentExperienceInviteDismissed.name] = function(p2, p3)
			if p2 and p2.notification.notificationId == p3.payload.notificationId then
				return nil
			end

			return p2
		end
	})
end
