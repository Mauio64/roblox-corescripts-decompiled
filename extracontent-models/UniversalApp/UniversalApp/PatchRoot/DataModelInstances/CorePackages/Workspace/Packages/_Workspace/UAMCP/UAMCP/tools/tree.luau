local utils = require(script.Parent.Parent.utils)

return {
	description = "Print a subtree of the DataModel as an indented tree, showing GUI properties.",
	params = {
		{
			name = "path",
			desc = "root path for the tree (default \"game.CoreGui\")",
			required = false
		},
		{
			name = "depth",
			desc = "max depth to traverse (default 3)",
			required = false
		},
		{
			name = "gui_only",
			desc = "if true, only show GuiObject descendants (default false)",
			required = false
		}
	},
	call = function(p1) -- line: 10
		-- upvalues: utils (copy)
		local v3 = utils.resolveInstance(p1.path or "game.CoreGui")

		if not v3 then
			return "ERROR: could not resolve path: " .. tostring(p1.path)
		end

		local v4 = p1.depth or 3
		local v5 = p1.gui_only or false
		local t1 = {}
		local n1 = 0

		local function recurse(p2, n2: number) -- line: 21
			-- upvalues: v4 (copy), n1 (ref), utils (copy), v5 (copy), t1 (copy), recurse (copy)
			if n2 > v4 or n1 >= utils.MAX_RESULTS then
				return
			end

			if v5 and not p2:IsA("GuiObject") and n2 > 0 then
				return
			end

			local v11 = ("%s%s \"%s\""):format(string.rep("  ", n2), p2.ClassName, p2.Name)
			local v12 = utils.guiProps(p2)

			if v12 ~= "" then
				v11 ..= "  " .. v12
			end

			table.insert(t1, v11)
			n1 += 1

			for _, child in ipairs(p2:GetChildren()) do
				recurse(child, n2 + 1)
			end
		end

		recurse(v3, 0)

		if utils.MAX_RESULTS <= n1 then
			table.insert(t1, ("\n... truncated at %d entries. Use a narrower path or smaller depth."):format(utils.MAX_RESULTS))
		end

		return table.concat(t1, "\n")
	end
}
