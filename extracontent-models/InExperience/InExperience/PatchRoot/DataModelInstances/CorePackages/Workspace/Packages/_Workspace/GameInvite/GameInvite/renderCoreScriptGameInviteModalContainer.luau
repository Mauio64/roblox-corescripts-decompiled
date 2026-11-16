local CoreGui = game:GetService("CoreGui")
local parent = script.Parent
local components = parent.Components
local parent2 = parent.Parent

local React = require(parent2.React)
local RoactRodux = require(parent2.RoactRodux)
local ReactRoblox = require(parent2.ReactRoblox)
local Style = require(parent2.Style)
local UniversalAppPolicy = require(parent2.UniversalAppPolicy)
local ApolloClient = require(parent2.ApolloClient)
local ApolloProvider = ApolloClient.ApolloProvider
local GameInviteConstants = require(parent.GameInviteConstants)
local GameInviteModal = require(components.GameInviteModal)
require(parent.gameInviteModalType)

local AppFeaturePolicies = UniversalAppPolicy.AppFeaturePolicies
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local InExperienceLocales = require(parent2.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(parent2.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local LocalizationService = game:GetService("LocalizationService")
local Foundation = require(parent2.Foundation)
local FoundationProvider = Foundation.FoundationProvider

game:DefineFastFlag("FixGameInviteModalLoadTimeIncrease", false)
local v

if game:GetFastFlag("FixGameInviteModalLoadTimeIncrease") then
	v = nil
else
	local RobloxApolloClient = require(parent2.RobloxApolloClient)
	v = RobloxApolloClient.initializeApolloClient({})
end

return function(client)
	local GameInviteStore = require(parent.State.GameInviteStore)
	local gameInvite = Instance.new("Folder")
	gameInvite.Name = "GameInvite"
	gameInvite.Parent = CoreGui

	local createElement = React.createElement
	local v2 = {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}

	local createElement2 = React.createElement
	local storeProvider = RoactRodux.StoreProvider

	local createElement3 = React.createElement
	local provider = RoactAppPolicy.Provider

	local createElement4 = React.createElement
	local createElement5 = React.createElement

	if not game:GetFastFlag("FixGameInviteModalLoadTimeIncrease") then
		client = v
	end

	local element = createElement(LocalizationProvider, v2, {
		createElement2(storeProvider, { store = GameInviteStore }, {
			PolicyProvider = createElement3(provider, {
				policy = { AppFeaturePolicies }
			}, {
				StyleProvider = createElement4(StyleProviderWithDefaultTheme, {}, {
					ApolloClientProvider = createElement5(ApolloProvider, { client = client }, {
						GameInviteModalWrapper = React.createElement(GameInviteModal, {
							displayOrder = -1,
							renderLocation = GameInviteConstants.RenderLocation.CoreScripts
						})
					})
				})
			})
		})
	})

	local root = ReactRoblox.createRoot(gameInvite)
	root:render(React.createElement(FoundationProvider, nil, { element }))

	return root
end
