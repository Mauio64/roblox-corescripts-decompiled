local function getSortedDescendantUIReadoutInfo(p1) -- line: 14
	local descendants = p1:GetDescendants()

	table.insert(descendants, p1)

	local t1 = {}

	for _, v in ipairs(descendants) do
		if v:IsA("TextLabel") or v:IsA("TextButton") then
			if #v.Text > 0 then
				table.insert(t1, {
					UIType = "Text",
					text = v.Text,
					absPosition = v.AbsolutePosition
				})
			end
		elseif not v:IsA("ImageLabel") and not v:IsA("ImageButton") then
			if v:IsA("TextBox") then
				table.insert(t1, {
					UIType = "Text box",
					text = if v.Text ~= "" then v.Text else v.PlaceholderText,
					absPosition = v.AbsolutePosition
				})
			elseif not v:IsA("VideoFrame") then
			end
		end
	end

	table.sort(t1, function(p2, p3) -- line: 53
		if p2.absPosition.Y == p3.absPosition.Y then
			return p2.absPosition.X < p3.absPosition.X
		end

		return p2.absPosition.Y < p3.absPosition.Y
	end)

	return t1
end

return function(p4) -- line: 64
	-- upvalues: getSortedDescendantUIReadoutInfo (copy)
	local v8 = getSortedDescendantUIReadoutInfo(p4)
	local t2 = {}

	for _, v in ipairs(v8) do
		table.insert(t2, v.text)
	end

	return (table.concat(t2, "\n"))
end
