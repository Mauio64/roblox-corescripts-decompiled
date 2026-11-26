local module = require("@luauforge/bundled/hKp")
local module2 = require("@luauforge/bundled/hKO")
local useNavigator = require("@luauforge/bundled/hKs").Hooks.useNavigator
local module3 = require("@luauforge/bundled/hKH")
local useLocalization = require("@luauforge/bundled/hKP").Hooks.useLocalization

require("@luauforge/bundled/hKz")
local module4 = require("@luauforge/bundled/hKQ")

local scrollingListTable = module2.App.Table.ScrollingListTable
local cellTailDescription = module2.App.Table.CellTailDescription
local cellHeadDetail = module2.App.Table.CellHeadDetail
local cell = module2.App.Table.Cell

local udim = UDim2.new(1, 0, 0, 64)

local function ListSelection(props)
	local reportListSelection = module3().ReportListSelection
	local children = {}
	local params = props.params

	local v5 = useNavigator()

	if params.listItems then
		for k, listItem in params.listItems do
			children[k] = module.createElement(cell, {
				size = reportListSelection.listEntrySize or udim,
				head = module.createElement(cellHeadDetail, {
					labelText = listItem.humanReadableText
				}),
				tail = module.createElement(cellTailDescription, {
					text = "",
					showArrow = true
				}),
				background = module.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1)
				}),
				onActivated = function()
					props.onItemSelected(props, listItem)

					if listItem.nextPage and listItem.nextPage.componentRefs then
						v5.push(listItem.nextPage.componentRefs)
					elseif listItem.nextList then
						v5.pushParams(listItem.nextList)
					elseif params.nextPage and params.nextPage.componentRefs then
						v5.push(params.nextPage.componentRefs)
					end
				end
			})
		end
	end

	local v6 = useLocalization({
		cancelText = "Feature.Chat.Action.Cancel",
		skipText = "Feature.VerificationUpsell.Action.GenericSkip"
	})

	local v7 = {
		{
			text = v6.cancelText,
			onActivated = function()
				props.onCancel(props)
			end
		}
	}

	if params.skippable then
		table.insert(v7, {
			text = v6.skipText,
			onActivated = function()
				if params.nextPage and params.nextPage.componentRefs then
					v5.push(params.nextPage.componentRefs)
				end
			end
		})
	end

	return module.createElement(module4, { title = params.heading, buttons = v7 }, {
		ListTable = module.createElement(scrollingListTable, {
			cells = children,
			selectable = false
		})
	})
end

return ListSelection
