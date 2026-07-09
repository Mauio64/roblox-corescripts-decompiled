local Parent = script:FindFirstAncestor("DetailsPageComponents").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local Cell = UIBlox.App.Table.Cell
local CellHeadDetail = UIBlox.App.Table.CellHeadDetail
local CellTailDescription = UIBlox.App.Table.CellTailDescription
local useStyle = UIBlox.Core.Style.useStyle
local useTokens = require(Parent.Foundation).Hooks.useTokens

return React.memo(function(t1: {[any]: any}) -- line: 24
	-- upvalues: useStyle (copy), useTokens (copy), React (copy), Cell (copy), CellHeadDetail (copy), CellTailDescription (copy)
	local v10 = useStyle()
	local v11 = useTokens()

	return React.createElement(Cell, {
		head = React.createElement(CellHeadDetail, {
			labelText = t1.infoName,
			labelTextColor = v10.Theme.TextDefault,
			labelTextFont = v11.Typography.TitleLarge
		}),
		horizontalPadding = t1.horizontalPadding,
		size = UDim2.new(1, 0, 0, 56),
		tail = React.createElement(CellTailDescription, {
			text = t1.infoData,
			textColor = v10.Theme.TextEmphasis,
			textFont = v11.Typography.TitleLarge
		}),
		userInteractionEnabled = t1.userInteractionEnabled or false
	})
end)
