local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local PickedUserRow = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/UserPicker/PickedUserRow")

local list = Foundation.List

local inputSize = Foundation.Enums.InputSize

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

	return React.createElement(list.Root, {
		LayoutOrder = props.layoutOrder,
		hasDivider = { hasDivider = true, isInset = false },
		isContained = true,
		size = inputSize.Medium,
		testId = testId
	}, children)
end

return PickedUserList
