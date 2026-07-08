local CorePackages = game:GetService("CorePackages")
local ShareGame = game:GetService("CoreGui"):WaitForChild("RobloxGui").Modules.Settings.Pages.ShareGame
local ApiSendGameInvite = require(ShareGame.Thunks.ApiSendGameInvite)
local ApiFetchPlaceInfos = require(CorePackages.Workspace.Packages.PlaceInfoRodux).Thunks.ApiFetchPlaceInfos
local Promise = require(CorePackages.Packages.Promise)
local ReceivedUserInviteStatus = require(ShareGame.Actions.ReceivedUserInviteStatus)
local InviteStatus = require(ShareGame.Constants).InviteStatus

return function(p1, s1: string, s2: string) -- line: 18
	-- upvalues: ReceivedUserInviteStatus (copy), InviteStatus (copy), Promise (copy), ApiFetchPlaceInfos (copy), ApiSendGameInvite (copy)
	return function(p2) -- line: 19
		-- upvalues: s2 (copy), ReceivedUserInviteStatus (copy), s1 (copy), InviteStatus (copy), Promise (copy), ApiFetchPlaceInfos (copy), p1 (copy), ApiSendGameInvite (copy)
		if s2 == "0" then
			warn("Game Invite failed to send. Cannot send invite to unpublished Place.")
			p2:dispatch(ReceivedUserInviteStatus(s1, InviteStatus.Failed))

			return Promise.reject()
		end

		local v12 = p2:getState()

		return Promise.new(function(resolve, reject) -- line: 29
			-- upvalues: v12 (copy), s1 (copy), InviteStatus (copy)
			if v12.Invites[tostring(s1)] == InviteStatus.Pending then
				reject()

				return
			end

			resolve()
		end):andThen(function() -- line: 36
			-- upvalues: v12 (copy), s2 (copy), Promise (copy), p2 (copy), ReceivedUserInviteStatus (copy), s1 (copy), InviteStatus (copy), ApiFetchPlaceInfos (copy), p1 (copy), ApiSendGameInvite (copy)
			local v15 = v12.PlaceInfos[s2]

			return Promise.new(function(resolve, reject) -- line: 39
				-- upvalues: p2 (copy), ReceivedUserInviteStatus (copy), s1 (copy), InviteStatus (copy), v15 (copy), ApiFetchPlaceInfos (copy), p1 (copy), s2 (copy)
				p2:dispatch(ReceivedUserInviteStatus(s1, InviteStatus.Pending))

				if v15 then
					resolve(v15)

					return
				end

				p2:dispatch(ApiFetchPlaceInfos(p1, { s2 })):andThen(function(p3) -- line: 46
					-- upvalues: resolve (copy), reject (copy)
					if p3[1] ~= nil then
						resolve(p3[1])

						return
					end

					reject()
				end, function() -- line: 52
					-- upvalues: reject (copy)
					reject()
				end)
			end):andThen(function(p4) -- line: 56
				-- upvalues: p2 (copy), ApiSendGameInvite (copy), p1 (copy), s1 (copy)
				return p2:dispatch(ApiSendGameInvite(p1, s1, p4))
			end):andThen(function(p5) -- line: 58
				-- upvalues: p2 (copy), ReceivedUserInviteStatus (copy), s1 (copy)
				p2:dispatch(ReceivedUserInviteStatus(s1, p5.resultType))

				return p5
			end, function() -- line: 61
				-- upvalues: p2 (copy), ReceivedUserInviteStatus (copy), s1 (copy), InviteStatus (copy)
				p2:dispatch(ReceivedUserInviteStatus(s1, InviteStatus.Failed))
			end)
		end)
	end
end
