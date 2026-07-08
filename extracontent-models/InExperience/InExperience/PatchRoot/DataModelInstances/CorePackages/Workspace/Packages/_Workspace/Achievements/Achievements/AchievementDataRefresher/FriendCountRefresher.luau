local Achievements = script:FindFirstAncestor("Achievements")
local AchievementsParent = Achievements.Parent
local Logger = require(Achievements.Logger)

require(AchievementsParent.Signal)

return {
	init = function(t1: {[any]: any}, p1, p2) -- line: 25
		t1.fireFriendCountChanged = p1
		t1.playersService = p2
		t1.friendIds = {}
		t1.friendCount = 0
	end,
	start = function(p3) -- line: 32
		p3.friendIds = p3:_getFriendIds()

		for _, player in pairs(p3.playersService:GetPlayers()) do
			p3:_onPlayerAdded(player)
		end

		p3.playerAdded = p3.playersService.PlayerAdded:Connect(function(player) -- line: 37
			-- upvalues: p3 (copy)
			p3:_onPlayerAdded(player)
		end)
		p3.playerRemoving = p3.playersService.PlayerRemoving:Connect(function(player) -- line: 40
			-- upvalues: p3 (copy)
			p3:_onPlayerRemoving(player)
		end)
	end,
	_getFriendIds = function(p4) -- line: 45
		-- upvalues: Logger (copy)
		local function iterPageItems(p5) -- line: 46
			return coroutine.wrap(function() -- line: 47
				-- upvalues: p5 (copy)
				local n1 = 1

				while true do
					for _, v in ipairs(p5:GetCurrentPage()) do
						coroutine.yield(v, n1)
					end

					if p5.IsFinished then
						break
					end

					p5:AdvanceToNextPageAsync()
					n1 += 1
				end
			end)
		end

		local ok, result = pcall(function() -- line: 62
			-- upvalues: p4 (copy)
			local t2 = {}

			if p4.playersService.LocalPlayer then
				local FriendsAsync = p4.playersService:GetFriendsAsync(p4.playersService.LocalPlayer.UserId)

				for v24, _ in coroutine.wrap(function() -- line: 47
					-- upvalues: FriendsAsync (copy)
					local n2 = 1

					while true do
						for _, v in ipairs(FriendsAsync:GetCurrentPage()) do
							coroutine.yield(v, n2)
						end

						if FriendsAsync.IsFinished then
							break
						end

						FriendsAsync:AdvanceToNextPageAsync()
						n2 += 1
					end
				end) do
					t2[v24.Id] = true
				end
			end

			return t2
		end)

		if not ok then
			Logger:warning(result)
		end

		return ok and result or {}
	end,
	_onPlayerAdded = function(t3: {[any]: any}, p6) -- line: 80
		if t3.friendIds[p6.UserId] then
			t3.friendCount = t3.friendCount + 1
			t3.fireFriendCountChanged(t3.friendCount)
		end
	end,
	_onPlayerRemoving = function(t4: {[any]: any}, p7) -- line: 87
		if t4.friendIds[p7.UserId] then
			t4.friendCount = t4.friendCount - 1
			t4.fireFriendCountChanged(t4.friendCount)
		end
	end,
	stop = function(p8) -- line: 94
		if p8.playerAdded then
			p8.playerAdded:Disconnect()
			p8.playerAdded = nil
		end

		if p8.playerRemoving then
			p8.playerRemoving:Disconnect()
			p8.playerRemoving = nil
		end

		p8.friendIds = {}
		p8.friendCount = 0
	end
}
