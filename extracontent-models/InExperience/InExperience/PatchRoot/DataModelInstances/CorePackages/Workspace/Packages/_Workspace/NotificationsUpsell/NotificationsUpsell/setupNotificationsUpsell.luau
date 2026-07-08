local ParentParent = script.Parent.Parent
local NotificationModalsManager = require(ParentParent.NotificationModalsManager)
local NotificationsUpsellModal = require(script.Parent.Components.NotificationsUpsellModal)
local GetGameNameAndDescription = require(ParentParent.GameDetailRodux).GetGameNameAndDescription
local FFlagLuaAppDefaultHttpRetry = require(ParentParent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local sendEventDeferred = require(ParentParent.NotificationsCommon).sendEventDeferred
local ModalEventConstants = require(script.Parent.Analytics.ModalEventConstants)
local HttpRequest = require(ParentParent.HttpRequest)
local v9 = HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.HttpRbxApi,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("SetupNotificationsUpsellHttpRetryCount", 4)
})
local v10 = game:DefineFastFlag("NotificationsUpsellDisableBackgroundDismiss", false)

local function openModal(s1: string) -- line: 22
	-- upvalues: sendEventDeferred (copy), ModalEventConstants (copy), NotificationModalsManager (copy), GetGameNameAndDescription (copy), v9 (copy), NotificationsUpsellModal (copy), v10 (copy)
	local v13 = false
	local v14 = nil

	if s1 ~= "0" and s1 ~= "" then
		v13, v14 = GetGameNameAndDescription(v9, s1):andThen(function(p1) -- line: 36
			return p1 and p1.Name
		end, function() -- line: 38
			return nil
		end):await()
	end

	sendEventDeferred(ModalEventConstants.ModalContext, ModalEventConstants.OptInEventName, {
		[ModalEventConstants.ActionType] = ModalEventConstants.Opened,
		[ModalEventConstants.UniverseId] = s1
	})
	NotificationModalsManager.OpenModal("UENUpsell", NotificationsUpsellModal, {
		CloseCallback = function() -- line: 23
			-- upvalues: sendEventDeferred (copy), ModalEventConstants (copy), s1 (copy)
			game:GetService("ExperienceNotificationService"):InvokeOptInPromptClosed()
			sendEventDeferred(ModalEventConstants.ModalContext, ModalEventConstants.OptInEventName, {
				[ModalEventConstants.ActionType] = ModalEventConstants.Closed,
				[ModalEventConstants.UniverseId] = s1
			})
		end,
		Props = {
			CloseModal = function() -- line: 30
				-- upvalues: NotificationModalsManager (copy)
				NotificationModalsManager.CloseModal("UENUpsell")
			end,
			ExperienceId = s1,
			ExperienceName = if not v13 then nil else v14
		},
		DisableBackgroundDismiss = not not v10 or nil
	})
end

return function() -- line: 59
	-- upvalues: openModal (copy)
	game:GetService("ExperienceNotificationService").PromptOptInRequested:Connect(function() -- line: 60
		-- upvalues: openModal (copy)
		openModal((tostring(game.GameId)))
	end)
end
