local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local AgentDetailMenu = require(script.Parent.AgentDetailMenu)
local BuildOverflowMenuButton = require(script.Parent.BuildOverflowMenuButton)
local GetBuildOverflowMenuStore = require(BuildExperience.Stores.GetBuildOverflowMenuStore)

require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)

local PublishStatus = require(BuildExperience.Chat.PublishStatus)

local function BuildPillMenu(t1: {[any]: any}) -- line: 46
	-- upvalues: GetBuildOverflowMenuStore (copy), PublishStatus (copy), React (copy), View (copy), AgentDetailMenu (copy), BuildOverflowMenuButton (copy), IconName (copy)
	local v13 = t1.store or GetBuildOverflowMenuStore()
	local v14 = PublishStatus.usePublishStatus(t1.target)
	local v15 = React.useCallback(function(p1) -- line: 50
		-- upvalues: t1 (copy)
		if p1.type == "openPage" then
			if t1.onOpenPage then
				t1.onOpenPage(p1.page)

				return
			end
		elseif p1.type == "openInvitePicker" then
			if t1.onOpenInvitePicker then
				t1.onOpenInvitePicker()

				return
			end
		elseif t1.onAction then
			t1.onAction(p1)
		end
	end, {
		t1.onAction,
		t1.onOpenPage,
		t1.onOpenInvitePicker
	})
	local v16 = React.useCallback(function() -- line: 64
		-- upvalues: t1 (copy)
		if t1.onOpenAgentsPage then
			t1.onOpenAgentsPage()
		end
	end, { t1.onOpenAgentsPage })

	return React.createElement(React.Fragment, nil, {
		Pill = React.createElement(View, {
			tag = "row align-y-center gap-xsmall size-0-1100 auto-x padding-x-xsmall radius-circle clip bg-over-media-0",
			Position = t1.position,
			AnchorPoint = t1.anchorPoint,
			LayoutOrder = t1.layoutOrder,
			testId = t1.testId
		}, {
			AgentDetail = React.createElement(AgentDetailMenu, {
				layoutOrder = 1,
				onActivated = v16
			}),
			Overflow = React.createElement(BuildOverflowMenuButton, {
				layoutOrder = 2,
				icon = IconName.ThreeDotsHorizontal,
				store = v13,
				target = t1.target,
				hasPublishedTurn = v14.hasPublishedTurn,
				hasPublishedVersion = v14.hasPublishedVersion,
				onAction = v15,
				onOpenCreatorCreditPage = t1.onOpenCreatorCreditPage
			})
		})
	})
end

return BuildPillMenu
