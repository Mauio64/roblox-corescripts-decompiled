local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)
local React = require(MomentsParent.React)
local SignalsReact = require(MomentsParent.SignalsReact)
local Button = Foundation.Button
local useSignalState = SignalsReact.useSignalState

require(Moments.ExperienceDetailsSheet.Types)

local useJoinExperience = require(script.Parent.useJoinExperience)
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)

local function JoinButton(t1: {[any]: any}) -- line: 30
	-- upvalues: useJoinExperience (copy), useSignalState (copy), GetMomentsPreferencesStore (copy), React (copy), Button (copy), Foundation (copy)
	local v12 = useJoinExperience()
	local v13 = useSignalState(GetMomentsPreferencesStore(false).getIsTeleporting)
	local context = t1.context

	return React.createElement(Button, {
		LayoutOrder = t1.LayoutOrder,
		text = t1.text,
		size = Foundation.Enums.InputSize.Medium,
		variant = Foundation.Enums.ButtonVariant.Emphasis,
		isDisabled = t1.isDisabled == true or v13,
		testId = t1.testId,
		onActivated = function() -- line: 43
			-- upvalues: v12 (copy), context (copy)
			v12(context)
		end
	})
end

return React.memo(JoinButton)
