local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local InExperienceInterventionParent = InExperienceIntervention.Parent
local React = require(InExperienceInterventionParent.React)
local Cryo = require(InExperienceInterventionParent.Cryo)
local InExperienceInterventionEventReceiver = require(InExperienceIntervention.InExperienceInterventionEventReceiver)
local InExperienceInterventionUIStateReducer = require(InExperienceIntervention.Reducers.InExperienceInterventionUIStateReducer)
local InExperienceInterventionDialogManager = require(InExperienceIntervention.InExperienceInterventionDialogManager)
local Constants = require(InExperienceInterventionParent.InterventionShared).Utils.Constants
local useLocalization = require(InExperienceInterventionParent.Localization).Hooks.useLocalization

function InExperienceInterventionContainer() -- line: 12
	-- upvalues: React (copy), InExperienceInterventionUIStateReducer (copy), Constants (copy), useLocalization (copy), Cryo (copy), InExperienceInterventionEventReceiver (copy), InExperienceInterventionDialogManager (copy)
	local v10, v11 = React.useReducer(InExperienceInterventionUIStateReducer, Constants.InitialUIState)
	local v12 = useLocalization(Constants.localizationKeys)
	local v13 = React.useCallback(function(p1) -- line: 18
		-- upvalues: Cryo (copy), v11 (copy)
		local v15 = Cryo.Dictionary.join(p1, {
			dispatchTimestamp = DateTime.now().UnixTimestamp
		})

		v11(v15)
	end, { v11 })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		EventReceiver = React.createElement(InExperienceInterventionEventReceiver, {
			uiStateDispatch = v13,
			localizedText = v12
		}),
		DialogManager = React.createElement(InExperienceInterventionDialogManager, {
			uiState = v10,
			uiStateDispatch = v13
		})
	})
end

return InExperienceInterventionContainer
