local DetailsPageComponents = script:FindFirstAncestor("DetailsPageComponents")
local DetailsPageComponentsParent = DetailsPageComponents.Parent
local DetailsInfoTableRow = require(DetailsPageComponents.DetailsInfoTableRow)
local React = require(DetailsPageComponentsParent.React)
local ListTable = require(DetailsPageComponentsParent.UIBlox).App.Table.ListTable

return React.memo(function(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), DetailsInfoTableRow (copy), ListTable (copy)
	local v7 = React.useMemo(function() -- line: 23
		-- upvalues: t1 (copy), React (copy), DetailsInfoTableRow (copy)
		local t2 = {}

		for _, v10 in t1.rows do
			table.insert(t2, React.createElement(DetailsInfoTableRow, {
				horizontalPadding = t1.horizontalPadding,
				infoData = v10.infoData,
				infoName = v10.infoName
			}))
		end

		return t2
	end, {
		t1.horizontalPadding,
		t1.rows
	})

	return React.createElement(ListTable, {
		automaticSize = Enum.AutomaticSize.Y,
		cells = v7,
		dividerStartOffset = t1.dividerStartOffset
	})
end)
