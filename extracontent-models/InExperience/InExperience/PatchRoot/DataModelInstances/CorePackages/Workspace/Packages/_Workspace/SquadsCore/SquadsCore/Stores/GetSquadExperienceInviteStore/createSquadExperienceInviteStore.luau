local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local Cryo = require(parent.Cryo)
require(parent.RoduxSquads)
local Signals = require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal

local RoduxSquads = require(SquadsCore.RoduxSquads)
local ExperienceInviteModel = RoduxSquads.Models.ExperienceInviteModel

local function getAndUpdateState(p, formatted)
	if
		p
		and p.notification.experienceInviteId == formatted.experienceInviteId
		and (p.model == nil or p.model.versionId < formatted.versionId)
	then
		return Cryo.Dictionary.join(p, { model = formatted })
	end

	return p
end

return function()
	local sessionScopedSignal, v = createSessionScopedSignal(false)

	local sessionScopedSignal2, v2 = createSessionScopedSignal(nil)

	local function fn(p)
		assert(p, "Experience invite must exist.")
		local formatted = ExperienceInviteModel.format(p)
		v2(function(p2)
			return getAndUpdateState(p2, formatted)
		end)
	end

	return {
		getIsExperienceInvitePending = sessionScopedSignal,
		getCurrentExperienceInvite = sessionScopedSignal2,
		getHasCurrentExperienceInvite = Signals.createComputed(function(p): boolean
			return sessionScopedSignal2(p) ~= nil
		end),
		currentExperienceInviteStatusUpdated = function(flag: boolean)
			v(flag)
		end,
		currentExperienceInviteReceived = function(experienceInviteId: string, membershipEntityId: string, notificationId: string, isInviter: boolean)
			v2(function(p)
				if p == nil or p.notification.experienceInviteId ~= experienceInviteId then
					return {
						notification = {
							experienceInviteId = experienceInviteId,
							membershipEntityId = membershipEntityId,
							notificationId = notificationId,
							isInviter = isInviter
						}
					}
				end

				return p
			end)
		end,
		currentExperienceInviteUpdated = fn,
		currentExperienceInviteDismissed = function(p: string)
			v2(function(p2)
				if p2 and p2.notification.notificationId == p then
					return nil
				end

				return p2
			end)
		end,
		getExperienceInviteSucceeded = fn,
		voteForExperienceInviteSucceeded = fn,
		reset = function()
			v(false)
			v2(nil)
		end
	}
end
