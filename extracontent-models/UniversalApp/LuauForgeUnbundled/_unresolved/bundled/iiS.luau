local function getSortedDescendantUIReadoutInfo(folder)
	local descendants = folder:GetDescendants()
	table.insert(descendants, folder)
	local sortedDescendantUIReadoutInfo = {}

	for i, instance in ipairs(descendants) do
		if instance:IsA("TextLabel") or instance:IsA("TextButton") then
			if #instance.Text > 0 then
				table.insert(sortedDescendantUIReadoutInfo, {
					UIType = "Text",
					text = instance.Text,
					absPosition = instance.AbsolutePosition
				})
			end
		elseif not instance:IsA("ImageLabel") and not instance:IsA("ImageButton") then
			if instance:IsA("TextBox") then
				local v6 = if instance.Text == "" then instance.PlaceholderText else instance.Text
				local v5 = {
					UIType = "Text box",
					text = v6,
					absPosition = instance.AbsolutePosition
				}
				table.insert(sortedDescendantUIReadoutInfo, v5)
			else
				instance:IsA("VideoFrame")
			end
		end
	end

	table.sort(sortedDescendantUIReadoutInfo, function(a, b): boolean
		if a.absPosition.Y == b.absPosition.Y then
			return a.absPosition.X < b.absPosition.X
		end

		return a.absPosition.Y < b.absPosition.Y
	end)

	return sortedDescendantUIReadoutInfo
end

return function(p2)
	local sortedDescendantUIReadoutInfo = getSortedDescendantUIReadoutInfo(p2)

	local texts = {}

	for i, v5 in ipairs(sortedDescendantUIReadoutInfo) do
		table.insert(texts, v5.text)
	end

	return (table.concat(texts, "\n"))
end
