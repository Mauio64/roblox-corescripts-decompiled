local parent = script.Parent.Parent

require(parent.util.Types)

return function(p, p2: string, p3, p4)
	if not p3 then
		if not p4.isServer then
			return false
		end

		error(string.format("Failed to load texture data"))
	end

	local v = p3[p]

	if not v then
		local v2 = p[p2]

		if not v2 or v2 == "" then
			return false
		end

		if p4.isServer then
			error(string.format("Failed to load texture data"))
		end
	end

	local v2 = v[p2]

	if v2 and v2.instance then
		return true, v2.instance
	end

	local v3 = p[p2]

	if not v3 or v3 == "" or not p4.isServer then
		return false
	end

	error(string.format("Failed to load texture data"))

	return true, v2.instance
end
