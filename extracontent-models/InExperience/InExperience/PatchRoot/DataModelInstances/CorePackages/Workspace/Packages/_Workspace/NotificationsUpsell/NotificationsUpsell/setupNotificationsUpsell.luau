local parent = script.Parent.Parent

local NotificationModalsManager = require(parent.NotificationModalsManager)
local NotificationsUpsellModal = require(script.Parent.Components.NotificationsUpsellModal)
local GameDetailRodux = require(parent.GameDetailRodux)
local GetGameNameAndDescription = GameDetailRodux.GetGameNameAndDescription

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDefaultHttpRetry = SharedFlags.FFlagLuaAppDefaultHttpRetry
local NotificationsCommon = require(parent.NotificationsCommon)
local sendEventDeferred = NotificationsCommon.sendEventDeferred
local ModalEventConstants = require(script.Parent.Analytics.ModalEventConstants)

local HttpRequest = require(parent.HttpRequest)
local config = HttpRequest.config
local v = { requestFunction = HttpRequest.requestFunctions.HttpRbxApi, maxRetryCount = 0 }
local maxRetryCount

if FFlagLuaAppDefaultHttpRetry then
	maxRetryCount = game:DefineFastInt("SetupNotificationsUpsellHttpRetryCount", 4)
end

v.maxRetryCount = maxRetryCount
local v2 = config(v)

local defineFastFlag = game:DefineFastFlag("NotificationsUpsellDisableBackgroundDismiss", false)

local function openModal(gameId: string)
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

	local v3, experienceName

	if gameId == "0" or gameId == "" then
		v3 = false
	else
		v3, experienceName = GetGameNameAndDescription(v2, gameId):andThen(function(p)
			return p and p.Name
		end, function(): nil
			return nil
		end):await()
	end

	sendEventDeferred(ModalEventConstants.ModalContext, ModalEventConstants.OptInEventName, {
		[ModalEventConstants.ActionType] = ModalEventConstants.Opened,
		[ModalEventConstants.UniverseId] = gameId
	})

	local openModal2 = NotificationModalsManager.OpenModal

	local props = { CloseModal = fn2, ExperienceId = gameId, ExperienceName = nil }

	if not v3 then
		experienceName = nil
	end

	props.ExperienceName = experienceName
	openModal2("UENUpsell", NotificationsUpsellModal, {
		CloseCallback = fn,
		Props = props,
		DisableBackgroundDismiss = defineFastFlag and true or nil
	})
end

return function()
	local ExperienceNotificationService = game:GetService("ExperienceNotificationService")
	ExperienceNotificationService.PromptOptInRequested:Connect(function()
		openModal(tostring(game.GameId))
	end)
end
