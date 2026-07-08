local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local function getFormattedTags(p1) -- line: 6
	if p1 ~= nil then
		if typeof(p1) == "table" then
			local t1 = {}

			for v5, v6 in p1 do
				if v6 then
					table.insert(t1, v5)
				end
			end

			return table.concat(t1, " ")
		end

		if typeof(p1) == "string" then
			return p1
		end

		assert(false, "Invalid argument to useStyleTags. Expected a table or string, got " .. typeof(p1))
	end

	return nil
end

return getFormattedTags
