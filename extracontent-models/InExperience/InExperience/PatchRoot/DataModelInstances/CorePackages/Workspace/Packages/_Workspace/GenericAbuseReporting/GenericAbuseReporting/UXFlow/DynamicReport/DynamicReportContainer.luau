local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local LayerCollectorProvider = require(GenericAbuseReportingParent.UIBlox).Core.Layout.LayerCollector.LayerCollectorProvider
local Foundation = require(GenericAbuseReportingParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local ThemeContext = require(GenericAbuseReportingParent.Style).ThemeContext
local AbuseReportAnalyticsProvider = require(GenericAbuseReporting.Bedui.Provider.AbuseReportAnalyticsProvider)
local AbuseReportBeduiProvider = require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiProvider)
local AbuseReportFormDataProvider = require(GenericAbuseReporting.Bedui.Provider.AbuseReportFormDataProvider)

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)

local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)
local DynamicReport = require(GenericAbuseReporting.UXFlow.DynamicReport.DynamicReport)
local DynamicReportV2Container = require(GenericAbuseReporting.UXFlow.DynamicReportV2.DynamicReportV2Container)
local SharedFlags = require(GenericAbuseReportingParent.SharedFlags)
local FFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport
local FFlagEnableReportingFlowForMomentsFeed = SharedFlags.FFlagEnableReportingFlowForMomentsFeed
local v17 = game:DefineFastFlag("FixKidsBlueOnReportDropdown", false)

local function DynamicReportContainer(t1: {[any]: any}) -- line: 37
	-- upvalues: React (copy), ThemeContext (copy), AbuseVector (copy), FFlagEnableReportingFlowForMomentsFeed (copy), DynamicReportV2Container (copy), v17 (copy), LayerCollectorProvider (copy), AbuseReportBeduiProvider (copy), AbuseReportFormDataProvider (copy), FFlagAddThumbnailSelectorReport (copy), AbuseReportAnalyticsProvider (copy), DynamicReport (copy), FoundationProvider (copy), Foundation (copy)
	local v20 = React.useContext(ThemeContext)

	if t1.abuseVector == AbuseVector.UserProfile or FFlagEnableReportingFlowForMomentsFeed and t1.abuseVector == AbuseVector.MomentsFeed then
		local t2 = {
			abuseVector = t1.abuseVector,
			targetId = t1.targetId,
			onClose = t1.onClose,
			onSubmit = t1.onSubmit,
			custom = t1.custom
		}

		return React.createElement(DynamicReportV2Container, t2)
	end

	if v17 then
		return React.createElement(LayerCollectorProvider, {}, {
			AbuseReportBeduiProvider = React.createElement(AbuseReportBeduiProvider, {
				abuseVector = t1.abuseVector
			}, {
				AbuseReportFormDataProvider = React.createElement(AbuseReportFormDataProvider, {
					custom = if not FFlagAddThumbnailSelectorReport then nil else t1.custom
				}, {
					AbuseReportAnalyticsProvider = React.createElement(AbuseReportAnalyticsProvider, {
						abuseVector = t1.abuseVector
					}, {
						DynamicReport = React.createElement(DynamicReport, t1)
					})
				})
			})
		})
	end

	return React.createElement(LayerCollectorProvider, {}, {
		FoundationProvider = React.createElement(FoundationProvider, {
			theme = if v20.theme ~= "light" then Foundation.Enums.Theme.Dark else Foundation.Enums.Theme.Light
		}, {
			AbuseReportBeduiProvider = React.createElement(AbuseReportBeduiProvider, {
				abuseVector = t1.abuseVector
			}, {
				AbuseReportFormDataProvider = React.createElement(AbuseReportFormDataProvider, {
					custom = if not FFlagAddThumbnailSelectorReport then nil else t1.custom
				}, {
					AbuseReportAnalyticsProvider = React.createElement(AbuseReportAnalyticsProvider, {
						abuseVector = t1.abuseVector
					}, {
						DynamicReport = React.createElement(DynamicReport, t1)
					})
				})
			})
		})
	})
end

return React.memo(DynamicReportContainer)
