local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local Signals = require(BuildExperienceParent.Signals)
local SignalsReact = require(BuildExperienceParent.SignalsReact)

require(BuildExperience.Chat.chatTypes)

local UserFeedback = require(BuildExperience.Components.MessageUtilities.UserFeedback)
local feedbackIcons = require(BuildExperience.Components.MessageUtilities.feedbackIcons)
local GetPlaytestLoadingStore = require(BuildExperience.Stores.GetPlaytestLoadingStore)
local Snackbar = require(BuildExperienceParent.Foundation).Snackbar
local v10, v11 = Signals.createSignal(false)
local t1 = {
	get = v10,
	set = v11
}
local t2 = {}

local function getRollbackInProgressSignal(n1: number?) -- line: 38
	-- upvalues: t1 (copy), t2 (copy), Signals (copy)
	if n1 == nil then
		return t1
	end

	local v17 = t2[n1]

	if v17 == nil then
		local v18, v19 = Signals.createSignal(false)

		v17 = {
			get = v18,
			set = v19
		}
		t2[n1] = v17
	end

	return v17
end
local function AgentTurnFeedback(t3: {[any]: any}) -- line: 55
	-- upvalues: React (copy), t1 (copy), t2 (copy), Signals (copy), GetPlaytestLoadingStore (copy), SignalsReact (copy), feedbackIcons (copy), UserFeedback (copy), Snackbar (copy)
	local turnFeedbackIds = t3.turnFeedbackIds
	local v22, v23 = React.useState("")
	local v24 = if turnFeedbackIds == nil then nil else turnFeedbackIds.placeId
	local v25 = React.useMemo(function() -- line: 59
		-- upvalues: v24 (copy), t1 (copy), t2 (copy), Signals (copy)
		local v34 = v24

		if v34 == nil then
			return t1
		end

		local v35 = t2[v34]

		if v35 == nil then
			local v36, v37 = Signals.createSignal(false)

			v35 = {
				get = v36,
				set = v37
			}
			t2[v34] = v35
		end

		return v35
	end, { v24 })
	local v26 = React.useCallback(function(p1) -- line: 62
		-- upvalues: GetPlaytestLoadingStore (copy), v24 (copy)
		local v39 = GetPlaytestLoadingStore(p1)

		return v24 ~= nil and v39.getAgentStatusForPlaceId(v24)(p1) == "Loading"
	end, { v24 })
	local v27 = SignalsReact.useSignalState(v26)
	local v28 = SignalsReact.useSignalState(v25.get)
	local v29 = React.useCallback(function() -- line: 68
		-- upvalues: v23 (copy)
		v23("")
	end, {})
	local v30 = React.useCallback(function() -- line: 72
		-- upvalues: v25 (copy)
		v25.set(true)
	end, { v25 })
	local v31 = React.useCallback(function() -- line: 75
		-- upvalues: v25 (copy), v23 (copy)
		v25.set(false)
		v23("Reverted agent publish.")
	end, { v25 })
	local v32 = React.useCallback(function() -- line: 79
		-- upvalues: v25 (copy), v23 (copy)
		v25.set(false)
		v23("Couldn't revert agent publish. Try again.")
	end, { v25 })
	local v33 = React.useCallback(function(p2) -- line: 83
		-- upvalues: turnFeedbackIds (copy), feedbackIcons (copy), v30 (copy), v31 (copy), v32 (copy)
		if turnFeedbackIds == nil then
			return
		end

		feedbackIcons.createOnActivated(turnFeedbackIds, {
			onRevertStart = v30,
			onRevertSuccess = v31,
			onRevertFailure = v32
		})(p2)
	end, {
		v32,
		v30,
		v31,
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
				isRevertDisabled = v27 or v28
			}),
			onActivated = v33,
			testId = t3.testId
		}),
		RevertSnackbar = if v22 == "" then nil else React.createElement(Snackbar, {
			LayoutOrder = (t3.LayoutOrder or 0) + 1,
			title = v22,
			onClose = v29,
			testId = `{ t3.testId }.revert-snackbar`
		})
	})
end

return AgentTurnFeedback
