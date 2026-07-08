local function dumpProperty(p1, s1: string) -- line: 7
	local ok, result = pcall(function() -- line: 8
		-- upvalues: p1 (copy), s1 (copy)
		return p1[s1]
	end)

	if ok then
		return (tostring(result))
	end

	return nil
end
local function dumpInstance(p2, t1: {[any]: any}?) -- line: 14
	local p2Name = p2.Name
	local v11 = false

	for _, v13 in t1 or {} do
		local ok, result = pcall(function() -- line: 8
			-- upvalues: p2 (copy), v13 (copy)
			return p2[v13]
		end)
		local v16 = if not ok then nil else tostring(result)

		if v16 then
			local v17

			if not v11 then
				v11 = true
				v17 = p2Name .. "   ("
			else
				v17 = p2Name .. ", "
			end

			p2Name = v17 .. v13 .. "=" .. v16
		end
	end

	if v11 then
		p2Name ..= ")"
	end

	return p2Name .. "\n"
end
local function dumpInstanceTree(p3, t2: {[any]: any}?, s2: string) -- line: 38
	-- upvalues: dumpInstance (copy), dumpInstanceTree (copy)
	if p3 == nil then
		return s2 .. "[nil Instance]\n"
	end

	if p3.Name == nil then
		return s2 .. "[Invalid Instance]\n"
	end

	local v21 = s2 .. dumpInstance(p3, t2)

	for _, child in p3:GetChildren() do
		v21 ..= dumpInstanceTree(child, t2, s2 .. "   ")
	end

	return v21
end

return function(p4, t3: {[any]: any}?) -- line: 61
	-- upvalues: dumpInstanceTree (copy)
	return (dumpInstanceTree(p4, t3, ""))
end
