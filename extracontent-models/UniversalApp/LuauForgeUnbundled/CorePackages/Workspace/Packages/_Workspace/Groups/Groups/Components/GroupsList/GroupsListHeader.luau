local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Navigation").useNavigation

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Foundation")
local view = Foundation.View
local text = Foundation.Text
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local AppHeaderBar = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/AppHeaderBar")

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/TextKeys")
local useGroupsWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Contexts/useGroupsWrapperContext")
local fFlagEnableGroupOverviewPane = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/SharedFlags").FFlagEnableGroupOverviewPane

local function GroupsListHeader(p2)
	local v5 = useGroupsWrapperContext()
	local v6 = useNavigation()

	local v7 = useLocalization({
		title = TextKeys.HeadingGroups,
		seeAll = TextKeys.ActionSeeAll
	})

	local function fn()
		if fFlagEnableGroupOverviewPane and v5.navigateTo.previousView then
			v5.navigateTo.previousView()
		else
			v6.goBack()
		end
	end

	local v10 = React.useCallback(fn, {
		if fFlagEnableGroupOverviewPane then v5.navigateTo.previousView else nil,
		v6
	})

	local v11 = React.useMemo(function()
		return AppHeaderBar.makeBackButton(v10)
	end, { v10 })

	local v12 = React.useMemo(function()
		local v13 = v11()
		return React.createElement(view, {
			tag = "align-x-left size-0 auto-xy",
			LayoutOrder = 1
		}, {
			button = v13
		})
	end, { v11 })

	return React.createElement(
		"Frame",
		{
			LayoutOrder = p2.layoutOrder,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		},
		{
			LeftSection = React.createElement(view, {
				tag = "row align-y-center gap-small auto-xy"
			}, {
				BackButton = v12,
				Title = React.createElement(text, {
					Text = v7.title,
					tag = "text-heading-medium text-align-x-left content-default",
					LayoutOrder = 2
				})
			}),
			SeeAllButton = React.createElement(button, {
				text = v7.seeAll,
				variant = buttonVariant.Text,
				size = inputSize.Medium,
				onActivated = v5.navigateTo.seeAllGroups,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0)
			})
		}
	)
end

return GroupsListHeader
