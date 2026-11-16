local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiInstrumentation = SduiCoreSystem.SduiInstrumentation
local getSduiServiceDependenciesStore = SduiCoreSystem.getSduiServiceDependenciesStore
local getSduiTokensStore = SduiCoreSystem.getSduiTokensStore
local getSduiPolicyStore = SduiCoreSystem.getSduiPolicyStore

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local SharedFlags = require(parent.SharedFlags)
local FFlagInitializeSduiForApp = SharedFlags.FFlagInitializeSduiForApp

local registerDiscoveryActions = require(ServerDrivenUi.Actions.registerDiscoveryActions)

local registerDiscoveryActionTelemetryHandlers = require(ServerDrivenUi.Actions.TelemetryHandlers.registerDiscoveryActionTelemetryHandlers)
local registerDiscoveryImpressions = require(ServerDrivenUi.Impressions.registerDiscoveryImpressions)
local registerDiscoveryUiComponents = require(ServerDrivenUi.Content.registerDiscoveryUiComponents)
local useSduiDependencies = require(ServerDrivenUi.System.useSduiDependencies)
local useSduiSocialData = require(ServerDrivenUi.DataStore.useSduiSocialData)
local SduiInGameFriendsData = require(ServerDrivenUi.DataStore.SduiInGameFriendsData)

local function SduiDiscoveryDependencyUpdater(): nil
	local v = useSduiDependencies((React.useMemo(function()
		return SduiInstrumentation.new()
	end, {})))

	React.useEffect(function()
		getSduiServiceDependenciesStore().setDependencies(v)
	end, { v })

	local v2 = useTokens()
	React.useEffect(function()
		getSduiTokensStore().setTokens(v2)
	end, { v2 })
	local v3 = useAppPolicy(function(p)
		return p
	end)

	React.useEffect(function()
		getSduiPolicyStore().setAppPolicy(v3)
	end, { v3 })

	if not FFlagInitializeSduiForApp then
		React.useEffect(function()
			registerDiscoveryActions()
			registerDiscoveryUiComponents()
			registerDiscoveryImpressions()
			registerDiscoveryActionTelemetryHandlers()
		end, {})
	end

	local v4 = useSduiSocialData()
	React.useEffect(function()
		SduiInGameFriendsData.setInGameFriendsByGameSignal(v4.getInGameFriendsByGame)
	end, { v4 })
	return nil
end

return React.memo(SduiDiscoveryDependencyUpdater)
