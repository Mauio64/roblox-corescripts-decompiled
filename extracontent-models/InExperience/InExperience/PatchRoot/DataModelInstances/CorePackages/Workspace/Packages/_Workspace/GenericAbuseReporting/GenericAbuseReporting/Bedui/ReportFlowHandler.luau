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
local FFlagGenericAbuseReportingUnifyReportTags = require(GenericAbuseReporting.Flags.FFlagGenericAbuseReportingUnifyReportTags)

local function ReportFlowHandler(t1: {[any]: any}) -- line: 62
	-- upvalues: useTokens (copy), React (copy), useBeduiData (copy), useFormData (copy), useRoactService (copy), RoactNetworking (copy), useAnalyticsContext (copy), useLayerCollector (copy), AbuseReportBeduiContextStatus (copy), validateBeduiData (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), InnerContentConfigType (copy), Cryo (copy), Players (copy), AbuseVector (copy), getReportBody (copy), submitReportV1 (copy), Dash (copy), FFlagGenericAbuseReportingUnifyReportTags (copy), FFlagAddThumbnailSelectorReport (copy), getReportTags (copy), submitReport (copy), createReport (copy), ValueToAbuseCategory (copy), AbuseCategory (copy), SingleStepContainer (copy), SingleStepInnerContentRenderer (copy), ArgCheck (copy), ButtonVariant (copy), FillBehavior (copy), Skeleton (copy), EnumsRadius (copy), Empty (copy), Stepper (copy)
	local v43 = useTokens()
	local v44, v45 = React.useState({})
	local v46 = useBeduiData()
	local formData = useFormData().formData
	local additionalReportTags = useFormData().additionalReportTags
	local v49 = useRoactService(RoactNetworking)
	local v50 = useAnalyticsContext()
	local isReportSubmitted = v50.isReportSubmitted
	local setIsReportSubmitted = v50.setIsReportSubmitted
	local v53 = useLayerCollector().absoluteSize.X < 540
	local v54 = React.useMemo(function() -- line: 78
		-- upvalues: v46 (copy), AbuseReportBeduiContextStatus (copy)
		return v46 == nil or v46.status == AbuseReportBeduiContextStatus.Loading
	end, { v46 })
	local v55 = React.useMemo(function() -- line: 82
		-- upvalues: v54 (copy), v46 (copy), validateBeduiData (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v50 (copy), AbuseReportBeduiContextStatus (copy)
		if v54 or v46 == nil then
			return true
		end

		local v59, v60 = validateBeduiData(v46.beduiData)

		if not v59 then
			sendAnalyticsEvent({
				eventType = TelemetryEventType.Error,
				context = v50,
				meta = {
					error = `ReportFlowHandler - Invalid Bedui data: { tostring(v60) }`
				}
			})

			return true
		end

		return v46.status == AbuseReportBeduiContextStatus.Error
	end, {
		v46,
		v54,
		validateBeduiData,
		sendAnalyticsEvent,
		v50
	})
	local v56 = React.useCallback(function(p1) -- line: 101
		-- upvalues: InnerContentConfigType (copy), formData (copy), v45 (copy), Cryo (copy), v44 (copy)
		if p1 == nil then
			return true
		end

		local v62 = false

		if p1.type == InnerContentConfigType.ConfigurableComponentList then
			for _, v64 in p1.configurableComponentList.components do
				if not v64.isOptional and formData[v64.formDataKey] == nil then
					v62 = true
					v45(Cryo.List.join(v44, { v64.formDataKey }))
				end
			end
		end

		return not v62
	end, {
		formData,
		v44
	})
	local v57 = React.useCallback(function() -- line: 120
		-- upvalues: Players (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v50 (copy), t1 (copy), AbuseVector (copy), getReportBody (copy), formData (copy), additionalReportTags (copy), submitReportV1 (copy), v49 (copy), Dash (copy), FFlagGenericAbuseReportingUnifyReportTags (copy), FFlagAddThumbnailSelectorReport (copy), getReportTags (copy), submitReport (copy), createReport (copy), ValueToAbuseCategory (copy), AbuseCategory (copy)
		local LocalPlayer = Players.LocalPlayer

		if LocalPlayer == nil then
			sendAnalyticsEvent({
				eventType = TelemetryEventType.Error,
				context = v50,
				meta = {
					error = "ReportFlowHandler - LocalPlayer is nil"
				}
			})

			return
		end

		if t1.abuseVector == AbuseVector.AdV2 then
			local v66 = getReportBody({
				abuseVector = t1.abuseVector,
				formData = formData,
				localPlayerUserId = LocalPlayer.UserId,
				targetIdStr = t1.targetId,
				additionalReportTags = additionalReportTags
			})

			submitReportV1(v49, v66):andThen(function(_) -- line: 142
				-- upvalues: sendAnalyticsEvent (copy), TelemetryEventType (copy), v50 (copy), t1 (copy)
				sendAnalyticsEvent({
					eventType = TelemetryEventType.Submitted,
					context = v50
				})

				if t1.onSubmit then
					t1.onSubmit()
				end
			end):catch(function(p3) -- line: 151
				-- upvalues: Dash (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v50 (copy)
				local v77 = Dash.pretty(p3, {
					depth = 10
				})

				sendAnalyticsEvent({
					eventType = TelemetryEventType.Error,
					context = v50,
					meta = {
						error = `ReportFlowHandler - Submitting v1 report: { v77 }`
					}
				})
			end)

			return
		end

		if FFlagGenericAbuseReportingUnifyReportTags or FFlagAddThumbnailSelectorReport then
			local v67 = getReportTags({
				formData = formData,
				localPlayerUserId = tostring(LocalPlayer.UserId),
				abuseVector = t1.abuseVector,
				targetId = t1.targetId,
				custom = t1.custom,
				additionalReportTags = additionalReportTags
			})

			submitReport(v49, v67):andThen(function(_) -- line: 172
				-- upvalues: sendAnalyticsEvent (copy), TelemetryEventType (copy), v50 (copy), t1 (copy)
				sendAnalyticsEvent({
					eventType = TelemetryEventType.Submitted,
					context = v50
				})

				if t1.onSubmit then
					t1.onSubmit()
				end
			end):catch(function(p5) -- line: 181
				-- upvalues: Dash (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v50 (copy)
				local v80 = Dash.pretty(p5, {
					depth = 10
				})

				sendAnalyticsEvent({
					eventType = TelemetryEventType.Error,
					context = v50,
					meta = {
						error = `ReportFlowHandler - Submitting report: { v80 }`
					}
				})
			end)

			return
		end

		local v68 = createReport({
			abuseCategory = ValueToAbuseCategory[formData.legacy_abuse_category] or (formData.abuse_category or AbuseCategory.ABUSE_CATEGORY_INVALID),
			abuseVector = t1.abuseVector,
			comment = formData.free_comment,
			submitterId = tostring(LocalPlayer.UserId),
			targetId = t1.targetId,
			custom = t1.custom
		})

		submitReport(v49, v68):andThen(function(_) -- line: 203
			-- upvalues: sendAnalyticsEvent (copy), TelemetryEventType (copy), v50 (copy)
			sendAnalyticsEvent({
				eventType = TelemetryEventType.Submitted,
				context = v50
			})
		end):catch(function(p7) -- line: 209
			-- upvalues: Dash (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v50 (copy)
			local v83 = Dash.pretty(p7, {
				depth = 10
			})

			sendAnalyticsEvent({
				eventType = TelemetryEventType.Error,
				context = v50,
				meta = {
					error = `ReportFlowHandler - Submitting report: { v83 }`
				}
			})
		end)
	end, {
		formData,
		Players.LocalPlayer,
		t1.abuseVector,
		t1.targetId,
		sendAnalyticsEvent,
		v50
	})
	local v58 = React.useMemo(function() -- line: 232
		-- upvalues: v54 (copy), v55 (copy), v46 (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v50 (copy), Dash (copy), v53 (copy), Cryo (copy), React (copy), SingleStepContainer (copy), v44 (copy), SingleStepInnerContentRenderer (copy), ArgCheck (copy), isReportSubmitted (copy), v57 (copy), setIsReportSubmitted (copy), v56 (copy), ButtonVariant (copy), FillBehavior (copy)
		if v54 then
			return {}
		end

		if v55 or not v46.beduiData or not v46.beduiData.nodes then
			sendAnalyticsEvent({
				eventType = TelemetryEventType.Error,
				context = v50,
				meta = {
					error = "ReportFlowHandler - Invalid Bedui data or no nodes found"
				}
			})

			return {}
		end

		local t2 = {}

		for _, v71 in v46.beduiData.nodes do
			local v72 = Dash.joinDeep({}, v71)
			local innerContentConfig = v72.innerContentConfig
			local v74 = v53 and v71.footerContentConfig

			if v74 then
				innerContentConfig = {
					type = innerContentConfig.type,
					configurableComponentList = {
						components = Cryo.List.join(innerContentConfig.configurableComponentList.components, v72.footerContentConfig.configurableComponentList.components)
					}
				}
			end

			if t2[v72.stepId] ~= nil then
				sendAnalyticsEvent({
					eventType = TelemetryEventType.Error,
					context = v50,
					meta = {
						error = `ReportFlowHandler - Duplicate stepId found: { tostring(v72.stepId) }`
					}
				})

				return {}
			end

			t2[v72.stepId] = {
				onStepCancel = nil,
				stepId = v72.stepId,
				predefinedNextStepId = v72.actionInfo.predefinedNextStepId,
				content = React.createElement(SingleStepContainer, {
					node = v72,
					contentConfig = innerContentConfig,
					formDataKeysWithError = v44
				}),
				footer = if not v72.footerContentConfig or v74 then nil else React.createElement(SingleStepInnerContentRenderer, {
					contentConfig = v72.footerContentConfig,
					formDataKeysWithError = v44
				}),
				labels = {
					continueButton = v72.actionInfo.actionLabel
				},
				onStepContinue = function() -- line: 295
					-- upvalues: ArgCheck (copy), isReportSubmitted (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v50 (copy), v72 (copy), v57 (copy), setIsReportSubmitted (copy)
					ArgCheck.assert(isReportSubmitted == false, "Report should only be able to be submitted once")

					if isReportSubmitted then
						sendAnalyticsEvent({
							eventType = TelemetryEventType.Error,
							context = v50,
							meta = {
								error = `ReportFlowHandler - Report already submitted for stepId: { tostring(v72.stepId) }`
							}
						})
					end

					if v72.actionInfo.shouldSubmit and not isReportSubmitted then
						v57()
						setIsReportSubmitted(true)
					end
				end,
				validateState = function() -- line: 313
					-- upvalues: v56 (copy), innerContentConfig (ref)
					return v56(innerContentConfig)
				end,
				stepStyle = {
					buttonXAlignment = "align-x-right",
					continueButton = {
						variant = if not v72.actionInfo.shouldSubmit then ButtonVariant.Standard else ButtonVariant.Emphasis,
						fillBehavior = if not v53 then FillBehavior.Fit else FillBehavior.Fill
					}
				}
			}
		end

		return t2
	end, {
		v54,
		v55,
		v46,
		v44,
		v53,
		v57,
		v56,
		isReportSubmitted,
		sendAnalyticsEvent,
		v50
	})

	if v54 then
		return (React.createElement(Skeleton, {
			radius = EnumsRadius.Medium,
			Size = UDim2.new(1, 0, 0, v43.Size.Size_2500)
		}))
	end

	if v55 or not next(v58) then
		return (React.createElement(Empty, {}))
	end

	if next(v58) and v46.beduiData then
		return (React.createElement(Stepper, {
			currentStep = v46.beduiData.rootStepId,
			steps = v58
		}))
	end

	return nil
end

return React.memo(ReportFlowHandler)
