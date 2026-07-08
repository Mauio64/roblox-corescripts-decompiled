local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local ApiFetchUsersFriends = require(ShareGame.Thunks.ApiFetchUsersFriends)
local Constants = require(ShareGame.Constants)
local UserSorts = require(RobloxGui.Modules.Settings.Enum.UserSorts)
local GetFFlagInviteListRerank = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagInviteListRerank

return function(p1, p2) -- line: 15
	-- upvalues: RetrievalStatus (copy), ApiFetchUsersFriends (copy), Constants (copy), GetFFlagInviteListRerank (copy), UserSorts (copy)
	return function(p3) -- line: 16
		-- upvalues: p2 (copy), RetrievalStatus (copy), ApiFetchUsersFriends (copy), p1 (copy), Constants (copy), GetFFlagInviteListRerank (copy), UserSorts (copy)
		if p3:getState().Friends.retrievalStatus[p2] ~= RetrievalStatus.Fetching then
			p3:dispatch(ApiFetchUsersFriends(p1, p2, Constants.ThumbnailRequest.InviteToGame, if not GetFFlagInviteListRerank() then nil else UserSorts.StatusFrequents))
		end
	end
end
