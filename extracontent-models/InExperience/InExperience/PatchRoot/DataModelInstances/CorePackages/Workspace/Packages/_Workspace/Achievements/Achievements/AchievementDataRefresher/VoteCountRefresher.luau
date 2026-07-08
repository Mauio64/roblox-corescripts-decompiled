local Achievements = script:FindFirstAncestor("Achievements")
local AchievementsParent = Achievements.Parent

require(AchievementsParent.Signal)

local Logger = require(Achievements.Logger)
local GetUserVoteCount = require(Achievements.Requests.GetUserVoteCount)
local Promise = require(AchievementsParent.Promise)

require(AchievementsParent.LuauPolyfill)

local Dash = require(AchievementsParent.Dash)

return {
	init = function(p1, p2, p3, p4, p5) -- line: 36
		p1.fireVoteCountChanged = p2
		p1.store = p3
		p1.requestImpl = p4
		p1.platformCloudStorageService = p5
	end,
	start = function(p6) -- line: 48
		-- upvalues: Logger (copy)
		p6.storeChangedConnection = p6.store.changed:connect(function(p7, p8) -- line: 49
			-- upvalues: p6 (copy), Logger (copy)
			local LocalUserGameVoteCounter = p8.LocalUserGameVoteCounter
			local LocalUserGameVoteCounter2 = p7.LocalUserGameVoteCounter

			if LocalUserGameVoteCounter ~= LocalUserGameVoteCounter2 and LocalUserGameVoteCounter2.voteCountSinceAppStart > 0 then
				local lastUniverseId = LocalUserGameVoteCounter2.lastUniverseId

				p6:_checkPollster(lastUniverseId):catch(function(p9) -- line: 57
					-- upvalues: Logger (copy)
					Logger:warning(p9)
				end)
			end
		end)
	end,
	_checkPollster = function(p10, p11) -- line: 64
		-- upvalues: Promise (copy), Dash (copy), GetUserVoteCount (copy), Logger (copy)
		if p10.platformCloudStorageService and p10.platformCloudStorageService:IsUserDataAvailable() then
			return Promise.new(function() -- line: 66
				-- upvalues: p10 (copy), Dash (copy), p11 (copy)
				local v21 = p10.platformCloudStorageService:GetUserDataAsync("UniversesVoted").data or {}

				if #v21 < 5 and not Dash.includes(v21, p11) then
					table.insert(v21, p11)
					p10.platformCloudStorageService:SetUserDataAsync("UniversesVoted", {
						data = v21
					})
				end

				p10.fireVoteCountChanged(#v21)
			end)
		end

		return GetUserVoteCount(p10.requestImpl):andThen(function(p12) -- line: 75
			-- upvalues: Logger (copy), p10 (copy)
			if p12.responseBody == nil then
				Logger:warning("Response has no body.")

				return
			end

			local voteCount = p12.responseBody.voteCount

			if voteCount == nil then
				Logger:warning("Response has no voteCount field.")

				return
			end

			p10.fireVoteCountChanged(voteCount)
		end)
	end,
	stop = function(p13) -- line: 93
		if p13.storeChangedConnection then
			p13.storeChangedConnection:disconnect()
			p13.storeChangedConnection = nil
		end
	end
}
