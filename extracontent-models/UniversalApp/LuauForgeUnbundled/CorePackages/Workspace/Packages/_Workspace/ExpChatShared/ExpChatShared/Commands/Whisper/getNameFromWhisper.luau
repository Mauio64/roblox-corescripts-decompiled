local function getArgs(value, items)
	for k, item in pairs(items) do
		local v5 = item .. " "
		local v6 = string.len(v5)

		if string.sub(value, 1, v6):lower() == v5 then
			return (string.sub(value, v6 + 1))
		end
	end

	return nil
end

return function(p2, p3)
	local args = getArgs(p2, p3)

	if args then
		return string.split(args, " ")[1]
	end

	return nil
end
