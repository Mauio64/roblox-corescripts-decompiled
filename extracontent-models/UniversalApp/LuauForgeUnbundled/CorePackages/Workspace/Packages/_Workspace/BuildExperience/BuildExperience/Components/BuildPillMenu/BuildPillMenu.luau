local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local view = Foundation.View

local iconName = Foundation.Enums.IconName

local BuildOverflowMenuButton = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/BuildOverflowMenuButton")
local StopPlaytestButton = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/StopPlaytestButton")
local GetBuildOverflowMenuStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildOverflowMenuStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildOverflowMenuStore/createBuildOverflowMenuStore")
local PublishStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/PublishStatus")
local leaveExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/leaveExperience")
local FFlagBuildExperienceMenuImprovements = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMenuImprovements")

local function BuildPillMenu(props)
	local store = props.store or GetBuildOverflowMenuStore()
	local v5 = PublishStatus.usePublishStatus(props.target)

	local v6 = React.useCallback(function(p2)
		if p2.type == "openPage" then
			if props.onOpenPage then
				props.onOpenPage(p2.page)
			end
		elseif p2.type == "openInvitePicker" then
			if props.onOpenInvitePicker then
				props.onOpenInvitePicker()
			end
		elseif p2.type == "openInviteManagement" then
			if props.onOpenPlaytestManagement then
				props.onOpenPlaytestManagement()
			end
		elseif props.onAction then
			props.onAction(p2)
		end
	end, {
		props.onAction,
		props.onOpenPage,
		props.onOpenInvitePicker,
		props.onOpenPlaytestManagement
	})

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local v10 = {
		Position = props.position,
		AnchorPoint = props.anchorPoint,
		LayoutOrder = props.layoutOrder,
		tag = "row align-y-center gap-xsmall size-0-1100 auto-x padding-x-xsmall radius-circle clip bg-over-media-0",
		testId = props.testId
	}
	local v12

	if FFlagBuildExperienceMenuImprovements then
		v12 = React.createElement(StopPlaytestButton, {
			layoutOrder = 0,
			onActivated = function()
				leaveExperience()
			end
		})
	end

	return createElement(fragment, nil, {
		Pill = createElement2(view, v10, {
			StopPlaytest = v12,
			Overflow = React.createElement(BuildOverflowMenuButton, {
				layoutOrder = 3,
				icon = iconName.ThreeDotsHorizontal,
				store = store,
				target = props.target,
				hasPublishedTurn = v5.hasPublishedTurn,
				hasPublishedVersion = v5.hasPublishedVersion,
				onAction = v6,
				onOpenCreatorCreditPage = props.onOpenCreatorCreditPage
			})
		})
	})
end

return BuildPillMenu
