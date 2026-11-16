local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local shareGame = CoreGui:WaitForChild("RobloxGui").Modules.Settings.Pages.ShareGame

local ApiSendGameInvite = require(shareGame.Thunks.ApiSendGameInvite)
local PlaceInfoRodux = require(CorePackages.Workspace.Packages.PlaceInfoRodux)
local ApiFetchPlaceInfos = PlaceInfoRodux.Thunks.ApiFetchPlaceInfos
local Promise = require(CorePackages.Packages.Promise)

local ReceivedUserInviteStatus = require(shareGame.Actions.ReceivedUserInviteStatus)
local Constants = require(shareGame.Constants)

local InviteStatus = Constants.InviteStatus

return function(p, p2: string, p3: string)
	return function(object)
		if p3 ~= "0" then
			local state = object:getState()

			return Promise.new(function(callback, callback2)
				if state.Invites[tostring(p2)] == InviteStatus.Pending then
					callback2()
				else
					callback()
				end
			end):andThen(function()
				local placeInfo = state.PlaceInfos[p3]

				return Promise.new(function(callback, callback2)
					object:dispatch(ReceivedUserInviteStatus(p2, InviteStatus.Pending))

					if placeInfo then
						callback(placeInfo)
					else
						object:dispatch(ApiFetchPlaceInfos(p, { p3 })):andThen(function(list)
							if list[1] == nil then
								callback2()
							else
								callback(list[1])
							end
						end, function()
							callback2()
						end)
					end
				end):andThen(function(p4)
					return object:dispatch(ApiSendGameInvite(p, p2, p4))
				end):andThen(function(p4)
					object:dispatch(ReceivedUserInviteStatus(p2, p4.resultType))
					return p4
				end, function()
					object:dispatch(ReceivedUserInviteStatus(p2, InviteStatus.Failed))
				end)
			end)
		end

		warn("Game Invite failed to send. Cannot send invite to unpublished Place.")
		object:dispatch(ReceivedUserInviteStatus(p2, InviteStatus.Failed))
		return Promise.reject()
	end
end
