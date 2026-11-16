local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local CommentsSheetView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/CommentsSheetView")
local useCommentsSheetViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/useCommentsSheetViewModel")
local useHideTabBarWhileOpen = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet/Sheet/useHideTabBarWhileOpen")
local FFlagMomentsTabsBehindModalScrim = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsTabsBehindModalScrim")

local function TabBarVisibilityController(): nil
	useHideTabBarWhileOpen(true)
	return nil
end

local function CommentsSheetContainer()
	local v5 = useCommentsSheetViewModel()
	local createElement = React.createElement
	local fragment = React.Fragment
	local v7 = {
		Sheet = React.createElement(CommentsSheetView, v5),
		TabBarVisibilityController = 0
	}
	local v8 = if not (FFlagMomentsTabsBehindModalScrim or not v5.isOpen) then React.createElement(TabBarVisibilityController) else nil
	v7.TabBarVisibilityController = v8
	return createElement(fragment, nil, v7)
end

return React.memo(CommentsSheetContainer)
