local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local getUserSubscriptionDetails = require(CancelSubscriptionApp.NetworkRequests.getUserSubscriptionDetails)
local CancelSubscriptionRequested = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionRequested)
local CancelSubscriptionStarted = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionStarted)
local CancelSubscriptionFailed = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionFailed)
local ErrorStateEnum = require(CancelSubscriptionApp.Enums.ErrorStateEnum)
local LocalizationService = game:GetService("LocalizationService")

local function InitiateCancelUserSubscriptionFlow(p, p2: string)
	return function(object)
		object:dispatch(CancelSubscriptionRequested(p2))

		local robloxLocaleId = LocalizationService.RobloxLocaleId
		local v = ErrorStateEnum.ErrorCancelling
		return getUserSubscriptionDetails(p, p2):andThen(function(p3)
			if
				p3.SubscriptionState == Enum.SubscriptionState.SubscribedWillRenew
				or p3.SubscriptionState == Enum.SubscriptionState.SubscribedRenewalPaymentPending
			then
				object:dispatch(CancelSubscriptionStarted(p2, (p3.NextRenewTime:FormatLocalTime("LL", robloxLocaleId))))
				return
			end

			if
				p3.SubscriptionState == Enum.SubscriptionState.NeverSubscribed
				or p3.SubscriptionState == Enum.SubscriptionState.Expired
			then
				v = ErrorStateEnum.Unsubscribed
			elseif p3.SubscriptionState == Enum.SubscriptionState.SubscribedWillNotRenew then
				v = ErrorStateEnum.Expiring
			end

			object:dispatch(CancelSubscriptionFailed(v, p2))
		end):catch(function(_)
			object:dispatch(CancelSubscriptionFailed(ErrorStateEnum.ErrorCancelling, p2))
		end)
	end
end

return InitiateCancelUserSubscriptionFlow
