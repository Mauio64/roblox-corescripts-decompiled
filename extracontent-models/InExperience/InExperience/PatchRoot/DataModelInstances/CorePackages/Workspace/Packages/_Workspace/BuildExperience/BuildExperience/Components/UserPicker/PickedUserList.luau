local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local PickedUserRow = require(script.Parent.PickedUserRow)

local List = Foundation.List

local InputSize = Foundation.Enums.InputSize

local function PickedUserList(props)
	local testId = props.testId or "picked-user-list"
	local onRemove = props.onRemove
	local removingUserIds = props.removingUserIds or {}

	local children = {}

	if props.header ~= nil then
		children.Header = props.header
	end

	for k, userId in props.userIds do
		local formatted = `{testId}-user-{userId}`

		children[`row-{userId}`] = React.createElement(PickedUserRow, {
			userId = userId,
			isRemoving = removingUserIds[userId] == true,
			onRemove = onRemove,
			LayoutOrder = k + 1,
			testId = formatted
		})
	end

	return React.createElement(List.Root, {
		LayoutOrder = props.layoutOrder,
		hasDivider = { hasDivider = true, isInset = false },
		isContained = true,
		size = InputSize.Medium,
		testId = testId
	}, children)
end

return PickedUserList
