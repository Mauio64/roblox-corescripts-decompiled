local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)

local useStyle = UIBlox.Core.Style.useStyle

local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local panel3D = UIBlox.Core.VR.Panel3D

local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties
local module2 = require("@luauforge/bundled/fzG")
local module3 = require("@luauforge/bundled/gJr")
local module4 = require("@luauforge/bundled/dPN")
local roundedCornersFrame = require("@luauforge/bundled/fFV").RoundedCornersFrame
local fFlagAXFixAvatarScreenVR = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFixAvatarScreenVR

local overlayProvider = Foundation.OverlayProvider

local v5 = fFlagAXFixAvatarScreenVR
	and {
		Left = "Left_SurfaceGui",
		Right = "Right_SurfaceGui",
		Center = "Center_SurfaceGui",
		None = "Left_SurfaceGui"
	}
	or nil

local function getZOffset(p2, panelPlacement)
	local v6 = {}

	for k, v7 in p2.previousPages or {} do
		local vrPanelPlacement = avatarScreenProperties[v7.name].VRPanelPlacement

		local v8 = vrPanelPlacement == "None" and "Left" or vrPanelPlacement or "Left"
		v6[v8] = (v6[v8] or 0) + 1
	end

	local v7 = v6[panelPlacement] or 0

	if p2.isOverlayVisible then
		v7 += 1
	end

	return (Vector3.new(0, 0, v7 * module4.VR.SPACE_BETWEEN_STACKED_PANELS))
end

return function(props)
	local v6 = useAvatarRoute()
	local v7 = useStyle()

	local v8 = module4.VR.PanelInfo[props.panelPlacement or "Left"]

	if props.panelPlacement == "None" then
		return React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ClipsDescendants = false,
				BorderSizePixel = 0
			},
			props[Roact.Children]
		)
	end

	local v9 = React.useMemo(function()
		return getZOffset(v6, props.panelPlacement)
	end, {})
	local element = React.createElement(module2.Consumer, {
		render = function(p2)
			return Roact.createElement(module3.Consumer, {
				render = function(p3)
					local createElement = React.createElement

					local v11 = {
						hidden = not p3 or props.visible == false or p2 ~= avatarScreen.AvatarExperienceRoot,
						partSize = v8.PartSize,
						offset = v8.Offset + v9,
						virtualScreenSize = v8.VirtualScreenSize,
						panelName = props.panelPlacement
					}

					local v12 = if props.roundedCornersFrame then React.createElement(
						roundedCornersFrame,
						{
							cornerRadius = 10,
							backgroundColor = v7.Theme.BackgroundDefault.Color,
							backgroundTransparency = 0
						},
						props[Roact.Children]
					) else props[Roact.Children]
					return createElement(panel3D, v11, v12)
				end
			})
		end
	})

	if not fFlagAXFixAvatarScreenVR then
		return element
	end

	local luaAppScreenGui = CoreGui:WaitForChild("LuaAppScreenGui", 5)

	local child = luaAppScreenGui
		and luaAppScreenGui:FindFirstChild(v5[props.panelPlacement or "Left"], true)

	if child then
		return React.createElement(overlayProvider, { gui = child }, element)
	end

	return element
end
