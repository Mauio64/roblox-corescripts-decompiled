local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local Signals = require(BuildExperienceParent.Signals)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

require(BuildExperience.Chat.chatTypes)

local FeedbackAction = require(BuildExperience.Components.MessageUtilities.FeedbackAction)
local UserFeedback = require(BuildExperience.Components.MessageUtilities.UserFeedback)
local feedbackIcons = require(BuildExperience.Components.MessageUtilities.feedbackIcons)
local sendAgentTurnFeedback = require(BuildExperience.Components.MessageUtilities.sendAgentTurnFeedback)
local RestoreVersionDialog = require(BuildExperience.Components.VersionHistory.RestoreVersionDialog)
local GetPlaytestLoadingStore = require(BuildExperience.Stores.GetPlaytestLoadingStore)
local Snackbar = require(BuildExperienceParent.Foundation).Snackbar
local v14, v15 = Signals.createSignal(false)
local t1 = {
	get = v14,
	set = v15
}
local t2 = {}

local function getRollbackInProgressSignal(n1: number?) -- line: 38
	-- upvalues: t1 (copy), t2 (copy), Signals (copy)
	if n1 == nil then
		return t1
	end

	local v21 = t2[n1]

	if v21 == nil then
		local v22, v23 = Signals.createSignal(false)

		v21 = {
			get = v22,
			set = v23
		}
		t2[n1] = v21
	end

	return v21
end
local function AgentTurnFeedback(t3: {[any]: any}) -- line: 55
	-- upvalues: React (copy), feedbackIcons (copy), t1 (copy), t2 (copy), Signals (copy), GetPlaytestLoadingStore (copy), SignalsReact (copy), LocalizationStrings (copy), FeedbackAction (copy), sendAgentTurnFeedback (copy), UserFeedback (copy), Snackbar (copy), RestoreVersionDialog (copy)
	local turnFeedbackIds = t3.turnFeedbackIds
	local v26, v27 = React.useState(false)
	local v28, v29 = React.useState(nil)
	local v30, v31 = React.useState("")
	local v32 = if turnFeedbackIds == nil then nil else turnFeedbackIds.placeId
	local v33 = if turnFeedbackIds == nil then nil else feedbackIcons.getRollbackTargetVersionNumber(turnFeedbackIds)
	local v34 = React.useMemo(function() -- line: 65
		-- upvalues: v32 (copy), t1 (copy), t2 (copy), Signals (copy)
		local v43 = v32

		if v43 == nil then
			return t1
		end

		local v44 = t2[v43]

		if v44 == nil then
			local v45, v46 = Signals.createSignal(false)

			v44 = {
				get = v45,
				set = v46
			}
			t2[v43] = v44
		end

		return v44
	end, { v32 })
	local v35 = React.useCallback(function(p1) -- line: 68
		-- upvalues: GetPlaytestLoadingStore (copy), v32 (copy)
		local v48 = GetPlaytestLoadingStore(p1)

		if v32 == nil then
			return false
		end

		return v48.getAgentStatusForPlaceId(v32)(p1) == "Loading"
	end, { v32 })
	local v36 = SignalsReact.useSignalState(v35)
	local v37 = SignalsReact.useSignalState(v34.get)
	local v38 = React.useCallback(function() -- line: 77
		-- upvalues: v31 (copy)
		v31("")
	end, {})
	local v39 = React.useCallback(function() -- line: 81
		-- upvalues: v34 (copy)
		v34.set(true)
	end, { v34 })
	local v40 = React.useCallback(function() -- line: 84
		-- upvalues: v34 (copy), v31 (copy), LocalizationStrings (copy)
		v34.set(false)
		v31(LocalizationStrings.CHAT_REVERT_SUCCESS)
	end, { v34 })
	local v41 = React.useCallback(function() -- line: 88
		-- upvalues: v34 (copy), v31 (copy), LocalizationStrings (copy)
		v34.set(false)
		v31(LocalizationStrings.CHAT_REVERT_FAILURE)
	end, { v34 })
	local v42 = React.useCallback(function(p2) -- line: 92
		-- upvalues: turnFeedbackIds (copy), FeedbackAction (copy), v27 (copy), v29 (copy), sendAgentTurnFeedback (copy)
		if turnFeedbackIds == nil then
			return
		end

		if p2.action == FeedbackAction.REVERT then
			v27(true)

			return
		end

		v29(p2.action)
		sendAgentTurnFeedback(p2.action, turnFeedbackIds)
	end, { turnFeedbackIds })

	if turnFeedbackIds == nil or turnFeedbackIds.sequenceId == nil then
		return nil
	end

	return React.createElement(React.Fragment, nil, {
		Feedback = React.createElement(UserFeedback, {
			layoutOrder = t3.LayoutOrder,
			icons = feedbackIcons.getFeedbackIcons({
				includeRevert = feedbackIcons.canRevert(turnFeedbackIds),
				isRevertDisabled = v36 or v37
			}),
			onActivated = v42,
			selectedAction = v28,
			testId = t3.testId
		}),
		RevertSnackbar = if v30 == "" then nil else React.createElement(Snackbar, {
			LayoutOrder = (t3.LayoutOrder or 0) + 1,
			title = v30,
			onClose = v38,
			testId = `{ t3.testId }.revert-snackbar`
		}),
		RevertDialog = if not v26 or v33 == nil then nil else React.createElement(RestoreVersionDialog, {
			isOpen = true,
			title = LocalizationStrings.formatVersionHistoryVersionNumber(v33),
			description = LocalizationStrings.CHAT_REVERT_CONFIRMATION_DESCRIPTION,
			onRestore = function() -- line: 134
				-- upvalues: v27 (copy), v35 (copy), v34 (copy), v29 (copy), FeedbackAction (copy), sendAgentTurnFeedback (copy), turnFeedbackIds (copy), feedbackIcons (copy), v39 (copy), v40 (copy), v41 (copy)
				v27(false)

				if v35(false) or v34.get(false) then
					return
				end

				v29(FeedbackAction.REVERT)
				sendAgentTurnFeedback(FeedbackAction.REVERT, turnFeedbackIds)
				feedbackIcons.rollbackPublishedVersion(turnFeedbackIds, {
					onRevertStart = v39,
					onRevertSuccess = v40,
					onRevertFailure = v41
				})
			end,
			onCancel = function() -- line: 147
				-- upvalues: v27 (copy)
				v27(false)
			end
		})
	})
end

return AgentTurnFeedback
