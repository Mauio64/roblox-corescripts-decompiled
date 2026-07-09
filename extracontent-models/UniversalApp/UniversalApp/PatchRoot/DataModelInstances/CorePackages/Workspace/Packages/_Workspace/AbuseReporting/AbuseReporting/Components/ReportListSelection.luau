local AbuseReporting = script:FindFirstAncestor("AbuseReporting")
local AbuseReportingParent = AbuseReporting.Parent
local React = require(AbuseReportingParent.React)
local UIBlox = require(AbuseReportingParent.UIBlox)
local useNavigator = require(AbuseReportingParent.ServerUI).Hooks.useNavigator
local useAbuseReportingDesignTokens = require(AbuseReporting.Hooks.useAbuseReportingDesignTokens)
local useLocalization = require(AbuseReportingParent.Localization).Hooks.useLocalization

require(script.Parent.Parent.Common.Types)

local ReportStep = require(script.Parent.ReportStep)
local ScrollingListTable = UIBlox.App.Table.ScrollingListTable
local CellTailDescription = UIBlox.App.Table.CellTailDescription
local CellHeadDetail = UIBlox.App.Table.CellHeadDetail
local Cell = UIBlox.App.Table.Cell
local uDim2 = UDim2.new(1, 0, 0, 64)

local function ListSelection(t1: {[any]: any}) -- line: 45
	-- upvalues: useAbuseReportingDesignTokens (copy), useNavigator (copy), React (copy), Cell (copy), uDim2 (copy), CellHeadDetail (copy), CellTailDescription (copy), useLocalization (copy), ReportStep (copy), ScrollingListTable (copy)
	local ReportListSelection = useAbuseReportingDesignTokens().ReportListSelection
	local t2 = {}
	local params = t1.params
	local v19 = useNavigator()

	if params.listItems then
		for v20, v21 in params.listItems do
			t2[v20] = React.createElement(Cell, {
				size = ReportListSelection.listEntrySize or uDim2,
				head = React.createElement(CellHeadDetail, {
					labelText = v21.humanReadableText
				}),
				tail = React.createElement(CellTailDescription, {
					text = "",
					showArrow = true
				}),
				background = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1)
				}),
				onActivated = function() -- line: 68
					-- upvalues: t1 (copy), v21 (copy), v19 (copy), params (copy)
					t1.onItemSelected(t1, v21)

					if v21.nextPage and v21.nextPage.componentRefs then
						v19.push(v21.nextPage.componentRefs)

						return
					end

					if v21.nextList then
						v19.pushParams(v21.nextList)

						return
					end

					if params.nextPage and params.nextPage.componentRefs then
						v19.push(params.nextPage.componentRefs)
					end
				end
			})
		end
	end

	local v22 = useLocalization({
		cancelText = "Feature.Chat.Action.Cancel",
		skipText = "Feature.VerificationUpsell.Action.GenericSkip"
	})
	local t3 = {{
		text = v22.cancelText,
		onActivated = function() -- line: 91
			-- upvalues: t1 (copy)
			t1.onCancel(t1)
		end
	}}

	if params.skippable then
		table.insert(t3, {
			text = v22.skipText,
			onActivated = function() -- line: 100
				-- upvalues: params (copy), v19 (copy)
				if params.nextPage and params.nextPage.componentRefs then
					v19.push(params.nextPage.componentRefs)
				end
			end
		})
	end

	return React.createElement(ReportStep, {
		title = params.heading,
		buttons = t3
	}, {
		ListTable = React.createElement(ScrollingListTable, {
			selectable = false,
			cells = t2
		})
	})
end

return ListSelection
