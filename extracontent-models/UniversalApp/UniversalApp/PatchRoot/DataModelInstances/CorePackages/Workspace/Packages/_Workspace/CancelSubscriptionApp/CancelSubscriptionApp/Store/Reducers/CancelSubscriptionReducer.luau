local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local CancelSubscriptionAppParent = CancelSubscriptionApp.Parent
local Rodux = require(CancelSubscriptionAppParent.Rodux)
local CancelUserSubscriptionAsyncPromptStateEnum = require(CancelSubscriptionApp.Enums.CancelUserSubscriptionAsyncPromptStateEnum)
local CancelSubscriptionEnded = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionEnded)
local CancelSubscriptionSucceeded = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionSucceeded)
local CancelSubscriptionFailed = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionFailed)
local CancelSubscriptionStarted = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionStarted)
local CancelSubscriptionRequested = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionRequested)

require(CancelSubscriptionApp.Store.Types)

local function createInitialState() -- line: 22
	-- upvalues: CancelUserSubscriptionAsyncPromptStateEnum (copy)
	return {
		promptState = CancelUserSubscriptionAsyncPromptStateEnum.None
	}
end

return (Rodux.createReducer({
	promptState = CancelUserSubscriptionAsyncPromptStateEnum.None
}, {
	[CancelSubscriptionEnded.name] = function(_, _) -- line: 29
		-- upvalues: CancelUserSubscriptionAsyncPromptStateEnum (copy)
		return {
			promptState = CancelUserSubscriptionAsyncPromptStateEnum.None
		}
	end,
	[CancelSubscriptionSucceeded.name] = function(p3, p4) -- line: 35
		-- upvalues: CancelUserSubscriptionAsyncPromptStateEnum (copy)
		local v15 = table.clone(p3)

		v15.subscriptionId = p4.subscriptionId
		v15.promptState = CancelUserSubscriptionAsyncPromptStateEnum.Success

		return v15
	end,
	[CancelSubscriptionFailed.name] = function(p5, p6) -- line: 44
		-- upvalues: CancelUserSubscriptionAsyncPromptStateEnum (copy)
		local v18 = table.clone(p5)

		v18.errorState = p6.errorState
		v18.subscriptionId = p6.subscriptionId
		v18.promptState = CancelUserSubscriptionAsyncPromptStateEnum.Error

		return v18
	end,
	[CancelSubscriptionRequested.name] = function(p7, p8) -- line: 54
		-- upvalues: CancelUserSubscriptionAsyncPromptStateEnum (copy)
		local v21 = table.clone(p7)

		v21.subscriptionId = p8.subscriptionId
		v21.promptState = CancelUserSubscriptionAsyncPromptStateEnum.Pending

		return v21
	end,
	[CancelSubscriptionStarted.name] = function(p9, p10) -- line: 63
		-- upvalues: CancelUserSubscriptionAsyncPromptStateEnum (copy)
		local v24 = table.clone(p9)

		v24.promptState = CancelUserSubscriptionAsyncPromptStateEnum.Request
		v24.subscriptionId = p10.subscriptionId
		v24.expirationDate = p10.expirationDate

		return v24
	end
}))
