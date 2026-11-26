local module = require("@luauforge/bundled/gtJ")
local react = module.React
local uiBlox = module.UIBlox
local dash = module.Dash
local scrollingListTable = uiBlox.App.Table.ScrollingListTable
local listTable = uiBlox.App.Table.ListTable
local module2 = require("@luauforge/bundled/gui")

local defineFastFlag = game:DefineFastFlag("DisableAccountSelectionListScrollingRelease2", false)

return function(props)
	local function createAccountSelectionCell(p2)
		return react.createElement(module2, {
			user = p2,
			onAccountSelection = props.onAccountSelection,
			isDisabled = props.isDisabled
		})
	end

	if defineFastFlag and not props.isScrollable then
		return react.createElement(listTable, {
			size = UDim2.new(1, 0, 0, props.height),
			showDividers = false,
			cells = dash.map(props.users, createAccountSelectionCell)
		})
	end

	return react.createElement(scrollingListTable, {
		size = UDim2.new(1, 0, 0, props.height),
		cells = dash.map(props.users, createAccountSelectionCell)
	})
end
