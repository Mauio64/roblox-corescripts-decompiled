local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local shareGame = CoreGui:WaitForChild("RobloxGui").Modules.Settings.Pages.ShareGame
local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)
local GameInviteEvents = GameInvite.GameInviteEvents

local Promise = require(CorePackages.Packages.Promise)

local ReceivedUserInviteStatus = require(shareGame.Actions.ReceivedUserInviteStatus)
local Constants = require(shareGame.Constants)
local InviteStatus = Constants.InviteStatus

local GameInvite2 = require(CorePackages.Workspace.Packages.GameInvite)
local PostSendExperienceInvite = GameInvite2.PostSendExperienceInvite

return function(p, p2: string, p3: string, object, p4: string, p5: string?, p6: string?)
	return function(object2)
		if p3 ~= "0" then
			local state = object2:getState()

			return Promise.new(function(callback, callback2)
				if state.Invites[p2] == InviteStatus.Pending then
					callback2()
				else
					callback()
				end
			end):andThen(function()
				object2:dispatch(ReceivedUserInviteStatus(p2, InviteStatus.Pending))
				return PostSendExperienceInvite(p, p2, p3, p4, p5, p6)
			end):andThen(function(p7)
				object2:dispatch(ReceivedUserInviteStatus(p2, InviteStatus.Success))
				return p7
			end, function()
				object:sendEvent(p4, GameInviteEvents.ErrorShown)
				object2:dispatch(ReceivedUserInviteStatus(p2, InviteStatus.Failed))
			end)
		end

		warn("Game Invite failed to send. Cannot send invite to unpublished Place.")
		object2:dispatch(ReceivedUserInviteStatus(p2, InviteStatus.Failed))
		return Promise.reject()
	end
end
