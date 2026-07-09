local Parent = script:FindFirstAncestor("UAMCP").Parent
local DomTestingLibrary = require(Parent.DomTestingLibrary)
local utils = require(script.Parent.Parent.utils)

local function offScreenSuffix(p1) -- line: 7
	-- upvalues: utils (copy)
	local v8 = utils.findAncestorScrollFrame(p1)

	if v8 and not utils.isOnScreen(p1, v8) then
		return ("\n  *** OFF-SCREEN — element is scrolled out of view in '%s'. Use scroll_to first, then re-query."):format(v8.Name)
	end

	return ""
end
local function formatEntry(p2, b1: boolean) -- line: 17
	-- upvalues: utils (copy)
	local p2Text = p2.Text
	local v12 = ("%s \"%s\" — Text=\"%s\"  Vis=%s  Pos=%s  Size=%s\n  %s"):format(p2.ClassName, p2.Name, p2Text:sub(1, 60), tostring(b1), tostring(p2.AbsolutePosition), tostring(p2.AbsoluteSize), p2:GetFullName())
	local v13 = utils.findAncestorScrollFrame(p2)

	return v12 .. ((not v13 or utils.isOnScreen(p2, v13)) and "" or ("\n  *** OFF-SCREEN — element is scrolled out of view in '%s'. Use scroll_to first, then re-query."):format(v13.Name))
end
local function collectAllText(p3, b2: boolean, n1: number) -- line: 31
	-- upvalues: utils (copy), formatEntry (copy)
	local t1 = {}

	local function walk(p4) -- line: 33
		-- upvalues: t1 (copy), n1 (copy), utils (copy), b2 (copy), formatEntry (copy), walk (copy)
		if #t1 >= n1 then
			return
		end

		if utils.TEXT_CLASSES[p4.ClassName] then
			local ok, result = pcall(function() -- line: 39
				-- upvalues: p4 (copy)
				return p4.Text
			end)

			if ok and result and result ~= "" then
				local v34 = utils.isVisible(p4)

				if not b2 or v34 then
					t1[#t1 + 1] = formatEntry(p4, v34)
				end
			end
		end

		for _, child in ipairs(p4:GetChildren()) do
			if #t1 >= n1 then
				return
			end

			walk(child)
		end
	end

	walk(p3)

	return t1
end

return {
	description = "Find text elements. If query is provided, uses DomTestingLibrary queryAllByText. If query is omitted, lists all text elements under root. Defaults to visible-only results. Annotates elements scrolled outside their ancestor ScrollingFrame as *** OFF-SCREEN.",
	params = {
		{
			name = "query",
			desc = "text to search for (case-insensitive substring by default). Omit to list all text under root.",
			required = false
		},
		{
			name = "exact",
			desc = "if true, match text exactly instead of substring (default false)",
			required = false
		},
		{
			name = "root",
			desc = "root path (default \"game.CoreGui\")",
			required = false
		},
		{
			name = "visible_only",
			desc = "if false, include invisible elements (default true)",
			required = false
		},
		{
			name = "limit",
			required = false,
			desc = ("max results (default %d)"):format(utils.MAX_RESULTS)
		}
	},
	call = function(p5) -- line: 73
		-- upvalues: utils (copy), formatEntry (copy), DomTestingLibrary (copy)
		local v20 = utils.resolveInstance(p5.root or "game.CoreGui")

		if not v20 then
			return "ERROR: could not resolve root path: " .. tostring(p5.root)
		end

		local v21 = p5.limit or utils.MAX_RESULTS
		local v22 = p5.visible_only ~= false
		local v25

		if not p5.query or p5.query == "" then
			local t2 = {}

			local function walk(p6) -- line: 33
				-- upvalues: t2 (copy), v21 (copy), utils (copy), v22 (copy), formatEntry (copy), walk (copy)
				if #t2 >= v21 then
					return
				end

				if utils.TEXT_CLASSES[p6.ClassName] then
					local ok, result = pcall(function() -- line: 39
						-- upvalues: p6 (copy)
						return p6.Text
					end)

					if ok and result and result ~= "" then
						local v40 = utils.isVisible(p6)

						if not v22 or v40 then
							t2[#t2 + 1] = formatEntry(p6, v40)
						end
					end
				end

				for _, child in ipairs(p6:GetChildren()) do
					if #t2 >= v21 then
						return
					end

					walk(child)
				end
			end

			walk(v20)
			v25 = t2
		else
			local v26 = p5.exact and p5.query or utils.escapePattern(p5.query)
			local v27 = DomTestingLibrary.queryAllByText(v20, v26, {
				exact = p5.exact or false
			})

			v25 = {}

			for _, v in ipairs(v27) do
				if v21 <= #v25 then
					break
				end

				if utils.TEXT_CLASSES[v.ClassName] then
					local v30 = utils.isVisible(v)

					if not v22 or v30 then
						v25[#v25 + 1] = formatEntry(v, v30)
					end
				end
			end
		end

		if #v25 == 0 then
			return (p5.query and "No text elements found matching \"" .. p5.query .. "\"" or "No text elements found") .. (not v22 and "" or " (visible_only=true, try visible_only=false)")
		end

		return ("Found %d text element(s):\n\n"):format(#v25) .. table.concat(v25, "\n\n")
	end
}
