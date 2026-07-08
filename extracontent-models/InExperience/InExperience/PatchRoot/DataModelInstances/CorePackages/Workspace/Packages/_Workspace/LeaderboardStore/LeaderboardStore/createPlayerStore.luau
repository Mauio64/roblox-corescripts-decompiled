local ParentParent = script.Parent.Parent
local Signals = require(ParentParent.Signals)
local createSignalMap = require(ParentParent.CoreScriptsRoactCommon).Utilities.createSignalMap
local createRBXEventSignal = require(script.Parent.createRBXEventSignal)
local isValidStat = require(script.Parent.isValidStat)
local getScoreValue = require(script.Parent.getScoreValue)

require(script.Parent.LeaderboardStoreTypes)

local FFlagPlayerListFixLeaderstatsStacking = require(ParentParent.SharedFlags).FFlagPlayerListFixLeaderstatsStacking
local _ = {
	PlayerChildAdded = "PlayerChildAdded",
	PlayerChildRemoved = "PlayerChildRemoved",
	LeaderstatNameChanged = "LeaderstatNameChanged",
	StatChanged = "StatChanged",
	StatChildAdded = "StatChildAdded",
	StatChildRemoved = "StatChildRemoved"
}

local function createPlayerStore(p1, p2: ((...any) -> ...any), p3: ((...any) -> ...any), p4: ((...any) -> ...any), p5: ((...any) -> ...any), p6: ((...any) -> ...any)?) -- line: 54
	-- upvalues: Signals (copy), createSignalMap (copy), createRBXEventSignal (copy), getScoreValue (copy), isValidStat (copy), FFlagPlayerListFixLeaderstatsStacking (copy)
	local t1 = {}
	local t2 = {}
	local v18, v19 = Signals.createSignal(0)
	local v20 = createSignalMap()
	local s1 = "Neutral"
	local t3 = {
		order = v18,
		stats = v20
	}

	local function getPlayerTeam() -- line: 75
		-- upvalues: p1 (copy)
		return p1.Team or "Neutral"
	end
	local function addStatConnection(s2: string, s3: string, p7) -- line: 80
		-- upvalues: t2 (ref)
		if t2[s2] == nil then
			t2[s2] = {}
		end

		t2[s2][s3] = p7
	end
	local function _removeStatConnection(s4: string, s5: string) -- line: 87
		-- upvalues: t2 (ref)
		local v37 = t2[s4]

		if v37 == nil then
			return
		end

		local v38 = v37[s5]

		if v38 then
			if v38.Disconnect then
				v38:Disconnect()
			end

			v37[s5] = nil
		end
	end
	local function onStatAdded(p8) -- line: 102
		-- upvalues: createRBXEventSignal (copy), Signals (copy), getScoreValue (copy), p2 (copy), v20 (copy), p4 (copy), s1 (ref), p5 (copy), t2 (ref)
		local p8Value = p8.Value
		local v41, v42 = createRBXEventSignal(p8.Changed, p8Value)
		local v43 = Signals.createComputed(function(p9) -- line: 105
			-- upvalues: getScoreValue (copy), v41 (copy)
			return getScoreValue(v41(p9))
		end)

		p2(p8)
		v20.setData(p8.Name, v43, false)

		local v44 = Signals.createEffect(function(p10) -- line: 114
			-- upvalues: v43 (copy), p4 (copy), s1 (ref), p8 (copy), p5 (copy)
			v43(p10)
			p4(s1, p8.Name)
			p5(s1, p8.Name)
		end)
		local p8Name = p8.Name
		local t4 = {
			Disconnect = function() -- line: 121
				-- upvalues: v44 (copy), v42 (copy)
				v44()
				v42:Disconnect()
			end
		}

		if t2[p8Name] == nil then
			t2[p8Name] = {}
		end

		t2[p8Name].StatChanged = t4

		local connection = p8.ChildAdded:Connect(function() -- line: 128
			-- upvalues: p2 (copy), p8 (copy)
			p2(p8)
		end)
		local p8Name2 = p8.Name

		if t2[p8Name2] == nil then
			t2[p8Name2] = {}
		end

		t2[p8Name2].StatChildAdded = connection

		local connection2 = p8.ChildRemoved:Connect(function() -- line: 133
			-- upvalues: p2 (copy), p8 (copy)
			p2(p8)
		end)
		local p8Name3 = p8.Name

		if t2[p8Name3] == nil then
			t2[p8Name3] = {}
		end

		t2[p8Name3].StatChildRemoved = connection2
	end
	local function onStatRemoved(p11) -- line: 139
		-- upvalues: t2 (ref), v20 (copy), p3 (copy)
		local v52 = t2[p11.Name]

		if v52 == nil then
			return
		end

		for _, v in pairs(v52) do
			if v.Disconnect then
				v:Disconnect()
			end
		end

		t2[p11.Name] = nil
		v20.removeData(p11.Name, false)
		p3(p11)
	end
	local function leaderstatsAdded(p12) -- line: 155
		-- upvalues: isValidStat (copy), onStatAdded (copy), t1 (ref), onStatRemoved (copy)
		t1.leaderstatsChildAdded = p12.ChildAdded:Connect(function(child) -- line: 156
			-- upvalues: isValidStat (copy), onStatAdded (copy)
			if isValidStat(child) then
				onStatAdded(child)
			end
		end)
		t1.leaderstatsChildRemoved = p12.ChildRemoved:Connect(function(child) -- line: 163
			-- upvalues: isValidStat (copy), onStatRemoved (copy)
			if isValidStat(child) then
				onStatRemoved(child)
			end
		end)

		local children = p12:GetChildren()

		for _, v in ipairs(children) do
			if isValidStat(v) then
				onStatAdded(v)
			end
		end
	end
	local function onPlayerChildAdded(p13) -- line: 179
		-- upvalues: leaderstatsAdded (copy), t1 (ref)
		local v60 = p13.Name == "leaderstats"
		local v61 = p13:IsA("ValueBase") or (p13:IsA("Folder") or p13:IsA("Model"))

		if not v60 and not v61 then
			return
		end

		t1.LeaderstatNameChanged = p13.Changed:Connect(function(property) -- line: 186
			-- upvalues: p13 (copy), leaderstatsAdded (copy)
			if property == "Name" and p13.Name == "leaderstats" then
				leaderstatsAdded(p13)
			end
		end)

		if p13.Name == "leaderstats" then
			leaderstatsAdded(p13)
		end
	end
	local function onPlayerChildRemoved(p14) -- line: 200
		-- upvalues: isValidStat (copy), onStatRemoved (copy), FFlagPlayerListFixLeaderstatsStacking (copy), p6 (copy), p5 (copy), s1 (ref)
		if p14.Name == "leaderstats" then
			local children = p14:GetChildren()

			for _, v in ipairs(children) do
				if isValidStat(v) then
					onStatRemoved(v)
				end
			end

			if FFlagPlayerListFixLeaderstatsStacking then
				p6()
			end
		end

		p5(s1)
	end
	local function connectPlayerEvents() -- line: 217
		-- upvalues: p1 (copy), onPlayerChildAdded (copy), t1 (ref), onPlayerChildRemoved (copy), leaderstatsAdded (copy)
		t1.PlayerChildAdded = p1.ChildAdded:Connect(function(child) -- line: 218
			-- upvalues: onPlayerChildAdded (copy)
			onPlayerChildAdded(child)
		end)
		t1.PlayerChildRemoved = p1.ChildRemoved:Connect(function(child) -- line: 223
			-- upvalues: onPlayerChildRemoved (copy)
			onPlayerChildRemoved(child)
		end)

		local leaderstats = p1:FindFirstChild("leaderstats")

		if leaderstats then
			leaderstatsAdded(leaderstats)

			return
		end

		for _, child in ipairs(p1:GetChildren()) do
			onPlayerChildAdded(child)
		end
	end

	s1 = p1.Team or "Neutral"
	connectPlayerEvents()

	return {
		getPlayer = function() -- line: 281
			-- upvalues: p1 (copy)
			return p1
		end,
		getPlayerEntry = function() -- line: 284
			-- upvalues: t3 (copy)
			return t3
		end,
		getStatValue = function(s6: string, p15) -- line: 243
			-- upvalues: v20 (copy)
			local v71 = v20.getData(s6, false)

			if v71 then
				return v71(p15)
			end

			return nil
		end,
		getTeam = function() -- line: 288
			-- upvalues: s1 (ref)
			return s1
		end,
		setOrder = function(n1: number) -- line: 251
			-- upvalues: v19 (copy)
			v19(n1)
		end,
		setTeam = function(p16) -- line: 255
			-- upvalues: s1 (ref)
			s1 = p16
		end,
		destroy = function() -- line: 259
			-- upvalues: t2 (ref), t1 (ref)
			for _, v in pairs(t2) do
				for _, v2 in pairs(v) do
					if v2.Disconnect then
						v2:Disconnect()
					end
				end
			end

			t2 = {}

			for _, v in pairs(t1) do
				if v.Disconnect then
					v:Disconnect()
				end
			end

			t1 = {}
		end
	}
end

return createPlayerStore
