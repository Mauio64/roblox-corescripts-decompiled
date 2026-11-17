local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local React = require(parent.React)
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local RobloxAppLocales = require(parent.RobloxAppLocales)
local localization = RobloxAppLocales.Localization
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider

local connectToStore = require(PurchasePrompt.connectToStore)
local generateVIPServerLink = require(PurchasePrompt.Thunks.generateVIPServerLink)
local saveVIPServerConfiguration = require(PurchasePrompt.Thunks.saveVIPServerConfiguration)
local searchUsers = require(PurchasePrompt.Thunks.searchUsers)
local selectProductPrice = require(PurchasePrompt.Selectors.selectProductPrice)
local selectVIPServerOfferType = require(PurchasePrompt.Selectors.selectVIPServerOfferType)
local sendPrivateServerConfigEvent = require(PurchasePrompt.Utils.sendPrivateServerConfigEvent)
local teleportToVIPServer = require(PurchasePrompt.Utils.teleportToVIPServer)
require(PurchasePrompt.types)

local VIPServerConfigurationView = require(script.Parent.VIPServerConfigurationView)
local useVIPServerConfigurationViewModel = require(script.Parent.useVIPServerConfigurationViewModel)
local VIPServerJoinView = require(script.Parent.VIPServerJoinView)
local useVIPServerJoinViewModel = require(script.Parent.useVIPServerJoinViewModel)

local function VIPServerConfiguration(props)
	local v = useVIPServerConfigurationViewModel({
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

	return React.createElement(VIPServerConfigurationView, v)
end

local function VIPServerJoin(props)
	local v = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false
	})

	local joinButtonRef, focusRootRef = ReactFocusNavigation.useDefaultFocusBehavior(v)
	local v2 = useVIPServerJoinViewModel({
		vipServerAccessCode = props.vipServerAccessCode,
		serverName = props.serverName,
		gameName = props.gameName,
		thumbnailUrl = props.thumbnailUrl,
		teleport = teleportToVIPServer,
		logEvent = props.logEvent,
		onClose = props.onClose,
		focusRootRef = focusRootRef,
		joinButtonRef = joinButtonRef
	})

	return React.createElement(VIPServerJoinView, v2)
end

local function VIPServerPostPurchase(props)
	local state, setState = React.useState(false)
	local vipServerAccessCode = props.vipServerAccessCode
	local onClose = props.onClose
	local vipServerId = props.vipServerId
	local universeId = props.universeId
	local purchaseFlowUUID = props.purchaseFlowUUID

	local logEvent = React.useCallback(function(p)
		local clone = table.clone(p)
		clone.privateServerId = vipServerId
		clone.universeId = universeId
		clone.surface = "in_experience"
		clone.purchase_flow_uuid = purchaseFlowUUID
		sendPrivateServerConfigEvent(clone)
	end, { vipServerId, universeId, purchaseFlowUUID })

	local onSaved = React.useCallback(function()
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
			logEvent = logEvent,
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
		logEvent = logEvent,
		onSaved = onSaved,
		onClose = onClose
	})
end

local function VIPServerPostPurchaseContainer(p)
	local v = React.useMemo(function()
		return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	end, {})
	React.useEffect(function()
		return function()
			v:teardown()
		end
	end, { v })

	return React.createElement(
		LocalizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			FocusNavigationProvider = React.createElement(
				ReactFocusNavigation.FocusNavigationContext.Provider,
				{ value = v },
				{
					FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
						VIPServerPostPurchase = React.createElement(VIPServerPostPurchase, p)
					})
				}
			)
		}
	)
end

return connectToStore(function(data)
	local v = {
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
	local universeId

	if data.productPayload then
		universeId = data.productPayload.universeId
	end

	v.universeId = universeId
	v.purchaseFlowUUID = data.purchaseAnalyticsMetadata.purchaseFlowUUID
	v.price = selectProductPrice(data)
	v.offerType = selectVIPServerOfferType(data)
	return v
end, function(callback)
	return {
		generateLink = function()
			return callback(generateVIPServerLink())
		end,
		save = function(p)
			return callback(saveVIPServerConfiguration(p))
		end,
		searchUsers = function(p: string)
			return callback(searchUsers(p))
		end
	}
end)(VIPServerPostPurchaseContainer)
