local function dumpProperty(p2, p3)
	local success, result = pcall(function()
		return p2[p3]
	end)

	if success then
		return (tostring(result))
	end

	return nil
end

local function dumpInstance(instance, options)
	local v5 = instance.Name
	local flag = false

	for k, v6 in options or {} do
		local success, result = pcall(function()
			return instance[v6]
		end)

		local v7 = if success then tostring(result) else nil

		if not v7 then
			continue
		end

		local v8

		if flag then
			v8 = v5 .. ", "
		else
			v8 = v5 .. "   ("
			flag = true
		end

		v5 = v8 .. v6 .. "=" .. v7
	end

	if flag then
		v5 ..= ")"
	end

	return v5 .. "\n"
end

local function dumpInstanceTree(instance, p2, p3)
	if instance == nil then
		return p3 .. "[nil Instance]\n"
	end

	if instance.Name == nil then
		return p3 .. "[Invalid Instance]\n"
	end

	local v5 = p3 .. dumpInstance(instance, p2)

	for i, child in instance:GetChildren() do
		v5 ..= dumpInstanceTree(child, p2, p3 .. "   ")
	end

	return v5
end

return function(p2, p3)
	return (dumpInstanceTree(p2, p3, ""))
end
