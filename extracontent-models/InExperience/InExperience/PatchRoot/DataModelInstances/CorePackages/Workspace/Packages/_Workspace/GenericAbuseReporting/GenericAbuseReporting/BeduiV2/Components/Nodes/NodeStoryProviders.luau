local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View

local AbuseReportAnalyticsContext = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)
local AbuseReportAnalyticsProvider = AbuseReportAnalyticsContext.AbuseReportAnalyticsProvider
local arTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation)
local arTranslationProvider = arTranslation.ArTranslationProvider
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local LoaderContext = require(GenericAbuseReporting.BeduiV2.Loaders.LoaderContext)

local inlineSlots = LayoutSlots.inlineSlots
local LayoutSlotsProvider = LayoutSlots.LayoutSlotsProvider
local OverlaidControlsProvider = LayoutSlots.OverlaidControlsProvider
local LoaderProvider = LoaderContext.LoaderProvider

local udim = UDim2.new(0, 468, 0, 560)
local v = {}
local v2 = {}

local analytics = {
	sendEvent = function(...)
		print("Analytics:", ...)
	end
}

local function NodeStoryProviders(props)
	local state, setState = React.useState(nil)

	return React.createElement(AbuseReportAnalyticsProvider, { analytics = analytics }, {
		Translation = React.createElement(arTranslationProvider, {
			translations = props.translations or v2
		}, {
			LoaderCtx = React.createElement(LoaderProvider, {
				loaders = props.loaders or v,
				open = true
			}, {
				Layout = React.createElement(LayoutSlotsProvider, { slots = inlineSlots }, {
					Orientation = React.createElement(OverlaidControlsProvider, { value = true }, {
						Container = React.createElement(View, {
							Size = props.containerSize or udim,
							ClipsDescendants = true,
							ref = setState,
							tag = "col"
						}, {
							Overlay = state and React.createElement(
								Foundation.OverlayProvider,
								{ gui = state },
								props.children
							) or nil
						})
					})
				})
			})
		})
	})
end

return NodeStoryProviders
