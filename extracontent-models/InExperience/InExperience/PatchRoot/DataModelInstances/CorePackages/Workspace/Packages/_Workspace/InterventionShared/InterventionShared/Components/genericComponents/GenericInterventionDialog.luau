local InterventionShared = script:FindFirstAncestor("InterventionShared")
local InterventionSharedParent = InterventionShared.Parent
local VRService = game:GetService("VRService")
local React = require(InterventionSharedParent.React)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local Constants = require(InterventionShared.Utils.Constants)
local Cryo = require(InterventionSharedParent.Cryo)
local EvidenceField = require(InterventionShared.Components.genericComponents.EvidenceField)
local InterventionAnalytics = require(InterventionShared.InterventionAnalytics)
local LinkingProtocol = require(InterventionSharedParent.LinkingProtocol).LinkingProtocol
local PostDismissIntervention = require(InterventionShared.Http.PostDismissIntervention)
local Responsive = require(InterventionSharedParent.Responsive)
local NotificationModalsManager = require(InterventionSharedParent.NotificationModalsManager)
local UrlBuilder = require(InterventionSharedParent.UrlBuilder).UrlBuilder
local FocusNavigableSurfaceIdentifierEnum = require(InterventionSharedParent.FocusNavigationUtils).FocusNavigableSurfaceIdentifierEnum
local Foundation = require(InterventionSharedParent.Foundation)
local Badge = Foundation.Badge
local BadgeVariant = Foundation.Enums.BadgeVariant
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local Divider = Foundation.Divider
local IconName = Foundation.Enums.IconName
local IconPosition = Foundation.Enums.IconPosition
local IconVariant = Foundation.Enums.IconVariant
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local FoundationText = Foundation.Text
local View = Foundation.View
local Images = require(InterventionSharedParent.FoundationImages).Images
local useInterventionFocusRoot = require(InterventionShared.Hooks.useInterventionFocusRoot)
local useInterventionPlacement = require(InterventionShared.Hooks.useInterventionPlacement)
local useLocalization = require(InterventionSharedParent.Localization).Hooks.useLocalization
local usePreferredInput = Responsive.usePreferredInput
local useTokens = Foundation.Hooks.useTokens
local useWebView = require(InterventionShared.Hooks.useWebView)
local FFlagNavigateToSafetyDashboardForAppeals = require(InterventionSharedParent.SharedFlags).FFlagNavigateToSafetyDashboardForAppeals
local FFlagUniversalFeatureRestrictionReceivers = require(InterventionSharedParent.SharedFlags).FFlagUniversalFeatureRestrictionReceivers
local v43 = Images["icons/actions/accept"]

local function GenericInterventionDialog(t1: {[any]: any}) -- line: 86
	-- upvalues: useTokens (copy), useRef (copy), useInterventionPlacement (copy), useLocalization (copy), Constants (copy), usePreferredInput (copy), Responsive (copy), FFlagNavigateToSafetyDashboardForAppeals (copy), UrlBuilder (copy), useWebView (copy), LinkingProtocol (copy), useInterventionFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), useEffect (copy), InterventionAnalytics (copy), useCallback (copy), PostDismissIntervention (copy), FFlagUniversalFeatureRestrictionReceivers (copy), NotificationModalsManager (copy), v43 (copy), VRService (copy), React (copy), FoundationText (copy), View (copy), Divider (copy), EvidenceField (copy), Badge (copy), BadgeVariant (copy), IconName (copy), IconPosition (copy), IconVariant (copy), Cryo (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy), Dialog (copy), DialogSize (copy), Skeleton (copy), EnumsRadius (copy)
	local v46 = useTokens()
	local v47 = useRef(DateTime.now().UnixTimestampMillis)
	local v48 = useInterventionPlacement()
	local v49 = useLocalization(Constants.localizationKeys)
	local v50 = usePreferredInput() == Responsive.Input.Directional
	local v51 = if not FFlagNavigateToSafetyDashboardForAppeals then UrlBuilder.static.appealsPortal.main() else UrlBuilder.static.safetyDashboard.main()
	local v52 = useWebView(v51, if not FFlagNavigateToSafetyDashboardForAppeals then v49.AppealsPortalTitleText else v49.AccountStatusTitleText)
	local default = LinkingProtocol.default
	local v54 = useInterventionFocusRoot({
		isAutoFocusRoot = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ModerationOverlay
	})

	useEffect(function() -- line: 110
		-- upvalues: InterventionAnalytics (copy), t1 (copy), v48 (copy), v47 (copy)
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogRendered, {
			eventType = InterventionAnalytics.Constants.EventTypes.ModalAppeared,
			interventionType = t1.interventionTypeForAnalytics,
			placement = v48,
			renderedTimestamp = v47.current,
			eventId = t1.eventId,
			evidence = t1.evidence,
			duration = t1.durationForAnalytics,
			acknowledgeable = t1.acknowledgeable,
			abuseVector = t1.abuseVectorForAnalytics
		})
	end, { v47 })

	local v55 = useCallback(function() -- line: 125
		-- upvalues: t1 (copy), PostDismissIntervention (copy), InterventionAnalytics (copy), v48 (copy), v47 (copy)
		if t1.acknowledgeable and (t1.interventionId and t1.interventionId ~= "") then
			PostDismissIntervention(t1.interventionId):andThen(function(_) -- line: 127
				-- upvalues: InterventionAnalytics (copy), t1 (copy), v48 (copy), v47 (copy)
				InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogInterventionDismissSuccess, {
					eventType = InterventionAnalytics.Constants.EventTypes.DialogInterventionDismissSuccess,
					interventionType = t1.interventionTypeForAnalytics,
					placement = v48,
					renderedTimestamp = v47.current,
					eventId = t1.eventId,
					acknowledgeable = t1.acknowledgeable,
					abuseVector = t1.abuseVectorForAnalytics
				})
			end):catch(function(p2) -- line: 140
				-- upvalues: InterventionAnalytics (copy), t1 (copy), v48 (copy), v47 (copy)
				InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogInterventionDismissFailed, {
					eventType = InterventionAnalytics.Constants.EventTypes.DialogInterventionDismissFailed,
					interventionType = t1.interventionTypeForAnalytics,
					placement = v48,
					renderedTimestamp = v47.current,
					eventId = t1.eventId,
					error = p2.error,
					acknowledgeable = t1.acknowledgeable,
					abuseVector = t1.abuseVectorForAnalytics
				})
			end)
		end
	end, {
		t1.acknowledgeable,
		t1.interventionId,
		t1.interventionTypeForAnalytics,
		v48,
		v47.current,
		t1.eventId,
		t1.abuseVectorForAnalytics
	})
	local v56 = useCallback(function() -- line: 171
		-- upvalues: InterventionAnalytics (copy), t1 (copy), v48 (copy), v47 (copy), FFlagUniversalFeatureRestrictionReceivers (copy), v55 (copy), PostDismissIntervention (copy)
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogCtaClicked, {
			eventType = InterventionAnalytics.Constants.EventTypes.CtaClicked,
			interventionType = t1.interventionTypeForAnalytics,
			placement = v48,
			renderedTimestamp = v47.current,
			eventId = t1.eventId,
			acknowledgeable = t1.acknowledgeable,
			abuseVector = t1.abuseVectorForAnalytics
		})

		if FFlagUniversalFeatureRestrictionReceivers then
			v55()
		elseif t1.acknowledgeable and t1.interventionId and t1.interventionId ~= "" then
			PostDismissIntervention(t1.interventionId):andThen(function(_) -- line: 186
				-- upvalues: InterventionAnalytics (copy), t1 (copy), v48 (copy), v47 (copy)
				InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogInterventionDismissSuccess, {
					eventType = InterventionAnalytics.Constants.EventTypes.DialogInterventionDismissSuccess,
					interventionType = t1.interventionTypeForAnalytics,
					placement = v48,
					renderedTimestamp = v47.current,
					eventId = t1.eventId,
					acknowledgeable = t1.acknowledgeable,
					abuseVector = t1.abuseVectorForAnalytics
				})
			end):catch(function(p4) -- line: 199
				-- upvalues: InterventionAnalytics (copy), t1 (copy), v48 (copy), v47 (copy)
				InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogInterventionDismissFailed, {
					eventType = InterventionAnalytics.Constants.EventTypes.DialogInterventionDismissFailed,
					interventionType = t1.interventionTypeForAnalytics,
					placement = v48,
					renderedTimestamp = v47.current,
					eventId = t1.eventId,
					error = p4.error,
					acknowledgeable = t1.acknowledgeable,
					abuseVector = t1.abuseVectorForAnalytics
				})
			end)
		end

		t1.onDismiss()
	end, {
		t1.onDismiss,
		t1.interventionTypeForAnalytics,
		v48,
		v47.current,
		t1.eventId,
		t1.abuseVectorForAnalytics,
		t1.acknowledgeable,
		t1.interventionId,
		v55
	})
	local v57 = useCallback(function() -- line: 235
		-- upvalues: InterventionAnalytics (copy), t1 (copy), v48 (copy), v47 (copy), FFlagUniversalFeatureRestrictionReceivers (copy), v55 (copy), NotificationModalsManager (copy), v43 (copy), v49 (copy), v46 (copy), VRService (copy), v50 (copy), default (copy), v51 (copy), v52 (copy)
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogAppealClicked, {
			eventType = InterventionAnalytics.Constants.EventTypes.AppealClicked,
			interventionType = t1.interventionTypeForAnalytics,
			placement = v48,
			renderedTimestamp = v47.current,
			eventId = t1.eventId,
			acknowledgeable = t1.acknowledgeable,
			abuseVector = t1.abuseVectorForAnalytics
		})

		if FFlagUniversalFeatureRestrictionReceivers and (t1.useDetailedLayout and t1.onAppeal) then
			t1.onAppeal()

			if not t1.shouldOpenAppealsPortal then
				v55()
				t1.onDismiss()
				NotificationModalsManager.SetUIBloxToast({
					iconImage = v43,
					toastTitle = v49.TakeALookText,
					toastSubtitle = v49.FeedbackHelpsText,
					sequenceNumber = DateTime.now().UnixTimestamp,
					iconColorStyle = {
						Transparency = 0,
						Color = v46.Color.System.Success.Color3
					}
				})

				return
			end
		end

		if VRService.VREnabled or v50 then
			default:openURL(v51)

			return
		end

		v52()
	end, {
		v52,
		default,
		VRService.VREnabled,
		v50,
		t1.interventionTypeForAnalytics,
		v48,
		v47.current,
		v51,
		t1.abuseVectorForAnalytics,
		t1.acknowledgeable,
		t1.interventionId,
		t1.eventId,
		v49.FeedbackHelpsText,
		v49.TakeALookText,
		t1.onAppeal,
		t1.shouldOpenAppealsPortal,
		t1.onDismiss,
		t1.useDetailedLayout,
		v46.Color.System.Success.Color3,
		v55
	})
	local t2 = {}
	local v59 = FFlagUniversalFeatureRestrictionReceivers and t1.useDetailedLayout

	if t1.bodyText and t1.bodyText ~= "" then
		t2.BodyText = React.createElement(FoundationText, {
			tag = "auto-xy text-body-medium content-default text-align-x-left text-wrap",
			testId = "dialog-body-text",
			LayoutOrder = 1,
			Text = t1.bodyText
		})
	end

	if v59 then
		local t3 = {}

		if t1.evidence and t1.evidence ~= "" then
			t3.EvidenceItem = React.createElement(View, {
				tag = "size-full-0 auto-y padding-x-medium",
				testId = "dialog-evidence-item",
				LayoutOrder = 1
			}, {
				EvidenceText = React.createElement(FoundationText, {
					tag = "auto-xy text-body-medium text-align-x-left text-wrap",
					RichText = true,
					Text = t1.evidence
				})
			})
		end

		if t1.violationReason and t1.violationReason ~= "" then
			if t1.evidence and t1.evidence ~= "" then
				t3.DividerAfterEvidence = React.createElement(Divider, {
					LayoutOrder = 2
				})
			end

			t3.ReasonItem = React.createElement(View, {
				tag = "size-full-0 auto-y padding-x-medium",
				testId = "dialog-reason-item",
				LayoutOrder = 3
			}, {
				ReasonField = React.createElement(EvidenceField, {
					fieldLabel = v49.ReasonText,
					fieldValue = t1.violationReason
				})
			})
		end

		if t1.userNote and t1.userNote ~= "" then
			t3.NoteItem = React.createElement(View, {
				tag = "size-full-0 auto-y padding-x-medium",
				testId = "dialog-note-item",
				LayoutOrder = 4
			}, {
				NoteText = React.createElement(EvidenceField, {
					fieldLabel = v49.ModeratorNoteLabel,
					fieldValue = t1.userNote
				})
			})
		end

		if t1.formattedEndDate and t1.formattedEndDate ~= "" then
			t3.EndingOnItem = React.createElement(View, {
				tag = "size-full-0 auto-y row padding-x-medium align-y-center",
				testId = "dialog-ending-on-item",
				LayoutOrder = 5
			}, {
				EndingOnInfo = React.createElement(View, {
					tag = "auto-y col fill",
					LayoutOrder = 1
				}, {
					EvidenceField = React.createElement(EvidenceField, {
						hasColon = false,
						fieldLabel = v49.EndsOnText,
						fieldValue = t1.formattedEndDate
					})
				}),
				CountdownBadge = React.createElement(Badge, {
					LayoutOrder = 2,
					text = t1.countdownText or v49.CompleteText,
					variant = BadgeVariant.Neutral,
					icon = if not t1.countdownText then nil else {
						name = IconName.Clock,
						position = IconPosition.Left,
						variant = IconVariant.Filled
					}
				})
			})
		end

		if not Cryo.isEmpty(t3) then
			t2.DetailedList = React.createElement(View, {
				tag = "size-full-0 auto-y padding-top-xxsmall padding-x-xxsmall padding-bottom-medium",
				testId = "dialog-detailed-list",
				LayoutOrder = 2
			}, React.createElement(View, {
				tag = "col gap-medium size-full-0 auto-y padding-y-large stroke-standard stroke-default radius-large bg-shift-100"
			}, t3))
		end
	elseif t1.evidence and t1.evidence ~= "" or (t1.violationReason and t1.violationReason ~= "" or t1.isAppealable) then
		t2.Evidence = React.createElement(View, {
			tag = "size-full-0 auto-y padding-xxsmall",
			LayoutOrder = 2
		}, { React.createElement(View, {
			tag = "size-full-0 auto-y col gap-small padding-medium radius-medium bg-surface-200 stroke-standard stroke-default"
		}, {
			EvidenceText = t1.evidence and (t1.evidence ~= "" and React.createElement(FoundationText, {
				tag = "auto-xy text-body-medium text-align-x-left text-wrap",
				RichText = true,
				LayoutOrder = 1,
				Text = t1.evidence
			})),
			Reason = t1.violationReason and (t1.violationReason ~= "" and React.createElement(FoundationText, {
				tag = "auto-xy text-body-medium text-align-x-left text-wrap",
				RichText = true,
				LayoutOrder = 2,
				Text = `<b>{ v49.ReasonText }:</b>\n{ t1.violationReason }`
			})),
			AppealButton = t1.isAppealable and React.createElement(Button, {
				LayoutOrder = 3,
				text = v49.ReportMistakeText,
				variant = ButtonVariant.Standard,
				size = ButtonSize.XSmall,
				width = UDim.new(1, 0),
				onActivated = v57
			})
		}) })
	end

	if t1.dsaMessage and t1.dsaMessage ~= "" and not v59 then
		t2.DsaMessage = React.createElement(FoundationText, {
			tag = "auto-xy text-caption-small content-default text-align-x-left text-wrap",
			LayoutOrder = 3,
			Text = t1.dsaMessage
		})
	end

	local t4 = nil

	if v59 then
		t4 = {{
			variant = ButtonVariant.Emphasis,
			size = ButtonSize.Medium,
			text = v49.OkText,
			onActivated = v56,
			width = UDim.new(1, 0)
		}}

		if t1.isAppealable then
			table.insert(t4, {
				variant = ButtonVariant.Standard,
				size = ButtonSize.Medium,
				text = v49.ReportMistakeText,
				onActivated = v57,
				width = UDim.new(1, 0)
			})
		end
	end

	return React.createElement(Dialog.Root, {
		hasCloseButton = false,
		size = DialogSize.Medium,
		ref = v54,
		hasBackdrop = not VRService.VREnabled,
		disablePortal = v48 ~= Constants.InterventionPlacementType.InExperience
	}, {
		DialogTitle = not t1.isLoading and React.createElement(Dialog.Title, {
			text = t1.titleText
		}),
		DialogContent = React.createElement(Dialog.Content, nil, if not t1.isLoading then React.createElement(View, {
			tag = "size-full-0 auto-y col gap-medium"
		}, t2) else React.createElement(View, {
			tag = "size-full-0 auto-y col gap-medium margin-top-small"
		}, {
			Heading = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(0.6, 0, 0, v46.Size.Size_1100),
				radius = EnumsRadius.Medium
			}),
			Body = React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, v46.Size.Size_2000),
				radius = EnumsRadius.Medium
			}),
			Actions = React.createElement(Skeleton, {
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, v46.Size.Size_800),
				radius = EnumsRadius.Medium
			})
		})),
		DialogActions = not t1.isLoading and React.createElement(Dialog.Actions, {
			actions = if not v59 then {{
				variant = ButtonVariant.Emphasis,
				size = ButtonSize.Small,
				text = v49.OkText,
				onActivated = v56
			}} else t4,
			label = if not v59 or (not t1.useDetailedLayout or (not t1.dsaMessage or t1.dsaMessage == "")) then nil else t1.dsaMessage
		})
	})
end

return React.memo(GenericInterventionDialog)
