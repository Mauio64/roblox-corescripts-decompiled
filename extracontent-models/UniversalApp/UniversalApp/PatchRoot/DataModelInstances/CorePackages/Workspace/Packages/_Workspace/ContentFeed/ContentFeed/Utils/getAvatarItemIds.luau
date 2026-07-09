local HttpService = game:GetService("HttpService")

return function(s1: string?) -- line: 3
	-- upvalues: HttpService (copy)
	if not s1 then
		return nil
	end

	local ok, result = pcall(function() -- line: 8
		-- upvalues: HttpService (copy), s1 (copy)
		return HttpService:JSONDecode(s1)
	end)

	if not ok or not result then
		return nil
	end

	local t1 = {}
	local t2 = {}

	local function addItems(t3: {[any]: any}) -- line: 19
		-- upvalues: t2 (copy), t1 (copy)
		for _, v in pairs(t3) do
			if not t2[v] then
				table.insert(t1, v)
				t2[v] = true
			end
		end
	end

	if result.avatarItems then
		local avatarItems = result.avatarItems

		for _, v in pairs(avatarItems) do
			if not t2[v] then
				table.insert(t1, v)
				t2[v] = true
			end
		end
	end

	if result.userMetadata then
		for _, v in pairs(result.userMetadata) do
			if v.avatarItems then
				local avatarItems = v.avatarItems

				for _, v2 in pairs(avatarItems) do
					if not t2[v2] then
						table.insert(t1, v2)
						t2[v2] = true
					end
				end
			end
		end
	end

	if next(t1) == nil then
		return nil
	end

	return t1
end
