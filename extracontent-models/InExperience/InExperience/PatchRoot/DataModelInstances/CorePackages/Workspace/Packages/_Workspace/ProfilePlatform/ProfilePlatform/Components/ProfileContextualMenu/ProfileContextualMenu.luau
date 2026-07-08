local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local CoreGui = game:GetService("CoreGui")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local useIsSpatial = require(ProfilePlatformParent.Responsive).useIsSpatial
local FFlagProfileFixMenuNavigation = require(ProfilePlatformParent.SharedFlags).FFlagProfileFixMenuNavigation
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local InputSize = Foundation.Enums.InputSize
local Menu = Foundation.Menu
local OverlayProvider = Foundation.OverlayProvider

local function getVROverlaySurfaceGui() -- line: 38
	-- upvalues: FFlagProfileFixMenuNavigation (copy), CoreGui (copy)
	if FFlagProfileFixMenuNavigation then
		local LuaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")

		if LuaAppScreenGui then
			return (LuaAppScreenGui:FindFirstChild("MainAppScreen_SurfaceGui"))
		end

		return nil
	end

	return nil
end
local function ProfileContextualMenu(t1: {[any]: any}) -- line: 50
	-- upvalues: FFlagProfileFixMenuNavigation (copy), useIsSpatial (copy), CoreGui (copy), PopoverSide (copy), React (copy), OverlayProvider (copy), Menu (copy), PopoverAlign (copy), InputSize (copy)
	local v18

	if FFlagProfileFixMenuNavigation and useIsSpatial() then
		if FFlagProfileFixMenuNavigation then
			local LuaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")

			v18 = if not LuaAppScreenGui then nil else LuaAppScreenGui:FindFirstChild("MainAppScreen_SurfaceGui")
		else
			v18 = nil
		end
	else
		v18 = nil
	end

	local v19 = if not (t1.screenSize.Y / 2 < t1.rootElementPosition.Y) then PopoverSide.Bottom else PopoverSide.Top

	if v19 == PopoverSide.Top then
		local v20 = t1.screenSize.X / t1.screenSize.Y
		local v21 = -(t1.screenSize.Y - t1.rootElementPosition.Y) + -20
		local v22 = v20 >= 1.3 and v20 < 1.7

		if t1.screenSize.Y > 700 and not v22 then
			local _ = v21 + t1.screenSize.Y * 0.05
		end
	else
		local _ = t1.rootElementPosition.Y + 60
	end

	if FFlagProfileFixMenuNavigation then
		return (React.createElement(OverlayProvider, {
			gui = v18
		}, {
			Menu = React.createElement(Menu, {
				align = PopoverAlign.End,
				anchorRef = t1.rootElementRef,
				isOpen = t1.isOpen == nil or t1.isOpen,
				items = t1.buttonProps,
				onPressedOutside = t1.onDismiss,
				side = v19,
				size = InputSize.Medium,
				ref = if not FFlagProfileFixMenuNavigation then nil else t1.menuRef
			})
		}))
	end

	return (React.createElement(Menu, {
		align = PopoverAlign.End,
		anchorRef = t1.rootElementRef,
		isOpen = t1.isOpen == nil or t1.isOpen,
		items = t1.buttonProps,
		onPressedOutside = t1.onDismiss,
		side = v19,
		size = InputSize.Medium,
		ref = if not FFlagProfileFixMenuNavigation then nil else t1.menuRef
	}))
end

return ProfileContextualMenu
