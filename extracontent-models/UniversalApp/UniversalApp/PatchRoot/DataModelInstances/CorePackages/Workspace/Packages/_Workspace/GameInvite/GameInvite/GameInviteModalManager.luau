local Players = game:GetService("Players")
local SocialService = game:GetService("SocialService")
local ContextActionService = game:GetService("ContextActionService")
local GameInvite = script:FindFirstAncestor("GameInvite")
local GameInviteParent = GameInvite.Parent
local utils = GameInvite.utils

require(GameInvite.gameInviteModalType)

local Cryo = require(GameInviteParent.Cryo)
local GameInviteAnalyticsManager = require(GameInvite.analytics.GameInviteAnalyticsManager)
local getCustomizedInvitePromptParams = require(utils.getCustomizedInvitePromptParams)
local getCanSendAndCanCustomizeInvites = require(utils.getCanSendAndCanCustomizeInvites)
local isTriggerDDI = require(utils.gameInviteModalHelper).isTriggerDDI

game:DefineFastFlag("GameInviteModalAnalyticsEmptyEventContextFix", false)

local t1 = {}

t1.__index = t1

function t1.new() -- line: 23
	-- upvalues: t1 (copy)
	return (setmetatable({}, t1))
end

t1.ToggleGameInviteModalEvent = Instance.new("BindableEvent")
t1.isModalOpen = false
t1.openTrigger = nil
t1.customParams = nil
t1.placeId = nil

function t1.openModal(p1, p2, p3) -- line: 37
	-- upvalues: isTriggerDDI (copy), getCustomizedInvitePromptParams (copy), getCanSendAndCanCustomizeInvites (copy), Cryo (copy), GameInviteAnalyticsManager (copy), ContextActionService (copy)
	if not p1.isModalOpen then
		p1.isModalOpen = true
		p1.openTrigger = p2.trigger
		p1.placeId = p2.rootPlaceId or tostring(game.PlaceId)

		local v16 = false
		local v17 = false
		local v18 = false

		if isTriggerDDI(p2.trigger) then
			p1.ToggleGameInviteModalEvent:Fire(true, true, p2)

			local v19 = getCustomizedInvitePromptParams(p3, p2.trigger, getCanSendAndCanCustomizeInvites)

			p1.customParams = v19

			if v19 then
				v16 = v19.launchData ~= nil and v19.launchData ~= ""
				v17 = v19.promptMessage ~= nil and v19.promptMessage ~= ""
				v18 = v19.inviteMessageId ~= nil and v19.inviteMessageId ~= ""
				p1.ToggleGameInviteModalEvent:Fire(true, false, Cryo.Dictionary.join(p2, v19))

				if game:GetFastFlag("GameInviteModalAnalyticsEmptyEventContextFix") then
					GameInviteAnalyticsManager:sendGameInviteModalEvent(p2.trigger, {
						action_type = GameInviteAnalyticsManager.ActionType.ModalOpen,
						is_launch_data_provided = v16,
						is_prompt_customized = v17,
						is_invite_message_id_provided = v18,
						place_id = p2.rootPlaceId,
						hideCloseButton = p2.hideCloseButton
					})
				end
			else
				p1:closeModal()
			end
		else
			p1.ToggleGameInviteModalEvent:Fire(true, false, p2)

			if game:GetFastFlag("GameInviteModalAnalyticsEmptyEventContextFix") then
				GameInviteAnalyticsManager:sendGameInviteModalEvent(p2.trigger, {
					action_type = GameInviteAnalyticsManager.ActionType.ModalOpen,
					is_launch_data_provided = v16,
					is_prompt_customized = v17,
					is_invite_message_id_provided = v18,
					place_id = p2.rootPlaceId
				})
			end
		end

		if not game:GetFastFlag("GameInviteModalAnalyticsEmptyEventContextFix") then
			GameInviteAnalyticsManager:sendGameInviteModalEvent(p2.trigger, {
				action_type = GameInviteAnalyticsManager.ActionType.ModalOpen,
				is_launch_data_provided = v16,
				is_prompt_customized = v17,
				is_invite_message_id_provided = v18,
				place_id = p2.rootPlaceId
			})
		end

		ContextActionService:BindCoreAction("hideGameInviteModal", function(_, p5) -- line: 96
			-- upvalues: p1 (copy)
			if p5 == Enum.UserInputState.Begin then
				p1:closeModal()
			end
		end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Backspace)

		return
	end

	if isTriggerDDI(p2.trigger) then
		p1:invokeGameInvitePromptClosed()
	end
end
function t1.closeModal(t2: {[any]: any}, n1: number?) -- line: 109
	-- upvalues: isTriggerDDI (copy), GameInviteAnalyticsManager (copy), ContextActionService (copy)
	if t2.isModalOpen then
		local v22 = false
		local v23 = false
		local v24 = false

		if isTriggerDDI(t2.openTrigger) then
			if t2.customParams then
				v22 = t2.customParams.launchData ~= nil and t2.customParams.launchData ~= ""
				v23 = t2.customParams.promptMessage ~= nil and t2.customParams.promptMessage ~= ""
				v24 = t2.customParams.inviteMessageId ~= nil and t2.customParams.inviteMessageId ~= ""
			end

			t2:invokeGameInvitePromptClosed()
		end

		GameInviteAnalyticsManager:sendGameInviteModalEvent(t2.openTrigger, {
			action_type = GameInviteAnalyticsManager.ActionType.ModalClose,
			is_launch_data_provided = v22,
			is_prompt_customized = v23,
			is_invite_message_id_provided = v24,
			max_recipient_row_number = n1,
			place_id = t2.placeId
		})
		ContextActionService:UnbindCoreAction("hideGameInviteModal")
		t2.isModalOpen = false
		t2.openTrigger = nil
		t2.placeId = nil
	end

	t2.ToggleGameInviteModalEvent:Fire(false)
end
function t1.isGameModalOpen(p6) -- line: 143
	return p6.isModalOpen
end
function t1.invokeGameInvitePromptClosed(_) -- line: 147
	-- upvalues: SocialService (copy), Players (copy)
	if SocialService and Players.LocalPlayer then
		SocialService:InvokeGameInvitePromptClosed(Players.LocalPlayer, {})
	end
end

return t1.new()
