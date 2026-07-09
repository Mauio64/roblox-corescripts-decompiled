local function guiProps(p1) -- line: 1
	local t1 = {}

	if p1:IsA("GuiObject") then
		table.insert(t1, "Pos=" .. tostring(p1.AbsolutePosition))
		table.insert(t1, "Size=" .. tostring(p1.AbsoluteSize))
		table.insert(t1, "Vis=" .. tostring(p1.Visible))
		table.insert(t1, "ZIndex=" .. tostring(p1.ZIndex))
		table.insert(t1, "LayoutOrder=" .. tostring(p1.LayoutOrder))
	end

	if p1:IsA("TextLabel") or p1:IsA("TextButton") or p1:IsA("TextBox") then
		table.insert(t1, "Text=\"" .. tostring(p1.Text):sub(1, 80) .. "\"")
	end

	if p1:IsA("ImageLabel") or p1:IsA("ImageButton") then
		local str = tostring(p1.Image)

		if str ~= "" then
			table.insert(t1, "Image=\"" .. str:sub(1, 80) .. "\"")
		end
	end

	return table.concat(t1, " ")
end

return guiProps
