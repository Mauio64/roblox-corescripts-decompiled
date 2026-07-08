local t1 = {}

local function isPascalCase(s1: string) -- line: 7
	-- upvalues: t1 (copy)
	if t1[s1] then
		return true
	end

	if typeof(s1) ~= "string" then
		return false
	end

	local v5 = s1:sub(1, 1)
	local v6 = v5 == v5:upper()

	if v6 then
		t1[s1] = true
	end

	return v6
end
local function mapServerBindingProps(t2: {[any]: any}, t3: {[any]: any}) -- line: 34
	-- upvalues: t1 (copy)
	local v9 = nil
	local v10 = nil

	for v11, v12 in t2 do
		local v13 = t3[v11]

		if v13 ~= nil then
			v9 = v9 or {}
			v9[v13] = v12
		else
			local v14

			if t1[v11] then
				v14 = true
			elseif typeof(v11) ~= "string" then
				v14 = false
			else
				local v15 = v11:sub(1, 1)

				v14 = v15 == v15:upper()

				if v14 then
					t1[v11] = true
				end
			end

			if v14 then
				v10 = v10 or {}
				table.insert(v10, v11)
			end
		end
	end

	return v9, v10
end

return mapServerBindingProps
