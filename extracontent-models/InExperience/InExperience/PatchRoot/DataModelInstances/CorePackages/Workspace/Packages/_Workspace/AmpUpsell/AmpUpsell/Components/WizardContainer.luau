local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent
local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Enums = require(AmpUpsell.Common.Enums)
local ActionTypeEnum = Enums.ActionTypeEnum
local ActionStatusEnum = Enums.ActionStatusEnum
local AccessResponseEnum = Enums.AccessResponseEnum
local UserSettingsSettingNameEnum = Enums.UserSettingsSettingNameEnum
require(AmpUpsell.Common.Types)
local LocalizationStrings = require(AmpUpsell.Common.LocalizationStrings)
local accountSettingsUpsellStringsFn = LocalizationStrings.accountSettingsUpsellStringsFn
local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading

local Cryo = require(parent.Cryo)
local AnalyticsService = require(AmpUpsell.Analytics.AnalyticsService)
local sendModalActionEvent = require(AmpUpsell.Analytics.sendModalActionEvent)
local AmpApiProvider = require(AmpUpsell.Common.AmpApiProvider)
local AppScreens = require(AmpUpsell.Common.AppScreens)
local ErrorScreen = require(AmpUpsell.Components.ErrorScreen)
local useCompletionCallbackWithReturnPage = require(AmpUpsell.Common.useCompletionCallbackWithReturnPage)
local ApolloClient = require(parent.ApolloClient)
local useApolloClient = ApolloClient.useApolloClient
local SharedFlags = require(parent.SharedFlags)
local FFlagAmpWizardEntryPointEventCtxFallback = SharedFlags.FFlagAmpWizardEntryPointEventCtxFallback
local FFlagEnableAmpWizardDeepLink = SharedFlags.FFlagEnableAmpWizardDeepLink
local GetFFlagEnableAmpUpsellGql = require(AmpUpsell.Flags.GetFFlagEnableAmpUpsellGql)
local GetFFlagEnableAmpEmailUpsellSupport = require(AmpUpsell.Flags.GetFFlagEnableAmpEmailUpsellSupport)
local GetFFlagEnableAmpIDVUpsellSupport = require(AmpUpsell.Flags.GetFFlagEnableAmpIDVUpsellSupport)
local GetFFlagEnableAmpIDVUpsellPopOnCompletion = require(AmpUpsell.Flags.GetFFlagEnableAmpIDVUpsellPopOnCompletion)
local GetFFlagEnableAmpSubscriptionUpsell = require(AmpUpsell.Flags.GetFFlagEnableAmpSubscriptionUpsell)
local GetFFlagEnableAmpVPCPrologue = require(AmpUpsell.Flags.GetFFlagEnableAmpVPCPrologue)
local GetFFlagEnableAmpWizardInlineVPCForFAE = require(AmpUpsell.Flags.GetFFlagEnableAmpWizardInlineVPCForFAE)
local GetFFlagEnableAmpWizardVPCNavigationFix = require(AmpUpsell.Flags.GetFFlagEnableAmpWizardVPCNavigationFix)
local FFlagAmpWizardRetryKeepsNameSpace = require(AmpUpsell.Flags.FFlagAmpWizardRetryKeepsNameSpace)
local VPCPrologue = require(AmpUpsell.Components.Prologues.VPCPrologue)
local LoggingUtils = require(AmpUpsell.Common.LoggingUtils)
local logEventOnceIfEnabled = LoggingUtils.logEventOnceIfEnabled
local VPCApiProvider = require(AmpUpsell.Common.VPCApiProvider)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local VPCRequestTypeEnum = Enums.VPCRequestTypeEnum

local function VPCPrologueController(props)
	local options = props.options

	local onConfirm = React.useCallback(function()
		local actionProps = props.request.actionProps
		props.onDone()

		if options and options.onConfirm then
			options.onConfirm()
		end

		if props.request.openUpsellFn then
			props.request.openUpsellFn(actionProps)
		end
	end, { props.request, props.onDone, options })

	local onCancel = React.useCallback(function()
		props.onDone()

		if options and options.onCancel then
			options.onCancel()
		end

		props.handleCompletion(
			AccessResponseEnum.Denied,
			Cryo.Dictionary.join(props.actionsTaken, {
				[props.request.action] = ActionStatusEnum.Cancelled
			})
		)
	end, { props.handleCompletion, props.actionsTaken, props.onDone, props.request, options })

	local createElement = React.createElement
	local v = {
		recourseData = props.recourseData,
		onConfirm = onConfirm,
		onCancel = onCancel,
		config = 0
	}
	local config

	if options then
		config = options.config
	end

	v.config = config
	return createElement(VPCPrologue, v)
end

local function getSuccessfulActions(state)
	local successfulActions = {}

	for k, item in pairs(state) do
		if item == ActionStatusEnum.Success then
			table.insert(successfulActions, k)
		end
	end

	return successfulActions
end

local function shouldUseVpcV2(vpcV2Launcher, vpcExcludedRequestTypes, p): boolean -- 1 equivalent call inferred from this helper
	local action = p.action

	if vpcV2Launcher == nil or action ~= ActionTypeEnum.ParentConsent and action ~= ActionTypeEnum.ParentLink then
		return false
	end

	local parentConsentTypes = p.parentConsentTypes
	local v

	if parentConsentTypes then
		v = parentConsentTypes[1]
	end

	if v == nil then
		return true
	end

	return vpcExcludedRequestTypes == nil or table.find(vpcExcludedRequestTypes, v) == nil
end

local function WizardContainer(props)
	local v = useNavigation()
	local featureName = props.featureName
	local nameSpace = props.nameSpace
	local recourseData = props.recourseData
	local extraParameters = props.extraParameters

	local entryPointEventCtx = FFlagAmpWizardEntryPointEventCtxFallback
		and (props.entryPointEventCtx == nil or props.entryPointEventCtx == "")
		and "defaultLuaContext"
		or props.entryPointEventCtx
	local openUpsells = props.openUpsells
	local vpcV2Launcher = props.vpcV2Launcher
	local vpcExcludedRequestTypes = props.vpcExcludedRequestTypes
	local handleCompletion = props.completionCallback
	local metadata = props.metadata
	local v2

	if props.ampApiProvider then
		v2 = props.ampApiProvider
	else
		v2 = AmpApiProvider
	end

	local v3

	if props.analyticsService then
		v3 = props.analyticsService
	else
		v3 = AnalyticsService.EventStream
	end

	local v4

	if props.openAccountSettingsUpsell then
		v4 = props.openAccountSettingsUpsell
	else
		v4 = v.push
	end

	local isInExperienceEntry

	if props.isInExperienceEntry then
		isInExperienceEntry = props.isInExperienceEntry
	else
		isInExperienceEntry = false
	end

	local v5 = useRoactService(RoactNetworking)
	local state, setState = React.useState({})
	local state2, setState2 = React.useState(false)

	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState(nil)
	local v6 = useApolloClient()

	local v7 = useCompletionCallbackWithReturnPage(v, handleCompletion, metadata)

	if FFlagEnableAmpWizardDeepLink then
		handleCompletion = v7
	end

	local v8 = React.useCallback(function(p)
		if not shouldUseVpcV2(vpcV2Launcher, vpcExcludedRequestTypes, p) then -- inferred equivalent call
			v.pop()
		end
	end, { v.pop, vpcV2Launcher, vpcExcludedRequestTypes })

	local v9 = React.useCallback(function(_, p)
		local action = p.action

		if action == ActionTypeEnum.Phone then
			return {
				eventContext = "AmpUpsell",
				origin = AppScreens.AmpWizardContainer,
				onSuccess = function()
					setState(Cryo.Dictionary.join(state, {
						[ActionTypeEnum.Phone] = ActionStatusEnum.Success
					}))
				end,
				onFailure = function()
					handleCompletion(
						AccessResponseEnum.Denied,
						Cryo.Dictionary.join(state, {
							[ActionTypeEnum.Phone] = ActionStatusEnum.Failure
						})
					)
				end,
				onCancelled = function()
					handleCompletion(
						AccessResponseEnum.Denied,
						Cryo.Dictionary.join(state, {
							[ActionTypeEnum.Phone] = ActionStatusEnum.Cancelled
						})
					)
				end
			}
		end

		if GetFFlagEnableAmpEmailUpsellSupport() and action == ActionTypeEnum.AddedEmail then
			return {
				eventContext = "AmpUpsell",
				closeOnEmailUpdate = true,
				addEmailOver13TextKey = "Feature.VerificationUpsell.Description.IDVerificationAddEmailText",
				addEmailUnder13TextKey = "Feature.VerificationUpsell.Description.IDVerificationAddEmailText",
				addEmailTitleKey = "Feature.VerificationUpsell.Heading.AddEmail",
				successCallback = function(_)
					setState(Cryo.Dictionary.join(state, {
						[ActionTypeEnum.Email] = ActionStatusEnum.Success
					}))
				end,
				failureCallback = function()
					handleCompletion(
						AccessResponseEnum.Denied,
						Cryo.Dictionary.join(state, {
							[ActionTypeEnum.Phone] = ActionStatusEnum.Failure
						})
					)
				end,
				closeCentralOverlay = function() end
			}
		end

		if GetFFlagEnableAmpIDVUpsellSupport() and action == ActionTypeEnum.GovernmentId then
			return {
				featureName = featureName,
				entryPointEventCtx = entryPointEventCtx,
				metadata = metadata,
				onSuccess = function()
					if GetFFlagEnableAmpIDVUpsellPopOnCompletion() then
						v.pop()
					end

					setState(Cryo.Dictionary.join(state, {
						[ActionTypeEnum.GovernmentId] = ActionStatusEnum.Success
					}))
				end,
				onFailure = function()
					if GetFFlagEnableAmpIDVUpsellPopOnCompletion() then
						v.pop()
					end

					handleCompletion(
						AccessResponseEnum.Denied,
						Cryo.Dictionary.join(state, {
							[ActionTypeEnum.GovernmentId] = ActionStatusEnum.Failure
						})
					)
				end,
				onCancelled = function()
					if GetFFlagEnableAmpIDVUpsellPopOnCompletion() then
						v.pop()
					end

					handleCompletion(
						AccessResponseEnum.Denied,
						Cryo.Dictionary.join(state, {
							[ActionTypeEnum.GovernmentId] = ActionStatusEnum.Cancelled
						})
					)
				end
			}
		end

		if action == ActionTypeEnum.ParentConsent or action == ActionTypeEnum.ParentLink then
			return {
				recourseAction = p.action,
				parentConsentTypes = p.parentConsentTypes,
				recourseData = recourseData,
				entryPointEventCtx = entryPointEventCtx,
				isInExperienceEntry = isInExperienceEntry,
				onCancel = function()
					if GetFFlagEnableAmpWizardVPCNavigationFix() then
						v8(p)
					end

					handleCompletion(
						AccessResponseEnum.Denied,
						Cryo.Dictionary.join(state, { [action] = ActionStatusEnum.Cancelled })
					)
				end,
				onSuccess = function()
					if GetFFlagEnableAmpWizardVPCNavigationFix() then
						v8(p)
					end

					handleCompletion(
						AccessResponseEnum.Denied,
						Cryo.Dictionary.join(state, { [action] = ActionStatusEnum.Success })
					)
				end,
				onRetryAmp = function()
					v8(p)
					setState(Cryo.Dictionary.join(state, {
						[action] = ActionStatusEnum.RetryRequested
					}))
				end
			}
		end

		if action == ActionTypeEnum.AgeEstimation then
			return {
				featureName = featureName,
				entryPointEventCtx = entryPointEventCtx,
				metadata = metadata,
				skipFacialAgeEstimationWebLinkModal = props.skipFacialAgeEstimationWebLinkModal,
				onSuccess = function()
					logEventOnceIfEnabled("complete_flow_with_success")
					v.pop()
					handleCompletion(
						AccessResponseEnum.Granted,
						Cryo.Dictionary.join(state, {
							[ActionTypeEnum.AgeEstimation] = ActionStatusEnum.Success
						})
					)
				end,
				onFailure = function()
					logEventOnceIfEnabled("complete_flow_with_error")
					v.pop()
					handleCompletion(
						AccessResponseEnum.Denied,
						Cryo.Dictionary.join(state, {
							[ActionTypeEnum.AgeEstimation] = ActionStatusEnum.Failure
						})
					)
				end,
				onCancel = function()
					logEventOnceIfEnabled("complete_flow_with_cancel")
					v.pop()
					handleCompletion(
						AccessResponseEnum.Denied,
						Cryo.Dictionary.join(state, {
							[ActionTypeEnum.AgeEstimation] = ActionStatusEnum.Cancelled
						})
					)
				end,
				onRetry = function()
					v.pop()
					setState(Cryo.Dictionary.join(state, {
						[ActionTypeEnum.AgeEstimation] = ActionStatusEnum.RetryRequested
					}))
				end
			}
		end

		if not GetFFlagEnableAmpSubscriptionUpsell() or action ~= ActionTypeEnum.Subscription then
			return {}
		end

		local v9 = recourseData
		return {
			purchaseUIOptions = v9 and v9.purchaseUIOptions,
			surfaceName = v9 and v9.surfaceName,
			surfaceContext = v9 and v9.surfaceContext,
			analyticsContext = v9 and v9.analyticsContext,
			onSuccess = function()
				v.pop()
				handleCompletion(
					AccessResponseEnum.Granted,
					Cryo.Dictionary.join(state, {
						[ActionTypeEnum.Subscription] = ActionStatusEnum.Success
					})
				)
			end,
			onFailure = function()
				v.pop()
				handleCompletion(
					AccessResponseEnum.Denied,
					Cryo.Dictionary.join(state, {
						[ActionTypeEnum.Subscription] = ActionStatusEnum.Failure
					})
				)
			end,
			onCancel = function()
				v.pop()
				handleCompletion(
					AccessResponseEnum.Denied,
					Cryo.Dictionary.join(state, {
						[ActionTypeEnum.Subscription] = ActionStatusEnum.Cancelled
					})
				)
			end
		}
	end, { state, handleCompletion, v8 })

	local v10 = React.useCallback(function(data)
		local v10 = vpcExcludedRequestTypes
		local action = data.action
		local v11

		if vpcV2Launcher == nil or action ~= ActionTypeEnum.ParentConsent and action ~= ActionTypeEnum.ParentLink then
			v11 = false
		else
			local parentConsentTypes = data.parentConsentTypes
			local v12

			if parentConsentTypes then
				v12 = parentConsentTypes[1]
			end

			v11 = v12 == nil or v10 == nil or table.find(v10, v12) == nil
		end

		if v11 then
			return vpcV2Launcher
		end

		local action2 = data.action

		if action2 ~= ActionTypeEnum.UserSettings then
			return openUpsells[action2]
		end

		local userSettings = data.userSettings

		if userSettings and userSettings.settingName == UserSettingsSettingNameEnum.AllowFacialAgeEstimation then
			return nil
		end

		return openUpsells[action2]
	end, { openUpsells, vpcV2Launcher, vpcExcludedRequestTypes })

	local v11 = React.useCallback(function(_, list)
		if list == nil or #list == 0 then
			setState2(true)
			return
		end

		local item = list[1]
		local action = item.action

		local openUpsellFn = v10(item)

		if openUpsellFn == nil then
			if GetFFlagEnableAmpWizardInlineVPCForFAE() and action == ActionTypeEnum.UserSettings then
				local userSettings = item.userSettings

				if
					userSettings
					and userSettings.settingName == UserSettingsSettingNameEnum.AllowFacialAgeEstimation
				then
					setState4(item)
					return
				end
			end

			if action == ActionTypeEnum.Subscription then
				handleCompletion(AccessResponseEnum.Denied, state)
				return
			end

			local localizationStrings = accountSettingsUpsellStringsFn(item)

			if localizationStrings then
				v4({
					featureName = featureName,
					localizationStrings = localizationStrings,
					onCloseModal = function()
						v.pop()
						handleCompletion(
							AccessResponseEnum.Denied,
							Cryo.Dictionary.join(state, { [action] = ActionStatusEnum.Cancelled })
						)
					end
				})
			else
				handleCompletion(AccessResponseEnum.Error, state)
			end
		else
			local actionProps = v9(action, item)
			local v11 = action == ActionTypeEnum.ParentConsent or action == ActionTypeEnum.ParentLink

			if props.usePrologue and v11 and GetFFlagEnableAmpVPCPrologue() then
				local v12 = vpcExcludedRequestTypes
				local action2 = item.action
				local v13

				if
					vpcV2Launcher == nil
					or action2 ~= ActionTypeEnum.ParentConsent and action2 ~= ActionTypeEnum.ParentLink
				then
					v13 = false
				else
					local parentConsentTypes = item.parentConsentTypes
					local v14

					if parentConsentTypes then
						v14 = parentConsentTypes[1]
					end

					v13 = v14 == nil or v12 == nil or table.find(v12, v14) == nil
				end

				if not v13 then
					setState3({
						action = action,
						actionProps = actionProps,
						openUpsellFn = openUpsellFn
					})
					return
				end
			end

			openUpsellFn(actionProps)
		end
	end, {
		state,
		handleCompletion,
		featureName,
		v9,
		v.pop,
		v4,
		v10,
		props.usePrologue,
		vpcV2Launcher,
		vpcExcludedRequestTypes,
		setState4
	})

	local v12 = React.useCallback(function(p, p2)
		setState2(false)
		logEventOnceIfEnabled("amp_feature_access_init")
		local v12

		if GetFFlagEnableAmpUpsellGql() then
			v12 = v2.upsellFeatureAccessGql(v6, p, getSuccessfulActions(state), p2, extraParameters)
		else
			v12 = v2.upsellFeatureAccess(p, getSuccessfulActions(state), p2, extraParameters)
		end

		if v12.access == AccessResponseEnum.Error then
			setState2(true)
		elseif v12.access == AccessResponseEnum.Actionable then
			logEventOnceIfEnabled("amp_feature_access_actionable")
			v11(v12.recourse, v12.recourses)
		elseif v12.access == AccessResponseEnum.Granted then
			logEventOnceIfEnabled("amp_feature_access_granted")
			handleCompletion(AccessResponseEnum.Granted, state)
		else
			if v12.access ~= AccessResponseEnum.Denied then
				handleCompletion(AccessResponseEnum.Pending, state)

				return
			end

			logEventOnceIfEnabled("amp_feature_access_denied")
			handleCompletion(AccessResponseEnum.Denied, state)
		end
	end, { v2, extraParameters, handleCompletion })

	React.useEffect(function()
		sendModalActionEvent(v3, AppScreens.AmpWizardContainer, featureName, "Shown")
	end, { v3 })

	React.useEffect(function()
		v12(featureName, nameSpace)
	end, { state, featureName, v12, nameSpace })

	React.useEffect(function()
		if not GetFFlagEnableAmpWizardInlineVPCForFAE() or state4 == nil then
			return
		end

		local function faeRecourse(action) -- 2 equivalent calls inferred from this helper
			return {
				action = action,
				parentConsentTypes = { VPCRequestTypeEnum.UpdateUserSetting }
			}
		end

		local function buildFAEProps(p)
			local v13 = v9(p.action, p)

			local joined = Cryo.Dictionary.join(recourseData or {}, {
				allowFacialAgeEstimation = "Enabled"
			})
			return Cryo.Dictionary.join(v13, { recourseData = joined })
		end

		VPCApiProvider.getLinkedParentEmails(v5):andThen(function(p)
			local action2

			if (p.parentEmails and #p.parentEmails or 0) > 0 then
				action2 = ActionTypeEnum.ParentConsent
			else
				action2 = ActionTypeEnum.ParentLink
			end

			local v13 = faeRecourse(action2) -- inferred equivalent call
			local faeProps = buildFAEProps(v13)
			local openUpsellFn = v10(v13)

			if openUpsellFn == nil then
				setState2(true)
			elseif GetFFlagEnableAmpVPCPrologue() then
				local v14 = vpcExcludedRequestTypes
				local action = v13.action
				local v15

				if
					vpcV2Launcher == nil
					or action ~= ActionTypeEnum.ParentConsent and action ~= ActionTypeEnum.ParentLink
				then
					v15 = false
				else
					local parentConsentTypes = v13.parentConsentTypes
					local v16

					if parentConsentTypes then
						v16 = parentConsentTypes[1]
					end

					v15 = v16 == nil or v14 == nil or table.find(v14, v16) == nil
				end

				if v15 then
					openUpsellFn(faeProps)
				else
					setState3({
						action = action2,
						actionProps = faeProps,
						openUpsellFn = openUpsellFn
					})
				end
			else
				openUpsellFn(faeProps)
			end

			setState4(nil)
		end):catch(function(_)
			local v13 = faeRecourse(ActionTypeEnum.ParentLink) -- inferred equivalent call
			local faeProps = buildFAEProps(v13)
			local openUpsellFn = v10(v13)

			if openUpsellFn == nil then
				setState2(true)
			elseif GetFFlagEnableAmpVPCPrologue() then
				local v14 = vpcExcludedRequestTypes
				local action = v13.action
				local v15

				if
					vpcV2Launcher == nil
					or action ~= ActionTypeEnum.ParentConsent and action ~= ActionTypeEnum.ParentLink
				then
					v15 = false
				else
					local parentConsentTypes = v13.parentConsentTypes
					local v16

					if parentConsentTypes then
						v16 = parentConsentTypes[1]
					end

					v15 = v16 == nil or v14 == nil or table.find(v14, v16) == nil
				end

				if v15 then
					openUpsellFn(faeProps)
				else
					setState3({
						action = ActionTypeEnum.ParentLink,
						actionProps = faeProps,
						openUpsellFn = openUpsellFn
					})
				end
			else
				openUpsellFn(faeProps)
			end

			setState4(nil)
		end)
	end, { state4, v5, v9, openUpsells, recourseData, v10, vpcV2Launcher, vpcExcludedRequestTypes })

	if GetFFlagEnableAmpVPCPrologue() and state3 then
		return React.createElement(VPCPrologueController, {
			request = state3,
			recourseData = recourseData,
			handleCompletion = handleCompletion,
			actionsTaken = state,
			options = props.prologueOptions,
			onDone = function()
				setState3(nil)
			end
		})
	end

	if state2 then
		return React.createElement(ErrorScreen, {
			featureName = featureName,
			onRetry = function()
				setState2(false)

				if FFlagAmpWizardRetryKeepsNameSpace then
					v12(featureName, nameSpace)
				else
					v12(featureName)
				end
			end,
			onCancel = function()
				handleCompletion(AccessResponseEnum.Denied, state)
			end
		})
	end

	return React.createElement(Loading, {
		size = IconSize.Medium,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
end

return WizardContainer
