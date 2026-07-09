local t1 = {}

t1.__index = t1

function t1.new(_) -- line: 4
	-- upvalues: t1 (copy)
	local t2 = {
		CharacterAutoLoads = true,
		mockPlayers = {},
		mockPlayerAdded = Instance.new("BindableEvent"),
		mockPlayerRemoving = Instance.new("BindableEvent")
	}

	t2.PlayerAdded = t2.mockPlayerAdded.Event
	t2.PlayerRemoving = t2.mockPlayerRemoving.Event
	setmetatable(t2, {
		__index = t1
	})

	return t2
end
function t1.GetPlayers(p2) -- line: 22
	return p2.mockPlayers
end
function t1.mockAddPlayer(p3, p4) -- line: 28
	table.insert(p3.mockPlayers, p4)
	p3.mockPlayerAdded:Fire(p4)
end
function t1.mockRemovePlayer(p5, p6) -- line: 33
	local v9 = table.find(p5.mockPlayers, p6)

	if v9 ~= nil then
		table.remove(p5.mockPlayers, v9)
		p5.mockPlayerRemoving:Fire(p6)
	end
end
function t1.mockCleanup(p7) -- line: 41
	p7.mockPlayers = {}
	p7._playersByName = {}
end
function t1.createMockPlayerWithStats(_: {[any]: any}, s1: string, p8, t4: {[any]: any}?) -- line: 57
	local t5 = {
		Name = s1,
		DisplayName = s1,
		UserId = math.random(1, 1234567890),
		Team = p8,
		_childAdded = Instance.new("BindableEvent"),
		_childRemoved = Instance.new("BindableEvent"),
		_changed = Instance.new("BindableEvent")
	}

	if t4 then
		local Folder = Instance.new("Folder")

		Folder.Name = "leaderstats"

		for k, v in pairs(t4) do
			local valueType = v.valueType
			local v20

			if valueType then
				v20 = Instance.new(valueType)
			else
				local v21 = typeof(v.value)

				v20 = if v21 ~= "string" then if v21 ~= "number" then if v21 ~= "boolean" then Instance.new("IntValue") else Instance.new("BoolValue") else if v.value % 1 ~= 0 then Instance.new("NumberValue") else Instance.new("IntValue") else Instance.new("StringValue")
			end

			v20.Name = k
			v20.Value = v.value
			v20.Parent = Folder

			if v.isPrimary == true then
				local BoolValue = Instance.new("BoolValue")

				BoolValue.Name = "IsPrimary"
				BoolValue.Value = true
				BoolValue.Parent = v20
			end

			if v.priority then
				local IntValue = Instance.new("IntValue")

				IntValue.Name = "Priority"
				IntValue.Value = v.priority
				IntValue.Parent = v20
			end
		end

		t5.leaderstats = Folder
	end

	t5.ChildAdded = t5._childAdded.Event
	t5.ChildRemoved = t5._childRemoved.Event
	t5.Changed = t5._changed.Event

	function t5.FindFirstChild(p9, p10) -- line: 128
		return p9[p10]
	end
	function t5.GetChildren(p11) -- line: 131
		return { p11.leaderstats }
	end

	return t5
end

return t1
