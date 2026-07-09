local UserInputService = game:GetService("UserInputService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local SignalsReact = require(ExpChatParent.SignalsReact)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local Constants = require(script.Parent.Constants)
local FFlagExpChatPresetChatGamepadEnabled = require(ExpChat.Flags.FFlagExpChatPresetChatGamepadEnabled)

local function isTouchDevice() -- line: 13
	-- upvalues: UserInputService (copy)
	return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end
local function useLayoutMode() -- line: 17
	-- upvalues: GetPresetChatStore (copy), SignalsReact (copy), Constants (copy), FFlagExpChatPresetChatGamepadEnabled (copy), UserInputService (copy)
	local v10 = GetPresetChatStore(false)
	local v11 = SignalsReact.useSignalState(v10.getLayoutModeOverride)

	if v11 == Constants.LayoutMode.Tray or v11 == Constants.LayoutMode.FlyOut then
		return v11
	end

	if FFlagExpChatPresetChatGamepadEnabled and UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
		return Constants.LayoutMode.FlyOut
	end

	if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
		return Constants.LayoutMode.Tray
	end

	return Constants.LayoutMode.FlyOut
end

return useLayoutMode
