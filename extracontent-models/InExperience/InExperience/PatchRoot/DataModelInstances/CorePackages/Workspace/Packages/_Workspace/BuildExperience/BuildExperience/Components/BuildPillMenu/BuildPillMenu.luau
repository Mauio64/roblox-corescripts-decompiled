local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View

local IconName = Foundation.Enums.IconName

local BuildOverflowMenuButton = require(script.Parent.BuildOverflowMenuButton)
local StopPlaytestButton = require(script.Parent.StopPlaytestButton)
local GetBuildOverflowMenuStore = require(BuildExperience.Stores.GetBuildOverflowMenuStore)
require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)
local PublishStatus = require(BuildExperience.Chat.PublishStatus)
local leaveExperience = require(BuildExperience.utils.leaveExperience)
local FFlagBuildExperienceMenuImprovements = require(BuildExperience.Flags.FFlagBuildExperienceMenuImprovements)

local function BuildPillMenu(props)
	local store = props.store or GetBuildOverflowMenuStore()
	local v = PublishStatus.usePublishStatus(props.target)

	local onAction = React.useCallback(function(p)
		if p.type == "openPage" then
			if props.onOpenPage then
				props.onOpenPage(p.page)
			end
		elseif p.type == "openInvitePicker" then
			if props.onOpenInvitePicker then
				props.onOpenInvitePicker()
			end
		elseif p.type == "openInviteManagement" then
			if props.onOpenPlaytestManagement then
				props.onOpenPlaytestManagement()
			end
		elseif props.onAction then
			props.onAction(p)
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
	local v2 = {
		Position = props.position,
		AnchorPoint = props.anchorPoint,
		LayoutOrder = props.layoutOrder,
		tag = "row align-y-center gap-xsmall size-0-1100 auto-x padding-x-xsmall radius-circle clip bg-over-media-0",
		testId = props.testId
	}
	local stopPlaytest

	if FFlagBuildExperienceMenuImprovements then
		stopPlaytest = React.createElement(StopPlaytestButton, {
			layoutOrder = 0,
			onActivated = function()
				leaveExperience()
			end
		})
	end

	return createElement(fragment, nil, {
		Pill = createElement2(View, v2, {
			StopPlaytest = stopPlaytest,
			Overflow = React.createElement(BuildOverflowMenuButton, {
				layoutOrder = 3,
				icon = IconName.ThreeDotsHorizontal,
				store = store,
				target = props.target,
				hasPublishedTurn = v.hasPublishedTurn,
				hasPublishedVersion = v.hasPublishedVersion,
				onAction = onAction,
				onOpenCreatorCreditPage = props.onOpenCreatorCreditPage
			})
		})
	})
end

return BuildPillMenu
