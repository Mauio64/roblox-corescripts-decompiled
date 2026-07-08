local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local ParentParent = script.Parent.Parent
local SharedFlags = require(ParentParent.SharedFlags)
local Signals = require(ParentParent.Signals)
local CoreScriptsRoactCommon = require(ParentParent.CoreScriptsRoactCommon)
local createSignalMap = CoreScriptsRoactCommon.Utilities.createSignalMap
local sortTableByValue = CoreScriptsRoactCommon.Utilities.sortTableByValue
local createPlayerStore = require(script.Parent.createPlayerStore)
local createTeamStore = require(script.Parent.createTeamStore)

require(script.Parent.LeaderboardStoreTypes)

local v10 = game:DefineFastFlag("FilterNewPlayerListValueStat", false)
local v11 = game:DefineFastFlag("PlayerListHideUnusedStats", false)
local FFlagPlayerListFixLeaderstatsStacking = SharedFlags.FFlagPlayerListFixLeaderstatsStacking
local v13 = game:DefineFastFlag("PlayerListSortByLowercaseUsername", false)
local v14 = game:DefineFastFlag("PlayerListSortByLowercaseDisplayName", false)
local t1 = {}

t1.__index = t1

function t1.new(p1, p2) -- line: 55
	-- upvalues: t1 (copy), Signals (copy), createSignalMap (copy), createTeamStore (copy)
	local v20 = setmetatable({
		_leaderboardConnections = {}
	}, t1)

	v20._teamStores = {}
	v20._playerStores = {}
	v20._teamsService = p1
	v20._playersService = p2

	local v21, v22 = Signals.createSignal({})

	v20._getServerAddOrder = v21
	v20._setServerAddOrder = v22
	v20._serverAddOrderConnection = {}
	v20._serverInstanceAddedConnection = nil
	v20._serverAddOrderEffectCleanup = nil
	v20._gameStatMetadata = {}
	v20._topGameStatsOrder = createSignalMap()
	v20._topGameStatsOrderSetter = {}
	v20._topGameStatSortOrder = {}
	v20._gameStatsUsage = {}
	v20._virtualTeamList = createSignalMap()
	v20._teamStores.Neutral = createTeamStore("Neutral", p1)

	local Neutral = v20._teamStores.Neutral

	v20._virtualTeamList.setData("Neutral", {
		name = Neutral.getName,
		color = Neutral.getColor,
		order = Neutral.getOrder,
		stats = Neutral.getStats,
		players = Neutral.getPlayers
	}, false)
	v20:_connectPlayers()
	v20:_connectTeams()
	v20:_updateServerAddOrder()

	return v20
end
function t1.destroy(p3) -- line: 106
	for _, v in pairs(p3._serverAddOrderConnection) do
		if v.Disconnect then
			v:Disconnect()
		end
	end

	p3._serverAddOrderConnection = {}

	if p3._serverAddOrderEffectCleanup then
		p3._serverAddOrderEffectCleanup()
	end

	if p3._serverInstanceAddedConnection then
		p3._serverInstanceAddedConnection:Disconnect()
	end

	p3._serverInstanceAddedConnection = nil

	for _, v in pairs(p3._leaderboardConnections) do
		if v.Disconnect then
			v:Disconnect()
		end
	end

	p3._leaderboardConnections = {}

	for _, v in pairs(p3._teamStores) do
		v.destroy()
	end

	p3._teamStores = {}

	for _, v in pairs(p3._playerStores) do
		v.destroy()
	end

	p3._playerStores = {}
end
function t1.getGameStatsList(p4) -- line: 141
	return p4._topGameStatsOrder
end
function t1.getTeamList(p5) -- line: 145
	return p5._virtualTeamList
end
function t1.getTeamPlayerList(p6, p7, _) -- line: 149
	-- upvalues: createSignalMap (copy)
	local v38 = p6._teamStores[p7]

	if not v38 then
		return createSignalMap()
	end

	return v38.getPlayers
end
function t1.getPlayerEntry(t2: {[any]: any}, p9, _) -- line: 160
	local v42 = t2._playerStores[p9]

	if not v42 then
		return nil
	end

	return v42.getPlayerEntry()
end
function t1._updateTeamStats(t3: {[any]: any}, p11, s1: string) -- line: 171
	local v46 = t3._teamStores[p11]

	if v46 then
		v46.updateStat(s1, function(p12, p13, p14) -- line: 174
			-- upvalues: t3 (copy)
			local v169 = t3._playerStores[p12]

			if v169 then
				return v169.getStatValue(p13, p14)
			end

			return nil
		end)
	end
end
function t1._removeTeamStats(t4: {[any]: any}, p15, s2: string) -- line: 184
	local v50 = t4._teamStores[p15]

	if v50 then
		v50.removeStat(s2)
	end
end
function t1._updateAllTeamStats(t5: {[any]: any}, s3: string) -- line: 191
	for k, _ in pairs(t5._teamStores) do
		t5:_updateTeamStats(k, s3)
	end
end
function t1._removeAllTeamStats(t6: {[any]: any}, s4: string) -- line: 198
	for k, _ in pairs(t6._teamStores) do
		t6:_removeTeamStats(k, s4)
	end
end
function t1._shouldSortPlayers(t7: {[any]: any}, _, s5: string?) -- line: 205
	if s5 then
		if s5 == t7._topGameStatSortOrder[1] and t7._gameStatMetadata[s5] and t7._gameStatMetadata[s5].isNumber then
			return true
		end

		if t7._gameStatMetadata[s5] and t7._gameStatMetadata[s5].priority == 1e999 then
			return true
		end

		if not t7._topGameStatSortOrder[1] and t7._gameStatMetadata[s5] and t7._gameStatMetadata[s5].isNumber then
			return true
		end

		return false
	end

	return true
end
function t1._sortPlayers(t8: {[any]: any}, p17, s6: string?) -- line: 234
	-- upvalues: sortTableByValue (copy)
	if not t8:_shouldSortPlayers(p17, s6) then
		return
	end

	local v65 = t8._teamStores[p17]

	if not v65 then
		return
	end

	local v66 = v65.getPlayers.getAllData(false)
	local v67 = sortTableByValue(v66, t8:_compareStatsValue(t8._topGameStatSortOrder))

	for i, v in ipairs(v67) do
		local key = v.key
		local v71 = t8._playerStores[key]

		if v71 then
			v71.setOrder(i)
		end
	end
end
function t1._compareStatsValue(t9: {[any]: any}, t10: {[any]: any}) -- line: 267
	-- upvalues: v13 (copy), v14 (copy)
	return function(p18, p19) -- line: 268
		-- upvalues: t10 (copy), t9 (copy), v13 (copy), v14 (copy)
		local v172 = t10[1]

		if v172 then
			local v173 = t9._playerStores[p18.key]
			local v174 = t9._playerStores[p19.key]

			if not v173 then
				return false
			end

			if not v174 then
				return true
			end

			local v175 = v173.getPlayerEntry().stats.getData(v172, false)

			if v175 == nil then
				return false
			end

			local v176 = v174.getPlayerEntry().stats.getData(v172, false)

			if v176 == nil then
				return true
			end

			local v177 = v175(false)
			local v178 = v176(false)

			if typeof(v177) == typeof(v178) and v177 ~= v178 then
				return t9:_compareRawStatsValue(v177, v178)
			end

			if not v13 then
				return p18.key.Name < p19.key.Name
			end
		end

		if v14 then
			return p18.key.DisplayName:lower() < p19.key.DisplayName:lower()
		end

		if v13 then
			return p18.key.Name:lower() < p19.key.Name:lower()
		end

		return p18.key.Name < p19.key.Name
	end
end
function t1._compareRawStatsValue(_, p21, p22) -- line: 313
	if p21 ~= nil and p22 ~= nil then
		return p22 < p21
	end

	return p22 ~= nil
end

local function isGameStatValidNumber(p23) -- line: 322
	return p23:IsA("NumberValue") or (p23:IsA("IntValue") or (p23:IsA("DoubleConstrainedValue") or p23:IsA("IntConstrainedValue")))
end
local function compareGameStats(p24, p25) -- line: 329
	if p24.value.priority == nil and p25.value.priority == nil then
		return true
	end

	if p24.value.priority == nil then
		return p25.value.priority < 0
	end

	if p25.value.priority == nil then
		return p24.value.priority > 0
	end

	return p24.value.priority > p25.value.priority
end

function t1._updateGameStatsToShow(p26) -- line: 342
	-- upvalues: sortTableByValue (copy), compareGameStats (copy), v11 (copy), Signals (copy)
	local t11 = {}
	local v82 = sortTableByValue(p26._gameStatMetadata, compareGameStats)

	p26._topGameStatSortOrder = {}

	local n1 = 0

	for i, v in ipairs(v82) do
		if n1 >= 4 then
			break
		end

		if not v11 or p26._gameStatMetadata[v.key].isUsed then
			local key = v.key

			t11[key] = i

			if p26._topGameStatsOrder.getData(key, false) == nil then
				local v87, v88 = Signals.createSignal(i)

				p26._topGameStatsOrder.setData(key, {
					order = v87
				}, false)
				p26._topGameStatsOrderSetter[key] = v88
			else
				p26._topGameStatsOrderSetter[key](i)
			end

			table.insert(p26._topGameStatSortOrder, key)
			n1 += 1
		end
	end

	for k, _ in pairs(p26._topGameStatsOrder.getAllData(false)) do
		if not t11[k] then
			p26._topGameStatsOrder.removeData(k, false)
			p26._topGameStatsOrderSetter[k] = nil
		end
	end
end
function t1._updateGameStatOrder(t12: {[any]: any}, p27, n2: number?) -- line: 389
	local v94 = t12._gameStatMetadata[p27.Name]
	local v95 = n2 or 0

	if v94 then
		if n2 == nil then
			t12._gameStatMetadata[p27.Name].hasPriority = false
		else
			t12._gameStatMetadata[p27.Name].hasPriority = true
		end
	end

	if v95 ~= v94.priority then
		t12._gameStatMetadata[p27.Name].priority = v95
		t12:_updateGameStatsToShow()
	end
end
function t1._updateServerAddOrder(p28) -- line: 406
	-- upvalues: RobloxReplicatedStorage (copy), Signals (copy), v10 (copy), v11 (copy)
	local u97 = RobloxReplicatedStorage:GetAttribute("LeaderstatsOrder") or {}

	RobloxReplicatedStorage:GetAttributeChangedSignal("LeaderstatsOrder"):Connect(function() -- line: 412
		-- upvalues: u97 (ref), RobloxReplicatedStorage (copy), p28 (copy)
		u97 = RobloxReplicatedStorage:GetAttribute("LeaderstatsOrder") or {}
		p28._setServerAddOrder(u97)
	end)

	local HttpService = game:GetService("HttpService")

	local function decodeJSON(s7: string) -- line: 421
		-- upvalues: HttpService (copy)
		return HttpService:JSONDecode(s7)
	end
	local function decodeAddOrder(s8: string) -- line: 425
		-- upvalues: decodeJSON (copy)
		local ok, result = pcall(decodeJSON, s8)

		return ok and result or {}
	end

	p28._serverInstanceAddedConnection = nil

	local function childAdded(p29) -- line: 432
		-- upvalues: p28 (copy), u97 (ref), decodeJSON (copy)
		if p29.Name ~= "LeaderstatsOrder" then
			return
		end

		if p28._serverInstanceAddedConnection then
			p28._serverInstanceAddedConnection:Disconnect()
		end

		local p29Value = p29.Value
		local ok, result = pcall(decodeJSON, p29Value)

		u97 = ok and result or {}
		p28._serverAddOrderConnection[p29] = p29.Changed:Connect(function(property) -- line: 440
			-- upvalues: u97 (ref), decodeJSON (copy), p28 (copy)
			local ok2, result2 = pcall(decodeJSON, property)

			u97 = ok2 and result2 or {}
			p28._setServerAddOrder(u97)
		end)
	end

	p28._serverInstanceAddedConnection = RobloxReplicatedStorage.ChildAdded:Connect(childAdded)

	for _, child in ipairs(RobloxReplicatedStorage:GetChildren()) do
		childAdded(child)
	end

	p28._serverAddOrderEffectCleanup = Signals.createEffect(function(p30) -- line: 453
		-- upvalues: p28 (copy), v10 (copy), v11 (copy)
		local v188 = p28._getServerAddOrder(p30)
		local v189 = false

		for k, v in pairs(v188) do
			if not v10 or v ~= 0 then
				if p28._gameStatMetadata[k] then
					if p28._gameStatMetadata[k].hasPriority ~= true then
						p28._gameStatMetadata[k].priority = v * -1
						v189 = true
					end
				elseif not v11 then
					p28._gameStatMetadata[k] = {
						hasPriority = false,
						priority = v * -1
					}
				end
			end
		end

		if v189 then
			p28:_updateGameStatsToShow()
		end
	end)
end
function t1._updateGameStatPriority(p31, p32) -- line: 486
	local PriorityValue = nil
	local Priority = p32:FindFirstChild("Priority")

	if Priority and (Priority:IsA("IntValue") or Priority:IsA("NumberValue")) then
		PriorityValue = Priority.Value
	end

	local IsPrimary = p32:FindFirstChild("IsPrimary")

	if IsPrimary then
		if IsPrimary:IsA("BoolValue") then
			if IsPrimary.Value then
				PriorityValue = 1e999
			end
		else
			PriorityValue = 1e999
		end
	end

	p31:_updateGameStatOrder(p32, PriorityValue)
end
function t1._addGameStat(p33, p34) -- line: 506
	-- upvalues: v11 (copy)
	if p33._gameStatMetadata[p34.Name] == nil then
		p33._gameStatMetadata[p34.Name] = {}
	end

	p33._gameStatMetadata[p34.Name].isNumber = p34:IsA("NumberValue") or (p34:IsA("IntValue") or (p34:IsA("DoubleConstrainedValue") or p34:IsA("IntConstrainedValue")))
	p33:_updateGameStatPriority(p34)

	if v11 and not p33._gameStatMetadata[p34.Name].isUsed then
		p33._gameStatMetadata[p34.Name].isUsed = true
		p33:_updateGameStatsToShow()
	end

	p33._gameStatsUsage[p34.Name] = not p33._gameStatsUsage[p34.Name] and 1 or p33._gameStatsUsage[p34.Name] + 1
	p33:_updateAllTeamStats(p34.Name)
end
function t1._removeGameStat(p35, p36) -- line: 525
	p35._gameStatsUsage[p36.Name] = not p35._gameStatsUsage[p36.Name] and 0 or p35._gameStatsUsage[p36.Name] - 1

	if p35._gameStatsUsage[p36.Name] <= 0 then
		p35._gameStatsUsage[p36.Name] = nil
		p35._topGameStatsOrder.removeData(p36.Name, false)
		p35._topGameStatsOrderSetter[p36.Name] = nil
		p35._gameStatMetadata[p36.Name] = nil
		p35:_updateGameStatsToShow()
		p35:_updateAllTeamStats(p36.Name)

		return
	end

	p35:_updateGameStatPriority(p36)
end

if FFlagPlayerListFixLeaderstatsStacking then
	function t1._checkGameStatsExist(p37) -- line: 546
		local t13 = {}

		for v115, _ in p37._gameStatMetadata do
			t13[v115] = false
		end

		for v117, _ in p37._playerStores do
			local leaderstats = v117:FindFirstChild("leaderstats")

			if leaderstats then
				for v120, _ in t13 do
					if leaderstats:FindFirstChild(v120) then
						t13[v120] = true
					end
				end
			end
		end

		for v122, v123 in t13 do
			if not v123 then
				p37._gameStatsUsage[v122] = nil
				p37._topGameStatsOrder.removeData(v122, false)
				p37._topGameStatsOrderSetter[v122] = nil
				p37._gameStatMetadata[v122] = nil
				p37:_updateGameStatsToShow()
				p37:_updateAllTeamStats(v122)
			end
		end
	end
end

function t1._createPlayerStore(t14: {[any]: any}, p38) -- line: 576
	-- upvalues: createPlayerStore (copy), FFlagPlayerListFixLeaderstatsStacking (copy)
	return createPlayerStore(p38, function(p39) -- line: 579
		-- upvalues: t14 (copy)
		t14:_addGameStat(p39)
	end, function(p40) -- line: 582
		-- upvalues: t14 (copy)
		t14:_removeGameStat(p40)
	end, function(p41, p42) -- line: 585
		-- upvalues: t14 (copy)
		t14:_updateTeamStats(p41, p42)
	end, function(p43, p44) -- line: 588
		-- upvalues: t14 (copy)
		t14:_sortPlayers(p43, p44)
	end, if not FFlagPlayerListFixLeaderstatsStacking then nil else function() -- line: 592
		-- upvalues: t14 (copy)
		t14:_checkGameStatsExist()
	end)
end
function t1._createTeamStore(p45, p46) -- line: 599
	-- upvalues: createTeamStore (copy)
	return createTeamStore(p46, p45._teamsService)
end
function t1._getOrCreateTeamStore(p47, p48) -- line: 603
	local v130 = p47._teamStores[p48]

	if not v130 then
		v130 = p47:_createTeamStore(p48)
		p47._teamStores[p48] = v130

		if p48 ~= "Neutral" then
			p47._virtualTeamList.setData(p48, {
				name = v130.getName,
				color = v130.getColor,
				order = v130.getOrder,
				stats = v130.getStats,
				players = v130.getPlayers
			}, false)
		end
	end

	return v130
end
function t1._addPlayerStore(t15: {[any]: any}, p49) -- line: 623
	if t15._playerStores[p49] then
		return
	end

	local v133 = not p49.Team and "Neutral" or p49.Team

	t15:_getOrCreateTeamStore(v133).addPlayer(p49)

	local v134 = t15:_createPlayerStore(p49)

	t15._playerStores[p49] = v134
	t15:_connectPlayerTeamChange(p49)
	t15:_sortPlayers(v133)
end
function t1._removePlayerStore(t16: {[any]: any}, p50) -- line: 644
	local v137 = t16._playerStores[p50]

	if not v137 then
		return
	end

	local v138 = v137.getTeam()
	local v139 = t16._teamStores[v138]

	if v139 then
		v139.removePlayer(p50)
	end

	local v140 = "PlayerTeamChanged_" .. p50.Name
	local v141 = t16._leaderboardConnections[v140]

	if v141 and v141.Disconnect then
		v141:Disconnect()
		t16._leaderboardConnections[v140] = nil
	end

	v137.destroy()
	t16._playerStores[p50] = nil
	t16:_sortPlayers(v138)
end
function t1._connectPlayerTeamChange(t17: {[any]: any}, p51) -- line: 673
	local connection = p51.Changed:Connect(function(property: string) -- line: 674
		-- upvalues: t17 (copy), p51 (copy)
		if property == "Team" then
			local v199 = t17._playerStores[p51]

			if not v199 then
				return
			end

			local v200 = v199.getTeam()
			local v201 = not p51.Team and "Neutral" or p51.Team
			local v202 = t17._teamStores[v200]

			if v202 then
				v202.removePlayer(p51)
			end

			t17:_getOrCreateTeamStore(v201).addPlayer(p51)
			v199.setTeam(v201)
			t17:_sortPlayers(v200)
			t17:_sortPlayers(v201)
		end
	end)

	t17._leaderboardConnections["PlayerTeamChanged_" .. p51.Name] = connection
end
function t1._addTeamStore(t18: {[any]: any}, p52) -- line: 706
	if t18._teamStores[p52] then
		return
	end

	local v147 = t18:_createTeamStore(p52)

	t18._teamStores[p52] = v147
	t18._virtualTeamList.setData(p52, {
		name = v147.getName,
		color = v147.getColor,
		order = v147.getOrder,
		stats = v147.getStats,
		players = v147.getPlayers
	}, false)
end
function t1._removeTeamStore(t19: {[any]: any}, p53) -- line: 724
	local v150 = t19._teamStores[p53]

	if not v150 then
		return
	end

	local v151 = t19:_getOrCreateTeamStore("Neutral")
	local v152 = v150.getPlayers.getAllData(false)

	for k, _ in pairs(v152) do
		v150.removePlayer(k)
		v151.addPlayer(k)

		local v155 = t19._playerStores[k]

		if v155 then
			v155.setTeam("Neutral")
		end
	end

	v150.destroy()
	t19._teamStores[p53] = nil
	t19._virtualTeamList.removeData(p53, false)
end
function t1._connectTeams(p54) -- line: 756
	local connection = p54._teamsService.ChildAdded:Connect(function(child) -- line: 757
		-- upvalues: p54 (copy)
		if child:IsA("Team") then
			p54:_addTeamStore(child)
		end
	end)

	p54._leaderboardConnections.TeamAdded = connection

	local connection2 = p54._teamsService.ChildRemoved:Connect(function(child) -- line: 764
		-- upvalues: p54 (copy)
		if child:IsA("Team") then
			p54:_removeTeamStore(child)
		end
	end)

	p54._leaderboardConnections.TeamRemoved = connection2

	for _, v in pairs(p54._teamsService:GetTeams()) do
		p54:_addTeamStore(v)
	end
end
function t1._connectPlayers(p55) -- line: 779
	local connection = p55._playersService.PlayerAdded:Connect(function(player) -- line: 780
		-- upvalues: p55 (copy)
		p55:_addPlayerStore(player)
	end)

	p55._leaderboardConnections.PlayerAdded = connection

	local connection3 = p55._playersService.PlayerRemoving:Connect(function(player) -- line: 785
		-- upvalues: p55 (copy)
		p55:_removePlayerStore(player)
	end)

	p55._leaderboardConnections.PlayerRemoving = connection3

	for _, player in pairs(p55._playersService:GetPlayers()) do
		p55:_addPlayerStore(player)
	end
end

return t1
