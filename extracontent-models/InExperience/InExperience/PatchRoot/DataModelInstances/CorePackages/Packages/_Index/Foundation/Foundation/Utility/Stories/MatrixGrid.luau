local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)
local Text = require(Foundation.Components.Text)
local View = require(Foundation.Components.View)

local function MatrixGrid(t1: {[any]: any}) -- line: 26
	-- upvalues: React (copy), View (copy), Dash (copy), Text (copy)
	local v9 = t1.showLabelColumn == nil or t1.showLabelColumn
	local v10 = t1.showHeader == nil or t1.showHeader
	local v11 = t1.labelColumnWidth or 80
	local v12 = t1.headerTextAlign or "center"
	local v13 = t1.cellAlign or "center"
	local v14 = t1.rowGap or "large"
	local v15 = v12 ~= "left" and "text-align-x-center" or "text-align-x-left"
	local v16 = v13 ~= "left" and "align-x-center" or "align-x-left"
	local v17 = `row align-y-center gap-{ v14 } auto-xy`
	local v18 = `row align-y-center gap-{ v14 } auto-x`
	local n1 = 1
	local t2 = {}

	local function renderCells(t3: {[any]: any}) -- line: 41
		-- upvalues: t1 (copy), React (copy), View (copy), v16 (copy)
		local t4 = {}

		for v30, v31 in t3 do
			local v32 = if not t1.cellColumnWidth then nil else UDim2.fromOffset(t1.cellColumnWidth, 0)

			t4[`Cell-{ v30 }`] = React.createElement(View, {
				tag = `col auto-xy { v16 }`,
				Size = v32,
				LayoutOrder = v30
			}, {
				Content = v31
			})
		end

		return t4
	end

	if v10 then
		local v22 = Dash.map(t1.columnHeaders, function(p1, p2) -- line: 57
			-- upvalues: t1 (copy), React (copy), Text (copy), v15 (copy)
			local v35 = if not t1.cellColumnWidth then nil else UDim2.fromOffset(t1.cellColumnWidth, 0)

			return React.createElement(Text, {
				Text = p1,
				tag = `auto-xy text-caption-small content-muted { v15 }`,
				Size = v35,
				LayoutOrder = p2
			})
		end)

		if v9 then
			t2.HeaderRow = React.createElement(View, {
				tag = `padding-y-small { v17 }`,
				LayoutOrder = n1
			}, {
				Corner = React.createElement(View, {
					LayoutOrder = 1,
					Size = UDim2.fromOffset(v11, 0)
				}),
				Cells = React.createElement(View, {
					LayoutOrder = 2,
					tag = v18
				}, v22)
			})
		else
			t2.HeaderRow = React.createElement(View, {
				tag = `padding-y-small { v17 }`,
				LayoutOrder = n1
			}, v22)
		end

		n1 += 1
	end

	for v23, v24 in t1.rows do
		local t5 = {}

		if v9 then
			t5.Label = React.createElement(View, {
				tag = "col align-y-center size-full-0 auto-y clip",
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v11, 0)
			}, {
				Content = v24.label
			})
			t5.Cells = React.createElement(View, {
				LayoutOrder = 2,
				tag = v18
			}, (renderCells(v24.cells)))
		else
			for v26, v27 in renderCells(v24.cells) do
				t5[v26] = v27
			end
		end

		t2[`Row-{ v23 }`] = React.createElement(View, {
			tag = `padding-y-small { v17 }`,
			LayoutOrder = n1
		}, t5)
		n1 += 1
	end

	return React.createElement(View, {
		tag = "col auto-xy"
	}, t2)
end

return MatrixGrid
