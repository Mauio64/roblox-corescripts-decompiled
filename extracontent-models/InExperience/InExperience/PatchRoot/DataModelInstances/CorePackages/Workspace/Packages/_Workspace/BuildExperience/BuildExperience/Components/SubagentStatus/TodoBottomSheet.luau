local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local TodoList = require(script.Parent.TodoList)

local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View

local function TodoBottomSheet(props)
	local testId = props.testId or "subagent-status-bottom-sheet"

	return React.createElement(Sheet.Root, {
		isOpen = props.isOpen,
		onClose = props.onClose,
		snapPoints = { 0.5, 1 },
		defaultSnapPointIndex = 1,
		testId = testId
	}, {
		Header = React.createElement(Sheet.Header, { hasCloseAffordance = true }, {
			TitleWrapper = React.createElement(View, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y padding-y-small"
			}, {
				Title = React.createElement(Text, {
					LayoutOrder = 1,
					Text = props.title,
					tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis",
					testId = `{testId}-title`
				})
			})
		}),
		Content = React.createElement(Sheet.Content, nil, {
			List = React.createElement(TodoList, {
				LayoutOrder = 1,
				items = props.items,
				testId = `{testId}-list`
			})
		})
	})
end

return React.memo(TodoBottomSheet)
