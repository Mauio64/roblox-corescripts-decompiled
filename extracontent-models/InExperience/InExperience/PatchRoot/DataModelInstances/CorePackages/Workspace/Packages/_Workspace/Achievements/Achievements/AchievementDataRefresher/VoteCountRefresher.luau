local Achievements = script:FindFirstAncestor("Achievements")
local parent = Achievements.Parent

require(parent.Signal)
local Logger = require(Achievements.Logger)
local GetUserVoteCount = require(Achievements.Requests.GetUserVoteCount)
local Promise = require(parent.Promise)
require(parent.LuauPolyfill)
local Dash = require(parent.Dash)

local VoteCountRefresher = {}

function VoteCountRefresher:init(fireVoteCountChanged, store, requestImpl, platformCloudStorageService)
	self.fireVoteCountChanged = fireVoteCountChanged
	self.store = store
	self.requestImpl = requestImpl
	self.platformCloudStorageService = platformCloudStorageService
end

function VoteCountRefresher:start()
	self.storeChangedConnection = self.store.changed:connect(function(p, p2)
		local localUserGameVoteCounter = p2.LocalUserGameVoteCounter
		local localUserGameVoteCounter2 = p.LocalUserGameVoteCounter

		if
			localUserGameVoteCounter ~= localUserGameVoteCounter2
			and localUserGameVoteCounter2.voteCountSinceAppStart > 0
		then
			self:_checkPollster(localUserGameVoteCounter2.lastUniverseId):catch(function(p3)
				Logger:warning(p3)
			end)
		end
	end)
end

function VoteCountRefresher:_checkPollster(p)
	if self.platformCloudStorageService and self.platformCloudStorageService:IsUserDataAvailable() then
		return Promise.new(function()
			local data = self.platformCloudStorageService:GetUserDataAsync("UniversesVoted").data or {}

			if #data < 5 and not Dash.includes(data, p) then
				table.insert(data, p)
				self.platformCloudStorageService:SetUserDataAsync("UniversesVoted", { data = data })
			end

			self.fireVoteCountChanged(#data)
		end)
	end

	return GetUserVoteCount(self.requestImpl):andThen(function(p2)
		if p2.responseBody == nil then
			Logger:warning("Response has no body.")
			return
		end

		local voteCount = p2.responseBody.voteCount

		if voteCount == nil then
			Logger:warning("Response has no voteCount field.")
		else
			self.fireVoteCountChanged(voteCount)
		end
	end)
end

function VoteCountRefresher:stop()
	if self.storeChangedConnection then
		self.storeChangedConnection:disconnect()
		self.storeChangedConnection = nil
	end
end

return VoteCountRefresher
