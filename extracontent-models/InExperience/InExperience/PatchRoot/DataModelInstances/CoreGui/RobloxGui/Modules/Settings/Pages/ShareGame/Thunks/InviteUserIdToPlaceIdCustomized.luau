local CorePackages = game:GetService("CorePackages")
local ShareGame = game:GetService("CoreGui"):WaitForChild("RobloxGui").Modules.Settings.Pages.ShareGame
local GameInviteEvents = require(CorePackages.Workspace.Packages.GameInvite).GameInviteEvents
local Promise = require(CorePackages.Packages.Promise)
local ReceivedUserInviteStatus = require(ShareGame.Actions.ReceivedUserInviteStatus)
local InviteStatus = require(ShareGame.Constants).InviteStatus
local PostSendExperienceInvite = require(CorePackages.Workspace.Packages.GameInvite).PostSendExperienceInvite

return function(p1, s1: string, s2: string, p2, s3: string, s4: string?, s5: string?) -- line: 18
	-- upvalues: ReceivedUserInviteStatus (copy), InviteStatus (copy), Promise (copy), PostSendExperienceInvite (copy), GameInviteEvents (copy)
	return function(p3) -- line: 27
		-- upvalues: s2 (copy), ReceivedUserInviteStatus (copy), s1 (copy), InviteStatus (copy), Promise (copy), PostSendExperienceInvite (copy), p1 (copy), s3 (copy), s4 (copy), s5 (copy), p2 (copy), GameInviteEvents (copy)
		if s2 == "0" then
			warn("Game Invite failed to send. Cannot send invite to unpublished Place.")
			p3:dispatch(ReceivedUserInviteStatus(s1, InviteStatus.Failed))

			return Promise.reject()
		end

		local v16 = p3:getState()

		return Promise.new(function(resolve, reject) -- line: 36
			-- upvalues: v16 (copy), s1 (copy), InviteStatus (copy)
			if v16.Invites[s1] == InviteStatus.Pending then
				reject()

				return
			end

			resolve()
		end):andThen(function() -- line: 44
			-- upvalues: p3 (copy), ReceivedUserInviteStatus (copy), s1 (copy), InviteStatus (copy), PostSendExperienceInvite (copy), p1 (copy), s2 (copy), s3 (copy), s4 (copy), s5 (copy)
			p3:dispatch(ReceivedUserInviteStatus(s1, InviteStatus.Pending))

			return PostSendExperienceInvite(p1, s1, s2, s3, s4, s5)
		end):andThen(function(p4) -- line: 48
			-- upvalues: p3 (copy), ReceivedUserInviteStatus (copy), s1 (copy), InviteStatus (copy)
			p3:dispatch(ReceivedUserInviteStatus(s1, InviteStatus.Success))

			return p4
		end, function() -- line: 51
			-- upvalues: p2 (copy), s3 (copy), GameInviteEvents (copy), p3 (copy), ReceivedUserInviteStatus (copy), s1 (copy), InviteStatus (copy)
			p2:sendEvent(s3, GameInviteEvents.ErrorShown)
			p3:dispatch(ReceivedUserInviteStatus(s1, InviteStatus.Failed))
		end)
	end
end
