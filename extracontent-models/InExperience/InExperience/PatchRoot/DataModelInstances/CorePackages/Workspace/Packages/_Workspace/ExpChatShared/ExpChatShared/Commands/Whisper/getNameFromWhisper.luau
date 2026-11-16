local function getArgs(value: string, items)
	for _, item in pairs(items) do
		local v = item .. " "
		local v2 = string.len(v)

		if string.sub(value, 1, v2):lower() == v then
			return (string.sub(value, v2 + 1))
		end
	end

	return nil
end

return function(p: string, p2)
	local args = getArgs(p, p2)

	if args then
		return string.split(args, " ")[1]
	end

	return nil
end
