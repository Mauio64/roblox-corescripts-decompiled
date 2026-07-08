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
local FFlagAddThumbnailSelectorReport = require(GenericAbuseReportingParent.SharedFlags).FFlagAddThumbnailSelectorReport
local v15 = game:DefineFastFlag("EnableDynamicReportV2ForUserProfileReports3", false)
local v16 = game:DefineFastFlag("FixKidsBlueOnReportDropdown", false)

local function DynamicReportContainer(t1: {[any]: any}) -- line: 38
	-- upvalues: React (copy), ThemeContext (copy), v15 (copy), AbuseVector (copy), DynamicReportV2Container (copy), v16 (copy), LayerCollectorProvider (copy), AbuseReportBeduiProvider (copy), AbuseReportFormDataProvider (copy), FFlagAddThumbnailSelectorReport (copy), AbuseReportAnalyticsProvider (copy), DynamicReport (copy), FoundationProvider (copy), Foundation (copy)
	local v19 = React.useContext(ThemeContext)

	if v15 and t1.abuseVector == AbuseVector.UserProfile then
		local t2 = {
			abuseVector = t1.abuseVector,
			targetId = t1.targetId,
			onClose = t1.onClose,
			onSubmit = t1.onSubmit,
			custom = t1.custom
		}

		return React.createElement(DynamicReportV2Container, t2)
	end

	if v16 then
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
			theme = if v19.theme ~= "light" then Foundation.Enums.Theme.Dark else Foundation.Enums.Theme.Light
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
