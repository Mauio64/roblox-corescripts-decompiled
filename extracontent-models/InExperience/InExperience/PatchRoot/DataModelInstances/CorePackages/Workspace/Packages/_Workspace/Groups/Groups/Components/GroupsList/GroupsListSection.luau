local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Text = Foundation.Text

require(Groups.Common.Types)
local GroupListItem = require(script.Parent.GroupListItem)

local function GroupsListSection(props)
	if #props.groups == 0 then
		return nil
	end

	local children = {}
	local visible = false

	if props.heading and props.heading ~= "" then
		children.Heading = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.heading,
			tag = "content-default text-align-x-left size-full-0 auto-y text-title-large"
		})
	end

	for i, group in ipairs(props.groups) do
		local visible2 = not props.visibleIds or props.visibleIds[group.id] == true

		children[`Group_{group.id}`] = React.createElement(View, {
			Visible = visible2,
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
		visible = visible or visible2
	end

	return React.createElement(View, {
		tag = "col gap-small",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = props.layoutOrder,
		Visible = visible
	}, children)
end

return React.memo(GroupsListSection)
