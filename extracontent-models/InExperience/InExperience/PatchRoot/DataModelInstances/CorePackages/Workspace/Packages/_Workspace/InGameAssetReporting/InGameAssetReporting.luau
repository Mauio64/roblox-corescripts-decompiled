local parent = script.Parent
local CoreGui = game:GetService("CoreGui")

local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
local LocalizationService = game:GetService("LocalizationService")

local React = require(parent.React)
local Roact = require(parent.Roact)
local Style = require(parent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local UIBlox = require(parent.UIBlox)
local LayerCollectorProvider = UIBlox.Core.Layout.LayerCollector.LayerCollectorProvider
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider

local InExperienceLocales = require(parent.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local SharedFlags = require(parent.SharedFlags)
local FFlagHighlightModePreciseSelectionEnabled = SharedFlags.FFlagHighlightModePreciseSelectionEnabled

local MessageBusService = game:GetService("MessageBusService")
local messageId = MessageBusService:GetMessageId("CaptureMode", "sceneSelectionExitReason")

local SceneAnalysis = require(script.Analysis.SceneAnalysis)
local InGameAssetReportMode = require(script.InGameAssetReportUI.Components.InGameAssetReportMode)

local InGameAssetReportModePreciseSelection = require(script.InGameAssetReportUI.Components.PreciseSelection.InGameAssetReportModePreciseSelection)
local getHighlightModeVariant = require(script.Utility.getHighlightModeVariant)
local Constants = require(script.InGameAssetReportUI.Resources.Constants)
local HighlightModeVariants = Constants.HighlightModeVariants

local v = {
	[HighlightModeVariants.Default] = InGameAssetReportMode,
	[HighlightModeVariants.NoPreview] = InGameAssetReportModePreciseSelection
}

return {
	interpretAnnotation = SceneAnalysis.interpretAnnotation,
	extractItemsFromInterpretations = SceneAnalysis.extractItemsFromInterpretations,
	__setRandomGenerator = SceneAnalysis.__setRandomGenerator,
	initialize = function()
		local v2 = InGameAssetReportMode

		if FFlagHighlightModePreciseSelectionEnabled then
			local highlightModeVariant = getHighlightModeVariant()

			if highlightModeVariant ~= HighlightModeVariants.Default and v[highlightModeVariant] ~= nil then
				local ExperienceStateCaptureService2 = game:GetService("ExperienceStateCaptureService")
				ExperienceStateCaptureService2.SelectionMode = Enum.ExperienceStateCaptureSelectionMode.SafetyHighlightMode

				v2 = v[highlightModeVariant]
			end
		end

		local element = React.createElement(
			"ScreenGui",
			{
				IgnoreGuiInset = true,
				OnTopOfCoreBlur = false,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			},
			{
				LayerCollectorProvider = React.createElement(LayerCollectorProvider, {}, {
					FoundationProvider = React.createElement(FoundationProvider, {
						colorMode = "Dark"
					}, {
						LocalizationProvider = Roact.createElement(
							LocalizationProvider,
							{
								localization = Localization.new(LocalizationService.RobloxLocaleId)
							},
							{
								StyleProvider = React.createElement(
									StyleProviderWithDefaultTheme,
									{ withDarkTheme = true },
									{
										InGameAssetReportUI = Roact.createElement(v2, {
											backAction = function()
												MessageBusService:Publish(messageId, {
													reason = "back"
												})
												ExperienceStateCaptureService:ToggleCaptureMode()
											end,
											onReportComplete = function()
												MessageBusService:Publish(messageId, {
													reason = "submit"
												})
												ExperienceStateCaptureService:ToggleCaptureMode()
											end,
											getIsSmallPortraitMode = function(p)
												local isSmallPortraitMode

												if p.X < p.Y then
													isSmallPortraitMode = p.X < 800
												else
													isSmallPortraitMode = false
												end

												return isSmallPortraitMode
											end
										})
									}
								)
							}
						)
					})
				})
			}
		)

		if game:GetEngineFeature("ExperienceStateCaptureHiddenSelection") then
			ExperienceStateCaptureService.HiddenSelectionEnabled = true
		end

		Roact.mount(element, CoreGui, "InGameAssetReportMode")
	end,
	getHighlightModeVariant = getHighlightModeVariant,
	HighlightModeVariants = HighlightModeVariants,
	["jest.config"] = script["jest.config"]
}
