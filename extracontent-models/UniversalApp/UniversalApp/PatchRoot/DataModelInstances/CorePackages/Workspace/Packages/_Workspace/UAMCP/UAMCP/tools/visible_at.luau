local utils = require(script.Parent.Parent.utils)

local function isTransparentContainer(p1) -- line: 3
	if p1:IsA("TextLabel") or (p1:IsA("TextButton") or p1:IsA("TextBox")) then
		return false
	end

	if (p1:IsA("ImageLabel") or p1:IsA("ImageButton")) and p1.Image ~= "" and p1.ImageTransparency < 1 then
		return false
	end

	return p1.BackgroundTransparency >= 0.99
end

return {
	description = "Find leaf-level visible GuiObjects that overlap a screen coordinate. Filters out transparent containers and disabled ScreenGuis to reduce noise. Returns only innermost (leaf) elements.",
	params = {
		{
			name = "x",
			desc = "screen X coordinate",
			required = true
		},
		{
			name = "y",
			desc = "screen Y coordinate",
			required = true
		},
		{
			name = "root",
			desc = "root path (default \"game.CoreGui\")",
			required = false
		},
		{
			name = "all",
			desc = "if true, include transparent containers in results (default false)",
			required = false
		}
	},
	call = function(p2) -- line: 24
		-- upvalues: utils (copy), isTransparentContainer (copy)
		if not p2.x or not p2.y then
			return "ERROR: 'x' and 'y' are required"
		end

		local num = tonumber(p2.x)
		local num2 = tonumber(p2.y)

		if not num or not num2 then
			return "ERROR: 'x' and 'y' must be valid numbers"
		end

		local v7 = num
		local v8 = num2
		local v9 = p2.all == true
		local v10 = utils.resolveInstance(p2.root or "game.CoreGui")

		if not v10 then
			return "ERROR: could not resolve root path: " .. tostring(p2.root)
		end

		local t1 = {}

		local function recurse(p3) -- line: 42
			-- upvalues: v7 (copy), v8 (copy), v9 (copy), isTransparentContainer (copy), t1 (copy), recurse (copy)
			if p3:IsA("LayerCollector") then
				if not p3.Enabled then
					return
				end
			elseif p3:IsA("GuiObject") and not p3.Visible then
				return
			end

			if p3:IsA("GuiObject") then
				local AbsolutePosition = p3.AbsolutePosition
				local AbsoluteSize = p3.AbsoluteSize

				if v7 >= AbsolutePosition.X and v7 <= AbsolutePosition.X + AbsoluteSize.X and v8 >= AbsolutePosition.Y and v8 <= AbsolutePosition.Y + AbsoluteSize.Y then
					local v16 = false

					for _, child in ipairs(p3:GetChildren()) do
						if not child:IsA("GuiObject") or not child.Visible then
							continue
						end

						local AbsolutePosition2 = child.AbsolutePosition
						local AbsoluteSize2 = child.AbsoluteSize

						if v7 >= AbsolutePosition2.X and v7 <= AbsolutePosition2.X + AbsoluteSize2.X and v8 >= AbsolutePosition2.Y and v8 <= AbsolutePosition2.Y + AbsoluteSize2.Y then
							v16 = true

							break
						end
					end

					if not v16 and (v9 or not isTransparentContainer(p3)) then
						local v21 = ("%s \"%s\"  Pos=%s Size=%s"):format(p3.ClassName, p3.Name, tostring(AbsolutePosition), (tostring(AbsoluteSize)))

						if p3:IsA("TextLabel") or p3:IsA("TextButton") or p3:IsA("TextBox") then
							v21 ..= " Text=\"" .. p3.Text:sub(1, 40) .. "\""
						end

						local v22 = v21 .. "\n    " .. p3:GetFullName()

						t1[#t1 + 1] = v22
					end
				end
			end

			for _, child in ipairs(p3:GetChildren()) do
				if child:IsA("GuiObject") or child:IsA("Folder") or child:IsA("ScreenGui") then
					recurse(child)
				end
			end
		end

		recurse(v10)

		if #t1 == 0 then
			return ("No visible leaf GuiObjects found at (%d, %d)"):format(v7, v8)
		end

		return ("Found %d leaf element(s) at (%d, %d):\n\n"):format(#t1, v7, v8) .. table.concat(t1, "\n\n")
	end
}
