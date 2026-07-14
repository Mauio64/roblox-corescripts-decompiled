local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local AgentDetailMenu = require(script.Parent.AgentDetailMenu)
local BuildOverflowMenuButton = require(script.Parent.BuildOverflowMenuButton)
local GetBuildOverflowMenuStore = require(BuildExperience.Stores.GetBuildOverflowMenuStore)

require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)

local useSessionSummary = require(BuildExperience.Chat.useSessionSummary)

local function BuildPillMenu(t1: {[any]: any}) -- line: 43
	-- upvalues: GetBuildOverflowMenuStore (copy), React (copy), CreatorAgentChat (copy), useSessionSummary (copy), View (copy), AgentDetailMenu (copy), BuildOverflowMenuButton (copy), IconName (copy)
	local v14 = t1.store or GetBuildOverflowMenuStore()
	local v15 = React.useMemo(function() -- line: 45
		-- upvalues: CreatorAgentChat (copy), t1 (copy)
		return CreatorAgentChat.getCreatorAgentChatStore().getSessionForProject(t1.target.universeId, t1.target.placeId, t1.target.sessionId)
	end, {
		t1.target.universeId,
		t1.target.placeId,
		t1.target.sessionId
	})
	local v16 = useSessionSummary(v15)
	local subagentTaskState = v16.subagentTaskState
	local v18 = subagentTaskState ~= nil and #subagentTaskState.groups > 0
	local v19 = React.useCallback(function(p1) -- line: 53
		-- upvalues: t1 (copy)
		if p1.type == "openPage" then
			if t1.onOpenPage then
				t1.onOpenPage(p1.page)

				return
			end
		elseif t1.onAction then
			t1.onAction(p1)
		end
	end, {
		t1.onAction,
		t1.onOpenPage
	})
	local v20 = React.useCallback(function() -- line: 63
		-- upvalues: v18 (copy), t1 (copy)
		if not v18 then
			return
		end

		if t1.onOpenAgentsPage then
			t1.onOpenAgentsPage()
		end
	end, {
		v18,
		t1.onOpenAgentsPage
	})

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
				isDisabled = not v18,
				onActivated = v20
			}),
			Overflow = React.createElement(BuildOverflowMenuButton, {
				layoutOrder = 2,
				icon = IconName.ThreeDotsHorizontal,
				store = v14,
				target = t1.target,
				hasPublishedTurn = v16.hasPublishedTurn,
				onAction = v19
			})
		})
	})
end

return BuildPillMenu
