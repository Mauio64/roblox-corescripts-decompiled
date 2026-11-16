local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local React = require(parent.React)
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local RobloxAppLocales = require(parent.RobloxAppLocales)
local localization = RobloxAppLocales.Localization
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local connectToStore = require(PurchasePrompt.connectToStore)
local generateVIPServerLink = require(PurchasePrompt.Thunks.generateVIPServerLink)
local saveVIPServerConfiguration = require(PurchasePrompt.Thunks.saveVIPServerConfiguration)
local searchUsers = require(PurchasePrompt.Thunks.searchUsers)
local teleportToVIPServer = require(PurchasePrompt.Utils.teleportToVIPServer)
require(PurchasePrompt.types)

local VIPServerConfigurationView = require(script.Parent.VIPServerConfigurationView)
local useVIPServerConfigurationViewModel = require(script.Parent.useVIPServerConfigurationViewModel)
local VIPServerJoinView = require(script.Parent.VIPServerJoinView)
local useVIPServerJoinViewModel = require(script.Parent.useVIPServerJoinViewModel)

local function VIPServerConfiguration(props)
	local v = useVIPServerConfigurationViewModel({
		defaultServerName = props.serverName,
		generateLink = props.generateLink,
		save = props.save,
		searchUsers = props.searchUsers,
		onSaved = props.onSaved,
		onClose = props.onClose,
		players = Players
	})

	return React.createElement(VIPServerConfigurationView, v)
end

local function VIPServerJoin(props)
	local v = useVIPServerJoinViewModel({
		vipServerAccessCode = props.vipServerAccessCode,
		serverName = props.serverName,
		gameName = props.gameName,
		thumbnailUrl = props.thumbnailUrl,
		teleport = teleportToVIPServer,
		onClose = props.onClose
	})

	return React.createElement(VIPServerJoinView, v)
end

local function VIPServerPostPurchase(props)
	local state, setState = React.useState(false)
	local vipServerAccessCode = props.vipServerAccessCode
	local onClose = props.onClose

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
			onClose = onClose
		})
	end

	return React.createElement(VIPServerConfiguration, {
		serverName = props.serverName,
		generateLink = props.generateLink,
		save = props.save,
		searchUsers = props.searchUsers,
		onSaved = onSaved,
		onClose = onClose
	})
end

local function VIPServerPostPurchaseContainer(p)
	return React.createElement(
		LocalizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			FocusRoot = React.createElement(
				FocusRoot,
				{
					surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
					isIsolated = true,
					isAutoFocusRoot = true
				},
				{
					VIPServerPostPurchase = React.createElement(VIPServerPostPurchase, p)
				}
			)
		}
	)
end

return connectToStore(function(p)
	return {
		serverName = p.promptRequest.vipServerName or "",
		vipServerAccessCode = p.promptRequest.vipServerAccessCode,
		gameName = p.productInfo.name or "",
		thumbnailUrl = p.productInfo.imageUrl
	}
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
