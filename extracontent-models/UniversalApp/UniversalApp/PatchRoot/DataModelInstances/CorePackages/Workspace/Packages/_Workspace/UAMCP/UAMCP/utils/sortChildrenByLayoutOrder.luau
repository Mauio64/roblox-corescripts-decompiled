local function sortChildrenByLayoutOrder(t1: {[any]: any}) -- line: 1
	table.sort(t1, function(p1, p2) -- line: 2
		return (p1:IsA("GuiObject") and p1.LayoutOrder or 0) < (p2:IsA("GuiObject") and p2.LayoutOrder or 0)
	end)

	return t1
end

return sortChildrenByLayoutOrder
