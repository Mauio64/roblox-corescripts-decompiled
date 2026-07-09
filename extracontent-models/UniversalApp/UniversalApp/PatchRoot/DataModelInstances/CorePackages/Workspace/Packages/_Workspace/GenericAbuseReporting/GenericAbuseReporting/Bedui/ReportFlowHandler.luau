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
local SharedFlags = require(GenericAbuseReportingParent.SharedFlags)
local v40 = game:DefineFastFlag("FixRevampDropdownString", false)
local FFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport
local v42 = game:DefineFastFlag("DynamicReportPrettyErrorMessage", false)
local FFlagFixNotificationReportsMobile = SharedFlags.FFlagFixNotificationReportsMobile

local function ReportFlowHandler(t1: {[any]: any}) -- line: 64
	-- upvalues: useTokens (copy), React (copy), useBeduiData (copy), useFormData (copy), useRoactService (copy), RoactNetworking (copy), useAnalyticsContext (copy), useLayerCollector (copy), AbuseReportBeduiContextStatus (copy), validateBeduiData (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), InnerContentConfigType (copy), Cryo (copy), Players (copy), AbuseVector (copy), getReportBody (copy), submitReportV1 (copy), FFlagFixNotificationReportsMobile (copy), v42 (copy), Dash (copy), FFlagAddThumbnailSelectorReport (copy), getReportTags (copy), submitReport (copy), createReport (copy), v40 (copy), ValueToAbuseCategory (copy), AbuseCategory (copy), SingleStepContainer (copy), SingleStepInnerContentRenderer (copy), ArgCheck (copy), ButtonVariant (copy), FillBehavior (copy), Skeleton (copy), EnumsRadius (copy), Empty (copy), Stepper (copy)
	local v46 = useTokens()
	local v47, v48 = React.useState({})
	local v49 = useBeduiData()
	local formData = useFormData().formData
	local additionalReportTags = useFormData().additionalReportTags
	local v52 = useRoactService(RoactNetworking)
	local v53 = useAnalyticsContext()
	local isReportSubmitted = v53.isReportSubmitted
	local setIsReportSubmitted = v53.setIsReportSubmitted
	local v56 = useLayerCollector().absoluteSize.X < 540
	local v57 = React.useMemo(function() -- line: 80
		-- upvalues: v49 (copy), AbuseReportBeduiContextStatus (copy)
		return v49 == nil or v49.status == AbuseReportBeduiContextStatus.Loading
	end, { v49 })
	local v58 = React.useMemo(function() -- line: 84
		-- upvalues: v57 (copy), v49 (copy), validateBeduiData (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v53 (copy), AbuseReportBeduiContextStatus (copy)
		if v57 or v49 == nil then
			return true
		end

		local v62, v63 = validateBeduiData(v49.beduiData)

		if not v62 then
			sendAnalyticsEvent({
				eventType = TelemetryEventType.Error,
				context = v53,
				meta = {
					error = `ReportFlowHandler - Invalid Bedui data: { tostring(v63) }`
				}
			})

			return true
		end

		return v49.status == AbuseReportBeduiContextStatus.Error
	end, {
		v49,
		v57,
		validateBeduiData,
		sendAnalyticsEvent,
		v53
	})
	local v59 = React.useCallback(function(p1) -- line: 103
		-- upvalues: InnerContentConfigType (copy), formData (copy), v48 (copy), Cryo (copy), v47 (copy)
		if p1 == nil then
			return true
		end

		local v65 = false

		if p1.type == InnerContentConfigType.ConfigurableComponentList then
			for _, v67 in p1.configurableComponentList.components do
				if not v67.isOptional and formData[v67.formDataKey] == nil then
					v65 = true
					v48(Cryo.List.join(v47, { v67.formDataKey }))
				end
			end
		end

		return not v65
	end, {
		formData,
		v47
	})
	local v60 = React.useCallback(function() -- line: 122
		-- upvalues: Players (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v53 (copy), t1 (copy), AbuseVector (copy), getReportBody (copy), formData (copy), additionalReportTags (copy), submitReportV1 (copy), v52 (copy), FFlagFixNotificationReportsMobile (copy), v42 (copy), Dash (copy), FFlagAddThumbnailSelectorReport (copy), getReportTags (copy), submitReport (copy), createReport (copy), v40 (copy), ValueToAbuseCategory (copy), AbuseCategory (copy)
		local LocalPlayer = Players.LocalPlayer

		if LocalPlayer == nil then
			sendAnalyticsEvent({
				eventType = TelemetryEventType.Error,
				context = v53,
				meta = {
					error = "ReportFlowHandler - LocalPlayer is nil"
				}
			})

			return
		end

		if t1.abuseVector == AbuseVector.AdV2 then
			local v69 = getReportBody({
				abuseVector = t1.abuseVector,
				formData = formData,
				localPlayerUserId = LocalPlayer.UserId,
				targetIdStr = t1.targetId,
				additionalReportTags = additionalReportTags
			})

			submitReportV1(v52, v69):andThen(function(_) -- line: 144
				-- upvalues: sendAnalyticsEvent (copy), TelemetryEventType (copy), v53 (copy), FFlagFixNotificationReportsMobile (copy), t1 (copy)
				sendAnalyticsEvent({
					eventType = TelemetryEventType.Submitted,
					context = v53
				})

				if FFlagFixNotificationReportsMobile and t1.onSubmit then
					t1.onSubmit()
				end
			end):catch(function(p3) -- line: 153
				-- upvalues: v42 (copy), Dash (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v53 (copy)
				if v42 then
					local v80 = Dash.pretty(p3, {
						depth = 10
					})

					sendAnalyticsEvent({
						eventType = TelemetryEventType.Error,
						context = v53,
						meta = {
							error = `ReportFlowHandler - Submitting v1 report: { v80 }`
						}
					})

					return
				end

				sendAnalyticsEvent({
					eventType = TelemetryEventType.Error,
					context = v53,
					meta = {
						error = `ReportFlowHandler - Submitting v1 report: { tostring(p3) }`
					}
				})
			end)

			return
		end

		if FFlagAddThumbnailSelectorReport then
			local v70 = getReportTags({
				formData = formData,
				localPlayerUserId = tostring(LocalPlayer.UserId),
				abuseVector = t1.abuseVector,
				targetId = t1.targetId,
				custom = t1.custom,
				additionalReportTags = additionalReportTags
			})

			submitReport(v52, v70):andThen(function(_) -- line: 184
				-- upvalues: sendAnalyticsEvent (copy), TelemetryEventType (copy), v53 (copy), FFlagFixNotificationReportsMobile (copy), t1 (copy)
				sendAnalyticsEvent({
					eventType = TelemetryEventType.Submitted,
					context = v53
				})

				if FFlagFixNotificationReportsMobile and t1.onSubmit then
					t1.onSubmit()
				end
			end):catch(function(p5) -- line: 193
				-- upvalues: v42 (copy), Dash (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v53 (copy)
				if v42 then
					local v83 = Dash.pretty(p5, {
						depth = 10
					})

					sendAnalyticsEvent({
						eventType = TelemetryEventType.Error,
						context = v53,
						meta = {
							error = `ReportFlowHandler - Submitting report: { v83 }`
						}
					})

					return
				end

				sendAnalyticsEvent({
					eventType = TelemetryEventType.Error,
					context = v53,
					meta = {
						error = `ReportFlowHandler - Submitting report: { tostring(p5) }`
					}
				})
			end)

			return
		end

		local v71 = createReport({
			abuseCategory = if not v40 then ValueToAbuseCategory[formData.legacy_abuse_category] or AbuseCategory.ABUSE_CATEGORY_INVALID else ValueToAbuseCategory[formData.legacy_abuse_category] or (formData.abuse_category or AbuseCategory.ABUSE_CATEGORY_INVALID),
			abuseVector = t1.abuseVector,
			comment = formData.free_comment,
			submitterId = tostring(LocalPlayer.UserId),
			targetId = t1.targetId,
			custom = t1.custom
		})

		submitReport(v52, v71):andThen(function(_) -- line: 228
			-- upvalues: sendAnalyticsEvent (copy), TelemetryEventType (copy), v53 (copy)
			sendAnalyticsEvent({
				eventType = TelemetryEventType.Submitted,
				context = v53
			})
		end):catch(function(p7) -- line: 234
			-- upvalues: v42 (copy), Dash (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v53 (copy)
			if v42 then
				local v86 = Dash.pretty(p7, {
					depth = 10
				})

				sendAnalyticsEvent({
					eventType = TelemetryEventType.Error,
					context = v53,
					meta = {
						error = `ReportFlowHandler - Submitting report: { v86 }`
					}
				})

				return
			end

			sendAnalyticsEvent({
				eventType = TelemetryEventType.Error,
				context = v53,
				meta = {
					error = `ReportFlowHandler - Submitting report: { tostring(p7) }`
				}
			})
		end)
	end, {
		formData,
		Players.LocalPlayer,
		t1.abuseVector,
		t1.targetId,
		sendAnalyticsEvent,
		v53
	})
	local v61 = React.useMemo(function() -- line: 267
		-- upvalues: v57 (copy), v58 (copy), v49 (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v53 (copy), Dash (copy), v56 (copy), Cryo (copy), React (copy), SingleStepContainer (copy), v47 (copy), SingleStepInnerContentRenderer (copy), ArgCheck (copy), isReportSubmitted (copy), v60 (copy), setIsReportSubmitted (copy), v59 (copy), ButtonVariant (copy), FillBehavior (copy)
		if v57 then
			return {}
		end

		if v58 or not v49.beduiData or not v49.beduiData.nodes then
			sendAnalyticsEvent({
				eventType = TelemetryEventType.Error,
				context = v53,
				meta = {
					error = "ReportFlowHandler - Invalid Bedui data or no nodes found"
				}
			})

			return {}
		end

		local t2 = {}

		for _, v74 in v49.beduiData.nodes do
			local v75 = Dash.joinDeep({}, v74)
			local innerContentConfig = v75.innerContentConfig
			local v77 = v56 and v74.footerContentConfig

			if v77 then
				innerContentConfig = {
					type = innerContentConfig.type,
					configurableComponentList = {
						components = Cryo.List.join(innerContentConfig.configurableComponentList.components, v75.footerContentConfig.configurableComponentList.components)
					}
				}
			end

			if t2[v75.stepId] ~= nil then
				sendAnalyticsEvent({
					eventType = TelemetryEventType.Error,
					context = v53,
					meta = {
						error = `ReportFlowHandler - Duplicate stepId found: { tostring(v75.stepId) }`
					}
				})

				return {}
			end

			t2[v75.stepId] = {
				onStepCancel = nil,
				stepId = v75.stepId,
				predefinedNextStepId = v75.actionInfo.predefinedNextStepId,
				content = React.createElement(SingleStepContainer, {
					node = v75,
					contentConfig = innerContentConfig,
					formDataKeysWithError = v47
				}),
				footer = if not v75.footerContentConfig or v77 then nil else React.createElement(SingleStepInnerContentRenderer, {
					contentConfig = v75.footerContentConfig,
					formDataKeysWithError = v47
				}),
				labels = {
					continueButton = v75.actionInfo.actionLabel
				},
				onStepContinue = function() -- line: 330
					-- upvalues: ArgCheck (copy), isReportSubmitted (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v53 (copy), v75 (copy), v60 (copy), setIsReportSubmitted (copy)
					ArgCheck.assert(isReportSubmitted == false, "Report should only be able to be submitted once")

					if isReportSubmitted then
						sendAnalyticsEvent({
							eventType = TelemetryEventType.Error,
							context = v53,
							meta = {
								error = `ReportFlowHandler - Report already submitted for stepId: { tostring(v75.stepId) }`
							}
						})
					end

					if v75.actionInfo.shouldSubmit and not isReportSubmitted then
						v60()
						setIsReportSubmitted(true)
					end
				end,
				validateState = function() -- line: 348
					-- upvalues: v59 (copy), innerContentConfig (ref)
					return v59(innerContentConfig)
				end,
				stepStyle = {
					buttonXAlignment = "align-x-right",
					continueButton = {
						variant = if not v75.actionInfo.shouldSubmit then ButtonVariant.Standard else ButtonVariant.Emphasis,
						fillBehavior = if not v56 then FillBehavior.Fit else FillBehavior.Fill
					}
				}
			}
		end

		return t2
	end, {
		v57,
		v58,
		v49,
		v47,
		v56,
		v60,
		v59,
		isReportSubmitted,
		sendAnalyticsEvent,
		v53
	})

	if v57 then
		return (React.createElement(Skeleton, {
			radius = EnumsRadius.Medium,
			Size = UDim2.new(1, 0, 0, v46.Size.Size_2500)
		}))
	end

	if v58 or not next(v61) then
		return (React.createElement(Empty, {}))
	end

	if next(v61) and v49.beduiData then
		return (React.createElement(Stepper, {
			currentStep = v49.beduiData.rootStepId,
			steps = v61
		}))
	end

	return nil
end

return React.memo(ReportFlowHandler)
