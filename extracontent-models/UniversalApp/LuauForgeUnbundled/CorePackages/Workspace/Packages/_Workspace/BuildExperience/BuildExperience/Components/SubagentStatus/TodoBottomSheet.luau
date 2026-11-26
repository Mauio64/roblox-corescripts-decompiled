local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local TodoList = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SubagentStatus/TodoList")

local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View

local function TodoBottomSheet(props)
	local testId = props.testId or "subagent-status-bottom-sheet"

	return React.createElement(sheet.Root, {
		isOpen = props.isOpen,
		onClose = props.onClose,
		snapPoints = { 0.5, 1 },
		defaultSnapPointIndex = 1,
		testId = testId
	}, {
		Header = React.createElement(sheet.Header, { hasCloseAffordance = true }, {
			TitleWrapper = React.createElement(
				view,
				{ LayoutOrder = 1, tag = "size-full-0 auto-y padding-y-small" },
				{
					Title = React.createElement(text, {
						LayoutOrder = 1,
						Text = props.title,
						tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis",
						testId = `{testId}-title`
					})
				}
			)
		}),
		Content = React.createElement(sheet.Content, nil, {
			List = React.createElement(TodoList, {
				LayoutOrder = 1,
				items = props.items,
				testId = `{testId}-list`
			})
		})
	})
end

return React.memo(TodoBottomSheet)
