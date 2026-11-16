local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local parent = CancelSubscriptionApp.Parent
local Rodux = require(parent.Rodux)

local CancelUserSubscriptionAsyncPromptStateEnum = require(CancelSubscriptionApp.Enums.CancelUserSubscriptionAsyncPromptStateEnum)
local CancelSubscriptionEnded = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionEnded)
local CancelSubscriptionSucceeded = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionSucceeded)
local CancelSubscriptionFailed = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionFailed)
local CancelSubscriptionStarted = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionStarted)
local CancelSubscriptionRequested = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionRequested)

require(CancelSubscriptionApp.Store.Types)

local function createInitialState() -- 2 equivalent calls inferred from this helper
	return { promptState = CancelUserSubscriptionAsyncPromptStateEnum.None }
end

local createReducer = Rodux.createReducer
local initialState = createInitialState() -- inferred equivalent call
return (createReducer(initialState, {
	[CancelSubscriptionEnded.name] = function(_, _)
		return createInitialState() -- inferred equivalent call
	end,
	[CancelSubscriptionSucceeded.name] = function(p, p2)
		local clone = table.clone(p)
		clone.subscriptionId = p2.subscriptionId
		clone.promptState = CancelUserSubscriptionAsyncPromptStateEnum.Success
		return clone
	end,
	[CancelSubscriptionFailed.name] = function(p, p2)
		local clone = table.clone(p)
		clone.errorState = p2.errorState
		clone.subscriptionId = p2.subscriptionId
		clone.promptState = CancelUserSubscriptionAsyncPromptStateEnum.Error
		return clone
	end,
	[CancelSubscriptionRequested.name] = function(p, p2)
		local clone = table.clone(p)
		clone.subscriptionId = p2.subscriptionId
		clone.promptState = CancelUserSubscriptionAsyncPromptStateEnum.Pending
		return clone
	end,
	[CancelSubscriptionStarted.name] = function(p, p2)
		local clone = table.clone(p)
		clone.promptState = CancelUserSubscriptionAsyncPromptStateEnum.Request
		clone.subscriptionId = p2.subscriptionId
		clone.expirationDate = p2.expirationDate
		return clone
	end
}))
