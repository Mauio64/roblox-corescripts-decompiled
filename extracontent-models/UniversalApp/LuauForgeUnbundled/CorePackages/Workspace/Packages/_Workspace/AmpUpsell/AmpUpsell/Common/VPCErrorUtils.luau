local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Enums")
local vpcErrorCategoriesEnum = Enums.VPCErrorCategoriesEnum
local vpcRetryBehaviorEnum = Enums.VPCRetryBehaviorEnum
local vpcErrorCodesEnum = Enums.VPCErrorCodesEnum
local vpcErrorCategoryToMessageStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/LocalizationStrings").vpcErrorCategoryToMessageStrings

local v5 = {
	[vpcErrorCodesEnum.InvalidEmailAddress] = vpcErrorCategoriesEnum.InvalidEmail,
	[vpcErrorCodesEnum.EmailNotUnique] = vpcErrorCategoriesEnum.InvalidEmail,
	[vpcErrorCodesEnum.LinkingIneligible] = vpcErrorCategoriesEnum.InvalidEmail,
	[vpcErrorCodesEnum.ParentAtLinkLimit] = vpcErrorCategoriesEnum.InvalidEmail,
	[vpcErrorCodesEnum.SenderFlooded] = vpcErrorCategoriesEnum.SenderFlooded,
	[vpcErrorCodesEnum.ReceiverFlooded] = vpcErrorCategoriesEnum.ReceiverFlooded,
	[vpcErrorCodesEnum.InvalidParameter] = vpcErrorCategoriesEnum.BadUserInput,
	[vpcErrorCodesEnum.UpdateUserSettingRequestInvalid] = vpcErrorCategoriesEnum.BadUserInput,
	[vpcErrorCodesEnum.AlreadyLinked] = vpcErrorCategoriesEnum.UserStateRecoursePathMismatch,
	[vpcErrorCodesEnum.ChildAtLinkLimit] = vpcErrorCategoriesEnum.UserStateRecoursePathMismatch,
	[vpcErrorCodesEnum.NoLinkedParents] = vpcErrorCategoriesEnum.UserStateRecoursePathMismatch,
	[vpcErrorCodesEnum.SenderFloodedRequestCreated] = vpcErrorCategoriesEnum.SenderFloodedRequestCreated,
	[vpcErrorCodesEnum.Unknown] = vpcErrorCategoriesEnum.InternalVPCError,
	[vpcErrorCodesEnum.ServiceUnavailable] = vpcErrorCategoriesEnum.InternalVPCError,
	[vpcErrorCodesEnum.IllegalState] = vpcErrorCategoriesEnum.InternalVPCError,
	[vpcErrorCodesEnum.InvalidUserID] = vpcErrorCategoriesEnum.GenericError,
	[vpcErrorCodesEnum.ConsentAlreadyApplied] = vpcErrorCategoriesEnum.GenericError,
	[vpcErrorCodesEnum.ConsentAlreadyRequestedConflictingData] = vpcErrorCategoriesEnum.ConflictingPendingConsent,
	[vpcErrorCodesEnum.ReceiverNotWhitelisted] = vpcErrorCategoriesEnum.GenericError,
	[vpcErrorCodesEnum.InvalidComplianceFeature] = vpcErrorCategoriesEnum.GenericError,
	[vpcErrorCodesEnum.ChildTooOld] = vpcErrorCategoriesEnum.GenericError,
	[vpcErrorCodesEnum.UserForgotten] = vpcErrorCategoriesEnum.GenericError,
	[vpcErrorCodesEnum.UnsupportedNotificationType] = vpcErrorCategoriesEnum.GenericError,
	[vpcErrorCodesEnum.UnsupportedRequestType] = vpcErrorCategoriesEnum.GenericError,
	[vpcErrorCodesEnum.ChildIneligibleForConsent] = vpcErrorCategoriesEnum.GenericError
}

local v6 = {
	[vpcErrorCategoriesEnum.InternalVPCError] = vpcRetryBehaviorEnum.RetryVPC,
	[vpcErrorCategoriesEnum.InvalidEmail] = vpcRetryBehaviorEnum.RetryVPC,
	[vpcErrorCategoriesEnum.Flooded] = vpcRetryBehaviorEnum.NoRetry,
	[vpcErrorCategoriesEnum.SenderFlooded] = vpcRetryBehaviorEnum.NoRetry,
	[vpcErrorCategoriesEnum.ReceiverFlooded] = vpcRetryBehaviorEnum.NoRetry,
	[vpcErrorCategoriesEnum.BadUserInput] = vpcRetryBehaviorEnum.NoRetry,
	[vpcErrorCategoriesEnum.UserStateRecoursePathMismatch] = vpcRetryBehaviorEnum.RetryAMP,
	[vpcErrorCategoriesEnum.SenderFloodedRequestCreated] = vpcRetryBehaviorEnum.Success,
	[vpcErrorCategoriesEnum.GenericError] = vpcRetryBehaviorEnum.NoRetry,
	[vpcErrorCategoriesEnum.ConflictingPendingConsent] = vpcRetryBehaviorEnum.NoRetry
}

return {
	getStringsFromErrorCodeAndRetryNum = function(p2, p3)
		if p3 >= 4 then
			p2 = vpcErrorCodesEnum.SenderFlooded
		end

		local v7 = v5[p2]

		if v7 == nil then
			v7 = vpcErrorCategoriesEnum.GenericError
		end

		return vpcErrorCategoryToMessageStrings[v7]
	end,
	getRetryBehaviorFromErrorCodeAndRetryNum = function(p2, p3)
		if p3 >= 4 then
			p2 = vpcErrorCodesEnum.SenderFlooded
		end

		local v7 = v5[p2]

		if v7 == nil then
			v7 = vpcErrorCategoriesEnum.GenericError
		end

		return v6[v7]
	end,
	VPCErrorCategoriesEnum = vpcErrorCategoriesEnum,
	VPCRetryBehaviorEnum = vpcRetryBehaviorEnum
}
