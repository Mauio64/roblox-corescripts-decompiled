local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local SocialServerDrivenUiParent = SocialServerDrivenUi.Parent
local SduiCoreSystem = require(SocialServerDrivenUiParent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry
local FFlagLuaAppSduiVerificationUpsellActions = require(SocialServerDrivenUiParent.SharedFlags).FFlagLuaAppSduiVerificationUpsellActions

local function registerSocialActions() -- line: 12
	-- upvalues: SduiActionType (copy), FFlagLuaAppSduiVerificationUpsellActions (copy), SocialServerDrivenUi (copy), getSduiActionHandlerRegistry (copy)
	local t1 = {
		[SduiActionType.OpenFacialAgeEstimation] = if FFlagLuaAppSduiVerificationUpsellActions then nil else {
			lazyHandler = function() -- line: 19
				-- upvalues: SocialServerDrivenUi (copy)
				return require(SocialServerDrivenUi.Actions.SduiOpenFacialAgeEstimationAction)
			end
		},
		[SduiActionType.OpenAddConnectionsPage] = {
			lazyHandler = function() -- line: 25
				-- upvalues: SocialServerDrivenUi (copy)
				return require(SocialServerDrivenUi.Actions.SduiOpenAddConnectionsPageAction)
			end
		},
		[SduiActionType.OpenMarketplace] = {
			lazyHandler = function() -- line: 30
				-- upvalues: SocialServerDrivenUi (copy)
				return require(SocialServerDrivenUi.Actions.SduiOpenMarketplaceAction)
			end
		},
		[SduiActionType.HideProfileCompletion] = {
			lazyHandler = function() -- line: 35
				-- upvalues: SocialServerDrivenUi (copy)
				return require(SocialServerDrivenUi.Actions.SduiHideProfileCompletionAction)
			end
		}
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(t1)
end

return registerSocialActions
