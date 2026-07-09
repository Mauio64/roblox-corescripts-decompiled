local utils = require(script.Parent.Parent.utils)

return {
	description = "Show detailed properties of an instance at the given DataModel path. Also verifies the path exists.",
	params = {{
		name = "path",
		desc = "DataModel path, e.g. \"game.CoreGui.LuaAppScreenGui\"",
		required = true
	}},
	call = function(p1) -- line: 8
		-- upvalues: utils (copy)
		local v3 = utils.resolveInstance(p1.path)

		if not v3 then
			return "NOT FOUND: \"" .. tostring(p1.path) .. "\" does not resolve to an instance."
		end

		local t1 = {
			("Instance: %s"):format(v3.Name),
			("ClassName: %s"):format(v3.ClassName),
			("FullPath: %s"):format(v3:GetFullName()),
			("Children: %d"):format(#v3:GetChildren())
		}

		if v3:IsA("GuiObject") then
			table.insert(t1, "")
			table.insert(t1, "-- Layout --")
			table.insert(t1, "Position: " .. tostring(v3.Position))
			table.insert(t1, "Size: " .. tostring(v3.Size))
			table.insert(t1, "AnchorPoint: " .. tostring(v3.AnchorPoint))
			table.insert(t1, "AbsolutePosition: " .. tostring(v3.AbsolutePosition))
			table.insert(t1, "AbsoluteSize: " .. tostring(v3.AbsoluteSize))
			table.insert(t1, "AbsoluteRotation: " .. tostring(v3.AbsoluteRotation))
			table.insert(t1, "")
			table.insert(t1, "-- Visibility --")
			table.insert(t1, "Visible: " .. tostring(v3.Visible))
			table.insert(t1, "BackgroundTransparency: " .. tostring(v3.BackgroundTransparency))
			table.insert(t1, "ZIndex: " .. tostring(v3.ZIndex))
			table.insert(t1, "LayoutOrder: " .. tostring(v3.LayoutOrder))
			table.insert(t1, "ClipsDescendants: " .. tostring(v3.ClipsDescendants))
			table.insert(t1, "AutomaticSize: " .. tostring(v3.AutomaticSize))
		end

		if v3:IsA("TextLabel") or v3:IsA("TextButton") or v3:IsA("TextBox") then
			table.insert(t1, "")
			table.insert(t1, "-- Text --")
			table.insert(t1, "Text: \"" .. tostring(v3.Text) .. "\"")
			table.insert(t1, "TextColor3: " .. tostring(v3.TextColor3))
			table.insert(t1, "TextSize: " .. tostring(v3.TextSize))
			table.insert(t1, "Font: " .. tostring(v3.Font))
			table.insert(t1, "TextWrapped: " .. tostring(v3.TextWrapped))
			table.insert(t1, "RichText: " .. tostring(v3.RichText))
		end

		if v3:IsA("ImageLabel") or v3:IsA("ImageButton") then
			table.insert(t1, "")
			table.insert(t1, "-- Image --")
			table.insert(t1, "Image: " .. tostring(v3.Image))
			table.insert(t1, "ImageTransparency: " .. tostring(v3.ImageTransparency))
			table.insert(t1, "ScaleType: " .. tostring(v3.ScaleType))
		end

		if v3:IsA("ScrollingFrame") then
			table.insert(t1, "")
			table.insert(t1, "-- Scrolling --")
			table.insert(t1, "CanvasSize: " .. tostring(v3.CanvasSize))
			table.insert(t1, "CanvasPosition: " .. tostring(v3.CanvasPosition))
			table.insert(t1, "ScrollingDirection: " .. tostring(v3.ScrollingDirection))
		end

		if v3:IsA("ScreenGui") then
			table.insert(t1, "")
			table.insert(t1, "-- ScreenGui --")
			table.insert(t1, "DisplayOrder: " .. tostring(v3.DisplayOrder))
			table.insert(t1, "Enabled: " .. tostring(v3.Enabled))
			table.insert(t1, "IgnoreGuiInset: " .. tostring(v3.IgnoreGuiInset))
		end

		local children = v3:GetChildren()

		if #children > 0 then
			table.insert(t1, "")
			table.insert(t1, "-- Children --")

			for _, v in ipairs(children) do
				local v8 = ("  %s \"%s\""):format(v.ClassName, v.Name)

				if v:IsA("GuiObject") then
					v8 ..= "  Vis=" .. tostring(v.Visible)
				end

				table.insert(t1, v8)
			end
		end

		return table.concat(t1, "\n")
	end
}
