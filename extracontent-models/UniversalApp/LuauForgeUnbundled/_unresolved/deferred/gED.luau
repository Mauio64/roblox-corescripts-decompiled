local module = require("@luauforge/deferred/gEz")

local module2 = require("@luauforge/deferred/gEA")
local cell = module2.App.Table.Cell
local cellHeadDetail = module2.App.Table.CellHeadDetail
local cellTailDescription = module2.App.Table.CellTailDescription
local useStyle = module2.Core.Style.useStyle

local useTokens = require("@luauforge/deferred/gEE").Hooks.useTokens

return module.memo(function(props)
	local v5 = useStyle()
	local v6 = useTokens()

	return module.createElement(cell, {
		head = module.createElement(cellHeadDetail, {
			labelText = props.infoName,
			labelTextColor = v5.Theme.TextDefault,
			labelTextFont = v6.Typography.TitleLarge
		}),
		horizontalPadding = props.horizontalPadding,
		size = UDim2.new(1, 0, 0, 56),
		tail = module.createElement(cellTailDescription, {
			text = props.infoData,
			textColor = v5.Theme.TextEmphasis,
			textFont = v6.Typography.TitleLarge
		}),
		userInteractionEnabled = props.userInteractionEnabled or false
	})
end)
