local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local common = require(script.common)
local displayOptions = require(script.displayOptions)
local feedbackFlowState = require(script.feedbackFlowState)
local FetchingStatus = require(CorePackages.Workspace.Packages.Http).Reducers.FetchingStatus

return (Rodux.combineReducers({
	common = common,
	displayOptions = displayOptions,
	feedbackFlowState = feedbackFlowState,
	FetchingStatus = FetchingStatus
}))
