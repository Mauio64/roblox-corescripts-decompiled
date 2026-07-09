local Groups = script:FindFirstAncestor("Groups")
local GroupsParent = Groups.Parent
local React = require(GroupsParent.React)
local Foundation = require(GroupsParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text

require(Groups.Common.Types)

local GroupListItem = require(script.Parent.GroupListItem)

local function GroupsListSection(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), FoundationText (copy), View (copy), GroupListItem (copy)
	if #t1.groups == 0 then
		return nil
	end

	local t2 = {}
	local v11 = false

	if t1.heading and t1.heading ~= "" then
		t2.Heading = React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "content-default text-align-x-left size-full-0 auto-y text-title-large",
			Text = t1.heading
		})
	end

	for i, v in ipairs(t1.groups) do
		local v14 = not t1.visibleIds or t1.visibleIds[v.id] == true

		v11 = v11 or v14
		t2[`Group_{ v.id }`] = React.createElement(View, {
			Visible = v14,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = i + 1
		}, {
			Item = React.createElement(GroupListItem, {
				group = v,
				layoutOrder = i + 1,
				showRank = t1.showRank,
				showMemberCount = t1.showMemberCount
			})
		})
	end

	return React.createElement(View, {
		tag = "col gap-small",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.layoutOrder,
		Visible = v11
	}, t2)
end

return React.memo(GroupsListSection)
