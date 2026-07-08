local tableDifference = require(script.Parent.tableDifference)

local function membershipTable(p1) -- line: 8
	local t1 = {}

	for i = 1, #p1 do
		t1[p1[i]] = true
	end

	return t1
end
local function listOfKeys(p2) -- line: 20
	local t2 = {}

	for k, _ in pairs(p2) do
		table.insert(t2, k)
	end

	return t2
end

return function(p3, p4) -- line: 33
	-- upvalues: tableDifference (copy)
	local v13 = tableDifference
	local t3 = {}

	for i = 1, #p3 do
		t3[p3[i]] = true
	end

	local t4 = {}

	for i = 1, #p4 do
		t4[p4[i]] = true
	end

	local v18 = v13(t3, t4)
	local t5 = {}

	for k, _ in pairs(v18) do
		table.insert(t5, k)
	end

	return t5
end
