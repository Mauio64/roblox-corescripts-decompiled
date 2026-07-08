local ParentParent = script.Parent.Parent.Parent

require(ParentParent.ES7Types)

return function(p1, n1: number?, n2: number?) -- line: 23
	if typeof(p1) ~= "table" then
		error(string.format("Array.slice called on %s", (typeof(p1))))
	end

	local v5 = #p1
	local v6 = n1 or 1
	local v7 = if n2 ~= nil and not (n2 > v5 + 1) then n2 else v5 + 1

	if v6 > v5 + 1 then
		return {}
	end

	local t1 = {}

	if v6 < 1 then
		v6 = math.max(v5 - math.abs(v6), 1)
	end

	if v7 < 1 then
		v7 = math.max(v5 - math.abs(v7), 1)
	end

	local n3 = 1

	while v6 < v7 do
		t1[n3] = p1[v6]
		v6 += 1
		n3 += 1
	end

	return t1
end
