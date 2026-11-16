local Players = game:GetService("Players")
local SocialService = game:GetService("SocialService")
local ContextActionService = game:GetService("ContextActionService")

local GameInvite = script:FindFirstAncestor("GameInvite")
local parent = GameInvite.Parent
local utils = GameInvite.utils

require(GameInvite.gameInviteModalType)
local Cryo = require(parent.Cryo)

local GameInviteAnalyticsManager = require(GameInvite.analytics.GameInviteAnalyticsManager)
local getCustomizedInvitePromptParams = require(utils.getCustomizedInvitePromptParams)
local getCanSendAndCanCustomizeInvites = require(utils.getCanSendAndCanCustomizeInvites)
local gameInviteModalHelper = require(utils.gameInviteModalHelper)
local isTriggerDDI = gameInviteModalHelper.isTriggerDDI
local gameInviteModalHelper2 = require(utils.gameInviteModalHelper)
local isTriggerGameMenu = gameInviteModalHelper2.isTriggerGameMenu
local IxpServiceWrapper = require(parent.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper
local FFlagGameInviteInExpUserListExposure = require(GameInvite.Flags.FFlagGameInviteInExpUserListExposure)
local FStringGameInviteInExpIxpLayer = require(GameInvite.Flags.FStringGameInviteInExpIxpLayer)

game:DefineFastFlag("GameInviteModalAnalyticsEmptyEventContextFix", false)

local SharedFlags = require(parent.SharedFlags)
local FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt = SharedFlags.FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt

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

local function openDeveloperInviteModalNonBlocking(object, data, p)
	local openSession = object.openSession
	object.customParams = nil
	object.ToggleGameInviteModalEvent:Fire(true, false, data)

	ContextActionService:BindCoreAction("hideGameInviteModal", function(_, p2)
		if p2 == Enum.UserInputState.Begin then
			object:closeModal()
		end
	end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Backspace)

	task.spawn(function()
		local customizedInvitePromptParams = getCustomizedInvitePromptParams(
			p,
			data.trigger,
			getCanSendAndCanCustomizeInvites
		)

		if not object.isModalOpen or object.openSession ~= openSession then
			return
		end

		object.customParams = customizedInvitePromptParams

		if not customizedInvitePromptParams then
			object:closeModal()
			return
		end

		local is_launch_data_provided

		if customizedInvitePromptParams.launchData == nil then
			is_launch_data_provided = false
		else
			is_launch_data_provided = customizedInvitePromptParams.launchData ~= ""
		end

		local is_prompt_customized

		if customizedInvitePromptParams.promptMessage == nil then
			is_prompt_customized = false
		else
			is_prompt_customized = customizedInvitePromptParams.promptMessage ~= ""
		end

		local is_invite_message_id_provided

		if customizedInvitePromptParams.inviteMessageId == nil then
			is_invite_message_id_provided = false
		else
			is_invite_message_id_provided = customizedInvitePromptParams.inviteMessageId ~= ""
		end

		if is_launch_data_provided or is_prompt_customized or is_invite_message_id_provided then
			object.ToggleGameInviteModalEvent:Fire(
				true,
				false,
				Cryo.Dictionary.join(data, customizedInvitePromptParams)
			)
		end

		GameInviteAnalyticsManager:sendGameInviteModalEvent(data.trigger, {
			action_type = GameInviteAnalyticsManager.ActionType.ModalOpen,
			is_launch_data_provided = is_launch_data_provided,
			is_prompt_customized = is_prompt_customized,
			is_invite_message_id_provided = is_invite_message_id_provided,
			place_id = data.rootPlaceId
		})
	end)
end

function class:openModal(data, p)
	if self.isModalOpen then
		if isTriggerDDI(data.trigger) then
			self:invokeGameInvitePromptClosed()
		end
	else
		self.isModalOpen = true

		if FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt then
			self.openSession += 1
		end

		self.openTrigger = data.trigger

		self.placeId = data.rootPlaceId or tostring(game.PlaceId)

		if isTriggerDDI(data.trigger) and FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt then
			openDeveloperInviteModalNonBlocking(self, data, p)
			return
		end

		local is_launch_data_provided = false
		local is_prompt_customized = false
		local is_invite_message_id_provided = false

		if isTriggerDDI(data.trigger) then
			self.ToggleGameInviteModalEvent:Fire(true, true, data)

			local customizedInvitePromptParams = getCustomizedInvitePromptParams(
				p,
				data.trigger,
				getCanSendAndCanCustomizeInvites
			)
			self.customParams = customizedInvitePromptParams

			if customizedInvitePromptParams then
				if customizedInvitePromptParams.launchData == nil then
					is_launch_data_provided = false
				else
					is_launch_data_provided = customizedInvitePromptParams.launchData ~= ""
				end

				if customizedInvitePromptParams.promptMessage == nil then
					is_prompt_customized = false
				else
					is_prompt_customized = customizedInvitePromptParams.promptMessage ~= ""
				end

				if customizedInvitePromptParams.inviteMessageId == nil then
					is_invite_message_id_provided = false
				else
					is_invite_message_id_provided = customizedInvitePromptParams.inviteMessageId ~= ""
				end

				self.ToggleGameInviteModalEvent:Fire(
					true,
					false,
					Cryo.Dictionary.join(data, customizedInvitePromptParams)
				)

				if game:GetFastFlag("GameInviteModalAnalyticsEmptyEventContextFix") then
					GameInviteAnalyticsManager:sendGameInviteModalEvent(data.trigger, {
						action_type = GameInviteAnalyticsManager.ActionType.ModalOpen,
						is_launch_data_provided = is_launch_data_provided,
						is_prompt_customized = is_prompt_customized,
						is_invite_message_id_provided = is_invite_message_id_provided,
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
				IXPServiceWrapper:LogFlagLinkedUserLayerExposure(FStringGameInviteInExpIxpLayer)
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
				is_launch_data_provided = is_launch_data_provided,
				is_prompt_customized = is_prompt_customized,
				is_invite_message_id_provided = is_invite_message_id_provided,
				place_id = data.rootPlaceId
			})
		end

		ContextActionService:BindCoreAction("hideGameInviteModal", function(_, p2)
			if p2 == Enum.UserInputState.Begin then
				self:closeModal()
			end
		end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Backspace)
	end
end

function class:closeModal(max_recipient_row_number: number?)
	if self.isModalOpen then
		local is_launch_data_provided = false
		local is_prompt_customized = false
		local is_invite_message_id_provided = false

		if isTriggerDDI(self.openTrigger) then
			if self.customParams then
				if self.customParams.launchData == nil then
					is_launch_data_provided = false
				else
					is_launch_data_provided = self.customParams.launchData ~= ""
				end

				if self.customParams.promptMessage == nil then
					is_prompt_customized = false
				else
					is_prompt_customized = self.customParams.promptMessage ~= ""
				end

				if self.customParams.inviteMessageId == nil then
					is_invite_message_id_provided = false
				else
					is_invite_message_id_provided = self.customParams.inviteMessageId ~= ""
				end
			end

			self:invokeGameInvitePromptClosed()
		end

		GameInviteAnalyticsManager:sendGameInviteModalEvent(self.openTrigger, {
			action_type = GameInviteAnalyticsManager.ActionType.ModalClose,
			is_launch_data_provided = is_launch_data_provided,
			is_prompt_customized = is_prompt_customized,
			is_invite_message_id_provided = is_invite_message_id_provided,
			max_recipient_row_number = max_recipient_row_number,
			place_id = self.placeId
		})

		ContextActionService:UnbindCoreAction("hideGameInviteModal")
		self.isModalOpen = false

		if FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt then
			self.openSession += 1
		end

		self.openTrigger = nil
		self.placeId = nil
	end

	self.ToggleGameInviteModalEvent:Fire(false)
end

function class.isGameModalOpen(p)
	return p.isModalOpen
end

function class:invokeGameInvitePromptClosed()
	if SocialService and Players.LocalPlayer then
		SocialService:InvokeGameInvitePromptClosed(Players.LocalPlayer, {})
	end
end

return class.new()
