local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local v = {}
local count = 0

local leaderstatsOrder = Instance.new("StringValue")
leaderstatsOrder.Name = "LeaderstatsOrder"
leaderstatsOrder.Parent = RobloxReplicatedStorage

function updateStats()
	leaderstatsOrder.Value = HttpService:JSONEncode(v)
end

updateStats()

local function addLeaderstat(name) -- 2 equivalent calls inferred from this helper
	if v[name] then
		return
	end

	v[name] = count
	count += 1
	updateStats()
end

local function isValidStat(instance)
	return instance:IsA("StringValue")
		or instance:IsA("IntValue")
		or instance:IsA("BoolValue")
		or instance:IsA("NumberValue")
		or instance:IsA("DoubleConstrainedValue")
		or instance:IsA("IntConstrainedValue")
end

local function isValidContainer(instance) -- 1 equivalent call inferred from this helper
	return instance:IsA("ValueBase") or instance:IsA("Folder") or instance:IsA("Configuration") or instance:IsA("Model")
end

local v2 = {}

local function getLeaderstatConnections(p, p2) -- 2 equivalent calls inferred from this helper
	if v2[p] then
		return v2[p].leaderstats[p2]
	end

	return nil
end

local function leaderstatChildAdded(p, instance, child)
	if not isValidStat(child) then
		return
	end

	local leaderstatConnections = getLeaderstatConnections(p, instance) -- inferred equivalent call

	if not leaderstatConnections then
		return
	end

	assert(leaderstatConnections ~= nil)

	local nameChangedConnection = child:GetPropertyChangedSignal("Name"):Connect(function()
		addLeaderstat(child.Name) -- inferred equivalent call
	end)
	leaderstatConnections.leaderStatNameChanged[child] = nameChangedConnection
	addLeaderstat(child.Name) -- inferred equivalent call
end

local function leaderstatChildRemoved(p, instance, child) -- 1 equivalent call inferred from this helper
	local leaderstatConnections = getLeaderstatConnections(p, instance) -- inferred equivalent call

	if not leaderstatConnections then
		return
	end

	assert(leaderstatConnections ~= nil)

	if not leaderstatConnections.leaderStatNameChanged[child] then
		return
	end

	leaderstatConnections.leaderStatNameChanged[child]:Disconnect()
	leaderstatConnections.leaderStatNameChanged[child] = nil
end

local function leaderstatsAdded(p, instance)
	if not v2[p] then
		return
	end

	local childAddedConnection = instance.ChildAdded:Connect(function(child)
		leaderstatChildAdded(p, instance, child)
	end)
	local childRemovedConnection = instance.ChildRemoved:Connect(function(child)
		leaderstatChildRemoved(p, instance, child) -- inferred equivalent call
	end)

	v2[p].leaderstats[instance] = {
		childAdded = childAddedConnection,
		childRemoved = childRemovedConnection,
		leaderStatNameChanged = {}
	}

	for _, child in instance:GetChildren() do
		leaderstatChildAdded(p, instance, child)
	end
end

local function disconnectTableOfConnections(items) -- 3 equivalent calls inferred from this helper
	for _, item in items do
		item:Disconnect()
	end
end

local function leaderstatsRemoved(p, p2) -- 2 equivalent calls inferred from this helper
	if not v2[p] then
		return
	end

	local leaderstat = v2[p].leaderstats[p2]

	if not leaderstat then
		return
	end

	leaderstat.childAdded:Disconnect()
	leaderstat.childRemoved:Disconnect()
	disconnectTableOfConnections(leaderstat.leaderStatNameChanged) -- inferred equivalent call
	v2[p].leaderstats[p2] = nil
end

local function playerChildNameChanged(p, instance) -- 2 equivalent calls inferred from this helper
	if instance.Name == "leaderstats" then
		leaderstatsAdded(p, instance)
		return
	end

	leaderstatsRemoved(p, instance) -- inferred equivalent call
end

local function playerChildAdded(instance, child)
	if not (isValidContainer(child) and v2[instance]) then -- inferred equivalent call
		return
	end

	local nameChangedConnection = child:GetPropertyChangedSignal("Name"):Connect(function()
		playerChildNameChanged(instance, child) -- inferred equivalent call
	end)

	v2[instance].namedChanged[child] = nameChangedConnection
	playerChildNameChanged(instance, child) -- inferred equivalent call
end

local function playerChildRemoved(instance, child) -- 1 equivalent call inferred from this helper
	if not v2[instance] then
		return
	end

	if v2[instance].namedChanged[child] then
		v2[instance].namedChanged[child]:Disconnect()
		v2[instance].namedChanged[child] = nil
	end

	if child.Name == "leaderstats" then
		leaderstatsRemoved(instance, child) -- inferred equivalent call
	end
end

local function playerAdded(instance)
	local childRemovedConnection = instance.ChildRemoved:Connect(function(child)
		playerChildRemoved(instance, child) -- inferred equivalent call
	end)
	v2[instance] = {
		childAdded = instance.ChildAdded:Connect(function(child)
			playerChildAdded(instance, child)
		end),
		childRemoved = childRemovedConnection,
		namedChanged = {},
		leaderstats = {}
	}

	for _, child in instance:GetChildren() do
		playerChildAdded(instance, child)
	end
end

local function playerRemoving(p)
	if not v2[p] then
		return
	end

	v2[p].childAdded:Disconnect()
	v2[p].childRemoved:Disconnect()
	disconnectTableOfConnections(v2[p].namedChanged) -- inferred equivalent call

	for _, leaderstat in v2[p].leaderstats do
		leaderstat.childAdded:Disconnect()
		leaderstat.childRemoved:Disconnect()
		disconnectTableOfConnections(leaderstat.leaderStatNameChanged) -- inferred equivalent call
	end

	v2[p] = nil
end

Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)

for _, v3 in Players:GetPlayers() do
	playerAdded(v3)
end
