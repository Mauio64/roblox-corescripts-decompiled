return function(p1, p2) -- line: 5
	if _G.__DEV__ then
		assert(typeof(p2) == "table", "Received a non-table as the second argument for instanceof")
	end

	if typeof(p1) ~= "table" then
		return false
	end

	local ok, result = pcall(function() -- line: 14
		-- upvalues: p2 (copy), p1 (ref)
		return p2.new ~= nil and p1.new == p2.new
	end)

	if ok and result then
		return true
	end

	local t1 = {
		tbl = true
	}

	while p1 and typeof(p1) == "table" do
		p1 = getmetatable(p1)

		if typeof(p1) == "table" then
			p1 = p1.__index

			if p2 == p1 then
				return true
			end
		end

		if typeof(p1) ~= "table" then
			continue
		end

		if t1[p1] then
			return false
		end

		t1[p1] = true
	end

	return false
end
