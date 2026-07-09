local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local React = require(AmpUpsellParent.React)
local useNavigation = require(AmpUpsellParent.Navigation).useNavigation
local Enums = require(AmpUpsell.Common.Enums)
local ActionTypeEnum = Enums.ActionTypeEnum
local ActionStatusEnum = Enums.ActionStatusEnum
local AccessResponseEnum = Enums.AccessResponseEnum
local UserSettingsSettingNameEnum = Enums.UserSettingsSettingNameEnum

require(AmpUpsell.Common.Types)

local accountSettingsUpsellStringsFn = require(AmpUpsell.Common.LocalizationStrings).accountSettingsUpsellStringsFn
local Foundation = require(AmpUpsellParent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local Cryo = require(AmpUpsellParent.Cryo)
local AnalyticsService = require(AmpUpsell.Analytics.AnalyticsService)
local sendModalActionEvent = require(AmpUpsell.Analytics.sendModalActionEvent)
local AmpApiProvider = require(AmpUpsell.Common.AmpApiProvider)
local AppScreens = require(AmpUpsell.Common.AppScreens)
local ErrorScreen = require(AmpUpsell.Components.ErrorScreen)
local useCompletionCallbackWithReturnPage = require(AmpUpsell.Common.useCompletionCallbackWithReturnPage)
local useApolloClient = require(AmpUpsellParent.ApolloClient).useApolloClient
local FFlagEnableAmpWizardDeepLink = require(AmpUpsellParent.SharedFlags).FFlagEnableAmpWizardDeepLink
local GetFFlagEnableAmpUpsellGql = require(AmpUpsell.Flags.GetFFlagEnableAmpUpsellGql)
local GetFFlagEnableAmpEmailUpsellSupport = require(AmpUpsell.Flags.GetFFlagEnableAmpEmailUpsellSupport)
local GetFFlagEnableAmpIDVUpsellSupport = require(AmpUpsell.Flags.GetFFlagEnableAmpIDVUpsellSupport)
local GetFFlagEnableAmpIDVUpsellPopOnCompletion = require(AmpUpsell.Flags.GetFFlagEnableAmpIDVUpsellPopOnCompletion)
local GetFFlagEnableAmpSubscriptionUpsell = require(AmpUpsell.Flags.GetFFlagEnableAmpSubscriptionUpsell)
local GetFFlagEnableAmpVPCPrologue = require(AmpUpsell.Flags.GetFFlagEnableAmpVPCPrologue)
local GetFFlagEnableAmpWizardInlineVPCForFAE = require(AmpUpsell.Flags.GetFFlagEnableAmpWizardInlineVPCForFAE)
local GetFFlagEnableAmpWizardVPCNavigationFix = require(AmpUpsell.Flags.GetFFlagEnableAmpWizardVPCNavigationFix)
local VPCPrologue = require(AmpUpsell.Components.Prologues.VPCPrologue)
local logEventOnceIfEnabled = require(AmpUpsell.Common.LoggingUtils).logEventOnceIfEnabled
local VPCApiProvider = require(AmpUpsell.Common.VPCApiProvider)
local useRoactService = require(AmpUpsellParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(AmpUpsellParent.RoactServiceTags).RoactNetworking
local VPCRequestTypeEnum = Enums.VPCRequestTypeEnum

local function VPCPrologueController(t1: {[any]: any}) -- line: 83
	-- upvalues: React (copy), AccessResponseEnum (copy), Cryo (copy), ActionStatusEnum (copy), VPCPrologue (copy)
	local v41 = React.useCallback(function() -- line: 84
		-- upvalues: t1 (copy)
		local actionProps = t1.request.actionProps

		t1.onDone()

		if t1.request.openUpsellFn then
			t1.request.openUpsellFn(actionProps)
		end
	end, {
		t1.request,
		t1.onDone
	})
	local v42 = React.useCallback(function() -- line: 92
		-- upvalues: t1 (copy), AccessResponseEnum (copy), Cryo (copy), ActionStatusEnum (copy)
		t1.onDone()
		t1.handleCompletion(AccessResponseEnum.Denied, Cryo.Dictionary.join(t1.actionsTaken, {
			[t1.request.action] = ActionStatusEnum.Cancelled
		}))
	end, {
		t1.handleCompletion,
		t1.actionsTaken,
		t1.onDone,
		t1.request
	})

	return React.createElement(VPCPrologue, {
		recourseData = t1.recourseData,
		onConfirm = v41,
		onCancel = v42
	})
end
local function getSuccessfulActions(t2: {[any]: any}) -- line: 107
	-- upvalues: ActionStatusEnum (copy)
	local t3 = {}

	for k, v in pairs(t2) do
		if v == ActionStatusEnum.Success then
			table.insert(t3, k)
		end
	end

	return t3
end
local function WizardContainer(t4: {[any]: any}) -- line: 117
	-- upvalues: useNavigation (copy), AmpApiProvider (copy), AnalyticsService (copy), useRoactService (copy), RoactNetworking (copy), React (copy), useApolloClient (copy), useCompletionCallbackWithReturnPage (copy), FFlagEnableAmpWizardDeepLink (copy), ActionTypeEnum (copy), AppScreens (copy), Cryo (copy), ActionStatusEnum (copy), AccessResponseEnum (copy), GetFFlagEnableAmpEmailUpsellSupport (copy), GetFFlagEnableAmpIDVUpsellSupport (copy), GetFFlagEnableAmpIDVUpsellPopOnCompletion (copy), GetFFlagEnableAmpWizardVPCNavigationFix (copy), logEventOnceIfEnabled (copy), GetFFlagEnableAmpSubscriptionUpsell (copy), UserSettingsSettingNameEnum (copy), GetFFlagEnableAmpVPCPrologue (copy), GetFFlagEnableAmpWizardInlineVPCForFAE (copy), accountSettingsUpsellStringsFn (copy), GetFFlagEnableAmpUpsellGql (copy), getSuccessfulActions (copy), sendModalActionEvent (copy), VPCRequestTypeEnum (copy), VPCApiProvider (copy), VPCPrologueController (copy), ErrorScreen (copy), Loading (copy), IconSize (copy)
	local v48 = useNavigation()
	local featureName = t4.featureName
	local nameSpace = t4.nameSpace
	local recourseData = t4.recourseData
	local extraParameters = t4.extraParameters
	local entryPointEventCtx = t4.entryPointEventCtx
	local openUpsells = t4.openUpsells
	local completionCallback = t4.completionCallback
	local metadata = t4.metadata
	local v57 = if not t4.ampApiProvider then AmpApiProvider else t4.ampApiProvider
	local v58 = if not t4.analyticsService then AnalyticsService.EventStream else t4.analyticsService
	local v59 = if not t4.openAccountSettingsUpsell then v48.push else t4.openAccountSettingsUpsell
	local v60 = not not t4.isInExperienceEntry and t4.isInExperienceEntry
	local v61 = useRoactService(RoactNetworking)
	local v62, v63 = React.useState({})
	local v64, v65 = React.useState(false)
	local v66, v67 = React.useState(nil)
	local v68, v69 = React.useState(nil)
	local v70 = useApolloClient()
	local v71 = useCompletionCallbackWithReturnPage(v48, completionCallback, metadata)
	local v72 = if not FFlagEnableAmpWizardDeepLink then completionCallback else v71
	local v73 = React.useCallback(function(_, p2) -- line: 149
		-- upvalues: ActionTypeEnum (copy), AppScreens (copy), v63 (copy), Cryo (copy), v62 (copy), ActionStatusEnum (copy), v72 (copy), AccessResponseEnum (copy), GetFFlagEnableAmpEmailUpsellSupport (copy), GetFFlagEnableAmpIDVUpsellSupport (copy), featureName (copy), GetFFlagEnableAmpIDVUpsellPopOnCompletion (copy), v48 (copy), recourseData (copy), entryPointEventCtx (copy), v60 (copy), GetFFlagEnableAmpWizardVPCNavigationFix (copy), metadata (copy), t4 (copy), logEventOnceIfEnabled (copy), GetFFlagEnableAmpSubscriptionUpsell (copy)
		local action = p2.action

		if action == ActionTypeEnum.Phone then
			return {
				eventContext = "AmpUpsell",
				origin = AppScreens.AmpWizardContainer,
				onSuccess = function() -- line: 155
					-- upvalues: v63 (copy), Cryo (copy), v62 (copy), ActionTypeEnum (copy), ActionStatusEnum (copy)
					v63(Cryo.Dictionary.join(v62, {
						[ActionTypeEnum.Phone] = ActionStatusEnum.Success
					}))
				end,
				onFailure = function() -- line: 160
					-- upvalues: v72 (copy), AccessResponseEnum (copy), Cryo (copy), v62 (copy), ActionTypeEnum (copy), ActionStatusEnum (copy)
					v72(AccessResponseEnum.Denied, Cryo.Dictionary.join(v62, {
						[ActionTypeEnum.Phone] = ActionStatusEnum.Failure
					}))
				end,
				onCancelled = function() -- line: 166
					-- upvalues: v72 (copy), AccessResponseEnum (copy), Cryo (copy), v62 (copy), ActionTypeEnum (copy), ActionStatusEnum (copy)
					v72(AccessResponseEnum.Denied, Cryo.Dictionary.join(v62, {
						[ActionTypeEnum.Phone] = ActionStatusEnum.Cancelled
					}))
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
				successCallback = function(_) -- line: 180
					-- upvalues: v63 (copy), Cryo (copy), v62 (copy), ActionTypeEnum (copy), ActionStatusEnum (copy)
					v63(Cryo.Dictionary.join(v62, {
						[ActionTypeEnum.Email] = ActionStatusEnum.Success
					}))
				end,
				failureCallback = function() -- line: 185
					-- upvalues: v72 (copy), AccessResponseEnum (copy), Cryo (copy), v62 (copy), ActionTypeEnum (copy), ActionStatusEnum (copy)
					v72(AccessResponseEnum.Denied, Cryo.Dictionary.join(v62, {
						[ActionTypeEnum.Phone] = ActionStatusEnum.Failure
					}))
				end,
				closeCentralOverlay = function() -- line: 191
				end
			}
		end

		if GetFFlagEnableAmpIDVUpsellSupport() and action == ActionTypeEnum.GovernmentId then
			return {
				featureName = featureName,
				onSuccess = function() -- line: 196
					-- upvalues: GetFFlagEnableAmpIDVUpsellPopOnCompletion (copy), v48 (copy), v63 (copy), Cryo (copy), v62 (copy), ActionTypeEnum (copy), ActionStatusEnum (copy)
					if GetFFlagEnableAmpIDVUpsellPopOnCompletion() then
						v48.pop()
					end

					v63(Cryo.Dictionary.join(v62, {
						[ActionTypeEnum.GovernmentId] = ActionStatusEnum.Success
					}))
				end,
				onFailure = function() -- line: 207
					-- upvalues: GetFFlagEnableAmpIDVUpsellPopOnCompletion (copy), v48 (copy), v72 (copy), AccessResponseEnum (copy), Cryo (copy), v62 (copy), ActionTypeEnum (copy), ActionStatusEnum (copy)
					if GetFFlagEnableAmpIDVUpsellPopOnCompletion() then
						v48.pop()
					end

					v72(AccessResponseEnum.Denied, Cryo.Dictionary.join(v62, {
						[ActionTypeEnum.GovernmentId] = ActionStatusEnum.Failure
					}))
				end,
				onCancelled = function() -- line: 219
					-- upvalues: GetFFlagEnableAmpIDVUpsellPopOnCompletion (copy), v48 (copy), v72 (copy), AccessResponseEnum (copy), Cryo (copy), v62 (copy), ActionTypeEnum (copy), ActionStatusEnum (copy)
					if GetFFlagEnableAmpIDVUpsellPopOnCompletion() then
						v48.pop()
					end

					v72(AccessResponseEnum.Denied, Cryo.Dictionary.join(v62, {
						[ActionTypeEnum.GovernmentId] = ActionStatusEnum.Cancelled
					}))
				end
			}
		end

		if action == ActionTypeEnum.ParentConsent or action == ActionTypeEnum.ParentLink then
			return {
				recourseAction = p2.action,
				parentConsentTypes = p2.parentConsentTypes,
				recourseData = recourseData,
				entryPointEventCtx = entryPointEventCtx,
				isInExperienceEntry = v60,
				onCancel = function() -- line: 240
					-- upvalues: GetFFlagEnableAmpWizardVPCNavigationFix (copy), v48 (copy), v72 (copy), AccessResponseEnum (copy), Cryo (copy), v62 (copy), action (copy), ActionStatusEnum (copy)
					if GetFFlagEnableAmpWizardVPCNavigationFix() then
						v48.pop()
					end

					v72(AccessResponseEnum.Denied, Cryo.Dictionary.join(v62, {
						[action] = ActionStatusEnum.Cancelled
					}))
				end,
				onSuccess = function() -- line: 249
					-- upvalues: GetFFlagEnableAmpWizardVPCNavigationFix (copy), v48 (copy), v72 (copy), AccessResponseEnum (copy), Cryo (copy), v62 (copy), action (copy), ActionStatusEnum (copy)
					if GetFFlagEnableAmpWizardVPCNavigationFix() then
						v48.pop()
					end

					v72(AccessResponseEnum.Denied, Cryo.Dictionary.join(v62, {
						[action] = ActionStatusEnum.Success
					}))
				end,
				onRetryAmp = function() -- line: 258
					-- upvalues: v48 (copy), v63 (copy), Cryo (copy), v62 (copy), action (copy), ActionStatusEnum (copy)
					v48.pop()
					v63(Cryo.Dictionary.join(v62, {
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
				skipFacialAgeEstimationWebLinkModal = t4.skipFacialAgeEstimationWebLinkModal,
				onSuccess = function() -- line: 271
					-- upvalues: logEventOnceIfEnabled (copy), v48 (copy), v72 (copy), AccessResponseEnum (copy), Cryo (copy), v62 (copy), ActionTypeEnum (copy), ActionStatusEnum (copy)
					logEventOnceIfEnabled("complete_flow_with_success")
					v48.pop()
					v72(AccessResponseEnum.Granted, Cryo.Dictionary.join(v62, {
						[ActionTypeEnum.AgeEstimation] = ActionStatusEnum.Success
					}))
				end,
				onFailure = function() -- line: 282
					-- upvalues: logEventOnceIfEnabled (copy), v48 (copy), v72 (copy), AccessResponseEnum (copy), Cryo (copy), v62 (copy), ActionTypeEnum (copy), ActionStatusEnum (copy)
					logEventOnceIfEnabled("complete_flow_with_error")
					v48.pop()
					v72(AccessResponseEnum.Denied, Cryo.Dictionary.join(v62, {
						[ActionTypeEnum.AgeEstimation] = ActionStatusEnum.Failure
					}))
				end,
				onCancel = function() -- line: 293
					-- upvalues: logEventOnceIfEnabled (copy), v48 (copy), v72 (copy), AccessResponseEnum (copy), Cryo (copy), v62 (copy), ActionTypeEnum (copy), ActionStatusEnum (copy)
					logEventOnceIfEnabled("complete_flow_with_cancel")
					v48.pop()
					v72(AccessResponseEnum.Denied, Cryo.Dictionary.join(v62, {
						[ActionTypeEnum.AgeEstimation] = ActionStatusEnum.Cancelled
					}))
				end,
				onRetry = function() -- line: 304
					-- upvalues: v48 (copy), v63 (copy), Cryo (copy), v62 (copy), ActionTypeEnum (copy), ActionStatusEnum (copy)
					v48.pop()
					v63(Cryo.Dictionary.join(v62, {
						[ActionTypeEnum.AgeEstimation] = ActionStatusEnum.RetryRequested
					}))
				end
			}
		end

		if GetFFlagEnableAmpSubscriptionUpsell() and action == ActionTypeEnum.Subscription then
			local v81 = recourseData

			return {
				purchaseUIOptions = v81 and v81.purchaseUIOptions,
				surfaceName = v81 and v81.surfaceName,
				surfaceContext = v81 and v81.surfaceContext,
				analyticsContext = v81 and v81.analyticsContext,
				onSuccess = function() -- line: 321
					-- upvalues: v48 (copy), v72 (copy), AccessResponseEnum (copy), Cryo (copy), v62 (copy), ActionTypeEnum (copy), ActionStatusEnum (copy)
					v48.pop()
					v72(AccessResponseEnum.Granted, Cryo.Dictionary.join(v62, {
						[ActionTypeEnum.Subscription] = ActionStatusEnum.Success
					}))
				end,
				onFailure = function() -- line: 331
					-- upvalues: v48 (copy), v72 (copy), AccessResponseEnum (copy), Cryo (copy), v62 (copy), ActionTypeEnum (copy), ActionStatusEnum (copy)
					v48.pop()
					v72(AccessResponseEnum.Denied, Cryo.Dictionary.join(v62, {
						[ActionTypeEnum.Subscription] = ActionStatusEnum.Failure
					}))
				end,
				onCancel = function() -- line: 341
					-- upvalues: v48 (copy), v72 (copy), AccessResponseEnum (copy), Cryo (copy), v62 (copy), ActionTypeEnum (copy), ActionStatusEnum (copy)
					v48.pop()
					v72(AccessResponseEnum.Denied, Cryo.Dictionary.join(v62, {
						[ActionTypeEnum.Subscription] = ActionStatusEnum.Cancelled
					}))
				end
			}
		end

		return {}
	end, {
		v62,
		v72
	})
	local v74 = React.useCallback(function(p4) -- line: 362
		-- upvalues: ActionTypeEnum (copy), UserSettingsSettingNameEnum (copy), openUpsells (copy)
		local action = p4.action

		if action == ActionTypeEnum.UserSettings then
			local userSettings = p4.userSettings

			if userSettings and userSettings.settingName == UserSettingsSettingNameEnum.AllowFacialAgeEstimation then
				return nil
			end
		end

		return openUpsells[action]
	end, { openUpsells })
	local v75 = React.useCallback(function(_, t5: {[any]: any}?) -- line: 376
		-- upvalues: v65 (copy), v74 (copy), v73 (copy), ActionTypeEnum (copy), t4 (copy), GetFFlagEnableAmpVPCPrologue (copy), v67 (copy), GetFFlagEnableAmpWizardInlineVPCForFAE (copy), UserSettingsSettingNameEnum (copy), v69 (copy), v72 (copy), AccessResponseEnum (copy), v62 (copy), accountSettingsUpsellStringsFn (copy), v59 (copy), featureName (copy), v48 (copy), Cryo (copy), ActionStatusEnum (copy)
		if t5 == nil or #t5 == 0 then
			v65(true)

			return
		end

		local v87 = t5[1]
		local action = v87.action
		local v89 = v74(v87)

		if v89 ~= nil then
			local v90 = v73(action, v87)
			local v91 = action == ActionTypeEnum.ParentConsent or action == ActionTypeEnum.ParentLink

			if t4.usePrologue and v91 and GetFFlagEnableAmpVPCPrologue() then
				v67({
					action = action,
					actionProps = v90,
					openUpsellFn = v89
				})

				return
			end

			v89(v90)

			return
		end

		if GetFFlagEnableAmpWizardInlineVPCForFAE() and action == ActionTypeEnum.UserSettings then
			local userSettings = v87.userSettings

			if userSettings and userSettings.settingName == UserSettingsSettingNameEnum.AllowFacialAgeEstimation then
				v69(v87)

				return
			end
		end

		if action == ActionTypeEnum.Subscription then
			v72(AccessResponseEnum.Denied, v62)

			return
		end

		local v93 = accountSettingsUpsellStringsFn(v87)

		if not v93 then
			v72(AccessResponseEnum.Error, v62)

			return
		end

		v59({
			featureName = featureName,
			localizationStrings = v93,
			onCloseModal = function() -- line: 420
				-- upvalues: v48 (copy), v72 (copy), AccessResponseEnum (copy), Cryo (copy), v62 (copy), action (copy), ActionStatusEnum (copy)
				v48.pop()
				v72(AccessResponseEnum.Denied, Cryo.Dictionary.join(v62, {
					[action] = ActionStatusEnum.Cancelled
				}))
			end
		})
	end, {
		v62,
		v72,
		featureName,
		v73,
		v48.pop,
		v59,
		v74,
		t4.usePrologue,
		v69
	})
	local v76 = React.useCallback(function(p6, p7) -- line: 440
		-- upvalues: v65 (copy), logEventOnceIfEnabled (copy), GetFFlagEnableAmpUpsellGql (copy), v57 (copy), v70 (copy), getSuccessfulActions (copy), v62 (copy), extraParameters (copy), AccessResponseEnum (copy), v75 (copy), v72 (copy)
		v65(false)
		logEventOnceIfEnabled("amp_feature_access_init")

		local v96 = if not GetFFlagEnableAmpUpsellGql() then v57.upsellFeatureAccess(p6, getSuccessfulActions(v62), p7, extraParameters) else v57.upsellFeatureAccessGql(v70, p6, getSuccessfulActions(v62), p7, extraParameters)

		if v96.access == AccessResponseEnum.Error then
			v65(true)

			return
		end

		if v96.access == AccessResponseEnum.Actionable then
			logEventOnceIfEnabled("amp_feature_access_actionable")
			v75(v96.recourse, v96.recourses)

			return
		end

		if v96.access == AccessResponseEnum.Granted then
			logEventOnceIfEnabled("amp_feature_access_granted")
			v72(AccessResponseEnum.Granted, v62)

			return
		end

		if v96.access == AccessResponseEnum.Denied then
			logEventOnceIfEnabled("amp_feature_access_denied")
			v72(AccessResponseEnum.Denied, v62)

			return
		end

		v72(AccessResponseEnum.Pending, v62)
	end, {
		v57,
		extraParameters,
		v72
	})

	React.useEffect(function() -- line: 473
		-- upvalues: sendModalActionEvent (copy), v58 (copy), AppScreens (copy), featureName (copy)
		sendModalActionEvent(v58, AppScreens.AmpWizardContainer, featureName, "Shown")
	end, { v58 })
	React.useEffect(function() -- line: 477
		-- upvalues: v76 (copy), featureName (copy), nameSpace (copy)
		v76(featureName, nameSpace)
	end, {
		v62,
		featureName,
		v76,
		nameSpace
	})
	React.useEffect(function() -- line: 483
		-- upvalues: GetFFlagEnableAmpWizardInlineVPCForFAE (copy), v68 (copy), VPCRequestTypeEnum (copy), v73 (copy), Cryo (copy), recourseData (copy), VPCApiProvider (copy), v61 (copy), ActionTypeEnum (copy), openUpsells (copy), GetFFlagEnableAmpVPCPrologue (copy), v67 (copy), v69 (copy)
		if not GetFFlagEnableAmpWizardInlineVPCForFAE() or v68 == nil then
			return
		end

		local function buildFAEProps(p8) -- line: 490
			-- upvalues: VPCRequestTypeEnum (copy), v73 (copy), Cryo (copy), recourseData (copy)
			local t6 = {
				action = p8,
				parentConsentTypes = { VPCRequestTypeEnum.UpdateUserSetting }
			}
			local v101 = v73(p8, t6)
			local v102 = Cryo.Dictionary.join(recourseData or {}, {
				allowFacialAgeEstimation = "Enabled"
			})

			return Cryo.Dictionary.join(v101, {
				recourseData = v102
			})
		end

		VPCApiProvider.getLinkedParentEmails(v61):andThen(function(p9) -- line: 501
			-- upvalues: ActionTypeEnum (copy), buildFAEProps (copy), openUpsells (copy), GetFFlagEnableAmpVPCPrologue (copy), v67 (copy), v69 (copy)
			local v104 = if not ((p9.parentEmails and #p9.parentEmails or 0) > 0) then ActionTypeEnum.ParentLink else ActionTypeEnum.ParentConsent
			local v105 = buildFAEProps(v104)
			local v106 = openUpsells[v104]

			if GetFFlagEnableAmpVPCPrologue() then
				v67({
					action = v104,
					actionProps = v105,
					openUpsellFn = v106
				})
			else
				v106(v105)
			end

			v69(nil)
		end):catch(function(_) -- line: 520
			-- upvalues: buildFAEProps (copy), ActionTypeEnum (copy), openUpsells (copy), v69 (copy)
			local v108 = buildFAEProps(ActionTypeEnum.ParentLink)

			openUpsells[ActionTypeEnum.ParentLink](v108)
			v69(nil)
		end)
	end, {
		v68,
		v61,
		v73,
		openUpsells,
		recourseData
	})

	if GetFFlagEnableAmpVPCPrologue() and v66 then
		return React.createElement(VPCPrologueController, {
			request = v66,
			recourseData = recourseData,
			handleCompletion = v72,
			actionsTaken = v62,
			onDone = function() -- line: 534
				-- upvalues: v67 (copy)
				v67(nil)
			end
		})
	end

	if v64 then
		return React.createElement(ErrorScreen, {
			featureName = featureName,
			onRetry = function() -- line: 543
				-- upvalues: v65 (copy), v76 (copy), featureName (copy)
				v65(false)
				v76(featureName)
			end,
			onCancel = function() -- line: 547
				-- upvalues: v72 (copy), AccessResponseEnum (copy), v62 (copy)
				v72(AccessResponseEnum.Denied, v62)
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
