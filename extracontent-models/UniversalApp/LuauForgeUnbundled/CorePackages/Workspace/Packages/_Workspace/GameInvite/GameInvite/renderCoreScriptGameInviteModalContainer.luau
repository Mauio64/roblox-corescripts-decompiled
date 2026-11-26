local CoreGui = game:GetService("CoreGui")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/RoactRodux")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/ReactRoblox")
local Style = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Style")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/UniversalAppPolicy")
local apolloProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/ApolloClient").ApolloProvider
local GameInviteConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteConstants")
local GameInviteModal = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteModal")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/gameInviteModalType")

local appFeaturePolicies = UniversalAppPolicy.AppFeaturePolicies
local roactAppPolicy = UniversalAppPolicy.RoactAppPolicy
local styleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/InExperienceLocales").Localization
local localizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Localization").LocalizationProvider
local LocalizationService = game:GetService("LocalizationService")
local foundationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Foundation").FoundationProvider

game:DefineFastFlag("FixGameInviteModalLoadTimeIncrease", false)
local v5

if game:GetFastFlag("FixGameInviteModalLoadTimeIncrease") then
	v5 = nil
else
	v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/RobloxApolloClient").initializeApolloClient({})
end

return function(client)
	local GameInviteStore = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/State/GameInviteStore")
	local gameInvite = Instance.new("Folder")
	gameInvite.Name = "GameInvite"
	gameInvite.Parent = CoreGui

	local createElement = React.createElement
	local v7 = {
		localization = localization.new(LocalizationService.RobloxLocaleId)
	}

	local createElement2 = React.createElement
	local storeProvider = RoactRodux.StoreProvider

	local createElement3 = React.createElement
	local provider = roactAppPolicy.Provider

	local createElement4 = React.createElement
	local createElement5 = React.createElement

	if not game:GetFastFlag("FixGameInviteModalLoadTimeIncrease") then
		client = v5
	end

	local element = createElement(localizationProvider, v7, {
		createElement2(storeProvider, { store = GameInviteStore }, {
			PolicyProvider = createElement3(provider, {
				policy = { appFeaturePolicies }
			}, {
				StyleProvider = createElement4(styleProviderWithDefaultTheme, {}, {
					ApolloClientProvider = createElement5(apolloProvider, {
						client = client
					}, {
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
	root:render(React.createElement(foundationProvider, nil, { element }))

	return root
end
