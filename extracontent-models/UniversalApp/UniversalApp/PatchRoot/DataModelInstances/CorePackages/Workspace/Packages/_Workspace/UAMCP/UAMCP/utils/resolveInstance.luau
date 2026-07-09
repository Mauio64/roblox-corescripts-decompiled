local function resolveInstance(s1: string) -- line: 1
	if not s1 or s1 == "" then
		return game
	end

	local t1 = {}

	for match in s1:gmatch("[^%.]+") do
		table.insert(t1, match)
	end

	local n1 = 1

	if t1[1] == "game" then
		n1 = 2
	end

	local function resolveFrom(p1, n2: number) -- line: 16
		-- upvalues: t1 (copy), n1 (ref), resolveFrom (copy)
		if n2 > #t1 then
			return p1
		end

		local v9 = t1[n2]

		if n2 == n1 and p1 == game then
			local v10 = game:FindFirstChild(v9)

			if not v10 then
				local ok, result = pcall(function() -- line: 26
					-- upvalues: v9 (copy)
					return game:GetService(v9)
				end)

				if ok and result then
					v10 = result
				end
			end

			if v10 then
				return resolveFrom(v10, n2 + 1)
			end

			return nil
		end

		local children = p1:GetChildren()
		local v14 = nil

		for _, v in ipairs(children) do
			if v9 ~= v.Name then
				continue
			end

			if not v14 then
				v14 = v
			end

			local v17 = resolveFrom(v, n2 + 1)

			if v17 then
				return v17
			end
		end

		return nil
	end

	return resolveFrom(game, n1)
end

return resolveInstance
