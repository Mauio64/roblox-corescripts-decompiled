local utils = require(script.Parent.Parent.utils)

return {
	description = "Read arbitrary properties from an instance by name. Use when inspect doesn't show the property you need (e.g. FontFace, Active, AutoButtonColor).",
	params = {
		{
			name = "path",
			desc = "DataModel path to the instance",
			required = true
		},
		{
			name = "props",
			desc = "array of property names to read, e.g. { \"FontFace\", \"Active\" }",
			required = true
		}
	},
	call = function(p1) -- line: 13
		-- upvalues: utils (copy)
		if not p1.path then
			return "ERROR: 'path' is required"
		end

		if not p1.props or #p1.props == 0 then
			return "ERROR: 'props' is required (array of property names)"
		end

		local v3 = utils.resolveInstance(p1.path)

		if not v3 then
			return "NOT FOUND: \"" .. tostring(p1.path) .. "\" does not resolve to an instance."
		end

		local t1 = {
			("%s (%s)"):format(v3.Name, v3.ClassName),
			v3:GetFullName(),
			""
		}

		for _, v in ipairs(p1.props) do
			local ok, result = pcall(function() -- line: 33
				-- upvalues: v3 (copy), v (copy)
				return v3[v]
			end)

			if ok then
				t1[#t1 + 1] = ("%s = %s"):format(v, (tostring(result)))
			else
				t1[#t1 + 1] = ("%s = ERROR: %s"):format(v, (tostring(result)))
			end
		end

		return table.concat(t1, "\n")
	end
}
