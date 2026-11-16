local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/Logger")
require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Signal")

return {
	init = function(p2, fireFriendCountChanged, playersService)
		p2.fireFriendCountChanged = fireFriendCountChanged
		p2.playersService = playersService
		p2.friendIds = {}
		p2.friendCount = 0
	end,
	start = function(self)
		self.friendIds = self:_getFriendIds()

		for k, v5 in pairs(self.playersService:GetPlayers()) do
			self:_onPlayerAdded(v5)
		end

		self.playerAdded = self.playersService.PlayerAdded:Connect(function(player)
			self:_onPlayerAdded(player)
		end)
		self.playerRemoving = self.playersService.PlayerRemoving:Connect(function(player)
			self:_onPlayerRemoving(player)
		end)
	end,
	_getFriendIds = function(self)
		local function iterPageItems(object)
			return coroutine.wrap(function()
				local v5 = 1

				while true do
					for i, v6 in ipairs(object:GetCurrentPage()) do
						coroutine.yield(v6, v5)
					end

					if object.IsFinished then
						break
					end

					object:AdvanceToNextPageAsync()
					v5 += 1
				end
			end)
		end

		local success, result = pcall(function()
			local idSet = {}

			if self.playersService.LocalPlayer then
				local friendsAsync = self.playersService:GetFriendsAsync(self.playersService.LocalPlayer.UserId)

				for k, v5 in coroutine.wrap(function()
					local v5 = 1

					while true do
						for i, v6 in ipairs(friendsAsync:GetCurrentPage()) do
							coroutine.yield(v6, v5)
						end

						if friendsAsync.IsFinished then
							break
						end

						friendsAsync:AdvanceToNextPageAsync()
						v5 += 1
					end
				end) do
					idSet[k.Id] = true
				end
			end

			return idSet
		end)

		if not success then
			Logger:warning(result)
		end

		return success and result or {}
	end,
	_onPlayerAdded = function(self, p2)
		if self.friendIds[p2.UserId] then
			self.friendCount += 1
			self.fireFriendCountChanged(self.friendCount)
		end
	end,
	_onPlayerRemoving = function(self, p2)
		if self.friendIds[p2.UserId] then
			self.friendCount -= 1
			self.fireFriendCountChanged(self.friendCount)
		end
	end,
	stop = function(state)
		if state.playerAdded then
			state.playerAdded:Disconnect()
			state.playerAdded = nil
		end

		if state.playerRemoving then
			state.playerRemoving:Disconnect()
			state.playerRemoving = nil
		end

		state.friendIds = {}
		state.friendCount = 0
	end
}
