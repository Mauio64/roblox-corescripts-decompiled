local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local useTokens = require(ServerDrivenUiParent.Foundation).Hooks.useTokens
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiInstrumentation = SduiCoreSystem.SduiInstrumentation
local getSduiServiceDependenciesStore = SduiCoreSystem.getSduiServiceDependenciesStore
local getSduiTokensStore = SduiCoreSystem.getSduiTokensStore
local getSduiPolicyStore = SduiCoreSystem.getSduiPolicyStore
local useAppPolicy = require(ServerDrivenUiParent.UniversalAppPolicy).useAppPolicy
local registerDiscoveryActions = require(ServerDrivenUi.Actions.registerDiscoveryActions)
local registerDiscoveryActionTelemetryHandlers = require(ServerDrivenUi.Actions.TelemetryHandlers.registerDiscoveryActionTelemetryHandlers)
local registerDiscoveryImpressions = require(ServerDrivenUi.Impressions.registerDiscoveryImpressions)
local registerDiscoveryUiComponents = require(ServerDrivenUi.Content.registerDiscoveryUiComponents)
local useSduiDependencies = require(ServerDrivenUi.System.useSduiDependencies)
local useSduiSocialData = require(ServerDrivenUi.DataStore.useSduiSocialData)
local SduiInGameFriendsData = require(ServerDrivenUi.DataStore.SduiInGameFriendsData)
local FFlagSduiAppPolicyBindings = require(ServerDrivenUiParent.SharedFlags).FFlagSduiAppPolicyBindings
local FFlagSduiActionTelemetryHandler = require(ServerDrivenUiParent.SharedFlags).FFlagSduiActionTelemetryHandler

local function SduiDiscoveryDependencyUpdater() -- line: 29
	-- upvalues: React (copy), SduiInstrumentation (copy), useSduiDependencies (copy), getSduiServiceDependenciesStore (copy), useTokens (copy), getSduiTokensStore (copy), FFlagSduiAppPolicyBindings (copy), useAppPolicy (copy), getSduiPolicyStore (copy), registerDiscoveryActions (copy), registerDiscoveryUiComponents (copy), registerDiscoveryImpressions (copy), FFlagSduiActionTelemetryHandler (copy), registerDiscoveryActionTelemetryHandlers (copy), useSduiSocialData (copy), SduiInGameFriendsData (copy)
	local v21 = React.useMemo(function() -- line: 30
		-- upvalues: SduiInstrumentation (copy)
		return SduiInstrumentation.new()
	end, {})
	local v22 = useSduiDependencies(v21)

	React.useEffect(function() -- line: 37
		-- upvalues: getSduiServiceDependenciesStore (copy), v22 (copy)
		getSduiServiceDependenciesStore().setDependencies(v22)
	end, { v22 })

	local v23 = useTokens()

	React.useEffect(function() -- line: 42
		-- upvalues: getSduiTokensStore (copy), v23 (copy)
		getSduiTokensStore().setTokens(v23)
	end, { v23 })

	if FFlagSduiAppPolicyBindings then
		local v24 = useAppPolicy(function(p1) -- line: 47
			return p1
		end)

		React.useEffect(function() -- line: 50
			-- upvalues: getSduiPolicyStore (copy), v24 (copy)
			getSduiPolicyStore().setAppPolicy(v24)
		end, { v24 })
	end

	React.useEffect(function() -- line: 55
		-- upvalues: registerDiscoveryActions (copy), registerDiscoveryUiComponents (copy), registerDiscoveryImpressions (copy), FFlagSduiActionTelemetryHandler (copy), registerDiscoveryActionTelemetryHandlers (copy)
		registerDiscoveryActions()
		registerDiscoveryUiComponents()
		registerDiscoveryImpressions()

		if FFlagSduiActionTelemetryHandler then
			registerDiscoveryActionTelemetryHandlers()
		end
	end, {})

	local v25 = useSduiSocialData()

	React.useEffect(function() -- line: 66
		-- upvalues: SduiInGameFriendsData (copy), v25 (copy)
		SduiInGameFriendsData.setInGameFriendsByGameSignal(v25.getInGameFriendsByGame)
	end, { v25 })

	return nil
end

return React.memo(SduiDiscoveryDependencyUpdater)
