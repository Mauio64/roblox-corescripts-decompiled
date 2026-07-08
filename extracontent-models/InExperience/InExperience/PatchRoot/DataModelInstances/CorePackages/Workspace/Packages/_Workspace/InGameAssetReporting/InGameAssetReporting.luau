local scriptParent = script.Parent
local CoreGui = game:GetService("CoreGui")
local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
local LocalizationService = game:GetService("LocalizationService")
local React = require(scriptParent.React)
local Roact = require(scriptParent.Roact)
local StyleProviderWithDefaultTheme = require(scriptParent.Style).StyleProviderWithDefaultTheme
local LayerCollectorProvider = require(scriptParent.UIBlox).Core.Layout.LayerCollector.LayerCollectorProvider
local FoundationProvider = require(scriptParent.Foundation).FoundationProvider
local Localization = require(scriptParent.InExperienceLocales).Localization
local LocalizationProvider = require(scriptParent.Localization).LocalizationProvider
local SharedFlags = require(scriptParent.SharedFlags)
local FFlagHighlightModePreciseSelectionEnabled = SharedFlags.FFlagHighlightModePreciseSelectionEnabled
local FFlagAbuseReportMenuV2 = SharedFlags.FFlagAbuseReportMenuV2
local MessageBusService = game:GetService("MessageBusService")
local MessageId = MessageBusService:GetMessageId("CaptureMode", "sceneSelectionExitReason")
local SceneAnalysis = require(script.Analysis.SceneAnalysis)
local InGameAssetReportMode = require(script.InGameAssetReportUI.Components.InGameAssetReportMode)
local InGameAssetReportModePreciseSelection = require(script.InGameAssetReportUI.Components.PreciseSelection.InGameAssetReportModePreciseSelection)
local getHighlightModeVariant = require(script.Utility.getHighlightModeVariant)
local HighlightModeVariants = require(script.InGameAssetReportUI.Resources.Constants).HighlightModeVariants
local t1 = {
	[HighlightModeVariants.Default] = InGameAssetReportMode,
	[HighlightModeVariants.NoPreview] = InGameAssetReportModePreciseSelection
}

return {
	interpretAnnotation = SceneAnalysis.interpretAnnotation,
	extractItemsFromInterpretations = SceneAnalysis.extractItemsFromInterpretations,
	__setRandomGenerator = SceneAnalysis.__setRandomGenerator,
	initialize = function() -- line: 42
		-- upvalues: InGameAssetReportMode (copy), FFlagHighlightModePreciseSelectionEnabled (copy), getHighlightModeVariant (copy), HighlightModeVariants (copy), t1 (copy), React (copy), LayerCollectorProvider (copy), FoundationProvider (copy), Roact (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), StyleProviderWithDefaultTheme (copy), FFlagAbuseReportMenuV2 (copy), MessageBusService (copy), MessageId (copy), ExperienceStateCaptureService (copy), CoreGui (copy)
		local v23 = InGameAssetReportMode

		if FFlagHighlightModePreciseSelectionEnabled then
			local v24 = getHighlightModeVariant()

			if v24 ~= HighlightModeVariants.Default and t1[v24] ~= nil then
				game:GetService("ExperienceStateCaptureService").SelectionMode = Enum.ExperienceStateCaptureSelectionMode.SafetyHighlightMode
				v23 = t1[v24]
			end
		end

		local v25 = React.createElement("ScreenGui", {
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}, {
			LayerCollectorProvider = React.createElement(LayerCollectorProvider, {}, {
				FoundationProvider = React.createElement(FoundationProvider, {
					theme = "Dark"
				}, {
					LocalizationProvider = Roact.createElement(LocalizationProvider, {
						localization = Localization.new(LocalizationService.RobloxLocaleId)
					}, {
						StyleProvider = React.createElement(StyleProviderWithDefaultTheme, {
							withDarkTheme = true
						}, {
							InGameAssetReportUI = Roact.createElement(v23, {
								backAction = function() -- line: 73
									-- upvalues: FFlagAbuseReportMenuV2 (copy), MessageBusService (copy), MessageId (copy), ExperienceStateCaptureService (copy)
									if FFlagAbuseReportMenuV2 then
										MessageBusService:Publish(MessageId, {
											reason = "back"
										})
									end

									ExperienceStateCaptureService:ToggleCaptureMode()
								end,
								onReportComplete = function() -- line: 79
									-- upvalues: FFlagAbuseReportMenuV2 (copy), MessageBusService (copy), MessageId (copy), ExperienceStateCaptureService (copy)
									if FFlagAbuseReportMenuV2 then
										MessageBusService:Publish(MessageId, {
											reason = "submit"
										})
									end

									ExperienceStateCaptureService:ToggleCaptureMode()
								end,
								getIsSmallPortraitMode = function(p1) -- line: 85
									return p1.X < p1.Y and p1.X < 800
								end
							})
						})
					})
				})
			})
		})

		if game:GetEngineFeature("ExperienceStateCaptureHiddenSelection") then
			ExperienceStateCaptureService.HiddenSelectionEnabled = true
		end

		Roact.mount(v25, CoreGui, "InGameAssetReportMode")
	end,
	getHighlightModeVariant = getHighlightModeVariant,
	HighlightModeVariants = HighlightModeVariants,
	["jest.config"] = script["jest.config"]
}
