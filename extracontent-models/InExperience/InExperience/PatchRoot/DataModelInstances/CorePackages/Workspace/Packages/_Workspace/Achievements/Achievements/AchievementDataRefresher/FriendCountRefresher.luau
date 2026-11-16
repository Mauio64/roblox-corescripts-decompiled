local Achievements = script:FindFirstAncestor("Achievements")
local parent = Achievements.Parent

local Logger = require(Achievements.Logger)
require(parent.Signal)

local FriendCountRefresher = {}

function FriendCountRefresher:init(fireFriendCountChanged, playersService)
	self.fireFriendCountChanged = fireFriendCountChanged
	self.playersService = playersService
	self.friendIds = {}
	self.friendCount = 0
end

function FriendCountRefresher:start()
	self.friendIds = self:_getFriendIds()

	for _, v in pairs(self.playersService:GetPlayers()) do
		self:_onPlayerAdded(v)
	end

	self.playerAdded = self.playersService.PlayerAdded:Connect(function(player)
		self:_onPlayerAdded(player)
	end)
	self.playerRemoving = self.playersService.PlayerRemoving:Connect(function(player)
		self:_onPlayerRemoving(player)
	end)
end

function FriendCountRefresher:_getFriendIds()
	local function iterPageItems(friendsAsync) -- 1 equivalent call inferred from this helper
		return coroutine.wrap(function()
			local v = 1

			while true do
				for _, v2 in ipairs(friendsAsync:GetCurrentPage()) do
					coroutine.yield(v2, v)
				end

				if friendsAsync.IsFinished then
					break
				end

				friendsAsync:AdvanceToNextPageAsync()
				v += 1
			end
		end)
	end

	local success, result = pcall(function()
		local idSet = {}

		if self.playersService.LocalPlayer then
			for k, _ in iterPageItems(self.playersService:GetFriendsAsync(self.playersService.LocalPlayer.UserId)) do -- inferred equivalent call
				idSet[k.Id] = true
			end
		end

		return idSet
	end)

	if not success then
		Logger:warning(result)
	end

	return success and result or {}
end

function FriendCountRefresher:_onPlayerAdded(p)
	if self.friendIds[p.UserId] then
		self.friendCount += 1
		self.fireFriendCountChanged(self.friendCount)
	end
end

function FriendCountRefresher:_onPlayerRemoving(p)
	if self.friendIds[p.UserId] then
		self.friendCount -= 1
		self.fireFriendCountChanged(self.friendCount)
	end
end

function FriendCountRefresher:stop()
	if self.playerAdded then
		self.playerAdded:Disconnect()
		self.playerAdded = nil
	end

	if self.playerRemoving then
		self.playerRemoving:Disconnect()
		self.playerRemoving = nil
	end

	self.friendIds = {}
	self.friendCount = 0
end

return FriendCountRefresher
