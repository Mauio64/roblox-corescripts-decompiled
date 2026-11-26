local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Navigation").useNavigation
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Enums")
local actionTypeEnum = Enums.ActionTypeEnum
local actionStatusEnum = Enums.ActionStatusEnum
local accessResponseEnum = Enums.AccessResponseEnum
local userSettingsSettingNameEnum = Enums.UserSettingsSettingNameEnum
require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Types")
local accountSettingsUpsellStringsFn = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/LocalizationStrings").accountSettingsUpsellStringsFn
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Cryo")
local AnalyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Analytics/AnalyticsService")
local sendModalActionEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Analytics/sendModalActionEvent")
local AmpApiProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/AmpApiProvider")
local AppScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/AppScreens")
local ErrorScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/ErrorScreen")
local useCompletionCallbackWithReturnPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/useCompletionCallbackWithReturnPage")
local useApolloClient = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/ApolloClient").useApolloClient
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/SharedFlags")
local fFlagAmpWizardEntryPointEventCtxFallback = SharedFlags.FFlagAmpWizardEntryPointEventCtxFallback
local fFlagEnableAmpWizardDeepLink = SharedFlags.FFlagEnableAmpWizardDeepLink
local GetFFlagEnableAmpUpsellGql = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableAmpUpsellGql")
local GetFFlagEnableAmpEmailUpsellSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableAmpEmailUpsellSupport")
local GetFFlagEnableAmpIDVUpsellSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableAmpIDVUpsellSupport")
local GetFFlagEnableAmpIDVUpsellPopOnCompletion = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableAmpIDVUpsellPopOnCompletion")
local GetFFlagEnableAmpSubscriptionUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableAmpSubscriptionUpsell")
local GetFFlagEnableAmpVPCPrologue = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableAmpVPCPrologue")
local GetFFlagEnableAmpWizardInlineVPCForFAE = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableAmpWizardInlineVPCForFAE")
local GetFFlagEnableAmpWizardVPCNavigationFix = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableAmpWizardVPCNavigationFix")
local FFlagAmpWizardRetryKeepsNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/FFlagAmpWizardRetryKeepsNameSpace")
local VPCPrologue = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Prologues/VPCPrologue")
local logEventOnceIfEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/LoggingUtils").logEventOnceIfEnabled
local VPCApiProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/VPCApiProvider")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactServiceTags").RoactNetworking
local vpcRequestTypeEnum = Enums.VPCRequestTypeEnum

local function VPCPrologueController(props)
	local options = props.options

	local v5 = React.useCallback(function()
		local actionProps = props.request.actionProps
		props.onDone()

		if options and options.onConfirm then
			options.onConfirm()
		end

		if props.request.openUpsellFn then
			props.request.openUpsellFn(actionProps)
		end
	end, { props.request, props.onDone, options })

	local v6 = React.useCallback(function()
		props.onDone()

		if options and options.onCancel then
			options.onCancel()
		end

		props.handleCompletion(
			accessResponseEnum.Denied,
			Cryo.Dictionary.join(props.actionsTaken, {
				[props.request.action] = actionStatusEnum.Cancelled
			})
		)
	end, {
		props.handleCompletion,
		props.actionsTaken,
		props.onDone,
		props.request,
		options
	})

	local createElement = React.createElement
	local v8 = {
		recourseData = props.recourseData,
		onConfirm = v5,
		onCancel = v6,
		config = 0
	}

	local v9 = if options then options.config else nil
	v8.config = v9
	return createElement(VPCPrologue, v8)
end

local function getSuccessfulActions(state)
	local successfulActions = {}

	for k, item in pairs(state) do
		if item == actionStatusEnum.Success then
			table.insert(successfulActions, k)
		end
	end

	return successfulActions
end

local function shouldUseVpcV2(p2, list, p3): boolean
	local action = p3.action

	if p2 == nil or action ~= actionTypeEnum.ParentConsent and action ~= actionTypeEnum.ParentLink then
		return false
	end

	local parentConsentTypes = p3.parentConsentTypes
	local v5 = if parentConsentTypes then parentConsentTypes[1] else nil

	if v5 == nil then
		return true
	end

	return list == nil or table.find(list, v5) == nil
end

local function WizardContainer(props)
	local v5 = useNavigation()
	local featureName = props.featureName
	local nameSpace = props.nameSpace
	local recourseData = props.recourseData
	local extraParameters = props.extraParameters

	local v6 = fFlagAmpWizardEntryPointEventCtxFallback
		and (props.entryPointEventCtx == nil or props.entryPointEventCtx == "")
		and "defaultLuaContext"
		or props.entryPointEventCtx
	local openUpsells = props.openUpsells
	local vpcV2Launcher = props.vpcV2Launcher
	local vpcExcludedRequestTypes = props.vpcExcludedRequestTypes
	local v7 = props.completionCallback
	local metadata = props.metadata
	local v8 = if props.ampApiProvider then props.ampApiProvider else AmpApiProvider
	local v9 = if props.analyticsService then props.analyticsService else AnalyticsService.EventStream
	local v10 = if props.openAccountSettingsUpsell then props.openAccountSettingsUpsell else v5.push
	local v11 = if props.isInExperienceEntry then props.isInExperienceEntry else false

	local v12 = useRoactService(roactNetworking)
	local state, setState = React.useState({})
	local state2, setState2 = React.useState(false)

	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState(nil)
	local v13 = useApolloClient()

	local v14 = useCompletionCallbackWithReturnPage(v5, v7, metadata)

	if fFlagEnableAmpWizardDeepLink then
		v7 = v14
	end

	local v15 = React.useCallback(function(p2)
		local v17 = vpcExcludedRequestTypes
		local action = p2.action
		local v18

		if
			vpcV2Launcher == nil
			or action ~= actionTypeEnum.ParentConsent and action ~= actionTypeEnum.ParentLink
		then
			v18 = false
		else
			local parentConsentTypes = p2.parentConsentTypes
			local v19 = if parentConsentTypes then parentConsentTypes[1] else nil
			v18 = v19 == nil or (v17 == nil or table.find(v17, v19) == nil)
		end

		if not v18 then
			v5.pop()
		end
	end, { v5.pop, vpcV2Launcher, vpcExcludedRequestTypes })

	local v16 = React.useCallback(function(p2, p3)
		local action = p3.action

		if action == actionTypeEnum.Phone then
			return {
				eventContext = "AmpUpsell",
				origin = AppScreens.AmpWizardContainer,
				onSuccess = function()
					setState(Cryo.Dictionary.join(state, {
						[actionTypeEnum.Phone] = actionStatusEnum.Success
					}))
				end,
				onFailure = function()
					v7(
						accessResponseEnum.Denied,
						Cryo.Dictionary.join(state, {
							[actionTypeEnum.Phone] = actionStatusEnum.Failure
						})
					)
				end,
				onCancelled = function()
					v7(
						accessResponseEnum.Denied,
						Cryo.Dictionary.join(state, {
							[actionTypeEnum.Phone] = actionStatusEnum.Cancelled
						})
					)
				end
			}
		end

		if GetFFlagEnableAmpEmailUpsellSupport() and action == actionTypeEnum.AddedEmail then
			return {
				eventContext = "AmpUpsell",
				closeOnEmailUpdate = true,
				addEmailOver13TextKey = "Feature.VerificationUpsell.Description.IDVerificationAddEmailText",
				addEmailUnder13TextKey = "Feature.VerificationUpsell.Description.IDVerificationAddEmailText",
				addEmailTitleKey = "Feature.VerificationUpsell.Heading.AddEmail",
				successCallback = function(p4)
					setState(Cryo.Dictionary.join(state, {
						[actionTypeEnum.Email] = actionStatusEnum.Success
					}))
				end,
				failureCallback = function()
					v7(
						accessResponseEnum.Denied,
						Cryo.Dictionary.join(state, {
							[actionTypeEnum.Phone] = actionStatusEnum.Failure
						})
					)
				end,
				closeCentralOverlay = function() end
			}
		end

		if GetFFlagEnableAmpIDVUpsellSupport() and action == actionTypeEnum.GovernmentId then
			return {
				featureName = featureName,
				entryPointEventCtx = v6,
				metadata = metadata,
				onSuccess = function()
					if GetFFlagEnableAmpIDVUpsellPopOnCompletion() then
						v5.pop()
					end

					setState(Cryo.Dictionary.join(state, {
						[actionTypeEnum.GovernmentId] = actionStatusEnum.Success
					}))
				end,
				onFailure = function()
					if GetFFlagEnableAmpIDVUpsellPopOnCompletion() then
						v5.pop()
					end

					v7(
						accessResponseEnum.Denied,
						Cryo.Dictionary.join(state, {
							[actionTypeEnum.GovernmentId] = actionStatusEnum.Failure
						})
					)
				end,
				onCancelled = function()
					if GetFFlagEnableAmpIDVUpsellPopOnCompletion() then
						v5.pop()
					end

					v7(
						accessResponseEnum.Denied,
						Cryo.Dictionary.join(state, {
							[actionTypeEnum.GovernmentId] = actionStatusEnum.Cancelled
						})
					)
				end
			}
		end

		if action == actionTypeEnum.ParentConsent or action == actionTypeEnum.ParentLink then
			return {
				recourseAction = p3.action,
				parentConsentTypes = p3.parentConsentTypes,
				recourseData = recourseData,
				entryPointEventCtx = v6,
				isInExperienceEntry = v11,
				onCancel = function()
					if GetFFlagEnableAmpWizardVPCNavigationFix() then
						v15(p3)
					end

					v7(
						accessResponseEnum.Denied,
						Cryo.Dictionary.join(state, {
							[action] = actionStatusEnum.Cancelled
						})
					)
				end,
				onSuccess = function()
					if GetFFlagEnableAmpWizardVPCNavigationFix() then
						v15(p3)
					end

					v7(
						accessResponseEnum.Denied,
						Cryo.Dictionary.join(state, {
							[action] = actionStatusEnum.Success
						})
					)
				end,
				onRetryAmp = function()
					v15(p3)
					setState(Cryo.Dictionary.join(state, {
						[action] = actionStatusEnum.RetryRequested
					}))
				end
			}
		end

		if action == actionTypeEnum.AgeEstimation then
			return {
				featureName = featureName,
				entryPointEventCtx = v6,
				metadata = metadata,
				skipFacialAgeEstimationWebLinkModal = props.skipFacialAgeEstimationWebLinkModal,
				onSuccess = function()
					logEventOnceIfEnabled("complete_flow_with_success")
					v5.pop()
					v7(
						accessResponseEnum.Granted,
						Cryo.Dictionary.join(state, {
							[actionTypeEnum.AgeEstimation] = actionStatusEnum.Success
						})
					)
				end,
				onFailure = function()
					logEventOnceIfEnabled("complete_flow_with_error")
					v5.pop()
					v7(
						accessResponseEnum.Denied,
						Cryo.Dictionary.join(state, {
							[actionTypeEnum.AgeEstimation] = actionStatusEnum.Failure
						})
					)
				end,
				onCancel = function()
					logEventOnceIfEnabled("complete_flow_with_cancel")
					v5.pop()
					v7(
						accessResponseEnum.Denied,
						Cryo.Dictionary.join(state, {
							[actionTypeEnum.AgeEstimation] = actionStatusEnum.Cancelled
						})
					)
				end,
				onRetry = function()
					v5.pop()
					setState(Cryo.Dictionary.join(state, {
						[actionTypeEnum.AgeEstimation] = actionStatusEnum.RetryRequested
					}))
				end
			}
		end

		if not GetFFlagEnableAmpSubscriptionUpsell() or action ~= actionTypeEnum.Subscription then
			return {}
		end

		local v17 = recourseData
		return {
			purchaseUIOptions = v17 and v17.purchaseUIOptions,
			surfaceName = v17 and v17.surfaceName,
			surfaceContext = v17 and v17.surfaceContext,
			analyticsContext = v17 and v17.analyticsContext,
			onSuccess = function()
				v5.pop()
				v7(
					accessResponseEnum.Granted,
					Cryo.Dictionary.join(state, {
						[actionTypeEnum.Subscription] = actionStatusEnum.Success
					})
				)
			end,
			onFailure = function()
				v5.pop()
				v7(
					accessResponseEnum.Denied,
					Cryo.Dictionary.join(state, {
						[actionTypeEnum.Subscription] = actionStatusEnum.Failure
					})
				)
			end,
			onCancel = function()
				v5.pop()
				v7(
					accessResponseEnum.Denied,
					Cryo.Dictionary.join(state, {
						[actionTypeEnum.Subscription] = actionStatusEnum.Cancelled
					})
				)
			end
		}
	end, { state, v7, v15 })

	local v17 = React.useCallback(function(data)
		local v19 = vpcExcludedRequestTypes
		local action = data.action
		local v20

		if
			vpcV2Launcher == nil
			or action ~= actionTypeEnum.ParentConsent and action ~= actionTypeEnum.ParentLink
		then
			v20 = false
		else
			local parentConsentTypes = data.parentConsentTypes
			local v21 = if parentConsentTypes then parentConsentTypes[1] else nil
			v20 = v21 == nil or v19 == nil or table.find(v19, v21) == nil
		end

		if v20 then
			return vpcV2Launcher
		end

		local action2 = data.action

		if action2 ~= actionTypeEnum.UserSettings then
			return openUpsells[action2]
		end

		local userSettings = data.userSettings

		if
			userSettings
			and userSettings.settingName == userSettingsSettingNameEnum.AllowFacialAgeEstimation
		then
			return nil
		end

		return openUpsells[action2]
	end, { openUpsells, vpcV2Launcher, vpcExcludedRequestTypes })

	local v18 = React.useCallback(function(p2, list)
		if list == nil or #list == 0 then
			setState2(true)
			return
		end

		local item = list[1]
		local action = item.action

		local v19 = v17(item)

		if v19 == nil then
			if GetFFlagEnableAmpWizardInlineVPCForFAE() and action == actionTypeEnum.UserSettings then
				local userSettings = item.userSettings

				if
					userSettings
					and userSettings.settingName == userSettingsSettingNameEnum.AllowFacialAgeEstimation
				then
					setState4(item)
					return
				end
			end

			if action == actionTypeEnum.Subscription then
				v7(accessResponseEnum.Denied, state)
				return
			end

			local v20 = accountSettingsUpsellStringsFn(item)

			if v20 then
				v10({
					featureName = featureName,
					localizationStrings = v20,
					onCloseModal = function()
						v5.pop()
						v7(
							accessResponseEnum.Denied,
							Cryo.Dictionary.join(state, {
								[action] = actionStatusEnum.Cancelled
							})
						)
					end
				})
			else
				v7(accessResponseEnum.Error, state)
			end
		else
			local v20 = v16(action, item)
			local v21 = action == actionTypeEnum.ParentConsent or action == actionTypeEnum.ParentLink

			if props.usePrologue and v21 and GetFFlagEnableAmpVPCPrologue() then
				local v23 = vpcExcludedRequestTypes
				local action2 = item.action
				local v24

				if
					vpcV2Launcher == nil
					or action2 ~= actionTypeEnum.ParentConsent and action2 ~= actionTypeEnum.ParentLink
				then
					v24 = false
				else
					local parentConsentTypes = item.parentConsentTypes
					local v25 = if parentConsentTypes then parentConsentTypes[1] else nil
					v24 = v25 == nil or v23 == nil or table.find(v23, v25) == nil
				end

				if not v24 then
					setState3({ action = action, actionProps = v20, openUpsellFn = v19 })
					return
				end
			end

			v19(v20)
		end
	end, {
		state,
		v7,
		featureName,
		v16,
		v5.pop,
		v10,
		v17,
		props.usePrologue,
		vpcV2Launcher,
		vpcExcludedRequestTypes,
		setState4
	})

	local v19 = React.useCallback(function(p2, p3)
		setState2(false)
		logEventOnceIfEnabled("amp_feature_access_init")
		local v20

		if GetFFlagEnableAmpUpsellGql() then
			v20 = v8.upsellFeatureAccessGql(v13, p2, getSuccessfulActions(state), p3, extraParameters)
		else
			v20 = v8.upsellFeatureAccess(p2, getSuccessfulActions(state), p3, extraParameters)
		end

		if v20.access == accessResponseEnum.Error then
			setState2(true)
		elseif v20.access == accessResponseEnum.Actionable then
			logEventOnceIfEnabled("amp_feature_access_actionable")
			v18(v20.recourse, v20.recourses)
		elseif v20.access == accessResponseEnum.Granted then
			logEventOnceIfEnabled("amp_feature_access_granted")
			v7(accessResponseEnum.Granted, state)
		else
			if v20.access ~= accessResponseEnum.Denied then
				v7(accessResponseEnum.Pending, state)

				return
			end

			logEventOnceIfEnabled("amp_feature_access_denied")
			v7(accessResponseEnum.Denied, state)
		end
	end, { v8, extraParameters, v7 })

	React.useEffect(function()
		sendModalActionEvent(v9, AppScreens.AmpWizardContainer, featureName, "Shown")
	end, { v9 })

	React.useEffect(function()
		v19(featureName, nameSpace)
	end, { state, featureName, v19, nameSpace })

	React.useEffect(function()
		if not GetFFlagEnableAmpWizardInlineVPCForFAE() or state4 == nil then
			return
		end

		local function faeRecourse(p2)
			return {
				action = p2,
				parentConsentTypes = { vpcRequestTypeEnum.UpdateUserSetting }
			}
		end

		local function buildFAEProps(p2)
			local v20 = v16(p2.action, p2)

			local joined = Cryo.Dictionary.join(recourseData or {}, {
				allowFacialAgeEstimation = "Enabled"
			})
			return Cryo.Dictionary.join(v20, { recourseData = joined })
		end

		VPCApiProvider.getLinkedParentEmails(v12):andThen(function(p2)
			local v20

			if (p2.parentEmails and #p2.parentEmails or 0) > 0 then
				v20 = actionTypeEnum.ParentConsent
			else
				v20 = actionTypeEnum.ParentLink
			end

			local v21 = {
				action = v20,
				parentConsentTypes = { vpcRequestTypeEnum.UpdateUserSetting }
			}

			local faeProps = buildFAEProps(v21)
			local v22 = v17(v21)

			if v22 == nil then
				setState2(true)
			elseif GetFFlagEnableAmpVPCPrologue() then
				local v24 = vpcExcludedRequestTypes
				local action = v21.action
				local v25

				if
					vpcV2Launcher == nil
					or action ~= actionTypeEnum.ParentConsent and action ~= actionTypeEnum.ParentLink
				then
					v25 = false
				else
					local parentConsentTypes = v21.parentConsentTypes
					local v26 = if parentConsentTypes then parentConsentTypes[1] else nil
					v25 = v26 == nil or v24 == nil or table.find(v24, v26) == nil
				end

				if v25 then
					v22(faeProps)
				else
					setState3({
						action = v20,
						actionProps = faeProps,
						openUpsellFn = v22
					})
				end
			else
				v22(faeProps)
			end

			setState4(nil)
		end):catch(function(p2)
			local v20 = {
				action = actionTypeEnum.ParentLink,
				parentConsentTypes = { vpcRequestTypeEnum.UpdateUserSetting }
			}
			local faeProps = buildFAEProps(v20)
			local v21 = v17(v20)

			if v21 == nil then
				setState2(true)
			elseif GetFFlagEnableAmpVPCPrologue() then
				local v23 = vpcExcludedRequestTypes
				local action = v20.action
				local v24

				if
					vpcV2Launcher == nil
					or action ~= actionTypeEnum.ParentConsent and action ~= actionTypeEnum.ParentLink
				then
					v24 = false
				else
					local parentConsentTypes = v20.parentConsentTypes
					local v25 = if parentConsentTypes then parentConsentTypes[1] else nil
					v24 = v25 == nil or v23 == nil or table.find(v23, v25) == nil
				end

				if v24 then
					v21(faeProps)
				else
					setState3({
						action = actionTypeEnum.ParentLink,
						actionProps = faeProps,
						openUpsellFn = v21
					})
				end
			else
				v21(faeProps)
			end

			setState4(nil)
		end)
	end, {
		state4,
		v12,
		v16,
		openUpsells,
		recourseData,
		v17,
		vpcV2Launcher,
		vpcExcludedRequestTypes
	})

	if GetFFlagEnableAmpVPCPrologue() and state3 then
		return React.createElement(VPCPrologueController, {
			request = state3,
			recourseData = recourseData,
			handleCompletion = v7,
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
					v19(featureName, nameSpace)
				else
					v19(featureName)
				end
			end,
			onCancel = function()
				v7(accessResponseEnum.Denied, state)
			end
		})
	end

	return React.createElement(loading, {
		size = iconSize.Medium,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
end

return WizardContainer
