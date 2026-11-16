local UserInputService = game:GetService("UserInputService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local SignalsReact = require(parent.SignalsReact)

local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local Constants = require(script.Parent.Constants)
local FFlagExpChatPresetChatGamepadEnabled = require(ExpChat.Flags.FFlagExpChatPresetChatGamepadEnabled)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput

local function isTouchDevice() -- 1 equivalent call inferred from this helper
	return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

local function useLayoutMode()
	local presetChatStore = GetPresetChatStore(false)
	local v = SignalsReact.useSignalState(presetChatStore.getLayoutModeOverride)

	if v == Constants.LayoutMode.Tray or v == Constants.LayoutMode.FlyOut then
		return v
	end

	if
		FFlagExpChatPresetChatGamepadEnabled
		and (UserInputService.PreferredInput == Enum.PreferredInput.Gamepad or FFlagLuaSupportMicroGamepadPreferredInput and UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad)
	then
		return Constants.LayoutMode.FlyOut
	end

	if isTouchDevice() then -- inferred equivalent call
		return Constants.LayoutMode.Tray
	end

	return Constants.LayoutMode.FlyOut
end

return useLayoutMode
