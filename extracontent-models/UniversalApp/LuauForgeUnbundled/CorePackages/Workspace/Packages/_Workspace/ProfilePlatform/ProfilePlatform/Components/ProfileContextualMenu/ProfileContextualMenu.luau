local CoreGui = game:GetService("CoreGui")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Responsive").useIsSpatial
local fFlagProfileFixMenuNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfileFixMenuNavigation

local popoverSide = Foundation.Enums.PopoverSide
local popoverAlign = Foundation.Enums.PopoverAlign
local inputSize = Foundation.Enums.InputSize
local menu = Foundation.Menu
local overlayProvider = Foundation.OverlayProvider

local function getVROverlaySurfaceGui()
	if not fFlagProfileFixMenuNavigation then
		return nil
	end

	local luaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")

	if luaAppScreenGui then
		return luaAppScreenGui:FindFirstChild("MainAppScreen_SurfaceGui")
	end

	return nil
end

local function ProfileContextualMenu(props)
	local mainAppScreen_SurfaceGui

	if fFlagProfileFixMenuNavigation and useIsSpatial() and fFlagProfileFixMenuNavigation then
		local luaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")

		if luaAppScreenGui then
			mainAppScreen_SurfaceGui = luaAppScreenGui:FindFirstChild("MainAppScreen_SurfaceGui")
		end
	end

	local v5

	if props.screenSize.Y / 2 < props.rootElementPosition.Y then
		v5 = popoverSide.Top
	else
		v5 = popoverSide.Bottom
	end

	if v5 == popoverSide.Top then
		local v6 = props.screenSize.X / props.screenSize.Y
		local v7 = -(props.screenSize.Y - props.rootElementPosition.Y) + -20
		local v8 = v6 >= 1.3 and v6 < 1.7

		if props.screenSize.Y > 700 and not v8 then
			v7 += props.screenSize.Y * 0.05
		end
	else
		local v6 = props.rootElementPosition.Y + 60
	end

	if fFlagProfileFixMenuNavigation then
		local createElement = React.createElement

		local createElement2 = React.createElement
		local v10 = {
			align = popoverAlign.End,
			anchorRef = props.rootElementRef,
			isOpen = props.isOpen == nil or props.isOpen,
			items = props.buttonProps,
			onPressedOutside = props.onDismiss,
			side = v5,
			size = inputSize.Medium,
			ref = 0
		}
		local v11 = if fFlagProfileFixMenuNavigation then props.menuRef else nil
		v10.ref = v11
		return createElement(overlayProvider, { gui = mainAppScreen_SurfaceGui }, {
			Menu = createElement2(menu, v10)
		})
	else
		local createElement = React.createElement
		local v7 = {
			align = popoverAlign.End,
			anchorRef = props.rootElementRef,
			isOpen = props.isOpen == nil or props.isOpen,
			items = props.buttonProps,
			onPressedOutside = props.onDismiss,
			side = v5,
			size = inputSize.Medium,
			ref = 0
		}
		local v8 = if fFlagProfileFixMenuNavigation then props.menuRef else nil
		v7.ref = v8
		return createElement(menu, v7)
	end
end

return ProfileContextualMenu
