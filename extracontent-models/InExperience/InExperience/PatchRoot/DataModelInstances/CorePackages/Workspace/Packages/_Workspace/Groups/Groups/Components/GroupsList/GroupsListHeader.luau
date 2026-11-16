local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local AppHeaderBar = require(parent.AppHeaderBar)

local TextKeys = require(Groups.Common.TextKeys)
local useGroupsWrapperContext = require(Groups.Contexts.useGroupsWrapperContext)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableGroupOverviewPane = SharedFlags.FFlagEnableGroupOverviewPane

local function GroupsListHeader(p)
	local v = useGroupsWrapperContext()
	local v2 = useNavigation()

	local v3 = useLocalization({ title = TextKeys.HeadingGroups, seeAll = TextKeys.ActionSeeAll })

	local useCallback = React.useCallback
	local function fn()
		if FFlagEnableGroupOverviewPane and v.navigateTo.previousView then
			v.navigateTo.previousView()
		else
			v2.goBack()
		end
	end

	local v4

	if FFlagEnableGroupOverviewPane then
		v4 = v.navigateTo.previousView
	end

	local v5 = useCallback(fn, { v4, v2 })

	local v6 = React.useMemo(function()
		return AppHeaderBar.makeBackButton(v5)
	end, { v5 })

	local backButton = React.useMemo(function()
		local button = v6()
		return React.createElement(View, { tag = "align-x-left size-0 auto-xy", LayoutOrder = 1 }, {
			button = button
		})
	end, { v6 })

	return React.createElement(
		"Frame",
		{
			LayoutOrder = p.layoutOrder,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		},
		{
			LeftSection = React.createElement(View, { tag = "row align-y-center gap-small auto-xy" }, {
				BackButton = backButton,
				Title = React.createElement(Text, {
					Text = v3.title,
					tag = "text-heading-medium text-align-x-left content-default",
					LayoutOrder = 2
				})
			}),
			SeeAllButton = React.createElement(Button, {
				text = v3.seeAll,
				variant = ButtonVariant.Text,
				size = InputSize.Medium,
				onActivated = v.navigateTo.seeAllGroups,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0)
			})
		}
	)
end

return GroupsListHeader
