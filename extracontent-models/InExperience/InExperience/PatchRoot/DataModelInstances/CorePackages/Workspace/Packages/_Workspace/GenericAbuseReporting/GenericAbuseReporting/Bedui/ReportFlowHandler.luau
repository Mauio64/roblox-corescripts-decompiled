local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Players = game:GetService("Players")
local ArgCheck = require(GenericAbuseReportingParent.ArgCheck)
local Cryo = require(GenericAbuseReportingParent.Cryo)
local Dash = require(GenericAbuseReportingParent.Dash)
local React = require(GenericAbuseReportingParent.React)
local RoactNetworking = require(GenericAbuseReportingParent.RoactServiceTags).RoactNetworking
local Foundation = require(GenericAbuseReportingParent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Empty = Foundation.Empty
local FillBehavior = Foundation.Enums.FillBehavior
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local useLayerCollector = require(GenericAbuseReportingParent.UIBlox).Core.Layout.LayerCollector.useLayerCollector
local useRoactService = require(GenericAbuseReportingParent.RobloxAppHooks).useRoactService
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
local FFlagAddThumbnailSelectorReport = require(GenericAbuseReportingParent.SharedFlags).FFlagAddThumbnailSelectorReport

local function ReportFlowHandler(t1: {[any]: any}) -- line: 61
	-- upvalues: useTokens (copy), React (copy), useBeduiData (copy), useFormData (copy), useRoactService (copy), RoactNetworking (copy), useAnalyticsContext (copy), useLayerCollector (copy), AbuseReportBeduiContextStatus (copy), validateBeduiData (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), InnerContentConfigType (copy), Cryo (copy), Players (copy), AbuseVector (copy), getReportBody (copy), submitReportV1 (copy), Dash (copy), FFlagAddThumbnailSelectorReport (copy), getReportTags (copy), submitReport (copy), createReport (copy), ValueToAbuseCategory (copy), AbuseCategory (copy), SingleStepContainer (copy), SingleStepInnerContentRenderer (copy), ArgCheck (copy), ButtonVariant (copy), FillBehavior (copy), Skeleton (copy), EnumsRadius (copy), Empty (copy), Stepper (copy)
	local v42 = useTokens()
	local v43, v44 = React.useState({})
	local v45 = useBeduiData()
	local formData = useFormData().formData
	local additionalReportTags = useFormData().additionalReportTags
	local v48 = useRoactService(RoactNetworking)
	local v49 = useAnalyticsContext()
	local isReportSubmitted = v49.isReportSubmitted
	local setIsReportSubmitted = v49.setIsReportSubmitted
	local v52 = useLayerCollector().absoluteSize.X < 540
	local v53 = React.useMemo(function() -- line: 77
		-- upvalues: v45 (copy), AbuseReportBeduiContextStatus (copy)
		return v45 == nil or v45.status == AbuseReportBeduiContextStatus.Loading
	end, { v45 })
	local v54 = React.useMemo(function() -- line: 81
		-- upvalues: v53 (copy), v45 (copy), validateBeduiData (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v49 (copy), AbuseReportBeduiContextStatus (copy)
		if v53 or v45 == nil then
			return true
		end

		local v58, v59 = validateBeduiData(v45.beduiData)

		if not v58 then
			sendAnalyticsEvent({
				eventType = TelemetryEventType.Error,
				context = v49,
				meta = {
					error = `ReportFlowHandler - Invalid Bedui data: { tostring(v59) }`
				}
			})

			return true
		end

		return v45.status == AbuseReportBeduiContextStatus.Error
	end, {
		v45,
		v53,
		validateBeduiData,
		sendAnalyticsEvent,
		v49
	})
	local v55 = React.useCallback(function(p1) -- line: 100
		-- upvalues: InnerContentConfigType (copy), formData (copy), v44 (copy), Cryo (copy), v43 (copy)
		if p1 == nil then
			return true
		end

		local v61 = false

		if p1.type == InnerContentConfigType.ConfigurableComponentList then
			for _, v63 in p1.configurableComponentList.components do
				if not v63.isOptional and formData[v63.formDataKey] == nil then
					v61 = true
					v44(Cryo.List.join(v43, { v63.formDataKey }))
				end
			end
		end

		return not v61
	end, {
		formData,
		v43
	})
	local v56 = React.useCallback(function() -- line: 119
		-- upvalues: Players (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v49 (copy), t1 (copy), AbuseVector (copy), getReportBody (copy), formData (copy), additionalReportTags (copy), submitReportV1 (copy), v48 (copy), Dash (copy), FFlagAddThumbnailSelectorReport (copy), getReportTags (copy), submitReport (copy), createReport (copy), ValueToAbuseCategory (copy), AbuseCategory (copy)
		local LocalPlayer = Players.LocalPlayer

		if LocalPlayer == nil then
			sendAnalyticsEvent({
				eventType = TelemetryEventType.Error,
				context = v49,
				meta = {
					error = "ReportFlowHandler - LocalPlayer is nil"
				}
			})

			return
		end

		if t1.abuseVector == AbuseVector.AdV2 then
			local v65 = getReportBody({
				abuseVector = t1.abuseVector,
				formData = formData,
				localPlayerUserId = LocalPlayer.UserId,
				targetIdStr = t1.targetId,
				additionalReportTags = additionalReportTags
			})

			submitReportV1(v48, v65):andThen(function(_) -- line: 141
				-- upvalues: sendAnalyticsEvent (copy), TelemetryEventType (copy), v49 (copy), t1 (copy)
				sendAnalyticsEvent({
					eventType = TelemetryEventType.Submitted,
					context = v49
				})

				if t1.onSubmit then
					t1.onSubmit()
				end
			end):catch(function(p3) -- line: 150
				-- upvalues: Dash (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v49 (copy)
				local v76 = Dash.pretty(p3, {
					depth = 10
				})

				sendAnalyticsEvent({
					eventType = TelemetryEventType.Error,
					context = v49,
					meta = {
						error = `ReportFlowHandler - Submitting v1 report: { v76 }`
					}
				})
			end)

			return
		end

		if FFlagAddThumbnailSelectorReport then
			local v66 = getReportTags({
				formData = formData,
				localPlayerUserId = tostring(LocalPlayer.UserId),
				abuseVector = t1.abuseVector,
				targetId = t1.targetId,
				custom = t1.custom,
				additionalReportTags = additionalReportTags
			})

			submitReport(v48, v66):andThen(function(_) -- line: 171
				-- upvalues: sendAnalyticsEvent (copy), TelemetryEventType (copy), v49 (copy), t1 (copy)
				sendAnalyticsEvent({
					eventType = TelemetryEventType.Submitted,
					context = v49
				})

				if t1.onSubmit then
					t1.onSubmit()
				end
			end):catch(function(p5) -- line: 180
				-- upvalues: Dash (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v49 (copy)
				local v79 = Dash.pretty(p5, {
					depth = 10
				})

				sendAnalyticsEvent({
					eventType = TelemetryEventType.Error,
					context = v49,
					meta = {
						error = `ReportFlowHandler - Submitting report: { v79 }`
					}
				})
			end)

			return
		end

		local v67 = createReport({
			abuseCategory = ValueToAbuseCategory[formData.legacy_abuse_category] or (formData.abuse_category or AbuseCategory.ABUSE_CATEGORY_INVALID),
			abuseVector = t1.abuseVector,
			comment = formData.free_comment,
			submitterId = tostring(LocalPlayer.UserId),
			targetId = t1.targetId,
			custom = t1.custom
		})

		submitReport(v48, v67):andThen(function(_) -- line: 202
			-- upvalues: sendAnalyticsEvent (copy), TelemetryEventType (copy), v49 (copy)
			sendAnalyticsEvent({
				eventType = TelemetryEventType.Submitted,
				context = v49
			})
		end):catch(function(p7) -- line: 208
			-- upvalues: Dash (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v49 (copy)
			local v82 = Dash.pretty(p7, {
				depth = 10
			})

			sendAnalyticsEvent({
				eventType = TelemetryEventType.Error,
				context = v49,
				meta = {
					error = `ReportFlowHandler - Submitting report: { v82 }`
				}
			})
		end)
	end, {
		formData,
		Players.LocalPlayer,
		t1.abuseVector,
		t1.targetId,
		sendAnalyticsEvent,
		v49
	})
	local v57 = React.useMemo(function() -- line: 231
		-- upvalues: v53 (copy), v54 (copy), v45 (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v49 (copy), Dash (copy), v52 (copy), Cryo (copy), React (copy), SingleStepContainer (copy), v43 (copy), SingleStepInnerContentRenderer (copy), ArgCheck (copy), isReportSubmitted (copy), v56 (copy), setIsReportSubmitted (copy), v55 (copy), ButtonVariant (copy), FillBehavior (copy)
		if v53 then
			return {}
		end

		if v54 or not v45.beduiData or not v45.beduiData.nodes then
			sendAnalyticsEvent({
				eventType = TelemetryEventType.Error,
				context = v49,
				meta = {
					error = "ReportFlowHandler - Invalid Bedui data or no nodes found"
				}
			})

			return {}
		end

		local t2 = {}

		for _, v70 in v45.beduiData.nodes do
			local v71 = Dash.joinDeep({}, v70)
			local innerContentConfig = v71.innerContentConfig
			local v73 = v52 and v70.footerContentConfig

			if v73 then
				innerContentConfig = {
					type = innerContentConfig.type,
					configurableComponentList = {
						components = Cryo.List.join(innerContentConfig.configurableComponentList.components, v71.footerContentConfig.configurableComponentList.components)
					}
				}
			end

			if t2[v71.stepId] ~= nil then
				sendAnalyticsEvent({
					eventType = TelemetryEventType.Error,
					context = v49,
					meta = {
						error = `ReportFlowHandler - Duplicate stepId found: { tostring(v71.stepId) }`
					}
				})

				return {}
			end

			t2[v71.stepId] = {
				onStepCancel = nil,
				stepId = v71.stepId,
				predefinedNextStepId = v71.actionInfo.predefinedNextStepId,
				content = React.createElement(SingleStepContainer, {
					node = v71,
					contentConfig = innerContentConfig,
					formDataKeysWithError = v43
				}),
				footer = if not v71.footerContentConfig or v73 then nil else React.createElement(SingleStepInnerContentRenderer, {
					contentConfig = v71.footerContentConfig,
					formDataKeysWithError = v43
				}),
				labels = {
					continueButton = v71.actionInfo.actionLabel
				},
				onStepContinue = function() -- line: 294
					-- upvalues: ArgCheck (copy), isReportSubmitted (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v49 (copy), v71 (copy), v56 (copy), setIsReportSubmitted (copy)
					ArgCheck.assert(isReportSubmitted == false, "Report should only be able to be submitted once")

					if isReportSubmitted then
						sendAnalyticsEvent({
							eventType = TelemetryEventType.Error,
							context = v49,
							meta = {
								error = `ReportFlowHandler - Report already submitted for stepId: { tostring(v71.stepId) }`
							}
						})
					end

					if v71.actionInfo.shouldSubmit and not isReportSubmitted then
						v56()
						setIsReportSubmitted(true)
					end
				end,
				validateState = function() -- line: 312
					-- upvalues: v55 (copy), innerContentConfig (ref)
					return v55(innerContentConfig)
				end,
				stepStyle = {
					buttonXAlignment = "align-x-right",
					continueButton = {
						variant = if not v71.actionInfo.shouldSubmit then ButtonVariant.Standard else ButtonVariant.Emphasis,
						fillBehavior = if not v52 then FillBehavior.Fit else FillBehavior.Fill
					}
				}
			}
		end

		return t2
	end, {
		v53,
		v54,
		v45,
		v43,
		v52,
		v56,
		v55,
		isReportSubmitted,
		sendAnalyticsEvent,
		v49
	})

	if v53 then
		return (React.createElement(Skeleton, {
			radius = EnumsRadius.Medium,
			Size = UDim2.new(1, 0, 0, v42.Size.Size_2500)
		}))
	end

	if v54 or not next(v57) then
		return (React.createElement(Empty, {}))
	end

	if next(v57) and v45.beduiData then
		return (React.createElement(Stepper, {
			currentStep = v45.beduiData.rootStepId,
			steps = v57
		}))
	end

	return nil
end

return React.memo(ReportFlowHandler)
