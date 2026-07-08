local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local LocalizationService = game:GetService("LocalizationService")
local InExperienceSquadContract = require(AppChat.Contracts).SquadContract.InExperienceSquadContract
local Contexts = require(AppChat.Contexts)
local UnreadMessagesProvider = Contexts.UnreadMessagesProvider
local ParentContainerProvider = Contexts.ParentContainer.ParentContainerProvider
local ApolloProvider = require(AppChatParent.ApolloClient).ApolloProvider
local Localization = require(AppChatParent.RobloxAppLocales).Localization
local LocalizationProvider = require(AppChatParent.Localization).LocalizationProvider
local React = require(AppChatParent.React)
local RoactUtils = require(AppChatParent.RoactUtils)
local RoactRodux = require(AppChatParent.RoactRodux)
local SquadExternalContractProvider = require(AppChatParent.SquadsCore.SquadExternalContractProvider)
local SharedFlags = require(AppChatParent.SharedFlags)
local SquadExternalContractProvider2 = SquadExternalContractProvider.SquadExternalContractProvider
local SquadLocationEnum = require(AppChatParent.SquadsCore.Enums).SquadLocationEnum
local ProviderContainer = RoactUtils.Components.ProviderContainer
local UniversalAppPolicy = require(AppChatParent.UniversalAppPolicy).UniversalAppPolicy
local AppFeaturePolicies = require(AppChatParent.UniversalAppPolicy).AppFeaturePolicies
local ChatPolicies = require(AppChatParent.SocialPolicies).ChatPolicies
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled

return function(t1: {[any]: any}) -- line: 46
	-- upvalues: React (copy), ParentContainerProvider (copy), UnreadMessagesProvider (copy), RoactRodux (copy), ApolloProvider (copy), UniversalAppPolicy (copy), AppFeaturePolicies (copy), ChatPolicies (copy), GetFFlagIsSquadEnabled (copy), SquadExternalContractProvider2 (copy), InExperienceSquadContract (copy), SquadLocationEnum (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), ProviderContainer (copy)
	local v24 = React.useMemo(function() -- line: 47
		-- upvalues: ParentContainerProvider (copy), t1 (copy), UnreadMessagesProvider (copy), RoactRodux (copy), ApolloProvider (copy), UniversalAppPolicy (copy), AppFeaturePolicies (copy), ChatPolicies (copy), GetFFlagIsSquadEnabled (copy), SquadExternalContractProvider2 (copy), InExperienceSquadContract (copy), SquadLocationEnum (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy)
		local t2 = {}

		table.insert(t2, {
			class = ParentContainerProvider,
			props = t1.parentContainerContext
		})
		table.insert(t2, {
			class = UnreadMessagesProvider,
			props = {
				dispatch = t1.updateAppChatUnreadMessagesCount
			}
		})
		table.insert(t2, {
			class = RoactRodux.StoreProvider,
			props = {
				store = t1.store
			}
		})
		table.insert(t2, {
			class = ApolloProvider,
			props = {
				client = t1.apolloClient
			}
		})
		table.insert(t2, {
			class = UniversalAppPolicy.Provider,
			props = {
				policy = {
					AppFeaturePolicies,
					ChatPolicies
				}
			}
		})

		if GetFFlagIsSquadEnabled() then
			table.insert(t2, {
				class = SquadExternalContractProvider2,
				props = {
					contract = InExperienceSquadContract,
					squadLocation = SquadLocationEnum.InExperience
				}
			})
		end

		table.insert(t2, {
			class = LocalizationProvider,
			props = {
				localization = Localization.new(LocalizationService.RobloxLocaleId)
			}
		})

		return t2
	end, {})

	return React.createElement(ProviderContainer, {
		providers = v24
	}, t1.children)
end
