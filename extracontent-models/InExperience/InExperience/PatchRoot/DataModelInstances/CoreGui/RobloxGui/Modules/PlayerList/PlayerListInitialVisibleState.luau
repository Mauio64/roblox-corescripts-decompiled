local VRService = game:GetService("VRService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local Utility = require(RobloxGui.Modules.Settings.Utility)

local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)

local parent = script.Parent

local FFlagPlayerListPersistVisibility = require(parent.Flags.FFlagPlayerListPersistVisibility)
local FStringPlayerListOverrideType = require(parent.Flags.FStringPlayerListOverrideType)
local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole
local isReskinConsoleMobileRoute = PlayerList.Common.isReskinConsoleMobileRoute
local FFlagPlayerListUseMobileOnSmallDisplay = PlayerList.Flags.FFlagPlayerListUseMobileOnSmallDisplay

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput

local function isTouchOrGamepad(p) -- 1 equivalent call inferred from this helper
	return p == Enum.PreferredInput.Touch
		or p == Enum.PreferredInput.Gamepad
		or FFlagLuaSupportMicroGamepadPreferredInput and p == Enum.PreferredInput.MicroGamepad
end

local function isCurrentReskinConsoleMobileRoute(preferredInput) -- 2 equivalent calls inferred from this helper
	return isReskinConsoleMobileRoute({
		displaySize = GuiService.ViewportDisplaySize,
		preferredInput = preferredInput
	})
end

local function isSmallTouchScreen(preferredInput)
	if isCurrentReskinConsoleMobileRoute(preferredInput) then -- inferred equivalent call
		return true
	end

	local v

	if FFlagPlayerListUseMobileOnSmallDisplay then
		v = GuiService.ViewportDisplaySize == Enum.DisplaySize.Small
	else
		v = false
	end

	local v2

	if FFlagEnableMobilePlayerListOnConsole then
		v2 = GuiService.ViewportDisplaySize == Enum.DisplaySize.Large
	else
		v2 = false
	end

	local v3

	if FFlagEnableMobilePlayerListOnConsole or FFlagPlayerListUseMobileOnSmallDisplay then
		v3 = isTouchOrGamepad(preferredInput) -- inferred equivalent call
	else
		v3 = false
	end

	local v4 = Utility:IsSmallTouchScreen()

	if not v4 then
		if
			FFlagEnableMobilePlayerListOnConsole and v2 and v3
			or FFlagPlayerListUseMobileOnSmallDisplay and v and v3
		then
			return v3
		end

		return FStringPlayerListOverrideType == "mobile"
	end

	return v4
end

return function(p)
	if p == nil then
		p = UserInputService.PreferredInput
	end

	local v = not isSmallTouchScreen(p)
		and not VRService.VREnabled
		and (isCurrentReskinConsoleMobileRoute(p) or FFlagEnableMobilePlayerListOnConsole or not TenFootInterface:IsEnabled()) -- inferred equivalent call

	if not v then
		return v
	end

	if FFlagPlayerListPersistVisibility then
		return UserSettings().GameSettings.PlayerListVisible
	end

	v = true
	return true
end
