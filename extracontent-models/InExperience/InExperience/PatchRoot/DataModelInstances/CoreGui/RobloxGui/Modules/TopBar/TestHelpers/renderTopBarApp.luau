local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ReactSceneUnderstanding = require(CorePackages.Packages.ReactSceneUnderstanding)
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(CorePackages.Workspace.Packages.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local Style = require(CorePackages.Workspace.Packages.Style)
local DesignTokenProvider = Style.DesignTokenProvider
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)

local parent = script.Parent.Parent
local MenuNavigationPromptTokenMapper = require(parent.TokenMappers.MenuNavigationPromptTokenMapper)
local Reducer = require(parent.Reducer)
local TopBarAppPolicy = require(parent.TopBarAppPolicy)

local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy
local AppFeaturePolicies = UniversalAppPolicy.AppFeaturePolicies
local FFlagShowGameAgeRating = SharedFlags.FFlagShowGameAgeRating

local style = {
	themeName = "dark",
	fontName = "gotham",
	deviceType = RobloxAppEnums.DeviceType.Console
}

if not CoreGui.RobloxGui:FindFirstChild("SendNotificationInfo") then
	local sendNotificationInfo = Instance.new("BindableEvent")
	sendNotificationInfo.Name = "SendNotificationInfo"
	sendNotificationInfo.Parent = CoreGui.RobloxGui
end

local function renderTopBarApp(p, p2)
	local store = Rodux.Store.new(Reducer, nil, { Rodux.thunkMiddleware })

	local createElement = Roact.createElement
	local storeProvider = RoactRodux.StoreProvider

	local createElement2 = Roact.createElement
	local provider

	if FFlagShowGameAgeRating then
		provider = RoactAppPolicy.Provider
	else
		provider = TopBarAppPolicy.Provider
	end

	local policy

	if FFlagShowGameAgeRating then
		policy = { AppFeaturePolicies }
	else
		policy = { TopBarAppPolicy.Mapper }
	end

	local element = createElement(storeProvider, { store = store }, {
		PolicyProvider = createElement2(provider, { policy = policy }, {
			LocalizationProvider = Roact.createElement(
				LocalizationProvider,
				{
					localization = Localization.new(LocalizationService.RobloxLocaleId)
				},
				{
					StyleProvider = Roact.createElement(UIBlox.App.Style.AppStyleProvider, {
						style = style
					}, {
						DesignTokenProvider = Roact.createElement(DesignTokenProvider, {
							tokenMappers = {
								MenuNavigationPrompt = MenuNavigationPromptTokenMapper
							}
						}, {
							SceneAnalysisProvider = Roact.createElement(
								ReactSceneUnderstanding.SceneAnalysisProvider,
								{},
								{ TopBarApp = Roact.createElement(p) }
							)
						})
					})
				}
			)
		})
	})

	return Roact.mount(element, p2)
end

return renderTopBarApp
