local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Signal = require(scriptParentParent.AppCommonLib).Signal

require(scriptParent.PlatformLeaderboardTypes)

local v4 = game:DefineFastInt("PlatformLeaderboardGlobalIntervalSeconds", 180)
local v5 = game:DefineFastInt("PlatformLeaderboardGlobalJitterSeconds", 30)
local v6 = game:DefineFastInt("PlatformLeaderboardFriendsIntervalSeconds", 180)
local v7 = game:DefineFastInt("PlatformLeaderboardFriendsJitterSeconds", 30)
local t1 = {}

t1.__index = t1

local _task = task

function t1.new(t2: {[any]: any}, p1, t3: {[any]: any}?) -- line: 63
	-- upvalues: _task (copy), Signal (copy), t1 (copy)
	return (setmetatable({
		_globalData = nil,
		_globalTimer = nil,
		_friendsTimer = nil,
		_fetcher = t2,
		_config = p1,
		_globalEntriesByUserId = {},
		_friendsData = {},
		_userScoreEntries = {},
		_currentlyActiveGlobalLeaderboardViewersByUserId = {},
		_currentFriendsLeaderboardViewersById = {},
		_scheduler = t3 or _task,
		_globalUpdated = Signal.new(),
		_friendsUpdated = Signal.new(),
		_userScoreUpdated = Signal.new()
	}, t1))
end
function t1.onGlobalUpdated(p2, p3: ((...any) -> ...any)) -- line: 86
	return p2._globalUpdated:connect(p3)
end
function t1.onFriendsUpdated(p4, p5: ((...any) -> ...any)) -- line: 93
	return p4._friendsUpdated:connect(p5)
end
function t1.onUserScoreUpdated(p6, p7: ((...any) -> ...any)) -- line: 100
	return p6._userScoreUpdated:connect(p7)
end
function t1.getGlobalData(p8) -- line: 107
	return p8._globalData
end
function t1.getFriendsData(p9, n1: number) -- line: 111
	return p9._friendsData[n1]
end
function t1.getUserScore(p10, n2: number) -- line: 118
	return p10._userScoreEntries[n2]
end
function t1._rebuildGlobalIndex(p11) -- line: 125
	table.clear(p11._globalEntriesByUserId)

	if not p11._globalData then
		return
	end

	for _, v26 in p11._globalData.entries do
		p11._globalEntriesByUserId[v26.userId] = v26
	end
end
function t1.resolveRankFromCache(p12, n3: number) -- line: 135
	local v29 = p12._globalEntriesByUserId[n3]

	if v29 then
		return v29.rank
	end

	return nil
end
function t1._resolveEntryFromGlobalLeaderboard(p13, n4: number) -- line: 140
	return p13._globalEntriesByUserId[n4]
end
function t1._fetchUserScoreForUser(p14, n5: number) -- line: 147
	if p14._userScoreEntries[n5] then
		p14._userScoreUpdated:fire(n5, p14._userScoreEntries[n5])

		return
	end

	local v34 = p14:_resolveEntryFromGlobalLeaderboard(n5)

	if v34 then
		p14._userScoreEntries[n5] = v34
		p14._userScoreUpdated:fire(n5, v34)

		return
	end

	local ok, result, v37 = pcall(p14._fetcher.fetchUserScore, p14._config.leaderboardId, n5)

	if ok and result then
		p14._userScoreEntries[n5] = v37
		p14._userScoreUpdated:fire(n5, v37)
	end
end
function t1._resolveUserScoresParallel(p15) -- line: 167
	table.clear(p15._userScoreEntries)

	for v39 in p15._currentlyActiveGlobalLeaderboardViewersByUserId do
		p15._scheduler.spawn(function() -- line: 170
			-- upvalues: p15 (copy), v39 (copy)
			p15:_fetchUserScoreForUser(v39)
		end)
	end
end
function t1._fetchFriendsLeaderboardForUser(p16, n6: number) -- line: 176
	local ok, result, v44 = pcall(p16._fetcher.fetchFriendsLeaderboard, p16._config.leaderboardId, n6)

	if ok and (result and v44) then
		local t4 = {
			entries = v44.entries,
			lastRefreshedAt = os.time()
		}

		p16._friendsData[n6] = t4
		p16._friendsUpdated:fire(n6, t4, v44.config)
	end
end
function t1.startGlobalRefresh(p17, n7: number) -- line: 187
	-- upvalues: v5 (copy), v4 (copy)
	local v48 = p17._currentlyActiveGlobalLeaderboardViewersByUserId[n7]

	p17._currentlyActiveGlobalLeaderboardViewersByUserId[n7] = true

	if p17._globalTimer then
		if not v48 then
			p17:_fetchUserScoreForUser(n7)
		end

		return
	end

	local u49 = nil

	local function loop() -- line: 198
		-- upvalues: p17 (copy), v5 (copy), v4 (copy), u49 (ref)
		repeat
			local ok, result, v74 = pcall(p17._fetcher.fetchGlobalLeaderboard, p17._config.leaderboardId)

			if ok and result and v74 then
				local t5 = {
					entries = v74.entries,
					lastRefreshedAt = os.time()
				}

				p17._globalData = t5
				p17:_rebuildGlobalIndex()
				p17._globalUpdated:fire(t5, v74.config)
			end

			p17:_resolveUserScoresParallel()

			local v76 = math.random(-v5, v5)

			p17._scheduler.wait((math.max(1, v4 + v76)))
		until p17._globalTimer ~= u49
	end

	u49 = p17._scheduler.defer(function() -- line: 216
		-- upvalues: loop (copy), p17 (copy), u49 (ref)
		if not pcall(loop) and p17._globalTimer == u49 then
			p17._globalTimer = nil
		end
	end)
	p17._globalTimer = u49
end
function t1.stopGlobalRefresh(p18, n8: number) -- line: 225
	p18._currentlyActiveGlobalLeaderboardViewersByUserId[n8] = nil
	p18._userScoreEntries[n8] = nil

	if next(p18._currentlyActiveGlobalLeaderboardViewersByUserId) then
		return
	end

	if p18._globalTimer then
		pcall(p18._scheduler.cancel, p18._globalTimer)
		p18._globalTimer = nil
	end

	p18._globalData = nil
	table.clear(p18._globalEntriesByUserId)
end
function t1.startFriendsRefresh(p19, n9: number) -- line: 240
	-- upvalues: v7 (copy), v6 (copy)
	p19._currentFriendsLeaderboardViewersById[n9] = true

	if p19._friendsTimer then
		if not p19._friendsData[n9] then
			p19:_fetchFriendsLeaderboardForUser(n9)
		end

		return
	end

	local u55 = nil
	local u56 = true

	local function loop() -- line: 253
		-- upvalues: p19 (copy), u56 (ref), v7 (copy), v6 (copy), u55 (ref)
		repeat
			table.clear(p19._friendsData)

			for v77 in p19._currentFriendsLeaderboardViewersById do
				local v78 = if not u56 then math.random(0, v7) else 0

				p19._scheduler.spawn(function() -- line: 258
					-- upvalues: p19 (copy), v78 (copy), v77 (copy)
					p19._scheduler.wait(v78)

					if p19._currentFriendsLeaderboardViewersById[v77] then
						p19:_fetchFriendsLeaderboardForUser(v77)
					end
				end)
			end

			u56 = false
			p19._scheduler.wait((math.max(1, v6)))
		until p19._friendsTimer ~= u55
	end

	u55 = p19._scheduler.defer(function() -- line: 271
		-- upvalues: loop (copy), p19 (copy), u55 (ref)
		if not pcall(loop) and p19._friendsTimer == u55 then
			p19._friendsTimer = nil
		end
	end)
	p19._friendsTimer = u55
end
function t1.stopFriendsRefresh(p20, n10: number) -- line: 280
	p20._currentFriendsLeaderboardViewersById[n10] = nil

	if next(p20._currentFriendsLeaderboardViewersById) then
		return
	end

	if p20._friendsTimer then
		pcall(p20._scheduler.cancel, p20._friendsTimer)
		p20._friendsTimer = nil
	end
end
function t1.forceRefresh(p21, p22, b1: boolean) -- line: 292
	p21._config = p22

	if b1 then
		p21._globalData = nil
		table.clear(p21._globalEntriesByUserId)
		table.clear(p21._friendsData)
		table.clear(p21._userScoreEntries)
	end

	local v63 = next(p21._currentlyActiveGlobalLeaderboardViewersByUserId)

	if p21._globalTimer and v63 then
		pcall(p21._scheduler.cancel, p21._globalTimer)
		p21._globalTimer = nil
		p21:startGlobalRefresh(v63)
	end

	if p21._friendsTimer then
		pcall(p21._scheduler.cancel, p21._friendsTimer)
		p21._friendsTimer = nil

		local t6 = {}

		for v65 in p21._currentFriendsLeaderboardViewersById do
			table.insert(t6, v65)
		end

		table.clear(p21._currentFriendsLeaderboardViewersById)

		for _, v67 in t6 do
			p21:startFriendsRefresh(v67)
		end
	end
end
function t1.cleanupForUserId(p23, n11: number) -- line: 329
	p23:stopGlobalRefresh(n11)
	p23:stopFriendsRefresh(n11)
end
function t1.teardown(p24) -- line: 334
	if p24._globalTimer then
		pcall(p24._scheduler.cancel, p24._globalTimer)
	end

	p24._globalTimer = nil
	p24._globalData = nil
	table.clear(p24._globalEntriesByUserId)
	table.clear(p24._currentlyActiveGlobalLeaderboardViewersByUserId)

	if p24._friendsTimer then
		pcall(p24._scheduler.cancel, p24._friendsTimer)
	end

	p24._friendsTimer = nil
	table.clear(p24._currentFriendsLeaderboardViewersById)
	table.clear(p24._friendsData)
	table.clear(p24._userScoreEntries)
end
function t1.destroy(p25) -- line: 351
	p25:teardown()
end

return t1
