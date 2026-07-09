local utils = require(script.Parent.Parent.utils)

return {
	description = "Search the DataModel for instances whose Name matches a query (case-insensitive substring). Defaults to GuiObject/ScreenGui classes only.",
	params = {
		{
			name = "query",
			desc = "substring to match against instance Name",
			required = true
		},
		{
			name = "root",
			desc = "root path to search under (default \"game.CoreGui\")",
			required = false
		},
		{
			name = "class",
			desc = "ClassName filter (overrides default GUI-only filter)",
			required = false
		},
		{
			name = "all",
			desc = "if true, search all classes instead of only GUI instances",
			required = false
		},
		{
			name = "limit",
			required = false,
			desc = ("max results (default %d)"):format(utils.MAX_RESULTS)
		}
	},
	call = function(p1) -- line: 12
		-- upvalues: utils (copy)
		local v3 = p1.query and p1.query:lower()

		if not v3 or v3 == "" then
			return "ERROR: 'query' is required"
		end

		local v4 = utils.resolveInstance(p1.root or "game.CoreGui")

		if not v4 then
			return "ERROR: could not resolve root path: " .. tostring(p1.root)
		end

		local class = p1.class
		local v6 = not p1.all and not class
		local v7 = p1.limit or utils.MAX_RESULTS
		local t1 = {}

		local function recurse(p2) -- line: 28
			-- upvalues: t1 (copy), v7 (copy), v3 (copy), class (copy), v6 (copy), utils (copy), recurse (copy)
			if #t1 >= v7 then
				return
			end

			if p2.Name:lower():find(v3, 1, true) then
				local v11 = true

				if class then
					v11 = p2.ClassName == class
				elseif v6 then
					v11 = p2:IsA("GuiObject") or p2:IsA("ScreenGui")
				end

				if v11 then
					local v12 = ("%s \"%s\"  —  %s"):format(p2.ClassName, p2.Name, p2:GetFullName())
					local v13 = utils.guiProps(p2)

					if v13 ~= "" then
						v12 ..= "\n    " .. v13
					end

					t1[#t1 + 1] = v12
				end
			end

			for _, child in ipairs(p2:GetChildren()) do
				recurse(child)
			end
		end

		recurse(v4)

		if #t1 == 0 then
			return "No instances found matching \"" .. tostring(p1.query) .. "\""
		end

		return ("Found %d result(s):\n\n"):format(#t1) .. table.concat(t1, "\n\n")
	end
}
