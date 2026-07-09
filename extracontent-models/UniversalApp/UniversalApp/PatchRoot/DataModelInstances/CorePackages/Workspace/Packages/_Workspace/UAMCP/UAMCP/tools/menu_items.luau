local utils = require(script.Parent.Parent.utils)

local function findVisibleText(p1, _: number) -- line: 3
	-- upvalues: utils (copy)
	local u13 = nil
	local u14 = nil

	local function scan(p2, n2: number) -- line: 7
		-- upvalues: utils (copy), u13 (ref), u14 (ref), scan (copy)
		if n2 > 8 then
			return
		end

		if utils.TEXT_CLASSES[p2.ClassName] and p2.Visible and p2.Text ~= "" and p2.AbsoluteSize.X > 10 then
			local p2Text = p2.Text

			if not p2Text:match("^%d+$") and not (#p2Text <= 1) then
				if p2.Name == "Title" or p2.Name:match("Label$") or p2.Name == "StyledTextLabel" or p2.Name == "HeaderText" then
					if not u13 or #p2Text > #u13 then
						u13 = p2Text
					end
				elseif not u14 then
					u14 = p2Text
				end
			end
		end

		for _, child in ipairs(p2:GetChildren()) do
			scan(child, n2 + 1)
		end
	end

	scan(p1, 0)

	return u13 or u14
end

local btnCenter = utils.btnCenter

local function isItemLike(p3) -- line: 42
	if p3:IsA("ImageButton") or p3:IsA("TextButton") then
		return true
	end

	if p3:IsA("Frame") then
		for _, descendant in ipairs(p3:GetDescendants()) do
			if descendant:IsA("ImageButton") or descendant:IsA("TextButton") then
				return true
			end
		end
	end

	return false
end
local function findClickableChild(p4) -- line: 56
	if p4:IsA("ImageButton") or p4:IsA("TextButton") then
		return p4
	end

	for _, child in ipairs(p4:GetChildren()) do
		if child:IsA("ImageButton") or child:IsA("TextButton") then
			return child
		end
	end

	for _, descendant in ipairs(p4:GetDescendants()) do
		if descendant:IsA("ImageButton") or descendant:IsA("TextButton") then
			return descendant
		end
	end

	return nil
end

local t1 = {
	hamburger = "CoreGui.TopBarApp.TopBarApp.UnibarLeftFrame.UnibarMenu.SubMenuHost",
	esc_tabs = "CoreGui.RobloxGui.SettingsClippingShield.SettingsShield.MenuContainer.Page.HubBar.TabHeaderContainer.HubBarContainer",
	system_bar = "CoreGui.LuaAppScreenGui.SystemBar.SystemBar.RealSystemBar.AnimatedFrame.MainFrame.PrimaryItems"
}

local function countItemLikeChildren(p5) -- line: 79
	-- upvalues: isItemLike (copy)
	local n3 = 0

	for _, child in ipairs(p5:GetChildren()) do
		if child:IsA("GuiObject") and child.Visible and not (child.AbsoluteSize.Y < 5) and child.Name ~= "UIListLayout" and child.Name ~= "UIPadding" and not child.Name:match("Layout$") and isItemLike(child) then
			n3 += 1
		end
	end

	return n3
end
local function findBestItemContainer(p6, n4: number?) -- line: 98
	-- upvalues: countItemLikeChildren (copy)
	local v30 = n4 or 12
	local v31 = countItemLikeChildren(p6)
	local t2 = {{
		depth = 0,
		inst = p6
	}}
	local n5 = 1

	while n5 <= #t2 do
		local v34 = t2[n5]

		n5 += 1

		if not (v30 <= v34.depth) then
			for _, child in ipairs(v34.inst:GetChildren()) do
				if child:IsA("GuiObject") and child.Visible then
					local v37 = countItemLikeChildren(child)

					if v31 < v37 then
						v31 = v37
						p6 = child
					end

					t2[#t2 + 1] = {
						inst = child,
						depth = v34.depth + 1
					}
				end
			end
		end
	end

	return p6
end
local function findFirstScrollingFrameChild(p7) -- line: 133
	for _, child in ipairs(p7:GetChildren()) do
		if child:IsA("ScrollingFrame") then
			return child
		end

		for _, child2 in ipairs(child:GetChildren()) do
			if child2:IsA("ScrollingFrame") then
				return child2
			end
		end
	end

	return nil
end
local function findItemContainer(p8) -- line: 147
	-- upvalues: findFirstScrollingFrameChild (copy), isItemLike (copy)
	local v44 = findFirstScrollingFrameChild(p8)

	if v44 then
		for _, child in ipairs(v44:GetChildren()) do
			if not child:IsA("Frame") and not child:IsA("ScrollingFrame") then
				continue
			end

			local v47 = false

			for _, child3 in ipairs(child:GetChildren()) do
				if isItemLike(child3) then
					v47 = true

					break
				end
			end

			if v47 then
				return child
			end
		end

		return v44
	end

	return p8
end

return {
	description = "List all clickable items in a menu or container. Auto-discovers item labels and click coordinates. Works for hamburger menus, tab bars, dropdown lists, or any container with clickable children. Supports named shortcuts: 'hamburger', 'esc_tabs', and 'system_bar' (UA left-side nav). When a custom path's immediate children don't look like menu items, auto-recurses to find the best container.",
	params = {{
		name = "path",
		desc = "DataModel path to the menu container, or a shortcut name: \"hamburger\" (nine-dot dropdown), \"esc_tabs\" (ESC menu tab bar), \"system_bar\" (UA left-side nav)",
		required = false
	}},
	call = function(p9) -- line: 178
		-- upvalues: utils (copy), t1 (copy), findItemContainer (copy), findBestItemContainer (copy), findClickableChild (copy), btnCenter (copy)
		local path = p9.path

		if not path then
			local v52 = utils.resolveInstance(t1.hamburger)

			if v52 then
				for _, child in ipairs(v52:GetChildren()) do
					if child:IsA("GuiObject") and child.Visible and child.AbsoluteSize.Y > 0 then
						path = "hamburger"

						break
					end
				end
			end

			if not path then
				local v55 = utils.resolveInstance("CoreGui.RobloxGui.SettingsClippingShield.SettingsShield")

				if v55 and v55:IsA("GuiObject") and v55.Visible then
					path = "esc_tabs"
				end
			end

			if not path then
				return "ERROR: no path provided and no open menu detected. Open a menu first or provide a 'path' parameter."
			end
		end

		local v56 = t1[path] or path
		local v57 = utils.resolveInstance(v56)

		if not v57 then
			return "ERROR: could not resolve path \"" .. tostring(v56) .. "\""
		end

		if path == "hamburger" then
			for _, child in ipairs(v57:GetChildren()) do
				if child:IsA("GuiObject") and child.Visible and child.AbsoluteSize.Y > 0 then
					v57 = findItemContainer(child)

					break
				end
			end
		elseif not t1[path] then
			v57 = findBestItemContainer(v57)
		end

		local t3 = {}
		local v61 = utils.sortChildrenByLayoutOrder(v57:GetChildren())

		for _, v in ipairs(v61) do
			if v:IsA("GuiObject") and v.Visible and not (v.AbsoluteSize.Y < 5) and v.Name ~= "UIListLayout" and v.Name ~= "UIPadding" and not v.Name:match("Layout$") then
				local u64 = nil
				local u65 = nil

				local function scan(p10, n6: number) -- line: 7
					-- upvalues: utils (copy), u64 (ref), u65 (ref), scan (copy)
					if n6 > 8 then
						return
					end

					if utils.TEXT_CLASSES[p10.ClassName] and p10.Visible and p10.Text ~= "" and p10.AbsoluteSize.X > 10 then
						local p10Text = p10.Text

						if not p10Text:match("^%d+$") and not (#p10Text <= 1) then
							if p10.Name == "Title" or p10.Name:match("Label$") or p10.Name == "StyledTextLabel" or p10.Name == "HeaderText" then
								if not u64 or #p10Text > #u64 then
									u64 = p10Text
								end
							elseif not u65 then
								u65 = p10Text
							end
						end
					end

					for _, child in ipairs(p10:GetChildren()) do
						scan(child, n6 + 1)
					end
				end

				scan(v, 0)

				local v67 = u64 or u65

				if v67 then
					local v68 = findClickableChild(v)
					local v69 = v68 and btnCenter(v68) or nil
					local v70 = true

					if v68 then
						local ok, result = pcall(function() -- line: 249
							-- upvalues: v68 (copy)
							return v68.Active
						end)

						if ok and not result then
							v70 = false
						end
					end

					local v73 = false
					local v74 = v:FindFirstChild("Underline") or (v:FindFirstChild("TabSelection") or v:FindFirstChild("SelectedIndicator"))

					if v74 and v74:IsA("GuiObject") and v74.Visible then
						v73 = true
					end

					table.insert(t3, {
						name = v67,
						id = v.Name,
						center = v69,
						active = v70,
						isSelected = v73
					})
				end
			end
		end

		if #t3 == 0 then
			return "No menu items found in " .. v57:GetFullName()
		end

		local t4 = { ("Found %d item(s) in %s:\n"):format(#t3, v57:GetFullName()) }

		for i, v in ipairs(t3) do
			local t5 = { ("%d. \"%s\""):format(i, v.name) }

			if v.isSelected then
				table.insert(t5, "  [ACTIVE]")
			end

			if v.center then
				if v.active then
					table.insert(t5, ("  click → (%s)"):format(v.center))
				else
					table.insert(t5, "  *** DISABLED")
				end
			end

			table.insert(t5, ("  id: %s"):format(v.id))
			table.insert(t4, table.concat(t5, "\n"))
		end

		return table.concat(t4, "\n\n")
	end
}
