local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame

local Http = require(CorePackages.Workspace.Packages.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus
local ApiFetchUsersFriends = require(ShareGame.Thunks.ApiFetchUsersFriends)

local Constants = require(ShareGame.Constants)
local UserSorts = require(RobloxGui.Modules.Settings.Enum.UserSorts)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagInviteListRerank = SharedFlags.GetFFlagInviteListRerank

return function(p, p2)
	return function(object)
		if object:getState().Friends.retrievalStatus[p2] ~= RetrievalStatus.Fetching then
			local inviteToGame = Constants.ThumbnailRequest.InviteToGame
			local v

			if GetFFlagInviteListRerank() then
				v = UserSorts.StatusFrequents
			end

			object:dispatch(ApiFetchUsersFriends(p, p2, inviteToGame, v))
		end
	end
end
