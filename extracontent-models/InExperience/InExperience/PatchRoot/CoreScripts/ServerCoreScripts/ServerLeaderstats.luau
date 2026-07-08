local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local t1 = {}
local n1 = 0
local StringValue = Instance.new("StringValue")

StringValue.Name = "LeaderstatsOrder"
StringValue.Parent = RobloxReplicatedStorage

function updateStats() -- line: 20
	-- upvalues: StringValue (copy), HttpService (copy), t1 (copy)
	StringValue.Value = HttpService:JSONEncode(t1)
end

updateStats()

local function addLeaderstat(p1) -- line: 26
	-- upvalues: t1 (copy), n1 (ref)
	if t1[p1] then
		return
	end

	t1[p1] = n1
	n1 += 1
	updateStats()
end
local function isValidStat(p2) -- line: 35
	return p2:IsA("StringValue") or (p2:IsA("IntValue") or (p2:IsA("BoolValue") or (p2:IsA("NumberValue") or (p2:IsA("DoubleConstrainedValue") or p2:IsA("IntConstrainedValue")))))
end
local function isValidContainer(p3) -- line: 44
	return p3:IsA("ValueBase") or (p3:IsA("Folder") or (p3:IsA("Configuration") or p3:IsA("Model")))
end

local t2 = {}

local function getLeaderstatConnections(p4, p5) -- line: 62
	-- upvalues: t2 (copy)
	if not t2[p4] then
		return nil
	end

	return t2[p4].leaderstats[p5]
end
local function leaderstatChildAdded(p6, p7, p8) -- line: 70
	-- upvalues: isValidStat (copy), t2 (copy), t1 (copy), n1 (ref)
	if not isValidStat(p8) then
		return
	end

	local v32 = if t2[p6] then t2[p6].leaderstats[p7] else nil

	if not v32 then
		return
	end

	assert(v32 ~= nil)

	local connection = p8:GetPropertyChangedSignal("Name"):Connect(function() -- line: 80
		-- upvalues: p8 (copy), t1 (copy), n1 (ref)
		local p8Name = p8.Name

		if t1[p8Name] then
			return
		end

		t1[p8Name] = n1
		n1 += 1
		updateStats()
	end)

	v32.leaderStatNameChanged[p8] = connection

	local p8Name = p8.Name

	if t1[p8Name] then
		return
	end

	t1[p8Name] = n1
	n1 += 1
	updateStats()
end
local function leaderstatChildRemoved(p9, p10, p11) -- line: 87
	-- upvalues: t2 (copy)
	local v38 = if t2[p9] then t2[p9].leaderstats[p10] else nil

	if not v38 then
		return
	end

	assert(v38 ~= nil)

	if not v38.leaderStatNameChanged[p11] then
		return
	end

	v38.leaderStatNameChanged[p11]:Disconnect()
	v38.leaderStatNameChanged[p11] = nil
end
local function leaderstatsAdded(p12, p13) -- line: 102
	-- upvalues: t2 (copy), leaderstatChildAdded (copy)
	if not t2[p12] then
		return
	end

	local connection = p13.ChildAdded:Connect(function(child) -- line: 107
		-- upvalues: leaderstatChildAdded (copy), p12 (copy), p13 (copy)
		leaderstatChildAdded(p12, p13, child)
	end)
	local connection2 = p13.ChildRemoved:Connect(function(child) -- line: 110
		-- upvalues: p12 (copy), p13 (copy), t2 (copy)
		local v83 = p12
		local v84 = p13
		local v85 = if t2[v83] then t2[v83].leaderstats[v84] else nil

		if not v85 then
			return
		end

		assert(v85 ~= nil)

		if not v85.leaderStatNameChanged[child] then
			return
		end

		v85.leaderStatNameChanged[child]:Disconnect()
		v85.leaderStatNameChanged[child] = nil
	end)

	t2[p12].leaderstats[p13] = {
		childAdded = connection,
		childRemoved = connection2,
		leaderStatNameChanged = {}
	}

	for _, child in p13:GetChildren() do
		leaderstatChildAdded(p12, p13, child)
	end
end
local function disconnectTableOfConnections(t3: {[any]: any}) -- line: 125
	for _, v47 in t3 do
		v47:Disconnect()
	end
end
local function leaderstatsRemoved(p14, p15) -- line: 131
	-- upvalues: t2 (copy)
	if not t2[p14] then
		return
	end

	local v50 = t2[p14].leaderstats[p15]

	if not v50 then
		return
	end

	v50.childAdded:Disconnect()
	v50.childRemoved:Disconnect()

	for _, v52 in v50.leaderStatNameChanged do
		v52:Disconnect()
	end

	t2[p14].leaderstats[p15] = nil
end
local function playerChildNameChanged(p16, p17) -- line: 147
	-- upvalues: leaderstatsAdded (copy), t2 (copy)
	if p17.Name == "leaderstats" then
		leaderstatsAdded(p16, p17)

		return
	end

	if not t2[p16] then
		return
	end

	local v55 = t2[p16].leaderstats[p17]

	if not v55 then
		return
	end

	v55.childAdded:Disconnect()
	v55.childRemoved:Disconnect()

	for _, v57 in v55.leaderStatNameChanged do
		v57:Disconnect()
	end

	t2[p16].leaderstats[p17] = nil
end
local function playerChildAdded(p18, p19) -- line: 155
	-- upvalues: t2 (copy), leaderstatsAdded (copy)
	if not p19:IsA("ValueBase") and (not p19:IsA("Folder") and (not p19:IsA("Configuration") and not p19:IsA("Model"))) then
		return
	end

	if not t2[p18] then
		return
	end

	local connection = p19:GetPropertyChangedSignal("Name"):Connect(function() -- line: 163
		-- upvalues: p18 (copy), p19 (copy), leaderstatsAdded (copy), t2 (copy)
		local v86 = p18
		local v87 = p19

		if v87.Name == "leaderstats" then
			leaderstatsAdded(v86, v87)

			return
		end

		if not t2[v86] then
			return
		end

		local v88 = t2[v86].leaderstats[v87]

		if not v88 then
			return
		end

		v88.childAdded:Disconnect()
		v88.childRemoved:Disconnect()

		for _, v90 in v88.leaderStatNameChanged do
			v90:Disconnect()
		end

		t2[v86].leaderstats[v87] = nil
	end)

	t2[p18].namedChanged[p19] = connection

	if p19.Name == "leaderstats" then
		leaderstatsAdded(p18, p19)

		return
	end

	if not t2[p18] then
		return
	end

	local v61 = t2[p18].leaderstats[p19]

	if not v61 then
		return
	end

	v61.childAdded:Disconnect()
	v61.childRemoved:Disconnect()

	for _, v63 in v61.leaderStatNameChanged do
		v63:Disconnect()
	end

	t2[p18].leaderstats[p19] = nil
end
local function playerChildRemoved(p20, p21) -- line: 171
	-- upvalues: t2 (copy)
	if not t2[p20] then
		return
	end

	if t2[p20].namedChanged[p21] then
		t2[p20].namedChanged[p21]:Disconnect()
		t2[p20].namedChanged[p21] = nil
	end

	if p21.Name == "leaderstats" then
		if not t2[p20] then
			return
		end

		local v66 = t2[p20].leaderstats[p21]

		if not v66 then
			return
		end

		v66.childAdded:Disconnect()
		v66.childRemoved:Disconnect()

		for _, v68 in v66.leaderStatNameChanged do
			v68:Disconnect()
		end

		t2[p20].leaderstats[p21] = nil
	end
end
local function playerAdded(p22) -- line: 186
	-- upvalues: t2 (copy), playerChildAdded (copy)
	local connection = p22.ChildRemoved:Connect(function(child) -- line: 187
		-- upvalues: p22 (copy), t2 (copy)
		local v92 = p22

		if not t2[v92] then
			return
		end

		if t2[v92].namedChanged[child] then
			t2[v92].namedChanged[child]:Disconnect()
			t2[v92].namedChanged[child] = nil
		end

		if child.Name == "leaderstats" then
			if not t2[v92] then
				return
			end

			local v93 = t2[v92].leaderstats[child]

			if not v93 then
				return
			end

			v93.childAdded:Disconnect()
			v93.childRemoved:Disconnect()

			for _, v95 in v93.leaderStatNameChanged do
				v95:Disconnect()
			end

			t2[v92].leaderstats[child] = nil
		end
	end)

	t2[p22] = {
		childAdded = p22.ChildAdded:Connect(function(child) -- line: 190
			-- upvalues: playerChildAdded (copy), p22 (copy)
			playerChildAdded(p22, child)
		end),
		childRemoved = connection,
		namedChanged = {},
		leaderstats = {}
	}

	for _, child in p22:GetChildren() do
		playerChildAdded(p22, child)
	end
end
local function playerRemoving(p23) -- line: 205
	-- upvalues: t2 (copy)
	if not t2[p23] then
		return
	end

	t2[p23].childAdded:Disconnect()
	t2[p23].childRemoved:Disconnect()

	for _, v75 in t2[p23].namedChanged do
		v75:Disconnect()
	end

	for _, v77 in t2[p23].leaderstats do
		v77.childAdded:Disconnect()
		v77.childRemoved:Disconnect()

		for _, v79 in v77.leaderStatNameChanged do
			v79:Disconnect()
		end
	end

	t2[p23] = nil
end

Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)

for _, player in Players:GetPlayers() do
	playerAdded(player)
end
