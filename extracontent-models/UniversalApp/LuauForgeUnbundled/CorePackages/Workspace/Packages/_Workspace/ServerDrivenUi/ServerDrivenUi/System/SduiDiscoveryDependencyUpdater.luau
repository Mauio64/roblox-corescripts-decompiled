local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation").Hooks.useTokens

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiInstrumentation = SduiCoreSystem.SduiInstrumentation
local getSduiServiceDependenciesStore = SduiCoreSystem.getSduiServiceDependenciesStore
local getSduiTokensStore = SduiCoreSystem.getSduiTokensStore
local getSduiPolicyStore = SduiCoreSystem.getSduiPolicyStore

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UniversalAppPolicy").useAppPolicy
local fFlagInitializeSduiForApp = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagInitializeSduiForApp

local registerDiscoveryActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/registerDiscoveryActions")

local registerDiscoveryActionTelemetryHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/registerDiscoveryActionTelemetryHandlers")
local registerDiscoveryImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Impressions/registerDiscoveryImpressions")
local registerDiscoveryUiComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/registerDiscoveryUiComponents")
local useSduiDependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/System/useSduiDependencies")
local useSduiSocialData = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/useSduiSocialData")
local SduiInGameFriendsData = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/SduiInGameFriendsData")

local function SduiDiscoveryDependencyUpdater(): nil
	local v6 = useSduiDependencies((React.useMemo(function()
		return sduiInstrumentation.new()
	end, {})))

	React.useEffect(function()
		getSduiServiceDependenciesStore().setDependencies(v6)
	end, { v6 })

	local v7 = useTokens()
	React.useEffect(function()
		getSduiTokensStore().setTokens(v7)
	end, { v7 })
	local v8 = useAppPolicy(function(p2)
		return p2
	end)

	React.useEffect(function()
		getSduiPolicyStore().setAppPolicy(v8)
	end, { v8 })

	if not fFlagInitializeSduiForApp then
		React.useEffect(function()
			registerDiscoveryActions()
			registerDiscoveryUiComponents()
			registerDiscoveryImpressions()
			registerDiscoveryActionTelemetryHandlers()
		end, {})
	end

	local v9 = useSduiSocialData()
	React.useEffect(function()
		SduiInGameFriendsData.setInGameFriendsByGameSignal(v9.getInGameFriendsByGame)
	end, { v9 })
	return nil
end

return React.memo(SduiDiscoveryDependencyUpdater)
