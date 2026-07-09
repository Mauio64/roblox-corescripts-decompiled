return function(s1: string, s2: string, s3: string, s4: string?, n1: number?) -- line: 1
	local t1 = {}

	if s4 ~= nil then
		table.insert(t1, s1 .. s4 .. s2 .. s3)
	else
		table.insert(t1, s1 .. s2 .. s3)
	end

	if n1 ~= nil then
		local str = tostring(n1)

		if s4 ~= nil then
			table.insert(t1, s1 .. s4 .. s2 .. str .. s3)

			return t1
		end

		table.insert(t1, s1 .. s2 .. str .. s3)
	end

	return t1
end
