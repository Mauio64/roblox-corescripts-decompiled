local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local Enums = require(script.Parent.Enums)
local VPCErrorCategoriesEnum = Enums.VPCErrorCategoriesEnum
local VPCRetryBehaviorEnum = Enums.VPCRetryBehaviorEnum
local VPCErrorCodesEnum = Enums.VPCErrorCodesEnum
local vpcErrorCategoryToMessageStrings = require(AmpUpsell.Common.LocalizationStrings).vpcErrorCategoryToMessageStrings
local t1 = {
	[VPCErrorCodesEnum.InvalidEmailAddress] = VPCErrorCategoriesEnum.InvalidEmail,
	[VPCErrorCodesEnum.EmailNotUnique] = VPCErrorCategoriesEnum.InvalidEmail,
	[VPCErrorCodesEnum.LinkingIneligible] = VPCErrorCategoriesEnum.InvalidEmail,
	[VPCErrorCodesEnum.ParentAtLinkLimit] = VPCErrorCategoriesEnum.InvalidEmail,
	[VPCErrorCodesEnum.SenderFlooded] = VPCErrorCategoriesEnum.SenderFlooded,
	[VPCErrorCodesEnum.ReceiverFlooded] = VPCErrorCategoriesEnum.ReceiverFlooded,
	[VPCErrorCodesEnum.InvalidParameter] = VPCErrorCategoriesEnum.BadUserInput,
	[VPCErrorCodesEnum.UpdateUserSettingRequestInvalid] = VPCErrorCategoriesEnum.BadUserInput,
	[VPCErrorCodesEnum.AlreadyLinked] = VPCErrorCategoriesEnum.UserStateRecoursePathMismatch,
	[VPCErrorCodesEnum.ChildAtLinkLimit] = VPCErrorCategoriesEnum.UserStateRecoursePathMismatch,
	[VPCErrorCodesEnum.NoLinkedParents] = VPCErrorCategoriesEnum.UserStateRecoursePathMismatch,
	[VPCErrorCodesEnum.SenderFloodedRequestCreated] = VPCErrorCategoriesEnum.SenderFloodedRequestCreated,
	[VPCErrorCodesEnum.Unknown] = VPCErrorCategoriesEnum.InternalVPCError,
	[VPCErrorCodesEnum.ServiceUnavailable] = VPCErrorCategoriesEnum.InternalVPCError,
	[VPCErrorCodesEnum.IllegalState] = VPCErrorCategoriesEnum.InternalVPCError,
	[VPCErrorCodesEnum.InvalidUserID] = VPCErrorCategoriesEnum.GenericError,
	[VPCErrorCodesEnum.ConsentAlreadyApplied] = VPCErrorCategoriesEnum.GenericError,
	[VPCErrorCodesEnum.ConsentAlreadyRequestedConflictingData] = VPCErrorCategoriesEnum.ConflictingPendingConsent,
	[VPCErrorCodesEnum.ReceiverNotWhitelisted] = VPCErrorCategoriesEnum.GenericError,
	[VPCErrorCodesEnum.InvalidComplianceFeature] = VPCErrorCategoriesEnum.GenericError,
	[VPCErrorCodesEnum.ChildTooOld] = VPCErrorCategoriesEnum.GenericError,
	[VPCErrorCodesEnum.UserForgotten] = VPCErrorCategoriesEnum.GenericError,
	[VPCErrorCodesEnum.UnsupportedNotificationType] = VPCErrorCategoriesEnum.GenericError,
	[VPCErrorCodesEnum.UnsupportedRequestType] = VPCErrorCategoriesEnum.GenericError,
	[VPCErrorCodesEnum.ChildIneligibleForConsent] = VPCErrorCategoriesEnum.GenericError
}
local t2 = {
	[VPCErrorCategoriesEnum.InternalVPCError] = VPCRetryBehaviorEnum.RetryVPC,
	[VPCErrorCategoriesEnum.InvalidEmail] = VPCRetryBehaviorEnum.RetryVPC,
	[VPCErrorCategoriesEnum.Flooded] = VPCRetryBehaviorEnum.NoRetry,
	[VPCErrorCategoriesEnum.SenderFlooded] = VPCRetryBehaviorEnum.NoRetry,
	[VPCErrorCategoriesEnum.ReceiverFlooded] = VPCRetryBehaviorEnum.NoRetry,
	[VPCErrorCategoriesEnum.BadUserInput] = VPCRetryBehaviorEnum.NoRetry,
	[VPCErrorCategoriesEnum.UserStateRecoursePathMismatch] = VPCRetryBehaviorEnum.RetryAMP,
	[VPCErrorCategoriesEnum.SenderFloodedRequestCreated] = VPCRetryBehaviorEnum.Success,
	[VPCErrorCategoriesEnum.GenericError] = VPCRetryBehaviorEnum.NoRetry,
	[VPCErrorCategoriesEnum.ConflictingPendingConsent] = VPCRetryBehaviorEnum.NoRetry
}

return {
	getStringsFromErrorCodeAndRetryNum = function(s1: string, n1: number) -- line: 69
		-- upvalues: VPCErrorCodesEnum (copy), t1 (copy), VPCErrorCategoriesEnum (copy), vpcErrorCategoryToMessageStrings (copy)
		if n1 >= 4 then
			s1 = VPCErrorCodesEnum.SenderFlooded
		end

		local v14 = t1[s1]

		if v14 == nil then
			v14 = VPCErrorCategoriesEnum.GenericError
		end

		return vpcErrorCategoryToMessageStrings[v14]
	end,
	getRetryBehaviorFromErrorCodeAndRetryNum = function(s2: string, n2: number) -- line: 55
		-- upvalues: VPCErrorCodesEnum (copy), t1 (copy), VPCErrorCategoriesEnum (copy), t2 (copy)
		if n2 >= 4 then
			s2 = VPCErrorCodesEnum.SenderFlooded
		end

		local v11 = t1[s2]

		if v11 == nil then
			v11 = VPCErrorCategoriesEnum.GenericError
		end

		return t2[v11]
	end,
	VPCErrorCategoriesEnum = VPCErrorCategoriesEnum,
	VPCRetryBehaviorEnum = VPCRetryBehaviorEnum
}
