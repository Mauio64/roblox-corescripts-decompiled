local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local UserInputService = game:GetService("UserInputService")
local Chrome = script:FindFirstAncestor("Chrome")
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local FocusUtils = require(CorePackages.Workspace.Packages.Chrome).FocusUtils
local Service = require(Chrome.Service)
local FFlagChatIntegrationFixShortcut = require(Chrome.Flags.FFlagChatIntegrationFixShortcut)
local InputType = require(CorePackages.Workspace.Packages.InputType)
local getInputGroup = InputType.getInputGroup
local v11 = require(CorePackages.Workspace.Packages.ExpChat).Stores.GetFocusNavigationStore(false)
local ChatSelector = require(RobloxGui.Modules.ChatSelector)

local function isUsingGamepad() -- line: 22
	-- upvalues: getInputGroup (copy), UserInputService (copy), InputType (copy)
	return getInputGroup(UserInputService:GetLastInputType()) == InputType.InputTypeConstants.Gamepad
end

return function(_) -- line: 27
	-- upvalues: ChatSelector (copy), getInputGroup (copy), UserInputService (copy), InputType (copy), FocusUtils (copy), FFlagChatIntegrationFixShortcut (copy), Service (copy), Constants (copy), v11 (copy)
	if ChatSelector:GetVisibility() and getInputGroup(UserInputService:GetLastInputType()) == InputType.InputTypeConstants.Gamepad then
		FocusUtils.FocusOffChrome(function() -- line: 29
			-- upvalues: FFlagChatIntegrationFixShortcut (copy), Service (copy), Constants (copy), v11 (copy)
			if not FFlagChatIntegrationFixShortcut then
				Service:setShortcutBar(Constants.UNIBAR_SHORTCUTBAR_ID)
			end

			v11.focusChatInputBar()
		end)
	end
end
