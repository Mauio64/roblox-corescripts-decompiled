local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)

local CommentsSheetView = require(script.Parent.CommentsSheetView)
local useCommentsSheetViewModel = require(script.Parent.useCommentsSheetViewModel)
local useHideTabBarWhileOpen = require(Moments.ExperienceDetailsSheet.Sheet.useHideTabBarWhileOpen)
local FFlagMomentsTabsBehindModalScrim = require(Moments.Flags.FFlagMomentsTabsBehindModalScrim)

local function TabBarVisibilityController(): nil
	useHideTabBarWhileOpen(true)
	return nil
end

local function CommentsSheetContainer()
	local v = useCommentsSheetViewModel()
	local createElement = React.createElement
	local fragment = React.Fragment
	local v2 = {
		Sheet = React.createElement(CommentsSheetView, v),
		TabBarVisibilityController = 0
	}
	local tabBarVisibilityController

	if not (FFlagMomentsTabsBehindModalScrim or not v.isOpen) then
		tabBarVisibilityController = React.createElement(TabBarVisibilityController)
	end

	v2.TabBarVisibilityController = tabBarVisibilityController
	return createElement(fragment, nil, v2)
end

return React.memo(CommentsSheetContainer)
