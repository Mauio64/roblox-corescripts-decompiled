local parent = script:FindFirstAncestor("CommercePurchaseApp").Parent
local Rodux = require(parent.Rodux)
local ToastLite = require(parent.ToastLite)
local CurrentToastMessagesReducer = ToastLite.Reducers.CurrentToastMessagesReducer

local PromptStateReducer = require(script.Parent.PromptStateReducer)

return Rodux.combineReducers({
	commercePurchaseState = PromptStateReducer,
	currentToastMessages = CurrentToastMessagesReducer
})
