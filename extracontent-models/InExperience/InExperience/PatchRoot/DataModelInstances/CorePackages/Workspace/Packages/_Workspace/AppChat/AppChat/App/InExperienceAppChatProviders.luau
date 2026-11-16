local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local LocalizationService = game:GetService("LocalizationService")

local Contracts = require(AppChat.Contracts)
local InExperienceSquadContract = Contracts.SquadContract.InExperienceSquadContract

local Contexts = require(AppChat.Contexts)
local UnreadMessagesProvider = Contexts.UnreadMessagesProvider
local ParentContainerProvider = Contexts.ParentContainer.ParentContainerProvider

local ApolloClient = require(parent.ApolloClient)
local ApolloProvider = ApolloClient.ApolloProvider

local RobloxAppLocales = require(parent.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local RoactRodux = require(parent.RoactRodux)
local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SharedFlags = require(parent.SharedFlags)

local squadExternalContractProvider = SquadExternalContractProvider.SquadExternalContractProvider
local Enums = require(parent.SquadsCore.Enums)
local SquadLocationEnum = Enums.SquadLocationEnum
local ProviderContainer = RoactUtils.Components.ProviderContainer
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local universalAppPolicy = UniversalAppPolicy.UniversalAppPolicy
local UniversalAppPolicy2 = require(parent.UniversalAppPolicy)
local AppFeaturePolicies = UniversalAppPolicy2.AppFeaturePolicies
local SocialPolicies = require(parent.SocialPolicies)
local ChatPolicies = SocialPolicies.ChatPolicies

local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled

return function(props)
	local providers = React.useMemo(function()
		local v = {}

		table.insert(v, { class = ParentContainerProvider, props = props.parentContainerContext })

		table.insert(v, {
			class = UnreadMessagesProvider,
			props = { dispatch = props.updateAppChatUnreadMessagesCount }
		})

		table.insert(v, {
			class = RoactRodux.StoreProvider,
			props = { store = props.store }
		})

		table.insert(v, {
			class = ApolloProvider,
			props = { client = props.apolloClient }
		})

		table.insert(v, {
			class = universalAppPolicy.Provider,
			props = {
				policy = { AppFeaturePolicies, ChatPolicies }
			}
		})

		if GetFFlagIsSquadEnabled() then
			table.insert(v, {
				class = squadExternalContractProvider,
				props = {
					contract = InExperienceSquadContract,
					squadLocation = SquadLocationEnum.InExperience
				}
			})
		end

		table.insert(v, {
			class = LocalizationProvider,
			props = {
				localization = Localization.new(LocalizationService.RobloxLocaleId)
			}
		})

		return v
	end, {})

	return React.createElement(ProviderContainer, { providers = providers }, props.children)
end
