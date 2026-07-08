local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

return function(p1, s1: string, p2, p3) -- line: 5
	if not p2 then
		if not p3.isServer then
			return false
		end

		error(string.format("Failed to load texture data"))
	end

	local v6 = p2[p1]

	if not v6 then
		local v7 = p1[s1]

		if not v7 or v7 == "" then
			return false
		end

		if p3.isServer then
			error(string.format("Failed to load texture data"))
		end
	end

	local v8 = v6[s1]

	if not v8 or not v8.instance then
		local v9 = p1[s1]

		if not v9 or v9 == "" then
			return false
		end

		if not p3.isServer then
			return false
		end

		error(string.format("Failed to load texture data"))
	end

	return true, v8.instance
end
