local Parent = script:FindFirstAncestor("CommercePurchaseApp").Parent
local Rodux = require(Parent.Rodux)
local CurrentToastMessagesReducer = require(Parent.ToastLite).Reducers.CurrentToastMessagesReducer
local PromptStateReducer = require(script.Parent.PromptStateReducer)

return Rodux.combineReducers({
	commercePurchaseState = PromptStateReducer,
	currentToastMessages = CurrentToastMessagesReducer
})
