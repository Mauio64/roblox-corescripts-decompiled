local TextChatService = game:GetService("TextChatService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local ExpChatShared = require(parent.ExpChatShared)
local React = require(parent.React)

local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local sendPreset = require(script.Parent.sendPreset)
local FFlagExpChatUniverseChatPresetEnabled = require(ExpChat.Flags.FFlagExpChatUniverseChatPresetEnabled)

local FFlagExpChatPresetChatAutocompleteEnabled = require(ExpChat.Flags.FFlagExpChatPresetChatAutocompleteEnabled)
local FFlagExpChatPresetTrayDismissAnalytics = require(ExpChat.Flags.FFlagExpChatPresetTrayDismissAnalytics)
local v = ExpChatShared.Flags.FIntPresetChatCooldownLuaMs / 1000

local v2 = ExpChatShared.Logger:new("ExpChat/PresetChat/useOnPresetActivated")

local function getRBXGeneralChannel()
	local rbxGeneral = TextChatService:FindFirstChild("RBXGeneral", true)

	if rbxGeneral and rbxGeneral:IsA("TextChannel") then
		return rbxGeneral
	end

	return nil
end

local function useOnPresetActivated(p)
	local presetChatStore = GetPresetChatStore(false)
	local textChannel = p.textChannel
	local closePresetTray = p.closePresetTray

	return React.useCallback(function(p2: string)
		if FFlagExpChatPresetTrayDismissAnalytics and presetChatStore.getIsTrayOpen(false) then
			presetChatStore.incrementPresetClickCount(p2)
		end

		if FFlagExpChatPresetChatAutocompleteEnabled then
			presetChatStore.setPresetCooldownEndsAt(os.clock() + v)

			local v3 = sendPreset(p2, textChannel)

			if v3 ~= "Sent" then
				presetChatStore.setPresetCooldownEndsAt(nil)
			end

			if v3 == "NoChannel" then
				v2:warning("Preset {} activated but no target text channel was provided; skipping send.", p2)
			elseif not FFlagExpChatPresetTrayDismissAnalytics then
				presetChatStore.incrementPresetClickCount(p2)
			end

			closePresetTray()
		else
			local textChannel2 = textChannel

			if textChannel2 ~= nil and textChannel2.Name ~= "RBXGeneral" then
				textChannel2 = TextChatService:FindFirstChild("RBXGeneral", true)

				if not (textChannel2 and textChannel2:IsA("TextChannel")) then
					textChannel2 = nil
				end
			end

			presetChatStore.setPresetCooldownEndsAt(os.clock() + v)

			if textChannel2 then
				if not pcall(function()
					textChannel2:SendPresetAsync(p2)
				end) then
					presetChatStore.setPresetCooldownEndsAt(nil)
				end
			elseif FFlagExpChatUniverseChatPresetEnabled then
				if not pcall(function()
					TextChatService:SendUniverseChatPresetAsync(p2)
				end) then
					presetChatStore.setPresetCooldownEndsAt(nil)
				end
			else
				v2:warning("Preset {} activated but no target text channel was provided; skipping send.", p2)
				presetChatStore.setPresetCooldownEndsAt(nil)
				closePresetTray()
				return
			end

			if not FFlagExpChatPresetTrayDismissAnalytics then
				presetChatStore.incrementPresetClickCount(p2)
			end

			closePresetTray()
		end
	end, { textChannel, presetChatStore, closePresetTray })
end

return useOnPresetActivated
