local MusicTestingUtils = script:FindFirstAncestor("MusicTestingUtils")
local LocalizationService = game:GetService("LocalizationService")
local Cryo = require(MusicTestingUtils.Parent.Cryo)
local React = require(MusicTestingUtils.Parent.React)
local ReactUtils = require(MusicTestingUtils.Parent.ReactUtils)
local Style = require(MusicTestingUtils.Parent.Style)
local Foundation = require(MusicTestingUtils.Parent.Foundation)
local ReactSceneUnderstanding = require(MusicTestingUtils.Parent.ReactSceneUnderstanding)
local Localization = require(MusicTestingUtils.Parent.RobloxAppLocales).Localization
local LocalizationProvider = require(MusicTestingUtils.Parent.Localization).LocalizationProvider
local Responsive = require(MusicTestingUtils.Parent.Responsive)
local RoactRodux = require(MusicTestingUtils.Parent.RoactRodux)
local Rodux = require(MusicTestingUtils.Parent.Rodux)
local Songbird = require(MusicTestingUtils.Parent.Songbird)
local t1 = {
	isReportAudioPopupVisible = true,
	theme = Foundation.Enums.Theme.Dark
}

local function ContextProviders(t2: {[any]: any}) -- line: 34
	-- upvalues: Cryo (copy), t1 (copy), React (copy), Foundation (copy), RoactRodux (copy), Rodux (copy), Style (copy), ReactUtils (copy), ReactSceneUnderstanding (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), Songbird (copy), Responsive (copy)
	local v18 = Cryo.Dictionary.join(t1, t2)
	local v19 = React.useRef(t2.host)

	return React.createElement(Foundation.FoundationProvider, {
		theme = v18.theme,
		overlayGui = v18.overlayGui,
		preferences = {
			reducedMotion = true
		}
	}, {
		StoreProvider = React.createElement(RoactRodux.StoreProvider, {
			store = Rodux.Store.new(function() -- line: 45
				return {}
			end)
		}, {
			AppStyleProvider = React.createElement(Style.AppStyleProvider, {
				style = {
					themeName = v18.theme,
					fontName = Enum.Font.BuilderSans.Name
				}
			}, {
				ContextStack = React.createElement(ReactUtils.ContextStack, {
					providers = {
						React.createElement(ReactSceneUnderstanding.SceneAnalysisProvider),
						React.createElement(LocalizationProvider, {
							localization = Localization.new(LocalizationService.RobloxLocaleId)
						}),
						React.createElement(Songbird.ReportAudioPopupContext.Provider, {
							value = {
								isVisible = v18.isReportAudioPopupVisible,
								hasThumbnail = v18.isReportAudioPopupHasThumbnail
							}
						}),
						React.createElement(Responsive.ContainerRef.Provider, {
							value = v19
						})
					}
				}, v18.children)
			})
		})
	})
end

return ContextProviders
