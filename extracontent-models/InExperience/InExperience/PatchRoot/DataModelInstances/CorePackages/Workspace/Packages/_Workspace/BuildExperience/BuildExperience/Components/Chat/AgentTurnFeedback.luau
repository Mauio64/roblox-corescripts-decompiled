local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local Signals = require(BuildExperienceParent.Signals)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

require(BuildExperience.Chat.chatTypes)

local UserFeedback = require(BuildExperience.Components.MessageUtilities.UserFeedback)
local feedbackIcons = require(BuildExperience.Components.MessageUtilities.feedbackIcons)
local GetPlaytestLoadingStore = require(BuildExperience.Stores.GetPlaytestLoadingStore)
local Snackbar = require(BuildExperienceParent.Foundation).Snackbar
local v11, v12 = Signals.createSignal(false)
local t1 = {
	get = v11,
	set = v12
}
local t2 = {}

local function getRollbackInProgressSignal(n1: number?) -- line: 36
	-- upvalues: t1 (copy), t2 (copy), Signals (copy)
	if n1 == nil then
		return t1
	end

	local v18 = t2[n1]

	if v18 == nil then
		local v19, v20 = Signals.createSignal(false)

		v18 = {
			get = v19,
			set = v20
		}
		t2[n1] = v18
	end

	return v18
end
local function AgentTurnFeedback(t3: {[any]: any}) -- line: 53
	-- upvalues: React (copy), t1 (copy), t2 (copy), Signals (copy), GetPlaytestLoadingStore (copy), SignalsReact (copy), LocalizationStrings (copy), feedbackIcons (copy), UserFeedback (copy), Snackbar (copy)
	local turnFeedbackIds = t3.turnFeedbackIds
	local v23, v24 = React.useState("")
	local v25 = if turnFeedbackIds == nil then nil else turnFeedbackIds.placeId
	local v26 = React.useMemo(function() -- line: 57
		-- upvalues: v25 (copy), t1 (copy), t2 (copy), Signals (copy)
		local v35 = v25

		if v35 == nil then
			return t1
		end

		local v36 = t2[v35]

		if v36 == nil then
			local v37, v38 = Signals.createSignal(false)

			v36 = {
				get = v37,
				set = v38
			}
			t2[v35] = v36
		end

		return v36
	end, { v25 })
	local v27 = React.useCallback(function(p1) -- line: 60
		-- upvalues: GetPlaytestLoadingStore (copy), v25 (copy)
		local v40 = GetPlaytestLoadingStore(p1)

		if v25 == nil then
			return false
		end

		return v40.getAgentStatusForPlaceId(v25)(p1) == "Loading"
	end, { v25 })
	local v28 = SignalsReact.useSignalState(v27)
	local v29 = SignalsReact.useSignalState(v26.get)
	local v30 = React.useCallback(function() -- line: 69
		-- upvalues: v24 (copy)
		v24("")
	end, {})
	local v31 = React.useCallback(function() -- line: 73
		-- upvalues: v26 (copy)
		v26.set(true)
	end, { v26 })
	local v32 = React.useCallback(function() -- line: 76
		-- upvalues: v26 (copy), v24 (copy), LocalizationStrings (copy)
		v26.set(false)
		v24(LocalizationStrings.CHAT_REVERT_SUCCESS)
	end, { v26 })
	local v33 = React.useCallback(function() -- line: 80
		-- upvalues: v26 (copy), v24 (copy), LocalizationStrings (copy)
		v26.set(false)
		v24(LocalizationStrings.CHAT_REVERT_FAILURE)
	end, { v26 })
	local v34 = React.useCallback(function(p2) -- line: 84
		-- upvalues: turnFeedbackIds (copy), feedbackIcons (copy), v31 (copy), v32 (copy), v33 (copy)
		if turnFeedbackIds == nil then
			return
		end

		feedbackIcons.createOnActivated(turnFeedbackIds, {
			onRevertStart = v31,
			onRevertSuccess = v32,
			onRevertFailure = v33
		})(p2)
	end, {
		v33,
		v31,
		v32,
		turnFeedbackIds
	})

	if turnFeedbackIds == nil or turnFeedbackIds.sequenceId == nil then
		return nil
	end

	return React.createElement(React.Fragment, nil, {
		Feedback = React.createElement(UserFeedback, {
			layoutOrder = t3.LayoutOrder,
			icons = feedbackIcons.getFeedbackIcons({
				includeRevert = feedbackIcons.canRevert(turnFeedbackIds),
				isRevertDisabled = v28 or v29
			}),
			onActivated = v34,
			testId = t3.testId
		}),
		RevertSnackbar = if v23 == "" then nil else React.createElement(Snackbar, {
			LayoutOrder = (t3.LayoutOrder or 0) + 1,
			title = v23,
			onClose = v30,
			testId = `{ t3.testId }.revert-snackbar`
		})
	})
end

return AgentTurnFeedback
