local Parent = script:FindFirstAncestor("UAMCP").Parent
local DomTestingLibrary = require(Parent.DomTestingLibrary)
local utils = require(script.Parent.Parent.utils)

local function findClickableInDescendants(p1) -- line: 7
	-- upvalues: findClickableInDescendants (copy)
	for _, child in ipairs(p1:GetChildren()) do
		if child:IsA("ImageButton") or child:IsA("TextButton") then
			return child
		end

		local v9 = findClickableInDescendants(child)

		if v9 then
			return v9
		end
	end

	return nil
end
local function findClickable(p2) -- line: 20
	-- upvalues: findClickableInDescendants (copy)
	local p2Parent = p2.Parent

	while p2Parent and p2Parent ~= game do
		if p2Parent:IsA("ImageButton") or p2Parent:IsA("TextButton") then
			return p2Parent
		end

		if not p2Parent:IsA("GuiObject") then
			break
		end

		p2Parent = p2Parent.Parent
	end

	local p2Parent2 = p2.Parent

	for _ = 1, 4 do
		if not p2Parent2 or p2Parent2 == game then
			return nil
		end

		for _, child in ipairs(p2Parent2:GetChildren()) do
			if child:IsA("ImageButton") or child:IsA("TextButton") then
				return child
			end

			local v16 = findClickableInDescendants(child)

			if v16 then
				return v16
			end
		end

		p2Parent2 = p2Parent2.Parent
	end

	return nil
end

return {
	description = "Find text content and return the nearest clickable ancestor (ImageButton/TextButton) with center coordinates. Defaults to visible-only results.",
	params = {
		{
			name = "query",
			desc = "substring to match against Text content (case-insensitive)",
			required = true
		},
		{
			name = "root",
			desc = "root path (default \"game.CoreGui\")",
			required = false
		},
		{
			name = "exact",
			desc = "if true, match text exactly instead of substring (default false)",
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
	call = function(p3) -- line: 61
		-- upvalues: utils (copy), DomTestingLibrary (copy), findClickable (copy)
		local query = p3.query

		if not query or query == "" then
			return "ERROR: 'query' is required"
		end

		local v19 = utils.resolveInstance(p3.root or "game.CoreGui")

		if not v19 then
			return "ERROR: could not resolve root path: " .. tostring(p3.root)
		end

		local v20 = p3.limit or utils.MAX_RESULTS
		local v21 = p3.visible_only ~= false
		local v22 = p3.exact and query or utils.escapePattern(query)
		local v23 = DomTestingLibrary.queryAllByText(v19, v22, {
			exact = p3.exact or false
		})

		if #v23 == 0 then
			return "No text found matching \"" .. query .. "\""
		end

		local t1 = {}

		for _, v in ipairs(v23) do
			if utils.TEXT_CLASSES[v.ClassName] then
				local v27 = utils.isVisible(v)

				if not v21 or v27 then
					local t2 = {
						text = v.Text,
						textClass = v.ClassName,
						textPath = v:GetFullName(),
						textPos = tostring(v.AbsolutePosition),
						textSize = tostring(v.AbsoluteSize),
						visible = v27
					}
					local v29 = if not v:IsA("TextButton") then findClickable(v) else v

					if v29 then
						local v30 = v29

						t2.clickClass = v30.ClassName
						t2.clickPath = v30:GetFullName()
						t2.clickPos = tostring(v30.AbsolutePosition)
						t2.clickSize = tostring(v30.AbsoluteSize)
						t2.clickCenter = utils.btnCenter(v30)

						local ok, result = pcall(function() -- line: 117
							-- upvalues: v30 (copy)
							return v30.Active
						end)

						if ok and not result then
							t2.disabled = true
						end

						local v33 = utils.findAncestorScrollFrame(v30)

						if v33 and not utils.isOnScreen(v30, v33) then
							t2.offScreen = true
							t2.scrollFrameName = v33.Name
						end
					end

					table.insert(t1, t2)

					if v20 <= #t1 then
						break
					end
				end
			end
		end

		if #t1 == 0 then
			return "No text found matching \"" .. query .. "\"" .. (not v21 and "" or " (visible_only=true, try visible_only=false)")
		end

		local t3 = { ("Found %d match(es) for \"%s\":\n"):format(#t1, query) }

		for _, v in ipairs(t1) do
			local t4 = {
				("Text: \"%s\"  Vis=%s"):format(v.text:sub(1, 60), (tostring(v.visible))),
				("Text element: %s  Pos=%s  Size=%s"):format(v.textClass, v.textPos, v.textSize),
				"  " .. v.textPath
			}

			if v.clickPath then
				table.insert(t4, ("Clickable: %s  Pos=%s  Size=%s"):format(v.clickClass, v.clickPos, v.clickSize))

				if v.disabled then
					table.insert(t4, "  *** DISABLED — button Active=false, clicking will have no effect. The button may require a prior action (e.g. changing a selection) before it becomes active.")
					table.insert(t4, ("  Click center: (%s)  <-- coords if it becomes active"):format(v.clickCenter))
				elseif v.offScreen then
					table.insert(t4, ("  *** OFF-SCREEN — element is scrolled out of view in '%s'. Use scroll_to({ target = \"%s\" }) or scroll_to({ path = \"%s\" }) first, then re-query for updated coords."):format(v.scrollFrameName, v.text:sub(1, 40), v.clickPath))
				else
					table.insert(t4, ("  Click center: (%s)  <-- use these coords"):format(v.clickCenter))
				end

				table.insert(t4, "  " .. v.clickPath)
			else
				table.insert(t4, "Clickable ancestor: none found (may be a non-interactive label)")
			end

			table.insert(t3, table.concat(t4, "\n"))
		end

		return table.concat(t3, "\n\n")
	end
}
