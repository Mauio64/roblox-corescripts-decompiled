local NotificationModalsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationModalsManager")
local NotificationsUpsellModal = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Components/NotificationsUpsellModal")
local getGameNameAndDescription = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/GameDetailRodux").GetGameNameAndDescription

local fFlagLuaAppDefaultHttpRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/SharedFlags").FFlagLuaAppDefaultHttpRetry
local sendEventDeferred = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsCommon").sendEventDeferred
local ModalEventConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Analytics/ModalEventConstants")

local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/HttpRequest")
local config = HttpRequest.config
local v5 = { requestFunction = HttpRequest.requestFunctions.HttpRbxApi, maxRetryCount = 0 }

local v6 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt(
	"SetupNotificationsUpsellHttpRetryCount",
	4
) else nil
v5.maxRetryCount = v6
local v7 = config(v5)

local defineFastFlag = game:DefineFastFlag("NotificationsUpsellDisableBackgroundDismiss", false)

local function openModal(gameId)
	local function fn()
		local ExperienceNotificationService = game:GetService("ExperienceNotificationService")
		ExperienceNotificationService:InvokeOptInPromptClosed()
		sendEventDeferred(ModalEventConstants.ModalContext, ModalEventConstants.OptInEventName, {
			[ModalEventConstants.ActionType] = ModalEventConstants.Closed,
			[ModalEventConstants.UniverseId] = gameId
		})
	end
	local function fn2()
		NotificationModalsManager.CloseModal("UENUpsell")
	end

	local v8, v9

	if gameId == "0" or gameId == "" then
		v8 = false
	else
		v8, v9 = getGameNameAndDescription(v7, gameId):andThen(function(p2)
			return p2 and p2.Name
		end, function(): nil
			return nil
		end):await()
	end

	sendEventDeferred(ModalEventConstants.ModalContext, ModalEventConstants.OptInEventName, {
		[ModalEventConstants.ActionType] = ModalEventConstants.Opened,
		[ModalEventConstants.UniverseId] = gameId
	})

	local openModal2 = NotificationModalsManager.OpenModal

	local v15 = { CloseModal = fn2, ExperienceId = gameId, ExperienceName = nil }

	if not v8 then
		v9 = nil
	end

	v15.ExperienceName = v9
	openModal2("UENUpsell", NotificationsUpsellModal, {
		CloseCallback = fn,
		Props = v15,
		DisableBackgroundDismiss = defineFastFlag and true or nil
	})
end

return function()
	local ExperienceNotificationService = game:GetService("ExperienceNotificationService")
	ExperienceNotificationService.PromptOptInRequested:Connect(function()
		openModal(tostring(game.GameId))
	end)
end
