local Groups = script:FindFirstAncestor("Groups")
local GroupsParent = Groups.Parent
local React = require(GroupsParent.React)
local useLocalization = require(GroupsParent.Localization).Hooks.useLocalization
local useNavigation = require(GroupsParent.Navigation).useNavigation
local Foundation = require(GroupsParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local AppHeaderBar = require(GroupsParent.AppHeaderBar)
local TextKeys = require(Groups.Common.TextKeys)
local useGroupsWrapperContext = require(Groups.Contexts.useGroupsWrapperContext)

local function GroupsListHeader(t1: {[any]: any}) -- line: 33
	-- upvalues: useGroupsWrapperContext (copy), useNavigation (copy), useLocalization (copy), TextKeys (copy), React (copy), AppHeaderBar (copy), View (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local v17 = useGroupsWrapperContext()
	local v18 = useNavigation()
	local v19 = useLocalization({
		title = TextKeys.HeadingGroups,
		seeAll = TextKeys.ActionSeeAll
	})
	local v20 = React.useCallback(function() -- line: 42
		-- upvalues: v18 (copy)
		v18.goBack()
	end, { v18 })
	local v21 = React.useMemo(function() -- line: 46
		-- upvalues: AppHeaderBar (copy), v20 (copy)
		return AppHeaderBar.makeBackButton(v20)
	end, { v20 })
	local v22 = React.useMemo(function() -- line: 50
		-- upvalues: v21 (copy), React (copy), View (copy)
		local v23 = v21()

		return React.createElement(View, {
			tag = "size-0 auto-xy align-x-left",
			LayoutOrder = 1
		}, {
			button = v23
		})
	end, { v21 })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		LeftSection = React.createElement(View, {
			tag = "row auto-xy align-y-center gap-small"
		}, {
			BackButton = v22,
			Title = React.createElement(FoundationText, {
				tag = "text-align-x-left content-default text-heading-medium",
				LayoutOrder = 2,
				Text = v19.title
			})
		}),
		SeeAllButton = React.createElement(Button, {
			text = v19.seeAll,
			variant = ButtonVariant.Text,
			size = InputSize.Medium,
			onActivated = v17.navigateTo.seeAllGroups,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0)
		})
	})
end

return GroupsListHeader
