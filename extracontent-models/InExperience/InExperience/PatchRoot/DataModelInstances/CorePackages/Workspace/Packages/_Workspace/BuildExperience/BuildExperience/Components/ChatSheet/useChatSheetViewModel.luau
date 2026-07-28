local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local useChatPlaytestFooter = require(BuildExperience.Chat.useChatPlaytestFooter)
local useChatSessionCore = require(BuildExperience.Chat.useChatSessionCore)

require(BuildExperience.Components.BuildPillMenu.BuildPillMenuPortal)

local GetAssistantBuildStore = require(BuildExperience.Stores.GetAssistantBuildStore)
local GetCreatorAgentResumeStore = require(BuildExperience.Stores.GetCreatorAgentResumeStore)
local getCurrentExperienceProject = require(BuildExperience.utils.getCurrentExperienceProject)

require(script.Parent.ChatSheetView)

local function noop() -- line: 31
end
local function useChatSheetViewModel(t1: {[any]: any}) -- line: 33
	-- upvalues: noop (copy), GetAssistantBuildStore (copy), SignalsReact (copy), GetCreatorAgentResumeStore (copy), getCurrentExperienceProject (copy), useChatSessionCore (copy), useChatPlaytestFooter (copy), React (copy)
	local v13 = t1.onClose or noop
	local v14 = t1.isOpen == nil or t1.isOpen
	local v15 = GetAssistantBuildStore()
	local v16 = SignalsReact.useSignalState(v15.getIsDisabled)
	local v17 = GetCreatorAgentResumeStore()
	local v18 = getCurrentExperienceProject()
	local v19 = t1.universeId or v18.universeId
	local v20 = t1.placeId or v18.placeId
	local v21 = useChatSessionCore({
		autoFocusComposer = false,
		universeId = v19,
		placeId = v20,
		sessionId = t1.sessionId,
		hydrateHistoryWhen = v14
	})
	local v22 = useChatPlaytestFooter(v21, "ChatSheetPlaytestCta")

	React.useEffect(function() -- line: 52
		-- upvalues: v14 (copy), v16 (copy), v13 (copy)
		if v14 and v16 then
			v13()
		end
	end, {
		v14,
		v16,
		v13
	})
	React.useEffect(function() -- line: 58
		-- upvalues: v14 (copy), v17 (copy), v19 (copy), t1 (copy)
		if not v14 then
			v17.setActiveTarget(nil)

			return
		end

		v17.setActiveTarget({
			universeId = v19,
			sessionId = t1.sessionId
		})

		return function() -- line: 67
			-- upvalues: v17 (copy)
			v17.setActiveTarget(nil)
		end
	end, {
		v17,
		v14,
		v19,
		t1.sessionId
	})

	return {
		isOpen = v14,
		onClose = v13,
		snapPoints = t1.snapPoints,
		defaultSnapPointIndex = t1.defaultSnapPointIndex,
		messages = v21.messages,
		localToolActions = v21.localToolActions,
		clockBinding = v21.clockBinding,
		onPlaytest = v22.onPlaytest,
		isPlaytestLoading = v22.isPlaytestLoading,
		scrollingFrameRef = v21.setScrollingFrame,
		composerText = v21.composerText,
		composerErrorText = v21.composerErrorText,
		onComposerChanged = v21.setComposerText,
		textBoxRef = v21.textBoxRef,
		isAssistantResponding = v21.isAssistantResponding,
		canStopAssistantResponse = v21.canStopAssistantResponse,
		canSendWhileResponding = v21.canSendWhileResponding,
		onSend = v21.sendMessage,
		onStop = v21.stopAssistantResponse,
		topBarPillMenuTarget = t1.topBarPillMenuTarget
	}
end

return useChatSheetViewModel
