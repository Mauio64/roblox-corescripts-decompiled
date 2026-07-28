local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local PickedUserRow = require(script.Parent.PickedUserRow)
local List = Foundation.List
local InputSize = Foundation.Enums.InputSize

local function PickedUserList(t1: {[any]: any}) -- line: 31
	-- upvalues: React (copy), PickedUserRow (copy), List (copy), InputSize (copy)
	local v9 = t1.testId or "picked-user-list"
	local onRemove = t1.onRemove
	local v11 = t1.removingUserIds or {}
	local t2 = {}

	if t1.header ~= nil then
		t2.Header = t1.header
	end

	for v13, v14 in t1.userIds do
		local v15 = `{ v9 }-user-{ v14 }`

		t2[`row-{ v14 }`] = React.createElement(PickedUserRow, {
			userId = v14,
			isRemoving = v11[v14] == true,
			onRemove = onRemove,
			LayoutOrder = v13 + 1,
			testId = v15
		})
	end

	return React.createElement(List.Root, {
		isContained = true,
		LayoutOrder = t1.layoutOrder,
		hasDivider = {
			hasDivider = true,
			isInset = false
		},
		size = InputSize.Medium,
		testId = v9
	}, t2)
end

return PickedUserList
