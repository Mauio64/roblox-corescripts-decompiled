local LocalizationService = game:GetService("LocalizationService")

local inExperienceSquadContract = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contracts").SquadContract.InExperienceSquadContract

local Contexts = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts")
local unreadMessagesProvider = Contexts.UnreadMessagesProvider
local parentContainerProvider = Contexts.ParentContainer.ParentContainerProvider

local apolloProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ApolloClient").ApolloProvider

local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppLocales").Localization
local localizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").LocalizationProvider
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactRodux")
local SquadExternalContractProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/SquadExternalContractProvider")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")

local squadExternalContractProvider = SquadExternalContractProvider.SquadExternalContractProvider
local squadLocationEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Enums").SquadLocationEnum
local providerContainer = RoactUtils.Components.ProviderContainer
local universalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalAppPolicy").UniversalAppPolicy
local appFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalAppPolicy").AppFeaturePolicies
local chatPolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialPolicies").ChatPolicies

local getFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled

return function(props)
	local v5 = React.useMemo(function()
		local v6 = {}

		table.insert(v6, {
			class = parentContainerProvider,
			props = props.parentContainerContext
		})

		table.insert(v6, {
			class = unreadMessagesProvider,
			props = { dispatch = props.updateAppChatUnreadMessagesCount }
		})

		table.insert(v6, {
			class = RoactRodux.StoreProvider,
			props = { store = props.store }
		})

		table.insert(v6, {
			class = apolloProvider,
			props = { client = props.apolloClient }
		})

		table.insert(v6, {
			class = universalAppPolicy.Provider,
			props = {
				policy = { appFeaturePolicies, chatPolicies }
			}
		})

		if getFFlagIsSquadEnabled() then
			table.insert(v6, {
				class = squadExternalContractProvider,
				props = {
					contract = inExperienceSquadContract,
					squadLocation = squadLocationEnum.InExperience
				}
			})
		end

		table.insert(v6, {
			class = localizationProvider,
			props = {
				localization = localization.new(LocalizationService.RobloxLocaleId)
			}
		})

		return v6
	end, {})

	return React.createElement(providerContainer, { providers = v5 }, props.children)
end
