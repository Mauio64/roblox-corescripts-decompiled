local Logger = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Logger")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/Cryo")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/Rodux")
local currentExperienceInviteUpdated = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Actions").CurrentExperienceInviteUpdated
local currentExperienceInviteDismissed = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Actions").CurrentExperienceInviteDismissed
local currentExperienceInviteReceived = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Actions").CurrentExperienceInviteReceived
local experienceInviteModel = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Models").ExperienceInviteModel

require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/RoduxSquadsTypes")

return function(p2)
	local networkingSquads = p2.NetworkingSquads

	local function fn(p3, formatted)
		if
			p3
			and p3.notification.experienceInviteId == formatted.experienceInviteId
			and (p3.model == nil or p3.model.versionId < formatted.versionId)
		then
			return Cryo.Dictionary.join(p3, { model = formatted })
		end

		return p3
	end

	return Rodux.createReducer(nil, {
		[networkingSquads.CreateExperienceInvite.Succeeded.name] = function(p3, p4)
			Logger:debug(
				"Create experience invite success. ExperienceInviteId: {}",
				p4.responseBody.experienceInviteId
			)

			return p3
		end,
		[networkingSquads.GetExperienceInvite.Succeeded.name] = function(p3, p4)
			local responseBody = p4.responseBody

			assert(responseBody, "Experience invite must exist.")
			return fn(p3, experienceInviteModel.format(responseBody))
		end,
		[networkingSquads.VoteForExperienceInvite.Succeeded.name] = function(p3, p4)
			local responseBody = p4.responseBody
			Logger:debug(
				"Vote experience invite success. ExperienceInviteId: {}",
				responseBody.experienceInviteId
			)
			return fn(p3, experienceInviteModel.format(responseBody))
		end,
		[currentExperienceInviteUpdated.name] = function(p3, p4)
			local experienceInvite = p4.payload.experienceInvite
			assert(experienceInvite, "Experience invite must exist.")
			return fn(p3, experienceInviteModel.format(experienceInvite))
		end,
		[currentExperienceInviteReceived.name] = function(p3, p4)
			local experienceInviteId = p4.payload.experienceInviteId

			if p3 == nil or p3.notification.experienceInviteId ~= experienceInviteId then
				return {
					notification = {
						experienceInviteId = experienceInviteId,
						membershipEntityId = p4.payload.membershipEntityId,
						notificationId = p4.payload.notificationId,
						isInviter = p4.payload.isInviter
					}
				}
			end

			return p3
		end,
		[currentExperienceInviteDismissed.name] = function(p3, p4)
			if p3 and p3.notification.notificationId == p4.payload.notificationId then
				return nil
			end

			return p3
		end
	})
end
