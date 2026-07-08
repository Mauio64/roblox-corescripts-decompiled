local t1 = {}

local function setAllCommands(p1) -- line: 2
	-- upvalues: t1 (ref)
	t1 = p1
end

return function(p2) -- line: 6
	-- upvalues: t1 (ref)
	if p2 then
		t1 = p2
	end

	return t1
end
