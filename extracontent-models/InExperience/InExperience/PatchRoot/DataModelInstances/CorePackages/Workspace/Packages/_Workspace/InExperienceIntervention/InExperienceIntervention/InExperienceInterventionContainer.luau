local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local parent = InExperienceIntervention.Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)

local InExperienceInterventionEventReceiver = require(InExperienceIntervention.InExperienceInterventionEventReceiver)
local InExperienceInterventionUIStateReducer = require(InExperienceIntervention.Reducers.InExperienceInterventionUIStateReducer)
local InExperienceInterventionDialogManager = require(InExperienceIntervention.InExperienceInterventionDialogManager)
local InterventionShared = require(parent.InterventionShared)
local Constants = InterventionShared.Utils.Constants
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

function InExperienceInterventionContainer()
	local uiState, v = React.useReducer(InExperienceInterventionUIStateReducer, Constants.InitialUIState)
	local localizedText = useLocalization(Constants.localizationKeys)

	local uiStateDispatch = React.useCallback(function(p)
		v((Cryo.Dictionary.join(p, { dispatchTimestamp = DateTime.now().UnixTimestamp })))
	end, { v })

	return React.createElement("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }, {
		EventReceiver = React.createElement(InExperienceInterventionEventReceiver, {
			uiStateDispatch = uiStateDispatch,
			localizedText = localizedText
		}),
		DialogManager = React.createElement(InExperienceInterventionDialogManager, {
			uiState = uiState,
			uiStateDispatch = uiStateDispatch
		})
	})
end

return InExperienceInterventionContainer
