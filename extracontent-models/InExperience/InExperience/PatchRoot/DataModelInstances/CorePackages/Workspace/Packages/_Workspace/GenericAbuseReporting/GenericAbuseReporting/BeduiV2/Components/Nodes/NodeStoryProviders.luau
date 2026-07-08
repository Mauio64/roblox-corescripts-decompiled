local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local View = Foundation.View
local AbuseReportAnalyticsProvider = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext).AbuseReportAnalyticsProvider
local ArTranslationProvider = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).ArTranslationProvider
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local LoaderContext = require(GenericAbuseReporting.BeduiV2.Loaders.LoaderContext)
local inlineSlots = LayoutSlots.inlineSlots
local LayoutSlotsProvider = LayoutSlots.LayoutSlotsProvider
local OverlaidControlsProvider = LayoutSlots.OverlaidControlsProvider
local LoaderProvider = LoaderContext.LoaderProvider
local uDim2 = UDim2.new(0, 468, 0, 560)
local t1 = {}
local t2 = {}
local t3 = {
	sendEvent = function(...) -- line: 25
		print("Analytics:", ...)
	end
}

local function NodeStoryProviders(t4: {[any]: any}) -- line: 37
	-- upvalues: React (copy), AbuseReportAnalyticsProvider (copy), t3 (copy), ArTranslationProvider (copy), t2 (copy), LoaderProvider (copy), t1 (copy), LayoutSlotsProvider (copy), inlineSlots (copy), OverlaidControlsProvider (copy), View (copy), uDim2 (copy), Foundation (copy)
	local v20, v21 = React.useState(nil)

	return React.createElement(AbuseReportAnalyticsProvider, {
		analytics = t3
	}, {
		Translation = React.createElement(ArTranslationProvider, {
			translations = t4.translations or t2
		}, {
			LoaderCtx = React.createElement(LoaderProvider, {
				open = true,
				loaders = t4.loaders or t1
			}, {
				Layout = React.createElement(LayoutSlotsProvider, {
					slots = inlineSlots
				}, {
					Orientation = React.createElement(OverlaidControlsProvider, {
						value = true
					}, {
						Container = React.createElement(View, {
							ClipsDescendants = true,
							tag = "col",
							Size = t4.containerSize or uDim2,
							ref = v21
						}, {
							Overlay = v20 and React.createElement(Foundation.OverlayProvider, {
								gui = v20
							}, t4.children) or nil
						})
					})
				})
			})
		})
	})
end

return NodeStoryProviders
