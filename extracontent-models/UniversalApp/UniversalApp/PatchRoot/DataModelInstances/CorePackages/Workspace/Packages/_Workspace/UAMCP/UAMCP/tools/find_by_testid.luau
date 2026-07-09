local utils = require(script.Parent.Parent.utils)
local CollectionService = game:GetService("CollectionService")

return {
	description = "Find instances by their data-testid tag (set via React.Tag). Supports exact match or substring search across all data-testid tags. Defaults to visible-only results.",
	params = {
		{
			name = "query",
			desc = "test ID to search for (case-insensitive substring match against the tag value)",
			required = true
		},
		{
			name = "exact",
			desc = "if true, match the full tag value exactly (default false)",
			required = false
		},
		{
			name = "root",
			desc = "root path to scope results under (default: all)",
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
	call = function(p1) -- line: 17
		-- upvalues: utils (copy), CollectionService (copy)
		if not p1.query or p1.query == "" then
			return "ERROR: 'query' is required"
		end

		local v4 = p1.limit or utils.MAX_RESULTS
		local v5 = p1.root and utils.resolveInstance(p1.root) or nil
		local v6 = p1.query:lower()
		local exact = p1.exact
		local v8 = p1.visible_only ~= false
		local AllTags = CollectionService:GetAllTags()
		local t1 = {}

		for _, v in ipairs(AllTags) do
			if v:sub(1, 12) == "data-testid=" then
				local v13 = v:sub(13)

				if exact then
					if v13 == p1.query then
						t1[#t1 + 1] = v
					end
				elseif v13:lower():find(v6, 1, true) then
					t1[#t1 + 1] = v
				end
			end
		end

		if #t1 == 0 then
			return "No data-testid tags found matching \"" .. tostring(p1.query) .. "\""
		end

		local t2 = {}

		for _, v in ipairs(t1) do
			local v2 = CollectionService:GetTagged(v)

			for _, v3 in ipairs(v2) do
				if v4 <= #t2 then
					break
				end

				if not v5 or v3:IsDescendantOf(v5) then
					local v20 = v3:IsA("GuiObject") and v3 or v3.Parent
					local v21 = not v20 or (not v20:IsA("GuiObject") or utils.isVisible(v20))

					if not v8 or v21 then
						local t3 = {
							testId = v:sub(13),
							class = v3.ClassName,
							name = v3.Name,
							path = v3:GetFullName(),
							visible = v21
						}

						if v3:IsA("GuiObject") then
							t3.pos = tostring(v3.AbsolutePosition)
							t3.size = tostring(v3.AbsoluteSize)
							t3.clickCenter = utils.btnCenter(v3)

							if v3:IsA("GuiButton") then
								local ok, result = pcall(function() -- line: 78
									-- upvalues: v3 (copy)
									return v3.Active
								end)

								if ok and not result then
									t3.disabled = true
								end
							end

							local v25 = utils.findAncestorScrollFrame(v3)

							if v25 and not utils.isOnScreen(v3, v25) then
								t3.offScreen = true
								t3.scrollFrameName = v25.Name
							end
						end

						t2[#t2 + 1] = t3
					end
				end
			end
		end

		if #t2 == 0 then
			return "No instances found with data-testid matching \"" .. tostring(p1.query) .. "\"" .. (v5 and " under " .. v5:GetFullName() or "") .. (not v8 and "" or " (visible_only=true, try visible_only=false)")
		end

		local t4 = { ("Found %d instance(s) with data-testid matching \"%s\":\n"):format(#t2, p1.query) }

		for _, v in ipairs(t2) do
			local t5 = { ("%s \"%s\"  testid=\"%s\""):format(v.class, v.name, v.testId) }

			if v.pos then
				t5[#t5 + 1] = ("  Pos=%s  Size=%s"):format(v.pos, v.size)
			end

			if v.disabled then
				t5[#t5 + 1] = "  *** DISABLED — button Active=false, clicking will have no effect."
				t5[#t5 + 1] = ("  Click center: (%s)  <-- coords if it becomes active"):format(v.clickCenter)
			elseif v.offScreen then
				t5[#t5 + 1] = ("  *** OFF-SCREEN — scrolled out of view in '%s'. Use scroll_to first."):format(v.scrollFrameName)
				t5[#t5 + 1] = ("  Click center: (%s)  <-- coords after scrolling"):format(v.clickCenter)
			elseif v.clickCenter then
				t5[#t5 + 1] = ("  Click center: (%s)  <-- use these coords"):format(v.clickCenter)
			end

			t5[#t5 + 1] = "  " .. v.path
			t4[#t4 + 1] = table.concat(t5, "\n")
		end

		return table.concat(t4, "\n\n")
	end
}
