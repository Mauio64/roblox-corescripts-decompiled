local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Foundation")

local view = Foundation.View
local text = Foundation.Text

require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/Types")
local GroupListItem = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Components/GroupsList/GroupListItem")

local function GroupsListSection(props)
	if #props.groups == 0 then
		return nil
	end

	local children = {}
	local v5 = false

	if props.heading and props.heading ~= "" then
		children.Heading = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.heading,
			tag = "content-default text-align-x-left size-full-0 auto-y text-title-large"
		})
	end

	for i, group in ipairs(props.groups) do
		local v6 = not props.visibleIds or props.visibleIds[group.id] == true

		children[`Group_{group.id}`] = React.createElement(view, {
			Visible = v6,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = i + 1
		}, {
			Item = React.createElement(GroupListItem, {
				group = group,
				layoutOrder = i + 1,
				showRank = props.showRank,
				showMemberCount = props.showMemberCount
			})
		})
		v5 = v5 or v6
	end

	return React.createElement(view, {
		tag = "col gap-small",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = props.layoutOrder,
		Visible = v5
	}, children)
end

return React.memo(GroupsListSection)
