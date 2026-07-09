local function findAncestorScrollFrame(p1) -- line: 1
	local p1Parent = p1.Parent

	while p1Parent and p1Parent ~= game do
		if p1Parent:IsA("ScrollingFrame") then
			return p1Parent
		end

		p1Parent = p1Parent.Parent
	end

	return nil
end

return findAncestorScrollFrame
