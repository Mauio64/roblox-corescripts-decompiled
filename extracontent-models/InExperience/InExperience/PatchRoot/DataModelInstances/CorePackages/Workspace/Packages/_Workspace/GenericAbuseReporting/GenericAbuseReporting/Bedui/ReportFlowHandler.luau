local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local Players = game:GetService("Players")

local ArgCheck = require(parent.ArgCheck)
local Cryo = require(parent.Cryo)
local Dash = require(parent.Dash)
local React = require(parent.React)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local Foundation = require(parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Empty = Foundation.Empty
local FillBehavior = Foundation.Enums.FillBehavior
local Radius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local UIBlox = require(parent.UIBlox)
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local useTokens = Foundation.Hooks.useTokens

local AbuseReportBeduiTypes = require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
local AbuseReportBeduiContextStatus = AbuseReportBeduiTypes.AbuseReportBeduiContextStatus
local AbuseCategory = require(GenericAbuseReporting.Enums.AbuseCategory)
local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)
local BeduiAnalytics = require(GenericAbuseReporting.Bedui.Utils.BeduiAnalytics)
local createReport = require(GenericAbuseReporting.Bedui.Utils.createReport)
local getReportBody = require(GenericAbuseReporting.Bedui.Utils.getReportBody)
local getReportTags = require(GenericAbuseReporting.Bedui.Utils.getReportTags)
local InnerContentConfigType = AbuseReportBeduiTypes.InnerContentConfigType
local sendAnalyticsEvent = BeduiAnalytics.sendAnalyticsEvent
local SingleStepContainer = require(GenericAbuseReporting.Bedui.SingleStepContainer)
local SingleStepInnerContentRenderer = require(GenericAbuseReporting.Bedui.SingleStepInnerContentRenderer)
local Stepper = require(GenericAbuseReporting.Common.Stepper)
local TelemetryEventType = BeduiAnalytics.TelemetryEventType
local submitReport = require(GenericAbuseReporting.Bedui.Utils.submitReport)
local submitReportV1 = require(GenericAbuseReporting.Bedui.Utils.submitReportV1)
local useAnalyticsContext = require(GenericAbuseReporting.Bedui.Provider.useAnalyticsContext)
local useBeduiData = require(GenericAbuseReporting.Bedui.Provider.useBeduiData)
local useFormData = require(GenericAbuseReporting.Bedui.Provider.useFormData)
local validateBeduiData = require(GenericAbuseReporting.Bedui.Provider.validateBeduiData)
local ValueToAbuseCategory = require(GenericAbuseReporting.Enums.ValueToAbuseCategory)

local SharedFlags = require(parent.SharedFlags)
local FFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport
local FFlagGenericAbuseReportingUnifyReportTags = require(GenericAbuseReporting.Flags.FFlagGenericAbuseReportingUnifyReportTags)

local function ReportFlowHandler(props)
	local v = useTokens()
	local state, setState = React.useState({})
	local v2 = useBeduiData()
	local formData = useFormData().formData
	local additionalReportTags = useFormData().additionalReportTags
	local v3 = useRoactService(RoactNetworking)

	local context = useAnalyticsContext()
	local isReportSubmitted = context.isReportSubmitted
	local setIsReportSubmitted = context.setIsReportSubmitted

	local v4 = useLayerCollector().absoluteSize.X < 540

	local v5 = React.useMemo(function(): boolean
		return v2 == nil or v2.status == AbuseReportBeduiContextStatus.Loading
	end, { v2 })

	local v6 = React.useMemo(function(): boolean
		if v5 or v2 == nil then
			return true
		end

		local v6, v7 = validateBeduiData(v2.beduiData)

		if v6 then
			return v2.status == AbuseReportBeduiContextStatus.Error
		end

		sendAnalyticsEvent({
			eventType = TelemetryEventType.Error,
			context = context,
			meta = {
				error = `ReportFlowHandler - Invalid Bedui data: {tostring(v7)}`
			}
		})

		return true
	end, { v2, v5, validateBeduiData, sendAnalyticsEvent, context })

	local v7 = React.useCallback(function(p): boolean
		if p == nil then
			return true
		end

		local v7 = false

		if p.type ~= InnerContentConfigType.ConfigurableComponentList then
			return true
		end

		for _, component in p.configurableComponentList.components do
			if component.isOptional or formData[component.formDataKey] ~= nil then
				continue
			end

			setState(Cryo.List.join(state, { component.formDataKey }))
			v7 = true
		end

		return not v7
	end, { formData, state })

	local v8 = React.useCallback(function()
		local localPlayer = Players.LocalPlayer

		if localPlayer == nil then
			sendAnalyticsEvent({
				eventType = TelemetryEventType.Error,
				context = context,
				meta = { error = "ReportFlowHandler - LocalPlayer is nil" }
			})
		elseif props.abuseVector == AbuseVector.AdV2 then
			submitReportV1(v3, (getReportBody({
				abuseVector = props.abuseVector,
				formData = formData,
				localPlayerUserId = localPlayer.UserId,
				targetIdStr = props.targetId,
				additionalReportTags = additionalReportTags
			}))):andThen(function(_)
				sendAnalyticsEvent({ eventType = TelemetryEventType.Submitted, context = context })

				if props.onSubmit then
					props.onSubmit()
				end
			end):catch(function(p)
				local pretty = Dash.pretty(p, { depth = 10 })
				sendAnalyticsEvent({
					eventType = TelemetryEventType.Error,
					context = context,
					meta = {
						error = `ReportFlowHandler - Submitting v1 report: {pretty}`
					}
				})
			end)
		elseif FFlagGenericAbuseReportingUnifyReportTags or FFlagAddThumbnailSelectorReport then
			submitReport(v3, (getReportTags({
				formData = formData,
				localPlayerUserId = tostring(localPlayer.UserId),
				abuseVector = props.abuseVector,
				targetId = props.targetId,
				custom = props.custom,
				additionalReportTags = additionalReportTags
			}))):andThen(function(_)
				sendAnalyticsEvent({ eventType = TelemetryEventType.Submitted, context = context })

				if props.onSubmit then
					props.onSubmit()
				end
			end):catch(function(p)
				local pretty = Dash.pretty(p, { depth = 10 })
				sendAnalyticsEvent({
					eventType = TelemetryEventType.Error,
					context = context,
					meta = {
						error = `ReportFlowHandler - Submitting report: {pretty}`
					}
				})
			end)
		else
			submitReport(v3, (createReport({
				abuseCategory = ValueToAbuseCategory[formData.legacy_abuse_category] or formData.abuse_category or AbuseCategory.ABUSE_CATEGORY_INVALID,
				abuseVector = props.abuseVector,
				comment = formData.free_comment,
				submitterId = tostring(localPlayer.UserId),
				targetId = props.targetId,
				custom = props.custom
			}))):andThen(function(_)
				sendAnalyticsEvent({ eventType = TelemetryEventType.Submitted, context = context })
			end):catch(function(p)
				local pretty = Dash.pretty(p, { depth = 10 })
				sendAnalyticsEvent({
					eventType = TelemetryEventType.Error,
					context = context,
					meta = {
						error = `ReportFlowHandler - Submitting report: {pretty}`
					}
				})
			end)
		end
	end, {
		formData,
		Players.LocalPlayer,
		props.abuseVector,
		props.targetId,
		sendAnalyticsEvent,
		context
	})

	local steps = React.useMemo(function()
		if v5 then
			return {}
		end

		if v6 or not (v2.beduiData and v2.beduiData.nodes) then
			sendAnalyticsEvent({
				eventType = TelemetryEventType.Error,
				context = context,
				meta = { error = "ReportFlowHandler - Invalid Bedui data or no nodes found" }
			})

			return {}
		end

		local result = {}

		for _, node in v2.beduiData.nodes do
			local joinDeep = Dash.joinDeep({}, node)

			local innerContentConfig = joinDeep.innerContentConfig
			local footerContentConfig = v4 and node.footerContentConfig

			local contentConfig = footerContentConfig and {
				type = innerContentConfig.type,
				configurableComponentList = {
					components = Cryo.List.join(
						innerContentConfig.configurableComponentList.components,
						joinDeep.footerContentConfig.configurableComponentList.components
					)
				}
			} or innerContentConfig

			if result[joinDeep.stepId] ~= nil then
				sendAnalyticsEvent({
					eventType = TelemetryEventType.Error,
					context = context,
					meta = {
						error = `ReportFlowHandler - Duplicate stepId found: {tostring(joinDeep.stepId)}`
					}
				})

				return {}
			end

			local stepId = joinDeep.stepId
			local v9 = {
				stepId = joinDeep.stepId,
				predefinedNextStepId = joinDeep.actionInfo.predefinedNextStepId,
				content = React.createElement(SingleStepContainer, {
					node = joinDeep,
					contentConfig = contentConfig,
					formDataKeysWithError = state
				}),
				footer = 0,
				labels = 0,
				onStepCancel = nil,
				onStepContinue = 0,
				validateState = 0,
				stepStyle = 0
			}
			local footer

			if joinDeep.footerContentConfig and not footerContentConfig then
				footer = React.createElement(SingleStepInnerContentRenderer, {
					contentConfig = joinDeep.footerContentConfig,
					formDataKeysWithError = state
				})
			end

			v9.footer = footer

			v9.labels = { continueButton = joinDeep.actionInfo.actionLabel }

			function v9.onStepContinue()
				ArgCheck.assert(isReportSubmitted == false, "Report should only be able to be submitted once")

				if isReportSubmitted then
					sendAnalyticsEvent({
						eventType = TelemetryEventType.Error,
						context = context,
						meta = {
							error = `ReportFlowHandler - Report already submitted for stepId: {tostring(joinDeep.stepId)}`
						}
					})
				end

				if joinDeep.actionInfo.shouldSubmit and not isReportSubmitted then
					v8()
					setIsReportSubmitted(true)
				end
			end
			function v9.validateState()
				return v7(contentConfig)
			end

			local variant

			if joinDeep.actionInfo.shouldSubmit then
				variant = ButtonVariant.Emphasis
			else
				variant = ButtonVariant.Standard
			end

			local fillBehavior

			if v4 then
				fillBehavior = FillBehavior.Fill
			else
				fillBehavior = FillBehavior.Fit
			end

			v9.stepStyle = {
				continueButton = { variant = variant, fillBehavior = fillBehavior },
				buttonXAlignment = "align-x-right"
			}
			result[stepId] = v9
		end

		return result
	end, {
		v5,
		v6,
		v2,
		state,
		v4,
		v8,
		v7,
		isReportSubmitted,
		sendAnalyticsEvent,
		context
	})

	if v5 then
		return (React.createElement(Skeleton, {
			radius = Radius.Medium,
			Size = UDim2.new(1, 0, 0, v.Size.Size_2500)
		}))
	end

	if v6 or not next(steps) then
		return (React.createElement(Empty, {}))
	end

	if next(steps) and v2.beduiData then
		return (React.createElement(Stepper, {
			currentStep = v2.beduiData.rootStepId,
			steps = steps
		}))
	end

	return nil
end

return React.memo(ReportFlowHandler)
