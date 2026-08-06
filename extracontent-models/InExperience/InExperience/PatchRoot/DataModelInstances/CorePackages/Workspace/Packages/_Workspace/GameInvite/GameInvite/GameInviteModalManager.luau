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

local FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt = require(GameInviteParent.SharedFlags).FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt
local t1 = {}

t1.__index = t1

function t1.new() -- line: 25
	-- upvalues: t1 (copy)
	return (setmetatable({}, t1))
end

t1.ToggleGameInviteModalEvent = Instance.new("BindableEvent")
t1.isModalOpen = false
t1.openTrigger = nil
t1.customParams = nil
t1.placeId = nil
t1.openSession = 0

local function openDeveloperInviteModalNonBlocking(p1, p2, p3) -- line: 43
	-- upvalues: ContextActionService (copy), getCustomizedInvitePromptParams (copy), getCanSendAndCanCustomizeInvites (copy), Cryo (copy), GameInviteAnalyticsManager (copy)
	local openSession = p1.openSession

	p1.customParams = nil
	p1.ToggleGameInviteModalEvent:Fire(true, false, p2)
	ContextActionService:BindCoreAction("hideGameInviteModal", function(_, p5) -- line: 48
		-- upvalues: p1 (copy)
		if p5 == Enum.UserInputState.Begin then
			p1:closeModal()
		end
	end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Backspace)
	task.spawn(function() -- line: 54
		-- upvalues: getCustomizedInvitePromptParams (copy), p3 (copy), p2 (copy), getCanSendAndCanCustomizeInvites (copy), p1 (copy), openSession (copy), Cryo (copy), GameInviteAnalyticsManager (copy)
		local v35 = getCustomizedInvitePromptParams(p3, p2.trigger, getCanSendAndCanCustomizeInvites)

		if not p1.isModalOpen or p1.openSession ~= openSession then
			return
		end

		p1.customParams = v35

		if not v35 then
			p1:closeModal()

			return
		end

		local v36 = v35.launchData ~= nil and v35.launchData ~= ""
		local v37 = v35.promptMessage ~= nil and v35.promptMessage ~= ""
		local v38 = v35.inviteMessageId ~= nil and v35.inviteMessageId ~= ""

		if v36 or v37 or v38 then
			p1.ToggleGameInviteModalEvent:Fire(true, false, Cryo.Dictionary.join(p2, v35))
		end

		GameInviteAnalyticsManager:sendGameInviteModalEvent(p2.trigger, {
			action_type = GameInviteAnalyticsManager.ActionType.ModalOpen,
			is_launch_data_provided = v36,
			is_prompt_customized = v37,
			is_invite_message_id_provided = v38,
			place_id = p2.rootPlaceId
		})
	end)
end

function t1.openModal(p6, p7, p8) -- line: 90
	-- upvalues: FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt (copy), isTriggerDDI (copy), openDeveloperInviteModalNonBlocking (copy), getCustomizedInvitePromptParams (copy), getCanSendAndCanCustomizeInvites (copy), Cryo (copy), GameInviteAnalyticsManager (copy), ContextActionService (copy)
	if not p6.isModalOpen then
		p6.isModalOpen = true

		if FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt then
			p6.openSession = p6.openSession + 1
		end

		p6.openTrigger = p7.trigger
		p6.placeId = p7.rootPlaceId or tostring(game.PlaceId)

		if isTriggerDDI(p7.trigger) and FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt then
			openDeveloperInviteModalNonBlocking(p6, p7, p8)

			return
		end

		local v22 = false
		local v23 = false
		local v24 = false

		if isTriggerDDI(p7.trigger) then
			p6.ToggleGameInviteModalEvent:Fire(true, true, p7)

			local v25 = getCustomizedInvitePromptParams(p8, p7.trigger, getCanSendAndCanCustomizeInvites)

			p6.customParams = v25

			if v25 then
				v22 = v25.launchData ~= nil and v25.launchData ~= ""
				v23 = v25.promptMessage ~= nil and v25.promptMessage ~= ""
				v24 = v25.inviteMessageId ~= nil and v25.inviteMessageId ~= ""
				p6.ToggleGameInviteModalEvent:Fire(true, false, Cryo.Dictionary.join(p7, v25))

				if game:GetFastFlag("GameInviteModalAnalyticsEmptyEventContextFix") then
					GameInviteAnalyticsManager:sendGameInviteModalEvent(p7.trigger, {
						action_type = GameInviteAnalyticsManager.ActionType.ModalOpen,
						is_launch_data_provided = v22,
						is_prompt_customized = v23,
						is_invite_message_id_provided = v24,
						place_id = p7.rootPlaceId,
						hideCloseButton = p7.hideCloseButton
					})
				end
			else
				p6:closeModal()
			end
		else
			p6.ToggleGameInviteModalEvent:Fire(true, false, p7)

			if game:GetFastFlag("GameInviteModalAnalyticsEmptyEventContextFix") then
				GameInviteAnalyticsManager:sendGameInviteModalEvent(p7.trigger, {
					action_type = GameInviteAnalyticsManager.ActionType.ModalOpen,
					is_launch_data_provided = v22,
					is_prompt_customized = v23,
					is_invite_message_id_provided = v24,
					place_id = p7.rootPlaceId
				})
			end
		end

		if not game:GetFastFlag("GameInviteModalAnalyticsEmptyEventContextFix") then
			GameInviteAnalyticsManager:sendGameInviteModalEvent(p7.trigger, {
				action_type = GameInviteAnalyticsManager.ActionType.ModalOpen,
				is_launch_data_provided = v22,
				is_prompt_customized = v23,
				is_invite_message_id_provided = v24,
				place_id = p7.rootPlaceId
			})
		end

		ContextActionService:BindCoreAction("hideGameInviteModal", function(_, p10) -- line: 157
			-- upvalues: p6 (copy)
			if p10 == Enum.UserInputState.Begin then
				p6:closeModal()
			end
		end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Backspace)

		return
	end

	if isTriggerDDI(p7.trigger) then
		p6:invokeGameInvitePromptClosed()
	end
end
function t1.closeModal(t2: {[any]: any}, n1: number?) -- line: 170
	-- upvalues: isTriggerDDI (copy), GameInviteAnalyticsManager (copy), ContextActionService (copy), FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt (copy)
	if t2.isModalOpen then
		local v28 = false
		local v29 = false
		local v30 = false

		if isTriggerDDI(t2.openTrigger) then
			if t2.customParams then
				v28 = t2.customParams.launchData ~= nil and t2.customParams.launchData ~= ""
				v29 = t2.customParams.promptMessage ~= nil and t2.customParams.promptMessage ~= ""
				v30 = t2.customParams.inviteMessageId ~= nil and t2.customParams.inviteMessageId ~= ""
			end

			t2:invokeGameInvitePromptClosed()
		end

		GameInviteAnalyticsManager:sendGameInviteModalEvent(t2.openTrigger, {
			action_type = GameInviteAnalyticsManager.ActionType.ModalClose,
			is_launch_data_provided = v28,
			is_prompt_customized = v29,
			is_invite_message_id_provided = v30,
			max_recipient_row_number = n1,
			place_id = t2.placeId
		})
		ContextActionService:UnbindCoreAction("hideGameInviteModal")
		t2.isModalOpen = false

		if FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt then
			t2.openSession = t2.openSession + 1
		end

		t2.openTrigger = nil
		t2.placeId = nil
	end

	t2.ToggleGameInviteModalEvent:Fire(false)
end
function t1.isGameModalOpen(p11) -- line: 207
	return p11.isModalOpen
end
function t1.invokeGameInvitePromptClosed(_) -- line: 211
	-- upvalues: SocialService (copy), Players (copy)
	if SocialService and Players.LocalPlayer then
		SocialService:InvokeGameInvitePromptClosed(Players.LocalPlayer, {})
	end
end

return t1.new()
