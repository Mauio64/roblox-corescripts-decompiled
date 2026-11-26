local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/React")
local localizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/Localization").LocalizationProvider
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/RobloxAppLocales").Localization
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/ReactFocusNavigation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/FocusNavigationUtils")
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider

local connectToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/connectToStore")
local generateVIPServerLink = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/generateVIPServerLink")
local saveVIPServerConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/saveVIPServerConfiguration")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/searchUsers")
local selectProductPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectProductPrice")
local selectVIPServerOfferType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectVIPServerOfferType")
local sendPrivateServerConfigEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/sendPrivateServerConfigEvent")
local teleportToVIPServer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/teleportToVIPServer")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local VIPServerConfigurationView = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/VIPServerPostPurchase/VIPServerConfigurationView")
local useVIPServerConfigurationViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/VIPServerPostPurchase/useVIPServerConfigurationViewModel")
local VIPServerJoinView = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/VIPServerPostPurchase/VIPServerJoinView")
local useVIPServerJoinViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/VIPServerPostPurchase/useVIPServerJoinViewModel")

local function VIPServerConfiguration(props)
	local v5 = useVIPServerConfigurationViewModel({
		defaultServerName = props.serverName,
		price = props.price,
		offerType = props.offerType,
		generateLink = props.generateLink,
		save = props.save,
		searchUsers = props.searchUsers,
		logEvent = props.logEvent,
		onSaved = props.onSaved,
		onClose = props.onClose,
		players = Players
	})

	return React.createElement(VIPServerConfigurationView, v5)
end

local function VIPServerJoin(props)
	local v5 = useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.CentralOverlay,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false
	})

	local v6, v7 = ReactFocusNavigation.useDefaultFocusBehavior(v5)
	local v8 = useVIPServerJoinViewModel({
		vipServerAccessCode = props.vipServerAccessCode,
		serverName = props.serverName,
		gameName = props.gameName,
		thumbnailUrl = props.thumbnailUrl,
		teleport = teleportToVIPServer,
		logEvent = props.logEvent,
		onClose = props.onClose,
		focusRootRef = v7,
		joinButtonRef = v6
	})

	return React.createElement(VIPServerJoinView, v8)
end

local function VIPServerPostPurchase(props)
	local state, setState = React.useState(false)
	local vipServerAccessCode = props.vipServerAccessCode
	local onClose = props.onClose
	local vipServerId = props.vipServerId
	local universeId = props.universeId
	local purchaseFlowUUID = props.purchaseFlowUUID

	local v5 = React.useCallback(function(p2)
		local clone = table.clone(p2)
		clone.privateServerId = vipServerId
		clone.universeId = universeId
		clone.surface = "in_experience"
		clone.purchase_flow_uuid = purchaseFlowUUID
		sendPrivateServerConfigEvent(clone)
	end, { vipServerId, universeId, purchaseFlowUUID })

	local v6 = React.useCallback(function()
		if vipServerAccessCode == nil then
			onClose()
		else
			setState(true)
		end
	end, { vipServerAccessCode, onClose })

	if state and vipServerAccessCode ~= nil then
		return React.createElement(VIPServerJoin, {
			vipServerAccessCode = vipServerAccessCode,
			serverName = props.serverName,
			gameName = props.gameName,
			thumbnailUrl = props.thumbnailUrl,
			logEvent = v5,
			onClose = onClose
		})
	end

	return React.createElement(VIPServerConfiguration, {
		serverName = props.serverName,
		price = props.price,
		offerType = props.offerType,
		generateLink = props.generateLink,
		save = props.save,
		searchUsers = props.searchUsers,
		logEvent = v5,
		onSaved = v6,
		onClose = onClose
	})
end

local function VIPServerPostPurchaseContainer(p2)
	local v5 = React.useMemo(function()
		return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	end, {})
	React.useEffect(function()
		return function()
			v5:teardown()
		end
	end, { v5 })

	return React.createElement(
		localizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			FocusNavigationProvider = React.createElement(
				ReactFocusNavigation.FocusNavigationContext.Provider,
				{ value = v5 },
				{
					FocusNavigationRegistryProvider = React.createElement(provider, nil, {
						VIPServerPostPurchase = React.createElement(VIPServerPostPurchase, p2)
					})
				}
			)
		}
	)
end

return connectToStore(function(data)
	local v5 = {
		serverName = data.promptRequest.vipServerName or "",
		vipServerAccessCode = data.promptRequest.vipServerAccessCode,
		gameName = data.productInfo.name or "",
		thumbnailUrl = data.productInfo.imageUrl,
		vipServerId = data.promptRequest.vipServerId,
		universeId = 0,
		purchaseFlowUUID = 0,
		price = 0,
		offerType = 0
	}
	local v6 = if data.productPayload then data.productPayload.universeId else nil
	v5.universeId = v6
	v5.purchaseFlowUUID = data.purchaseAnalyticsMetadata.purchaseFlowUUID
	v5.price = selectProductPrice(data)
	v5.offerType = selectVIPServerOfferType(data)
	return v5
end, function(callback)
	return {
		generateLink = function()
			return callback(generateVIPServerLink())
		end,
		save = function(p2)
			return callback(saveVIPServerConfiguration(p2))
		end,
		searchUsers = function(p2)
			return callback(module7(p2))
		end
	}
end)(VIPServerPostPurchaseContainer)
