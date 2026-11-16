local Players = game:GetService("Players")
local SocialService = game:GetService("SocialService")
local ContextActionService = game:GetService("ContextActionService")

require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/gameInviteModalType")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Cryo")

local GameInviteAnalyticsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/analytics/GameInviteAnalyticsManager")
local getCustomizedInvitePromptParams = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/getCustomizedInvitePromptParams")
local getCanSendAndCanCustomizeInvites = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/getCanSendAndCanCustomizeInvites")
local isTriggerDDI = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/gameInviteModalHelper").isTriggerDDI
local isTriggerGameMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/gameInviteModalHelper").isTriggerGameMenu
local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/IxpServiceWrapper").IXPServiceWrapper
local FFlagGameInviteInExpUserListExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Flags/FFlagGameInviteInExpUserListExposure")
local FStringGameInviteInExpIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Flags/FStringGameInviteInExpIxpLayer")

game:DefineFastFlag("GameInviteModalAnalyticsEmptyEventContextFix", false)

local fFlagGameInviteOpenModalWithoutBlockingOnCanPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedFlags").FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt

local class = {}
class.__index = class

function class.new()
	return (setmetatable({}, class))
end

class.ToggleGameInviteModalEvent = Instance.new("BindableEvent")
class.isModalOpen = false
class.openTrigger = nil
class.customParams = nil
class.placeId = nil
class.openSession = 0

local function openDeveloperInviteModalNonBlocking(object, data, p2)
	local openSession = object.openSession
	object.customParams = nil
	object.ToggleGameInviteModalEvent:Fire(true, false, data)

	ContextActionService:BindCoreAction("hideGameInviteModal", function(p3, p4)
		if p4 == Enum.UserInputState.Begin then
			object:closeModal()
		end
	end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Backspace)

	task.spawn(function()
		local v5 = getCustomizedInvitePromptParams(p2, data.trigger, getCanSendAndCanCustomizeInvites)

		if not object.isModalOpen or object.openSession ~= openSession then
			return
		end

		object.customParams = v5

		if not v5 then
			object:closeModal()
			return
		end

		local v6 = not (v5.launchData == nil) and v5.launchData ~= ""
		local v7 = not (v5.promptMessage == nil) and v5.promptMessage ~= ""
		local v8 = not (v5.inviteMessageId == nil) and v5.inviteMessageId ~= ""

		if v6 or v7 or v8 then
			object.ToggleGameInviteModalEvent:Fire(true, false, Cryo.Dictionary.join(data, v5))
		end

		GameInviteAnalyticsManager:sendGameInviteModalEvent(data.trigger, {
			action_type = GameInviteAnalyticsManager.ActionType.ModalOpen,
			is_launch_data_provided = v6,
			is_prompt_customized = v7,
			is_invite_message_id_provided = v8,
			place_id = data.rootPlaceId
		})
	end)
end

function class:openModal(data, p2)
	if self.isModalOpen then
		if isTriggerDDI(data.trigger) then
			self:invokeGameInvitePromptClosed()
		end
	else
		self.isModalOpen = true

		if fFlagGameInviteOpenModalWithoutBlockingOnCanPrompt then
			self.openSession += 1
		end

		self.openTrigger = data.trigger

		self.placeId = data.rootPlaceId or tostring(game.PlaceId)

		if isTriggerDDI(data.trigger) and fFlagGameInviteOpenModalWithoutBlockingOnCanPrompt then
			openDeveloperInviteModalNonBlocking(self, data, p2)
			return
		end

		local v5 = false
		local v6 = false
		local v7 = false

		if isTriggerDDI(data.trigger) then
			self.ToggleGameInviteModalEvent:Fire(true, true, data)

			local v8 = getCustomizedInvitePromptParams(p2, data.trigger, getCanSendAndCanCustomizeInvites)
			self.customParams = v8

			if v8 then
				v5 = not (v8.launchData == nil) and v8.launchData ~= ""
				v6 = not (v8.promptMessage == nil) and v8.promptMessage ~= ""
				v7 = not (v8.inviteMessageId == nil) and v8.inviteMessageId ~= ""

				self.ToggleGameInviteModalEvent:Fire(true, false, Cryo.Dictionary.join(data, v8))

				if game:GetFastFlag("GameInviteModalAnalyticsEmptyEventContextFix") then
					GameInviteAnalyticsManager:sendGameInviteModalEvent(data.trigger, {
						action_type = GameInviteAnalyticsManager.ActionType.ModalOpen,
						is_launch_data_provided = v5,
						is_prompt_customized = v6,
						is_invite_message_id_provided = v7,
						place_id = data.rootPlaceId,
						hideCloseButton = data.hideCloseButton
					})
				end
			else
				self:closeModal()
			end
		else
			self.ToggleGameInviteModalEvent:Fire(true, false, data)

			if FFlagGameInviteInExpUserListExposure and isTriggerGameMenu(data.trigger) then
				ixpServiceWrapper:LogFlagLinkedUserLayerExposure(FStringGameInviteInExpIxpLayer)
			end

			if game:GetFastFlag("GameInviteModalAnalyticsEmptyEventContextFix") then
				GameInviteAnalyticsManager:sendGameInviteModalEvent(data.trigger, {
					action_type = GameInviteAnalyticsManager.ActionType.ModalOpen,
					is_launch_data_provided = false,
					is_prompt_customized = false,
					is_invite_message_id_provided = false,
					place_id = data.rootPlaceId
				})
			end
		end

		if not game:GetFastFlag("GameInviteModalAnalyticsEmptyEventContextFix") then
			GameInviteAnalyticsManager:sendGameInviteModalEvent(data.trigger, {
				action_type = GameInviteAnalyticsManager.ActionType.ModalOpen,
				is_launch_data_provided = v5,
				is_prompt_customized = v6,
				is_invite_message_id_provided = v7,
				place_id = data.rootPlaceId
			})
		end

		ContextActionService:BindCoreAction("hideGameInviteModal", function(p3, p4)
			if p4 == Enum.UserInputState.Begin then
				self:closeModal()
			end
		end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Backspace)
	end
end

function class:closeModal(p2)
	if self.isModalOpen then
		local v5 = false
		local v6 = false
		local v7 = false

		if isTriggerDDI(self.openTrigger) then
			if self.customParams then
				v5 = not (self.customParams.launchData == nil) and self.customParams.launchData ~= ""
				v6 = not (self.customParams.promptMessage == nil) and self.customParams.promptMessage ~= ""
				v7 = not (self.customParams.inviteMessageId == nil)
					and self.customParams.inviteMessageId ~= ""
			end

			self:invokeGameInvitePromptClosed()
		end

		GameInviteAnalyticsManager:sendGameInviteModalEvent(self.openTrigger, {
			action_type = GameInviteAnalyticsManager.ActionType.ModalClose,
			is_launch_data_provided = v5,
			is_prompt_customized = v6,
			is_invite_message_id_provided = v7,
			max_recipient_row_number = p2,
			place_id = self.placeId
		})

		ContextActionService:UnbindCoreAction("hideGameInviteModal")
		self.isModalOpen = false

		if fFlagGameInviteOpenModalWithoutBlockingOnCanPrompt then
			self.openSession += 1
		end

		self.openTrigger = nil
		self.placeId = nil
	end

	self.ToggleGameInviteModalEvent:Fire(false)
end

function class.isGameModalOpen(p2)
	return p2.isModalOpen
end

function class:invokeGameInvitePromptClosed()
	if SocialService and Players.LocalPlayer then
		SocialService:InvokeGameInvitePromptClosed(Players.LocalPlayer, {})
	end
end

return class.new()
