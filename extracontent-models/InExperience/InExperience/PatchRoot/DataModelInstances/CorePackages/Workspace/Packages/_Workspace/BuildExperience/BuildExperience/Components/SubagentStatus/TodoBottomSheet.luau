local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local TodoList = require(script.Parent.TodoList)
local Sheet = Foundation.Sheet
local FoundationText = Foundation.Text
local View = Foundation.View

local function TodoBottomSheet(t1: {[any]: any}) -- line: 25
	-- upvalues: React (copy), Sheet (copy), View (copy), FoundationText (copy), TodoList (copy)
	local v10 = t1.testId or "subagent-status-bottom-sheet"

	return React.createElement(Sheet.Root, {
		defaultSnapPointIndex = 1,
		isOpen = t1.isOpen,
		onClose = t1.onClose,
		snapPoints = {
			0.5,
			1
		},
		testId = v10
	}, {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = true
		}, {
			TitleWrapper = React.createElement(View, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y padding-y-small"
			}, {
				Title = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis",
					Text = t1.title,
					testId = `{ v10 }-title`
				})
			})
		}),
		Content = React.createElement(Sheet.Content, nil, {
			List = React.createElement(TodoList, {
				LayoutOrder = 1,
				items = t1.items,
				testId = `{ v10 }-list`
			})
		})
	})
end

return React.memo(TodoBottomSheet)
