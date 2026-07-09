local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local getUserSubscriptionDetails = require(CancelSubscriptionApp.NetworkRequests.getUserSubscriptionDetails)
local CancelSubscriptionRequested = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionRequested)
local CancelSubscriptionStarted = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionStarted)
local CancelSubscriptionFailed = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionFailed)
local ErrorStateEnum = require(CancelSubscriptionApp.Enums.ErrorStateEnum)
local LocalizationService = game:GetService("LocalizationService")

local function InitiateCancelUserSubscriptionFlow(p1, s1: string) -- line: 9
	-- upvalues: CancelSubscriptionRequested (copy), LocalizationService (copy), ErrorStateEnum (copy), getUserSubscriptionDetails (copy), CancelSubscriptionStarted (copy), CancelSubscriptionFailed (copy)
	return function(p2) -- line: 10
		-- upvalues: CancelSubscriptionRequested (copy), s1 (copy), LocalizationService (copy), ErrorStateEnum (copy), getUserSubscriptionDetails (copy), p1 (copy), CancelSubscriptionStarted (copy), CancelSubscriptionFailed (copy)
		p2:dispatch(CancelSubscriptionRequested(s1))

		local RobloxLocaleId = LocalizationService.RobloxLocaleId
		local ErrorCancelling = ErrorStateEnum.ErrorCancelling

		return getUserSubscriptionDetails(p1, s1):andThen(function(p3) -- line: 16
			-- upvalues: RobloxLocaleId (copy), p2 (copy), CancelSubscriptionStarted (copy), s1 (copy), ErrorCancelling (ref), ErrorStateEnum (copy), CancelSubscriptionFailed (copy)
			if p3.SubscriptionState == Enum.SubscriptionState.SubscribedWillRenew or p3.SubscriptionState == Enum.SubscriptionState.SubscribedRenewalPaymentPending then
				local v15 = p3.NextRenewTime:FormatLocalTime("LL", RobloxLocaleId)

				p2:dispatch(CancelSubscriptionStarted(s1, v15))

				return
			end

			if p3.SubscriptionState == Enum.SubscriptionState.NeverSubscribed or p3.SubscriptionState == Enum.SubscriptionState.Expired then
				ErrorCancelling = ErrorStateEnum.Unsubscribed
			elseif p3.SubscriptionState == Enum.SubscriptionState.SubscribedWillNotRenew then
				ErrorCancelling = ErrorStateEnum.Expiring
			end

			p2:dispatch(CancelSubscriptionFailed(ErrorCancelling, s1))
		end):catch(function(_) -- line: 35
			-- upvalues: p2 (copy), CancelSubscriptionFailed (copy), ErrorStateEnum (copy), s1 (copy)
			p2:dispatch(CancelSubscriptionFailed(ErrorStateEnum.ErrorCancelling, s1))
		end)
	end
end

return InitiateCancelUserSubscriptionFlow
