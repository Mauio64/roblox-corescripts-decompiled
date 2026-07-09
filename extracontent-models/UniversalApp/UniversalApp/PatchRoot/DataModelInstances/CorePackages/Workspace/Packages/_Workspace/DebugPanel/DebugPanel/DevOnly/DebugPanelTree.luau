local Parent = script:FindFirstAncestor("DebugPanel").Parent
local React = require(Parent.React)
local scriptParent = script.Parent
local DebugPanelSection = require(scriptParent.DebugPanelSection)

require(scriptParent.DebugPanelSectionRegistry)

local function getSortedChildren(p1) -- line: 23
	local t1 = {}

	for _, v11 in p1.children do
		table.insert(t1, v11)
	end

	table.sort(t1, function(p2, p3) -- line: 28
		if p2.order ~= p3.order then
			return p2.order < p3.order
		end

		return p2.title < p3.title
	end)

	return t1
end
local function collapseChain(p4) -- line: 37
	local title = p4.title

	while p4.component == nil do
		local v14, v15 = next(p4.children)

		if v14 == nil or next(p4.children, v14) ~= nil or v15.component ~= nil or next(v15.children) == nil then
			return p4, title
		end

		title ..= " / " .. v15.title
		p4 = v15
	end

	return p4, title
end
local function DebugPanelTree(t2: {[any]: any}) -- line: 57
	-- upvalues: getSortedChildren (copy), collapseChain (copy), React (copy), DebugPanelTree (copy), DebugPanelSection (copy)
	local v17 = getSortedChildren(t2.node)
	local t3 = {}

	for i, v in ipairs(v17) do
		local v21, v22 = collapseChain(v)
		local t4 = {}

		if v21.component then
			t4.Content = React.createElement(v21.component)
		end

		if next(v21.children) ~= nil then
			t4.SubTree = React.createElement(DebugPanelTree, {
				node = v21,
				depth = t2.depth + 1
			})
		end

		t3[v21.leafId or v22] = React.createElement(DebugPanelSection, {
			title = v22,
			layoutOrder = i,
			depth = t2.depth,
			defaultCollapsed = v21.defaultCollapsed
		}, t4)
	end

	return React.createElement(React.Fragment, nil, t3)
end

return DebugPanelTree
