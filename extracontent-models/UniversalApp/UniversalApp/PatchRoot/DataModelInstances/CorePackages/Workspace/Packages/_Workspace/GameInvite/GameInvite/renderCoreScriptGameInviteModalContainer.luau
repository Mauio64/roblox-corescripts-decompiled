local CoreGui = game:GetService("CoreGui")
local scriptParent = script.Parent
local Components = scriptParent.Components
local scriptParentParent = scriptParent.Parent
local React = require(scriptParentParent.React)
local RoactRodux = require(scriptParentParent.RoactRodux)
local ReactRoblox = require(scriptParentParent.ReactRoblox)
local Style = require(scriptParentParent.Style)
local UniversalAppPolicy = require(scriptParentParent.UniversalAppPolicy)
local ApolloProvider = require(scriptParentParent.ApolloClient).ApolloProvider
local GameInviteConstants = require(scriptParent.GameInviteConstants)
local GameInviteModal = require(Components.GameInviteModal)

require(scriptParent.gameInviteModalType)

local AppFeaturePolicies = UniversalAppPolicy.AppFeaturePolicies
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local Localization = require(scriptParentParent.InExperienceLocales).Localization
local LocalizationProvider = require(scriptParentParent.Localization).LocalizationProvider
local LocalizationService = game:GetService("LocalizationService")
local FoundationProvider = require(scriptParentParent.Foundation).FoundationProvider

game:DefineFastFlag("FixGameInviteModalLoadTimeIncrease", false)

local u20 = nil

if not game:GetFastFlag("FixGameInviteModalLoadTimeIncrease") then
	u20 = require(scriptParentParent.RobloxApolloClient).initializeApolloClient({})
end

return function(p1) -- line: 34
	-- upvalues: scriptParent (copy), CoreGui (copy), React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), RoactRodux (copy), RoactAppPolicy (copy), AppFeaturePolicies (copy), StyleProviderWithDefaultTheme (copy), ApolloProvider (copy), u20 (ref), GameInviteModal (copy), GameInviteConstants (copy), ReactRoblox (copy), FoundationProvider (copy)
	local GameInviteStore = require(scriptParent.State.GameInviteStore)
	local Folder = Instance.new("Folder")

	Folder.Name = "GameInvite"
	Folder.Parent = CoreGui

	local v24 = React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, { React.createElement(RoactRodux.StoreProvider, {
		store = GameInviteStore
	}, {
		PolicyProvider = React.createElement(RoactAppPolicy.Provider, {
			policy = { AppFeaturePolicies }
		}, {
			StyleProvider = React.createElement(StyleProviderWithDefaultTheme, {}, {
				ApolloClientProvider = React.createElement(ApolloProvider, {
					client = if not game:GetFastFlag("FixGameInviteModalLoadTimeIncrease") then u20 else p1
				}, {
					GameInviteModalWrapper = React.createElement(GameInviteModal, {
						displayOrder = -1,
						renderLocation = GameInviteConstants.RenderLocation.CoreScripts
					})
				})
			})
		})
	}) })
	local v25 = ReactRoblox.createRoot(Folder)

	v25:render(React.createElement(FoundationProvider, nil, { v24 }))

	return v25
end
