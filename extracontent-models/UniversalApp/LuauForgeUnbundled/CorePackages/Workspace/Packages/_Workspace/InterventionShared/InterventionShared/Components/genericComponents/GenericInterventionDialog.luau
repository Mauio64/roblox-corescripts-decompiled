local VRService = game:GetService("VRService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React")
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Utils/Constants")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Cryo")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Components/genericComponents/EvidenceField")
local InterventionDialogFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Components/genericComponents/InterventionDialogFooter")
local InterventionDialogLoadingSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Components/genericComponents/InterventionDialogLoadingSkeleton")
local InterventionAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/InterventionAnalytics")
local linkingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/LinkingProtocol").LinkingProtocol
local PostDismissIntervention = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Http/PostDismissIntervention")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Responsive")
local NotificationModalsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/NotificationModalsManager")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/UrlBuilder").UrlBuilder

local focusNavigableSurfaceIdentifierEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/FocusNavigationUtils").FocusNavigableSurfaceIdentifierEnum

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Foundation")
local badge = Foundation.Badge
local badgeVariant = Foundation.Enums.BadgeVariant
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local divider = Foundation.Divider
local iconName = Foundation.Enums.IconName
local iconPosition = Foundation.Enums.IconPosition
local iconVariant = Foundation.Enums.IconVariant
local text = Foundation.Text
local view = Foundation.View
local images = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/FoundationImages").Images

local useInterventionFocusRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Hooks/useInterventionFocusRoot")
local useInterventionPlacement = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Hooks/useInterventionPlacement")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Localization").Hooks.useLocalization
local usePreferredInput = Responsive.usePreferredInput
local useSinkCoreShortcuts = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Hooks/useSinkCoreShortcuts")
local useTokens = Foundation.Hooks.useTokens
local useWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Hooks/useWebView")

local FFlagInterventionDialogBlockExperienceInput = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Flags/FFlagInterventionDialogBlockExperienceInput")
local fFlagNavigateToSafetyDashboardForAppeals = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/SharedFlags").FFlagNavigateToSafetyDashboardForAppeals
local FFlagUFRDialogContentCutoffFix = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Flags/FFlagUFRDialogContentCutoffFix")
local FFlagUFRImprovements = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Flags/FFlagUFRImprovements")

local iconsactionsaccept = images["icons/actions/accept"]

local function getNonEmptyString(p2)
	if p2 == "" then
		return nil
	end

	return p2
end

local function GenericInterventionDialog(props)
	local v5 = useTokens()

	local interventionId = props.interventionId

	if interventionId == "" then
		interventionId = nil
	end

	local dsaMessage = props.dsaMessage

	if dsaMessage == "" then
		dsaMessage = nil
	end

	local evidence = props.evidence

	if evidence == "" then
		evidence = nil
	end

	local formattedEndDate = props.formattedEndDate

	if formattedEndDate == "" then
		formattedEndDate = nil
	end

	local userNote = props.userNote

	if userNote == "" then
		userNote = nil
	end

	local violationReason = props.violationReason

	if violationReason == "" then
		violationReason = nil
	end

	local violationUid = props.violationUid

	if violationUid == "" then
		violationUid = nil
	end

	local v6 = useRef(DateTime.now().UnixTimestampMillis)
	local v7 = useInterventionPlacement()
	local v8 = useLocalization(Constants.localizationKeys)
	local v9 = usePreferredInput() == Responsive.Input.Directional
	local v10

	if fFlagNavigateToSafetyDashboardForAppeals then
		if violationUid then
			v10 = urlBuilder.static.safetyDashboard.violation({ id = violationUid })
		else
			v10 = urlBuilder.static.safetyDashboard.violations()
		end
	else
		v10 = urlBuilder.static.appealsPortal.main()
	end

	local v12

	if fFlagNavigateToSafetyDashboardForAppeals then
		v12 = v8.AccountStatusTitleText
	else
		v12 = v8.AppealsPortalTitleText
	end

	local v13 = useWebView(v10, v12)

	local default = linkingProtocol.default

	local v14 = useInterventionFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ModerationOverlay,
		isAutoFocusRoot = true
	})

	if FFlagInterventionDialogBlockExperienceInput then
		useSinkCoreShortcuts(v7 == Constants.InterventionPlacementType.InExperience)
	end

	useEffect(function()
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogRendered, {
			eventType = InterventionAnalytics.Constants.EventTypes.ModalAppeared,
			interventionType = props.interventionTypeForAnalytics,
			placement = v7,
			renderedTimestamp = v6.current,
			eventId = props.eventId,
			evidence = props.evidence,
			duration = props.durationForAnalytics,
			acknowledgeable = props.acknowledgeable,
			abuseVector = props.abuseVectorForAnalytics
		})
	end, { v6 })

	local v15 = useCallback(function()
		if props.acknowledgeable and interventionId then
			local v16 = false
			PostDismissIntervention(interventionId):andThen(function(p2)
				v16 = true
				InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogInterventionDismissSuccess, {
					eventType = InterventionAnalytics.Constants.EventTypes.DialogInterventionDismissSuccess,
					interventionType = props.interventionTypeForAnalytics,
					placement = v7,
					renderedTimestamp = v6.current,
					eventId = props.eventId,
					acknowledgeable = props.acknowledgeable,
					abuseVector = props.abuseVectorForAnalytics
				})

				if props.onAcknowledgementSuccess then
					props.onAcknowledgementSuccess()
				end
			end):catch(function(p2)
				InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogInterventionDismissFailed, {
					eventType = InterventionAnalytics.Constants.EventTypes.DialogInterventionDismissFailed,
					interventionType = props.interventionTypeForAnalytics,
					placement = v7,
					renderedTimestamp = v6.current,
					eventId = props.eventId,
					error = p2.error,
					acknowledgeable = props.acknowledgeable,
					abuseVector = props.abuseVectorForAnalytics
				})

				if not v16 and props.onAcknowledgementFailure then
					props.onAcknowledgementFailure()
				end
			end)
		end
	end, {
		props.acknowledgeable,
		interventionId,
		props.interventionTypeForAnalytics,
		v7,
		v6.current,
		props.eventId,
		props.abuseVectorForAnalytics,
		props.onAcknowledgementSuccess,
		props.onAcknowledgementFailure
	})

	local v16 = useCallback(function()
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogCtaClicked, {
			eventType = InterventionAnalytics.Constants.EventTypes.CtaClicked,
			interventionType = props.interventionTypeForAnalytics,
			placement = v7,
			renderedTimestamp = v6.current,
			eventId = props.eventId,
			acknowledgeable = props.acknowledgeable,
			abuseVector = props.abuseVectorForAnalytics
		})

		v15()
		props.onDismiss()
	end, {
		props.onDismiss,
		props.interventionTypeForAnalytics,
		v7,
		v6.current,
		props.eventId,
		props.abuseVectorForAnalytics,
		props.acknowledgeable,
		interventionId,
		v15,
		props.onAcknowledgementSuccess
	})

	local v17 = useCallback(function()
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogAppealClicked, {
			eventType = InterventionAnalytics.Constants.EventTypes.AppealClicked,
			interventionType = props.interventionTypeForAnalytics,
			placement = v7,
			renderedTimestamp = v6.current,
			eventId = props.eventId,
			acknowledgeable = props.acknowledgeable,
			abuseVector = props.abuseVectorForAnalytics
		})

		if props.useDetailedLayout and props.onAppeal then
			props.onAppeal()

			if not props.shouldOpenAppealsPortal then
				v15()
				props.onDismiss()

				NotificationModalsManager.SetUIBloxToast({
					iconImage = iconsactionsaccept,
					toastTitle = v8.TakeALookText,
					toastSubtitle = v8.FeedbackHelpsText,
					sequenceNumber = DateTime.now().UnixTimestamp,
					iconColorStyle = {
						Color = v5.Color.System.Success.Color3,
						Transparency = 0
					}
				})

				return
			end
		end

		if VRService.VREnabled or v9 then
			default:openURL(v10)
		else
			v13()
		end
	end, {
		v13,
		default,
		VRService.VREnabled,
		v9,
		props.interventionTypeForAnalytics,
		v7,
		v6.current,
		v10,
		props.abuseVectorForAnalytics,
		props.acknowledgeable,
		interventionId,
		props.eventId,
		v8.FeedbackHelpsText,
		v8.TakeALookText,
		props.onAppeal,
		props.shouldOpenAppealsPortal,
		props.onDismiss,
		props.useDetailedLayout,
		v5.Color.System.Success.Color3,
		v15
	})

	local children = {}
	local useDetailedLayout = props.useDetailedLayout

	if props.bodyText and props.bodyText ~= "" then
		children.BodyText = React.createElement(text, {
			Text = props.bodyText,
			tag = "auto-xy text-body-medium content-default text-align-x-left text-wrap",
			testId = "dialog-body-text",
			LayoutOrder = 1
		})
	end

	if useDetailedLayout then
		local children2 = {}
		local v18 = FFlagUFRImprovements and violationReason or userNote or formattedEndDate

		if evidence then
			children2.EvidenceItem = React.createElement(
				view,
				{
					tag = "size-full-0 auto-y padding-x-medium",
					testId = "dialog-evidence-item",
					LayoutOrder = 1
				},
				{
					EvidenceText = React.createElement(text, {
						Text = evidence,
						tag = "auto-xy text-body-medium text-align-x-left text-wrap",
						RichText = true
					})
				}
			)

			if FFlagUFRImprovements and v18 then
				children2.DividerBelowEvidence = React.createElement(divider, {
					LayoutOrder = 2
				})
			end
		end

		if violationReason then
			if not FFlagUFRImprovements and evidence then
				children2.DividerAfterEvidence = React.createElement(divider, {
					LayoutOrder = 2
				})
			end

			children2.ReasonItem = React.createElement(
				view,
				{
					tag = "size-full-0 auto-y padding-x-medium",
					testId = "dialog-reason-item",
					LayoutOrder = 3
				},
				{
					ReasonField = React.createElement(module4, {
						fieldLabel = v8.ReasonText,
						fieldValue = violationReason
					})
				}
			)
		end

		if userNote then
			children2.NoteItem = React.createElement(
				view,
				{
					tag = "size-full-0 auto-y padding-x-medium",
					testId = "dialog-note-item",
					LayoutOrder = 4
				},
				{
					NoteText = React.createElement(module4, {
						fieldLabel = v8.ModeratorNoteLabel,
						fieldValue = userNote
					})
				}
			)
		end

		if formattedEndDate then
			children2.EndingOnItem = React.createElement(
				view,
				{
					tag = "size-full-0 auto-y row padding-x-medium align-y-center",
					testId = "dialog-ending-on-item",
					LayoutOrder = 5
				},
				{
					EndingOnInfo = React.createElement(view, {
						tag = {
							["col fill"] = true,
							["auto-xy"] = FFlagUFRDialogContentCutoffFix,
							["auto-y"] = not FFlagUFRDialogContentCutoffFix
						},
						LayoutOrder = 1
					}, {
						EvidenceField = React.createElement(module4, {
							fieldLabel = v8.EndsOnText,
							fieldValue = formattedEndDate,
							hasColon = false
						})
					}),
					CountdownBadge = React.createElement(badge, {
						text = props.countdownText or v8.CompleteText,
						variant = badgeVariant.Neutral,
						icon = props.countdownText and {
							name = iconName.Clock,
							position = iconPosition.Left,
							variant = iconVariant.Filled
						} or nil,
						LayoutOrder = 2
					})
				}
			)
		end

		if not Cryo.isEmpty(children2) then
			children.DetailedList = React.createElement(
				view,
				{
					tag = "size-full-0 auto-y padding-top-xxsmall padding-x-xxsmall padding-bottom-medium",
					testId = "dialog-detailed-list",
					LayoutOrder = 2
				},
				React.createElement(
					view,
					{
						tag = "col gap-medium size-full-0 auto-y padding-y-large stroke-standard stroke-default radius-large bg-shift-100"
					},
					children2
				)
			)
		end
	elseif evidence or violationReason or props.isAppealable then
		children.Evidence = React.createElement(
			view,
			{ tag = "size-full-0 auto-y padding-xxsmall", LayoutOrder = 2 },
			{ React.createElement(
					view,
					{
						tag = "size-full-0 auto-y col gap-small padding-medium radius-medium bg-surface-200 stroke-standard stroke-default"
					},
					{
						EvidenceText = evidence and React.createElement(text, {
							Text = evidence,
							tag = "auto-xy text-body-medium text-align-x-left text-wrap",
							RichText = true,
							LayoutOrder = 1
						}),
						Reason = violationReason and React.createElement(text, {
							Text = `<b>{v8.ReasonText}:</b>\n{violationReason}`,
							tag = "auto-xy text-body-medium text-align-x-left text-wrap",
							RichText = true,
							LayoutOrder = 2
						}),
						AppealButton = props.isAppealable and React.createElement(button, {
							text = v8.ReportMistakeText,
							variant = buttonVariant.Standard,
							size = buttonSize.XSmall,
							width = UDim.new(1, 0),
							onActivated = v17,
							LayoutOrder = 3
						})
					}
				) }
		)
	end

	if dsaMessage and not useDetailedLayout then
		children.DsaMessage = React.createElement(text, {
			Text = dsaMessage,
			tag = "auto-xy text-caption-small content-default text-align-x-left text-wrap",
			LayoutOrder = 3
		})
	end

	local v18 = {
		{
			variant = buttonVariant.Emphasis,
			size = buttonSize.Small,
			text = v8.OkText,
			onActivated = v16
		}
	}

	local createElement = React.createElement
	local root = dialog.Root
	local v19 = {
		size = dialogSize.Medium,
		hasCloseButton = false,
		ref = v14,
		hasBackdrop = not VRService.VREnabled,
		disablePortal = v7 ~= Constants.InterventionPlacementType.InExperience
	}
	local v20 = {
		DialogTitle = not props.isLoading and React.createElement(dialog.Title, {
			text = props.titleText
		}),
		DialogContent = 0,
		DialogFooter = 0,
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local content = dialog.Content
	local v22

	if props.isLoading then
		v22 = React.createElement(InterventionDialogLoadingSkeleton)
	else
		v22 = React.createElement(view, { tag = "size-full-0 auto-y col gap-medium" }, children)
	end

	v20.DialogContent = createElement2(content, useDetailedLayout and {
		LayoutOrder = 2
	} or nil, v22)

	v20.DialogFooter = not props.isLoading and useDetailedLayout and React.createElement(InterventionDialogFooter, {
		ctaText = v8.OkText,
		dsaMessage = props.dsaMessage,
		isAppealable = props.isAppealable,
		onAppealActivated = v17,
		onCtaActivated = v16
	})

	v20.DialogActions = not props.isLoading
		and not useDetailedLayout
		and React.createElement(dialog.Actions, { actions = v18 })
	return createElement(root, v19, v20)
end

return React.memo(GenericInterventionDialog)
