local t1 = {}

t1.__index = t1

function t1.new(_) -- line: 4
	-- upvalues: t1 (copy)
	local t2 = {
		mockTeams = {},
		mockChildAddedEvent = Instance.new("BindableEvent"),
		mockChildRemovedEvent = Instance.new("BindableEvent")
	}

	t2.ChildAdded = t2.mockChildAddedEvent.Event
	t2.ChildRemoved = t2.mockChildRemovedEvent.Event
	setmetatable(t2, {
		__index = t1
	})

	return t2
end
function t1.GetTeams(p2) -- line: 21
	return p2.mockTeams
end
function t1.mockAddPlayerToTeam(p3, p4, p5) -- line: 27
	local v8 = nil

	if typeof(p5) == "string" then
		for _, v in ipairs(p3.mockTeams) do
			if p5 == v.Name then
				v8 = v

				break
			end
		end
	else
		v8 = p5
	end

	if v8 then
		p4.Team = v8
	end
end
function t1.mockRemovePlayerFromTeam(_, p7) -- line: 45
	p7.Team = nil
end
function t1.mockCreateTeam(p8, p9) -- line: 49
	table.insert(p8.mockTeams, p9)
	p8.mockChildAddedEvent:Fire(p9)
end
function t1.mockRemoveTeam(p10, p11) -- line: 54
	for i, v in ipairs(p10.mockTeams) do
		if v == p11 then
			table.remove(p10.mockTeams, i)
			p10.mockChildRemovedEvent:Fire(p11)

			return
		end
	end
end
function t1.mockCleanup(p12) -- line: 64
	p12.mockTeams = {}
end

return t1
