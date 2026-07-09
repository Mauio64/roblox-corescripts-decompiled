local function isVisible(p1) -- line: 1
	while p1 do
		if not p1:IsA("GuiObject") then
			if p1:IsA("LayerCollector") then
				return p1.Enabled
			end

			return true
		end

		if not p1.Visible then
			return false
		end

		p1 = p1.Parent
	end

	return true
end

return isVisible
