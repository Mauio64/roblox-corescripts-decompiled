local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local UserInputService = game:GetService("UserInputService")

local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local FocusUtils = Chrome.FocusUtils

local InputType = require(CorePackages.Workspace.Packages.InputType)
local getInputGroup = InputType.getInputGroup
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local focusNavigationStore = ExpChat.Stores.GetFocusNavigationStore(false)

local ChatSelector = require(RobloxGui.Modules.ChatSelector)

local function isUsingGamepad(): boolean -- 1 equivalent call inferred from this helper
	return getInputGroup(UserInputService:GetLastInputType()) == InputType.InputTypeConstants.Gamepad
end

return function(_)
	if ChatSelector:GetVisibility() and isUsingGamepad() then -- inferred equivalent call
		FocusUtils.FocusOffChrome(function()
			focusNavigationStore.focusChatInputBar()
		end)
	end
end
