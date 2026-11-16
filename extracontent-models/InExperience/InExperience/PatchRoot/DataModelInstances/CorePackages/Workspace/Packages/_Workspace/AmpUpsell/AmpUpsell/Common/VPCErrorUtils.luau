local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local Enums = require(script.Parent.Enums)
local VPCErrorCategoriesEnum = Enums.VPCErrorCategoriesEnum
local VPCRetryBehaviorEnum = Enums.VPCRetryBehaviorEnum
local VPCErrorCodesEnum = Enums.VPCErrorCodesEnum
local LocalizationStrings = require(AmpUpsell.Common.LocalizationStrings)
local vpcErrorCategoryToMessageStrings = LocalizationStrings.vpcErrorCategoryToMessageStrings

local v = {
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

local v2 = {
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
local VPCErrorUtils = {}

function VPCErrorUtils.getStringsFromErrorCodeAndRetryNum(p: string, p2: number)
	if p2 >= 4 then
		p = VPCErrorCodesEnum.SenderFlooded
	end

	local v3 = v[p]

	if v3 == nil then
		v3 = VPCErrorCategoriesEnum.GenericError
	end

	return vpcErrorCategoryToMessageStrings[v3]
end

function VPCErrorUtils.getRetryBehaviorFromErrorCodeAndRetryNum(p: string, p2: number)
	if p2 >= 4 then
		p = VPCErrorCodesEnum.SenderFlooded
	end

	local v3 = v[p]

	if v3 == nil then
		v3 = VPCErrorCategoriesEnum.GenericError
	end

	return v2[v3]
end

VPCErrorUtils.VPCErrorCategoriesEnum = VPCErrorCategoriesEnum
VPCErrorUtils.VPCRetryBehaviorEnum = VPCRetryBehaviorEnum
return VPCErrorUtils
