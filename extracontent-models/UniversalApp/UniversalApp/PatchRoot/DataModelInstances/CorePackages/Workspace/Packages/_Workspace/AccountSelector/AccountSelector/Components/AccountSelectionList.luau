local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local Dash = dependencies.Dash
local ScrollingListTable = UIBlox.App.Table.ScrollingListTable
local ListTable = UIBlox.App.Table.ListTable
local AccountSelection = require(script.Parent.AccountSelection)
local v9 = game:DefineFastFlag("DisableAccountSelectionListScrollingRelease2", false)

return function(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), AccountSelection (copy), v9 (copy), ScrollingListTable (copy), Dash (copy), ListTable (copy)
	local function createAccountSelectionCell(p1) -- line: 23
		-- upvalues: React (copy), AccountSelection (copy), t1 (copy)
		return React.createElement(AccountSelection, {
			user = p1,
			onAccountSelection = t1.onAccountSelection,
			isDisabled = t1.isDisabled
		})
	end

	if not v9 or t1.isScrollable then
		return React.createElement(ScrollingListTable, {
			size = UDim2.new(1, 0, 0, t1.height),
			cells = Dash.map(t1.users, createAccountSelectionCell)
		})
	end

	return React.createElement(ListTable, {
		showDividers = false,
		size = UDim2.new(1, 0, 0, t1.height),
		cells = Dash.map(t1.users, createAccountSelectionCell)
	})
end
