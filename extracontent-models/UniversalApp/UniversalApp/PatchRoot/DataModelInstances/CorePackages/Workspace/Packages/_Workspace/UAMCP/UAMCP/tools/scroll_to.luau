local utils = require(script.Parent.Parent.utils)

return {
	description = "Scroll a ScrollingFrame so that a target element is visible in the viewport. Finds targets by path, instance Name, or Text content (in that priority). Returns the new click center coordinates.",
	params = {
		{
			name = "target",
			desc = "Name or Text content of the element to scroll into view",
			required = false
		},
		{
			name = "path",
			desc = "Full DataModel path to the element (most reliable)",
			required = false
		},
		{
			name = "root",
			desc = "root path to search under (default \"game.CoreGui\")",
			required = false
		}
	},
	call = function(p1) -- line: 10
		-- upvalues: utils (copy)
		local v3

		if p1.path then
			v3 = utils.resolveInstance(p1.path)

			if not v3 then
				return "ERROR: could not resolve path \"" .. tostring(p1.path) .. "\""
			end
		else
			if not p1.target then
				return "ERROR: either 'target' or 'path' is required"
			end

			local v4 = utils.resolveInstance(p1.root or "game.CoreGui")

			if not v4 then
				return "ERROR: could not resolve root path: " .. tostring(p1.root)
			end

			local str = tostring(p1.target)
			local u6 = nil
			local u7 = nil

			local function findTarget(p2) -- line: 28
				-- upvalues: u6 (ref), str (copy), u7 (ref), utils (copy), findTarget (copy)
				if u6 then
					return
				end

				if p2.Name == str then
					u6 = p2

					return
				end

				if not u7 and utils.TEXT_CLASSES[p2.ClassName] then
					local ok, result = pcall(function() -- line: 38
						-- upvalues: p2 (copy)
						return p2.Text
					end)

					if ok and result and result:lower():find(str:lower(), 1, true) then
						u7 = p2
					end
				end

				for _, child in ipairs(p2:GetChildren()) do
					findTarget(child)
				end
			end

			findTarget(v4)
			v3 = u6 or u7

			if not v3 then
				return "ERROR: no element found matching \"" .. str .. "\" (searched by Name and Text content)"
			end
		end

		if not v3 then
			return "ERROR: no target resolved"
		end

		if not v3:IsA("GuiObject") then
			return ("ERROR: resolved target \"%s\" is not a GuiObject (cannot scroll to it)"):format(v3:GetFullName())
		end

		local v9 = utils.findAncestorScrollFrame(v3)

		if not v9 then
			local AbsolutePosition = v3.AbsolutePosition
			local AbsoluteSize = v3.AbsoluteSize
			local v12 = AbsolutePosition.X + AbsoluteSize.X / 2
			local v13 = AbsolutePosition.Y + AbsoluteSize.Y / 2

			return ("Target \"%s\" (%s) is not inside a ScrollingFrame. No scrolling needed.\n"):format(v3.Name, v3.ClassName) .. ("Path: %s\n"):format(v3:GetFullName()) .. ("AbsolutePosition: %s\n"):format((tostring(AbsolutePosition))) .. ("Click center: (%.0f, %.0f)  <-- use these coords"):format(v12, v13)
		end

		local AbsolutePosition = v9.AbsolutePosition
		local AbsoluteSize = v9.AbsoluteSize
		local AbsolutePosition2 = v3.AbsolutePosition
		local AbsoluteSize2 = v3.AbsoluteSize
		local AbsolutePositionY = AbsolutePosition.Y
		local v19 = AbsolutePosition.Y + AbsoluteSize.Y
		local AbsolutePosition2Y = AbsolutePosition2.Y
		local v21 = AbsolutePosition2.Y + AbsoluteSize2.Y
		local v22 = AbsolutePositionY <= AbsolutePosition2Y and v21 <= v19

		if not v22 then
			local v23 = math.min(math.max(0, AbsolutePosition2.Y - AbsolutePosition.Y + v9.CanvasPosition.Y + AbsoluteSize2.Y / 2 - AbsoluteSize.Y / 2), (math.max(0, v9.AbsoluteCanvasSize.Y - AbsoluteSize.Y)))

			v9.CanvasPosition = Vector2.new(v9.CanvasPosition.X, v23)
			task.wait()
		end

		local AbsolutePosition3 = v3.AbsolutePosition
		local AbsoluteSize3 = v3.AbsoluteSize
		local v26 = AbsolutePosition3.X + AbsoluteSize3.X / 2
		local v27 = AbsolutePosition3.Y + AbsoluteSize3.Y / 2
		local v28 = AbsolutePosition3.Y >= AbsolutePosition.Y and AbsolutePosition3.Y + AbsoluteSize3.Y <= AbsolutePosition.Y + AbsoluteSize.Y
		local t1 = {
			("Target: \"%s\" (%s)"):format(v3.Name, v3.ClassName),
			("Path: %s"):format(v3:GetFullName()),
			("ScrollingFrame: %s"):format(v9:GetFullName()),
			("Was visible: %s"):format((tostring(v22))),
			("Now visible: %s"):format((tostring(v28))),
			("New AbsolutePosition: %s"):format((tostring(AbsolutePosition3))),
			("New AbsoluteSize: %s"):format((tostring(AbsoluteSize3))),
			("Click center: (%.0f, %.0f)  <-- use these coords"):format(v26, v27)
		}

		if not v22 then
			t1[#t1 + 1] = ("Scrolled CanvasPosition to: %s"):format((tostring(v9.CanvasPosition)))
		end

		return table.concat(t1, "\n")
	end
}
