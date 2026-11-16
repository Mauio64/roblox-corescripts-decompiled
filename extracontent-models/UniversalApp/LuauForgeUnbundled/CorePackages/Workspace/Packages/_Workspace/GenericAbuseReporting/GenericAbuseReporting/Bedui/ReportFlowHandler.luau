local Players = game:GetService("Players")

local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/ArgCheck")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Cryo")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Dash")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RoactServiceTags").RoactNetworking
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local buttonVariant = Foundation.Enums.ButtonVariant
local empty = Foundation.Empty
local fillBehavior = Foundation.Enums.FillBehavior
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton
local useLayerCollector = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/UIBlox").Core.Layout.LayerCollector.useLayerCollector
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RobloxAppHooks").useRoactService
local useTokens = Foundation.Hooks.useTokens

local AbuseReportBeduiTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes")
local abuseReportBeduiContextStatus = AbuseReportBeduiTypes.AbuseReportBeduiContextStatus
local AbuseCategory = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseCategory")
local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")
local BeduiAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Utils/BeduiAnalytics")
local createReport = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Utils/createReport")
local getReportBody = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Utils/getReportBody")
local getReportTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Utils/getReportTags")
local innerContentConfigType = AbuseReportBeduiTypes.InnerContentConfigType
local sendAnalyticsEvent = BeduiAnalytics.sendAnalyticsEvent
local SingleStepContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/SingleStepContainer")
local SingleStepInnerContentRenderer = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/SingleStepInnerContentRenderer")
local Stepper = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/Stepper")
local telemetryEventType = BeduiAnalytics.TelemetryEventType
local submitReport = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Utils/submitReport")
local submitReportV1 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Utils/submitReportV1")
local useAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/useAnalyticsContext")
local useBeduiData = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/useBeduiData")
local useFormData = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/useFormData")
local validateBeduiData = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/validateBeduiData")
local ValueToAbuseCategory = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/ValueToAbuseCategory")

local fFlagAddThumbnailSelectorReport = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagAddThumbnailSelectorReport
local FFlagGenericAbuseReportingUnifyReportTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagGenericAbuseReportingUnifyReportTags")

local function ReportFlowHandler(props)
	local v5 = useTokens()
	local state, setState = React.useState({})
	local v6 = useBeduiData()
	local formData = useFormData().formData
	local additionalReportTags = useFormData().additionalReportTags
	local v7 = useRoactService(roactNetworking)

	local v8 = useAnalyticsContext()
	local isReportSubmitted = v8.isReportSubmitted
	local setIsReportSubmitted = v8.setIsReportSubmitted

	local v9 = useLayerCollector().absoluteSize.X < 540

	local v10 = React.useMemo(function(): boolean
		return v6 == nil or v6.status == abuseReportBeduiContextStatus.Loading
	end, { v6 })

	local v11 = React.useMemo(function(): boolean
		if v10 or v6 == nil then
			return true
		end

		local v12, v13 = validateBeduiData(v6.beduiData)

		if v12 then
			return v6.status == abuseReportBeduiContextStatus.Error
		end

		sendAnalyticsEvent({
			eventType = telemetryEventType.Error,
			context = v8,
			meta = {
				error = `ReportFlowHandler - Invalid Bedui data: {tostring(v13)}`
			}
		})

		return true
	end, { v6, v10, validateBeduiData, sendAnalyticsEvent, v8 })

	local v12 = React.useCallback(function(p2): boolean
		if p2 == nil then
			return true
		end

		local v13 = false

		if p2.type ~= innerContentConfigType.ConfigurableComponentList then
			return true
		end

		for k, component in p2.configurableComponentList.components do
			if component.isOptional or formData[component.formDataKey] ~= nil then
				continue
			end

			setState(Cryo.List.join(state, { component.formDataKey }))
			v13 = true
		end

		return not v13
	end, { formData, state })

	local v13 = React.useCallback(function()
		local localPlayer = Players.LocalPlayer

		if localPlayer == nil then
			sendAnalyticsEvent({
				eventType = telemetryEventType.Error,
				context = v8,
				meta = { error = "ReportFlowHandler - LocalPlayer is nil" }
			})
		elseif props.abuseVector == AbuseVector.AdV2 then
			submitReportV1(v7, (getReportBody({
				abuseVector = props.abuseVector,
				formData = formData,
				localPlayerUserId = localPlayer.UserId,
				targetIdStr = props.targetId,
				additionalReportTags = additionalReportTags
			}))):andThen(function(p2)
				sendAnalyticsEvent({
					eventType = telemetryEventType.Submitted,
					context = v8
				})

				if props.onSubmit then
					props.onSubmit()
				end
			end):catch(function(p2)
				local pretty = Dash.pretty(p2, { depth = 10 })
				sendAnalyticsEvent({
					eventType = telemetryEventType.Error,
					context = v8,
					meta = {
						error = `ReportFlowHandler - Submitting v1 report: {pretty}`
					}
				})
			end)
		elseif FFlagGenericAbuseReportingUnifyReportTags or fFlagAddThumbnailSelectorReport then
			submitReport(v7, (getReportTags({
				formData = formData,
				localPlayerUserId = tostring(localPlayer.UserId),
				abuseVector = props.abuseVector,
				targetId = props.targetId,
				custom = props.custom,
				additionalReportTags = additionalReportTags
			}))):andThen(function(p2)
				sendAnalyticsEvent({
					eventType = telemetryEventType.Submitted,
					context = v8
				})

				if props.onSubmit then
					props.onSubmit()
				end
			end):catch(function(p2)
				local pretty = Dash.pretty(p2, { depth = 10 })
				sendAnalyticsEvent({
					eventType = telemetryEventType.Error,
					context = v8,
					meta = {
						error = `ReportFlowHandler - Submitting report: {pretty}`
					}
				})
			end)
		else
			submitReport(v7, (createReport({
				abuseCategory = ValueToAbuseCategory[formData.legacy_abuse_category] or formData.abuse_category or AbuseCategory.ABUSE_CATEGORY_INVALID,
				abuseVector = props.abuseVector,
				comment = formData.free_comment,
				submitterId = tostring(localPlayer.UserId),
				targetId = props.targetId,
				custom = props.custom
			}))):andThen(function(p2)
				sendAnalyticsEvent({
					eventType = telemetryEventType.Submitted,
					context = v8
				})
			end):catch(function(p2)
				local pretty = Dash.pretty(p2, { depth = 10 })
				sendAnalyticsEvent({
					eventType = telemetryEventType.Error,
					context = v8,
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
		v8
	})

	local v14 = React.useMemo(function()
		if v10 then
			return {}
		end

		if v11 or not (v6.beduiData and v6.beduiData.nodes) then
			sendAnalyticsEvent({
				eventType = telemetryEventType.Error,
				context = v8,
				meta = {
					error = "ReportFlowHandler - Invalid Bedui data or no nodes found"
				}
			})

			return {}
		end

		local result = {}

		for k, node in v6.beduiData.nodes do
			local joinDeep = Dash.joinDeep({}, node)

			local innerContentConfig = joinDeep.innerContentConfig
			local footerContentConfig = v9 and node.footerContentConfig

			local v15 = footerContentConfig and {
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
					eventType = telemetryEventType.Error,
					context = v8,
					meta = {
						error = `ReportFlowHandler - Duplicate stepId found: {tostring(joinDeep.stepId)}`
					}
				})

				return {}
			end

			local stepId = joinDeep.stepId
			local v16 = {
				stepId = joinDeep.stepId,
				predefinedNextStepId = joinDeep.actionInfo.predefinedNextStepId,
				content = React.createElement(SingleStepContainer, {
					node = joinDeep,
					contentConfig = v15,
					formDataKeysWithError = state
				}),
				footer = 0,
				labels = 0,
				onStepCancel = nil,
				onStepContinue = 0,
				validateState = 0,
				stepStyle = 0
			}

			local v17 = if joinDeep.footerContentConfig and not footerContentConfig then React.createElement(SingleStepInnerContentRenderer, {
				contentConfig = joinDeep.footerContentConfig,
				formDataKeysWithError = state
			}) else nil
			v16.footer = v17

			v16.labels = { continueButton = joinDeep.actionInfo.actionLabel }

			function v16.onStepContinue()
				ArgCheck.assert(isReportSubmitted == false, "Report should only be able to be submitted once")

				if isReportSubmitted then
					sendAnalyticsEvent({
						eventType = telemetryEventType.Error,
						context = v8,
						meta = {
							error = `ReportFlowHandler - Report already submitted for stepId: {tostring(joinDeep.stepId)}`
						}
					})
				end

				if joinDeep.actionInfo.shouldSubmit and not isReportSubmitted then
					v13()
					setIsReportSubmitted(true)
				end
			end
			function v16.validateState()
				return v12(v15)
			end

			local v20 = if joinDeep.actionInfo.shouldSubmit then buttonVariant.Emphasis else buttonVariant.Standard
			local v21 = if v9 then fillBehavior.Fill else fillBehavior.Fit
			v16.stepStyle = {
				continueButton = { variant = v20, fillBehavior = v21 },
				buttonXAlignment = "align-x-right"
			}
			result[stepId] = v16
		end

		return result
	end, {
		v10,
		v11,
		v6,
		state,
		v9,
		v13,
		v12,
		isReportSubmitted,
		sendAnalyticsEvent,
		v8
	})

	if v10 then
		return (React.createElement(skeleton, {
			radius = radius.Medium,
			Size = UDim2.new(1, 0, 0, v5.Size.Size_2500)
		}))
	end

	if v11 or not next(v14) then
		return (React.createElement(empty, {}))
	end

	if next(v14) and v6.beduiData then
		return (React.createElement(Stepper, {
			currentStep = v6.beduiData.rootStepId,
			steps = v14
		}))
	end

	return nil
end

return React.memo(ReportFlowHandler)
