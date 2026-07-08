local function getArgs(s1: string, t1: {[any]: any}) -- line: 2
	for _, v in pairs(t1) do
		local v6 = v .. " "
		local v7 = string.len(v6)

		if v6 == string.sub(s1, 1, v7):lower() then
			return (string.sub(s1, v7 + 1))
		end
	end

	return nil
end

return function(s2: string, t2: {[any]: any}) -- line: 15
	-- upvalues: getArgs (copy)
	local v10 = getArgs(s2, t2)

	if v10 then
		return string.split(v10, " ")[1]
	end

	return nil
end
