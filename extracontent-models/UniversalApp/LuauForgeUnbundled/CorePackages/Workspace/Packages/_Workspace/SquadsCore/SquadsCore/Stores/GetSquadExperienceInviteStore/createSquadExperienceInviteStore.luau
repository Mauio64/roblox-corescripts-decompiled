local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoduxSquads")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Signals")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SignalsUtils").createSessionScopedSignal

local experienceInviteModel = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/RoduxSquads").Models.ExperienceInviteModel

local function getAndUpdateState(p2, formatted)
	if
		p2
		and p2.notification.experienceInviteId == formatted.experienceInviteId
		and (p2.model == nil or p2.model.versionId < formatted.versionId)
	then
		return Cryo.Dictionary.join(p2, { model = formatted })
	end

	return p2
end

return function()
	local sessionScopedSignal, v5 = createSessionScopedSignal(false)

	local sessionScopedSignal2, v6 = createSessionScopedSignal(nil)

	local function fn(p2)
		assert(p2, "Experience invite must exist.")
		local formatted = experienceInviteModel.format(p2)
		v6(function(p3)
			return getAndUpdateState(p3, formatted)
		end)
	end

	return {
		getIsExperienceInvitePending = sessionScopedSignal,
		getCurrentExperienceInvite = sessionScopedSignal2,
		getHasCurrentExperienceInvite = Signals.createComputed(function(p2): boolean
			return sessionScopedSignal2(p2) ~= nil
		end),
		currentExperienceInviteStatusUpdated = function(p2)
			v5(p2)
		end,
		currentExperienceInviteReceived = function(p2, p3, p4, p5)
			v6(function(p6)
				if p6 == nil or p6.notification.experienceInviteId ~= p2 then
					return {
						notification = {
							experienceInviteId = p2,
							membershipEntityId = p3,
							notificationId = p4,
							isInviter = p5
						}
					}
				end

				return p6
			end)
		end,
		currentExperienceInviteUpdated = fn,
		currentExperienceInviteDismissed = function(p2)
			v6(function(p3)
				if p3 and p3.notification.notificationId == p2 then
					return nil
				end

				return p3
			end)
		end,
		getExperienceInviteSucceeded = fn,
		voteForExperienceInviteSucceeded = fn,
		reset = function()
			v5(false)
			v6(nil)
		end
	}
end
