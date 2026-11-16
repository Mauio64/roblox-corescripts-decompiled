local function dumpProperty(p, p2: string) -- 1 equivalent call inferred from this helper
	local success, result = pcall(function()
		return p[p2]
	end)

	if success then
		return (tostring(result))
	end

	return nil
end

local function dumpInstance(instance, options)
	local v = instance.Name
	local flag = false

	for _, v2 in options or {} do
		local v3 = dumpProperty(instance, v2) -- inferred equivalent call

		if not v3 then
			continue
		end

		local v4

		if flag then
			v4 = v .. ", "
		else
			v4 = v .. "   ("
			flag = true
		end

		v = v4 .. v2 .. "=" .. v3
	end

	if flag then
		v ..= ")"
	end

	return v .. "\n"
end

local function dumpInstanceTree(instance, p, p2: string)
	if instance == nil then
		return p2 .. "[nil Instance]\n"
	end

	if instance.Name == nil then
		return p2 .. "[Invalid Instance]\n"
	end

	local v = p2 .. dumpInstance(instance, p)

	for _, child in instance:GetChildren() do
		v ..= dumpInstanceTree(child, p, p2 .. "   ")
	end

	return v
end

return function(p, p2)
	return (dumpInstanceTree(p, p2, ""))
end
