local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/React")
local localizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/Localization").LocalizationProvider
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/RobloxAppLocales").Localization
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/FocusNavigationUtils")
local focusRoot = FocusNavigationUtils.FocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local connectToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/connectToStore")
local generateVIPServerLink = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/generateVIPServerLink")
local saveVIPServerConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/saveVIPServerConfiguration")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/searchUsers")
local teleportToVIPServer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/teleportToVIPServer")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local VIPServerConfigurationView = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/VIPServerPostPurchase/VIPServerConfigurationView")
local useVIPServerConfigurationViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/VIPServerPostPurchase/useVIPServerConfigurationViewModel")
local VIPServerJoinView = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/VIPServerPostPurchase/VIPServerJoinView")
local useVIPServerJoinViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/VIPServerPostPurchase/useVIPServerJoinViewModel")

local function VIPServerConfiguration(props)
	local v5 = useVIPServerConfigurationViewModel({
		defaultServerName = props.serverName,
		generateLink = props.generateLink,
		save = props.save,
		searchUsers = props.searchUsers,
		onSaved = props.onSaved,
		onClose = props.onClose,
		players = Players
	})

	return React.createElement(VIPServerConfigurationView, v5)
end

local function VIPServerJoin(props)
	local v5 = useVIPServerJoinViewModel({
		vipServerAccessCode = props.vipServerAccessCode,
		serverName = props.serverName,
		gameName = props.gameName,
		thumbnailUrl = props.thumbnailUrl,
		teleport = teleportToVIPServer,
		onClose = props.onClose
	})

	return React.createElement(VIPServerJoinView, v5)
end

local function VIPServerPostPurchase(props)
	local state, setState = React.useState(false)
	local vipServerAccessCode = props.vipServerAccessCode
	local onClose = props.onClose

	local v5 = React.useCallback(function()
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
		onSaved = v5,
		onClose = onClose
	})
end

local function VIPServerPostPurchaseContainer(p2)
	return React.createElement(
		localizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			FocusRoot = React.createElement(
				focusRoot,
				{
					surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.CentralOverlay,
					isIsolated = true,
					isAutoFocusRoot = true
				},
				{
					VIPServerPostPurchase = React.createElement(VIPServerPostPurchase, p2)
				}
			)
		}
	)
end

return connectToStore(function(p2)
	return {
		serverName = p2.promptRequest.vipServerName or "",
		vipServerAccessCode = p2.promptRequest.vipServerAccessCode,
		gameName = p2.productInfo.name or "",
		thumbnailUrl = p2.productInfo.imageUrl
	}
end, function(callback)
	return {
		generateLink = function()
			return callback(generateVIPServerLink())
		end,
		save = function(p2)
			return callback(saveVIPServerConfiguration(p2))
		end,
		searchUsers = function(p2)
			return callback(module6(p2))
		end
	}
end)(VIPServerPostPurchaseContainer)
