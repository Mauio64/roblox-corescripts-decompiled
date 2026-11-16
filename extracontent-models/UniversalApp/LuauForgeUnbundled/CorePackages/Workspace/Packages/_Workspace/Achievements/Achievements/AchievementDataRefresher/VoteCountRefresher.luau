require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Signal")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/Logger")
local GetUserVoteCount = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/Requests/GetUserVoteCount")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/LuauPolyfill")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Dash")

return {
	init = function(p2, fireVoteCountChanged, store, requestImpl, platformCloudStorageService)
		p2.fireVoteCountChanged = fireVoteCountChanged
		p2.store = store
		p2.requestImpl = requestImpl
		p2.platformCloudStorageService = platformCloudStorageService
	end,
	start = function(self)
		self.storeChangedConnection = self.store.changed:connect(function(p2, p3)
			local localUserGameVoteCounter = p3.LocalUserGameVoteCounter
			local localUserGameVoteCounter2 = p2.LocalUserGameVoteCounter

			if
				localUserGameVoteCounter ~= localUserGameVoteCounter2
				and localUserGameVoteCounter2.voteCountSinceAppStart > 0
			then
				self:_checkPollster(localUserGameVoteCounter2.lastUniverseId):catch(function(p4)
					Logger:warning(p4)
				end)
			end
		end)
	end,
	_checkPollster = function(self, p2)
		if self.platformCloudStorageService and self.platformCloudStorageService:IsUserDataAvailable() then
			return Promise.new(function()
				local data2 = self.platformCloudStorageService:GetUserDataAsync("UniversesVoted").data or {}

				if #data2 < 5 and not Dash.includes(data2, p2) then
					table.insert(data2, p2)
					self.platformCloudStorageService:SetUserDataAsync("UniversesVoted", {
						data = data2
					})
				end

				self.fireVoteCountChanged(#data2)
			end)
		end

		return GetUserVoteCount(self.requestImpl):andThen(function(p3)
			if p3.responseBody == nil then
				Logger:warning("Response has no body.")
				return
			end

			local voteCount = p3.responseBody.voteCount

			if voteCount == nil then
				Logger:warning("Response has no voteCount field.")
			else
				self.fireVoteCountChanged(voteCount)
			end
		end)
	end,
	stop = function(p2)
		if p2.storeChangedConnection then
			p2.storeChangedConnection:disconnect()
			p2.storeChangedConnection = nil
		end
	end
}
