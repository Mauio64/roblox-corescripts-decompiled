local InterventionShared = script:FindFirstAncestor("InterventionShared")
local parent = InterventionShared.Parent

local VRService = game:GetService("VRService")

local React = require(parent.React)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef

local Constants = require(InterventionShared.Utils.Constants)
local Cryo = require(parent.Cryo)
local EvidenceField = require(InterventionShared.Components.genericComponents.EvidenceField)
local InterventionDialogFooter = require(InterventionShared.Components.genericComponents.InterventionDialogFooter)
local InterventionDialogLoadingSkeleton = require(InterventionShared.Components.genericComponents.InterventionDialogLoadingSkeleton)
local InterventionAnalytics = require(InterventionShared.InterventionAnalytics)
local LinkingProtocol = require(parent.LinkingProtocol)
local linkingProtocol = LinkingProtocol.LinkingProtocol
local PostDismissIntervention = require(InterventionShared.Http.PostDismissIntervention)
local Responsive = require(parent.Responsive)
local NotificationModalsManager = require(parent.NotificationModalsManager)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local Foundation = require(parent.Foundation)
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
local Text = Foundation.Text
local View = Foundation.View
local FoundationImages = require(parent.FoundationImages)
local Images = FoundationImages.Images

local useInterventionFocusRoot = require(InterventionShared.Hooks.useInterventionFocusRoot)
local useInterventionPlacement = require(InterventionShared.Hooks.useInterventionPlacement)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local usePreferredInput = Responsive.usePreferredInput
local useSinkCoreShortcuts = require(InterventionShared.Hooks.useSinkCoreShortcuts)
local useTokens = Foundation.Hooks.useTokens
local useWebView = require(InterventionShared.Hooks.useWebView)

local FFlagInterventionDialogBlockExperienceInput = require(InterventionShared.Flags.FFlagInterventionDialogBlockExperienceInput)
local SharedFlags = require(parent.SharedFlags)
local FFlagNavigateToSafetyDashboardForAppeals = SharedFlags.FFlagNavigateToSafetyDashboardForAppeals
local FFlagUFRDialogContentCutoffFix = require(InterventionShared.Flags.FFlagUFRDialogContentCutoffFix)
local FFlagUFRImprovements = require(InterventionShared.Flags.FFlagUFRImprovements)

local iconsactionsaccept = Images["icons/actions/accept"]

local function getNonEmptyString(p: string?) -- 7 equivalent calls inferred from this helper
	return if p ~= "" then p else nil
end

local function GenericInterventionDialog(props)
	local v = useTokens()

	local nonEmptyString = getNonEmptyString(props.interventionId) -- inferred equivalent call
	local nonEmptyString2 = getNonEmptyString(props.dsaMessage) -- inferred equivalent call
	local nonEmptyString3 = getNonEmptyString(props.evidence) -- inferred equivalent call
	local nonEmptyString4 = getNonEmptyString(props.formattedEndDate) -- inferred equivalent call
	local nonEmptyString5 = getNonEmptyString(props.userNote) -- inferred equivalent call
	local nonEmptyString6 = getNonEmptyString(props.violationReason) -- inferred equivalent call
	local nonEmptyString7 = getNonEmptyString(props.violationUid) -- inferred equivalent call

	local v2 = useRef(DateTime.now().UnixTimestampMillis)
	local placement = useInterventionPlacement()
	local v3 = useLocalization(Constants.localizationKeys)
	local v4 = usePreferredInput() == Responsive.Input.Directional
	local v5

	if FFlagNavigateToSafetyDashboardForAppeals then
		if nonEmptyString7 then
			v5 = urlBuilder.static.safetyDashboard.violation({ id = nonEmptyString7 })
		else
			v5 = urlBuilder.static.safetyDashboard.violations()
		end
	else
		v5 = urlBuilder.static.appealsPortal.main()
	end

	local v6

	if FFlagNavigateToSafetyDashboardForAppeals then
		v6 = v3.AccountStatusTitleText
	else
		v6 = v3.AppealsPortalTitleText
	end

	local v7 = useWebView(v5, v6)

	local default = linkingProtocol.default

	local ref = useInterventionFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ModerationOverlay,
		isAutoFocusRoot = true
	})

	if FFlagInterventionDialogBlockExperienceInput then
		useSinkCoreShortcuts(placement == Constants.InterventionPlacementType.InExperience)
	end

	useEffect(function()
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogRendered, {
			eventType = InterventionAnalytics.Constants.EventTypes.ModalAppeared,
			interventionType = props.interventionTypeForAnalytics,
			placement = placement,
			renderedTimestamp = v2.current,
			eventId = props.eventId,
			evidence = props.evidence,
			duration = props.durationForAnalytics,
			acknowledgeable = props.acknowledgeable,
			abuseVector = props.abuseVectorForAnalytics
		})
	end, { v2 })

	local v8 = useCallback(function()
		if props.acknowledgeable and nonEmptyString then
			local v8 = false
			PostDismissIntervention(nonEmptyString):andThen(function(_)
				v8 = true
				InterventionAnalytics.sendAnalyticsEvent(
					InterventionAnalytics.TelemetryConfigs.DialogInterventionDismissSuccess,
					{
						eventType = InterventionAnalytics.Constants.EventTypes.DialogInterventionDismissSuccess,
						interventionType = props.interventionTypeForAnalytics,
						placement = placement,
						renderedTimestamp = v2.current,
						eventId = props.eventId,
						acknowledgeable = props.acknowledgeable,
						abuseVector = props.abuseVectorForAnalytics
					}
				)

				if props.onAcknowledgementSuccess then
					props.onAcknowledgementSuccess()
				end
			end):catch(function(p)
				InterventionAnalytics.sendAnalyticsEvent(
					InterventionAnalytics.TelemetryConfigs.DialogInterventionDismissFailed,
					{
						eventType = InterventionAnalytics.Constants.EventTypes.DialogInterventionDismissFailed,
						interventionType = props.interventionTypeForAnalytics,
						placement = placement,
						renderedTimestamp = v2.current,
						eventId = props.eventId,
						error = p.error,
						acknowledgeable = props.acknowledgeable,
						abuseVector = props.abuseVectorForAnalytics
					}
				)

				if not v8 and props.onAcknowledgementFailure then
					props.onAcknowledgementFailure()
				end
			end)
		end
	end, {
		props.acknowledgeable,
		nonEmptyString,
		props.interventionTypeForAnalytics,
		placement,
		v2.current,
		props.eventId,
		props.abuseVectorForAnalytics,
		props.onAcknowledgementSuccess,
		props.onAcknowledgementFailure
	})

	local v9 = useCallback(function()
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogCtaClicked, {
			eventType = InterventionAnalytics.Constants.EventTypes.CtaClicked,
			interventionType = props.interventionTypeForAnalytics,
			placement = placement,
			renderedTimestamp = v2.current,
			eventId = props.eventId,
			acknowledgeable = props.acknowledgeable,
			abuseVector = props.abuseVectorForAnalytics
		})

		v8()
		props.onDismiss()
	end, {
		props.onDismiss,
		props.interventionTypeForAnalytics,
		placement,
		v2.current,
		props.eventId,
		props.abuseVectorForAnalytics,
		props.acknowledgeable,
		nonEmptyString,
		v8,
		props.onAcknowledgementSuccess
	})

	local v10 = useCallback(function()
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogAppealClicked, {
			eventType = InterventionAnalytics.Constants.EventTypes.AppealClicked,
			interventionType = props.interventionTypeForAnalytics,
			placement = placement,
			renderedTimestamp = v2.current,
			eventId = props.eventId,
			acknowledgeable = props.acknowledgeable,
			abuseVector = props.abuseVectorForAnalytics
		})

		if props.useDetailedLayout and props.onAppeal then
			props.onAppeal()

			if not props.shouldOpenAppealsPortal then
				v8()
				props.onDismiss()

				NotificationModalsManager.SetUIBloxToast({
					iconImage = iconsactionsaccept,
					toastTitle = v3.TakeALookText,
					toastSubtitle = v3.FeedbackHelpsText,
					sequenceNumber = DateTime.now().UnixTimestamp,
					iconColorStyle = { Color = v.Color.System.Success.Color3, Transparency = 0 }
				})

				return
			end
		end

		if VRService.VREnabled or v4 then
			default:openURL(v5)
		else
			v7()
		end
	end, {
		v7,
		default,
		VRService.VREnabled,
		v4,
		props.interventionTypeForAnalytics,
		placement,
		v2.current,
		v5,
		props.abuseVectorForAnalytics,
		props.acknowledgeable,
		nonEmptyString,
		props.eventId,
		v3.FeedbackHelpsText,
		v3.TakeALookText,
		props.onAppeal,
		props.shouldOpenAppealsPortal,
		props.onDismiss,
		props.useDetailedLayout,
		v.Color.System.Success.Color3,
		v8
	})

	local children = {}
	local useDetailedLayout = props.useDetailedLayout

	if props.bodyText and props.bodyText ~= "" then
		children.BodyText = React.createElement(Text, {
			Text = props.bodyText,
			tag = "auto-xy text-body-medium content-default text-align-x-left text-wrap",
			testId = "dialog-body-text",
			LayoutOrder = 1
		})
	end

	if useDetailedLayout then
		local children2 = {}
		local v11 = FFlagUFRImprovements and nonEmptyString6 or nonEmptyString5 or nonEmptyString4

		if nonEmptyString3 then
			children2.EvidenceItem = React.createElement(
				View,
				{
					tag = "size-full-0 auto-y padding-x-medium",
					testId = "dialog-evidence-item",
					LayoutOrder = 1
				},
				{
					EvidenceText = React.createElement(Text, {
						Text = nonEmptyString3,
						tag = "auto-xy text-body-medium text-align-x-left text-wrap",
						RichText = true
					})
				}
			)

			if FFlagUFRImprovements and v11 then
				children2.DividerBelowEvidence = React.createElement(Divider, { LayoutOrder = 2 })
			end
		end

		if nonEmptyString6 then
			if not FFlagUFRImprovements and nonEmptyString3 then
				children2.DividerAfterEvidence = React.createElement(Divider, { LayoutOrder = 2 })
			end

			children2.ReasonItem = React.createElement(
				View,
				{
					tag = "size-full-0 auto-y padding-x-medium",
					testId = "dialog-reason-item",
					LayoutOrder = 3
				},
				{
					ReasonField = React.createElement(EvidenceField, {
						fieldLabel = v3.ReasonText,
						fieldValue = nonEmptyString6
					})
				}
			)
		end

		if nonEmptyString5 then
			children2.NoteItem = React.createElement(
				View,
				{
					tag = "size-full-0 auto-y padding-x-medium",
					testId = "dialog-note-item",
					LayoutOrder = 4
				},
				{
					NoteText = React.createElement(EvidenceField, {
						fieldLabel = v3.ModeratorNoteLabel,
						fieldValue = nonEmptyString5
					})
				}
			)
		end

		if nonEmptyString4 then
			children2.EndingOnItem = React.createElement(
				View,
				{
					tag = "size-full-0 auto-y row padding-x-medium align-y-center",
					testId = "dialog-ending-on-item",
					LayoutOrder = 5
				},
				{
					EndingOnInfo = React.createElement(View, {
						tag = {
							["col fill"] = true,
							["auto-xy"] = FFlagUFRDialogContentCutoffFix,
							["auto-y"] = not FFlagUFRDialogContentCutoffFix
						},
						LayoutOrder = 1
					}, {
						EvidenceField = React.createElement(EvidenceField, {
							fieldLabel = v3.EndsOnText,
							fieldValue = nonEmptyString4,
							hasColon = false
						})
					}),
					CountdownBadge = React.createElement(Badge, {
						text = props.countdownText or v3.CompleteText,
						variant = BadgeVariant.Neutral,
						icon = props.countdownText and {
							name = IconName.Clock,
							position = IconPosition.Left,
							variant = IconVariant.Filled
						} or nil,
						LayoutOrder = 2
					})
				}
			)
		end

		if not Cryo.isEmpty(children2) then
			children.DetailedList = React.createElement(
				View,
				{
					tag = "size-full-0 auto-y padding-top-xxsmall padding-x-xxsmall padding-bottom-medium",
					testId = "dialog-detailed-list",
					LayoutOrder = 2
				},
				React.createElement(
					View,
					{
						tag = "col gap-medium size-full-0 auto-y padding-y-large stroke-standard stroke-default radius-large bg-shift-100"
					},
					children2
				)
			)
		end
	elseif nonEmptyString3 or nonEmptyString6 or props.isAppealable then
		children.Evidence = React.createElement(View, {
			tag = "size-full-0 auto-y padding-xxsmall",
			LayoutOrder = 2
		}, {
			React.createElement(
				View,
				{
					tag = "size-full-0 auto-y col gap-small padding-medium radius-medium bg-surface-200 stroke-standard stroke-default"
				},
				{
					EvidenceText = nonEmptyString3 and React.createElement(Text, {
						Text = nonEmptyString3,
						tag = "auto-xy text-body-medium text-align-x-left text-wrap",
						RichText = true,
						LayoutOrder = 1
					}),
					Reason = nonEmptyString6 and React.createElement(Text, {
						Text = `<b>{v3.ReasonText}:</b>\n{nonEmptyString6}`,
						tag = "auto-xy text-body-medium text-align-x-left text-wrap",
						RichText = true,
						LayoutOrder = 2
					}),
					AppealButton = props.isAppealable and React.createElement(Button, {
						text = v3.ReportMistakeText,
						variant = ButtonVariant.Standard,
						size = ButtonSize.XSmall,
						width = UDim.new(1, 0),
						onActivated = v10,
						LayoutOrder = 3
					})
				}
			)
		})
	end

	if nonEmptyString2 and not useDetailedLayout then
		children.DsaMessage = React.createElement(Text, {
			Text = nonEmptyString2,
			tag = "auto-xy text-caption-small content-default text-align-x-left text-wrap",
			LayoutOrder = 3
		})
	end

	local actions = {
		{
			variant = ButtonVariant.Emphasis,
			size = ButtonSize.Small,
			text = v3.OkText,
			onActivated = v9
		}
	}

	local createElement = React.createElement
	local root = Dialog.Root
	local v11 = {
		size = DialogSize.Medium,
		hasCloseButton = false,
		ref = ref,
		hasBackdrop = not VRService.VREnabled,
		disablePortal = placement ~= Constants.InterventionPlacementType.InExperience
	}
	local v12 = {
		DialogTitle = not props.isLoading and React.createElement(Dialog.Title, {
			text = props.titleText
		}),
		DialogContent = 0,
		DialogFooter = 0,
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local content = Dialog.Content
	local v13

	if props.isLoading then
		v13 = React.createElement(InterventionDialogLoadingSkeleton)
	else
		v13 = React.createElement(View, { tag = "size-full-0 auto-y col gap-medium" }, children)
	end

	v12.DialogContent = createElement2(content, useDetailedLayout and { LayoutOrder = 2 } or nil, v13)

	v12.DialogFooter = not props.isLoading and useDetailedLayout and React.createElement(InterventionDialogFooter, {
		ctaText = v3.OkText,
		dsaMessage = props.dsaMessage,
		isAppealable = props.isAppealable,
		onAppealActivated = v10,
		onCtaActivated = v9
	})

	v12.DialogActions = not props.isLoading
		and not useDetailedLayout
		and React.createElement(Dialog.Actions, { actions = actions })
	return createElement(root, v11, v12)
end

return React.memo(GenericInterventionDialog)
