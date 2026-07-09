local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local Modules = CoreGui.RobloxGui.Modules
local useStyle = UIBlox.Core.Style.useStyle
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local Panel3D = UIBlox.Core.VR.Panel3D
local AvatarScreenProperties = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties
local CurrentTabContext = require(Modules.LuaApp.Navigation.CurrentTabContext)
local SwitchNavigatorVisibleContext = require(Modules.LuaApp.Navigation.SwitchNavigatorVisibleContext)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local RoundedCornersFrame = require(CorePackages.Workspace.Packages.VrCompatibility).RoundedCornersFrame
local GetFFlagVRPanelWidthIXPEnabled = SharedFlags.GetFFlagVRPanelWidthIXPEnabled
local FFlagLuaAppForceVrAppPanelWidthRollout = SharedFlags.FFlagLuaAppForceVrAppPanelWidthRollout
local FFlagAXFixAvatarScreenVR = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXFixAvatarScreenVR
local OverlayProvider = Foundation.OverlayProvider
local VRPanelWidthIXP = require(CorePackages.Workspace.Packages.VrCompatibility).VRPanelWidthIXP
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local v25 = if not FFlagAXFixAvatarScreenVR then nil else {
	Left = "Left_SurfaceGui",
	Right = "Right_SurfaceGui",
	Center = "Center_SurfaceGui",
	None = "Left_SurfaceGui"
}

local function getZOffset(p1, p2) -- line: 57
	-- upvalues: AvatarScreenProperties (copy), Constants (copy)
	local t1 = {}

	for _, v31 in p1.previousPages or {} do
		local VRPanelPlacement = AvatarScreenProperties[v31.name].VRPanelPlacement

		if VRPanelPlacement == "None" then
			VRPanelPlacement = "Left"
		end

		local v33 = VRPanelPlacement or "Left"

		t1[v33] = (t1[v33] or 0) + 1
	end

	local v34 = t1[p2] or 0

	if p1.isOverlayVisible then
		v34 += 1
	end

	return (Vector3.new(0, 0, v34 * Constants.VR.SPACE_BETWEEN_STACKED_PANELS))
end

return function(t2: {[any]: any}) -- line: 83
	-- upvalues: useAvatarRoute (copy), useStyle (copy), Constants (copy), FFlagLuaAppForceVrAppPanelWidthRollout (copy), GetFFlagVRPanelWidthIXPEnabled (copy), IxpUtils (copy), VRPanelWidthIXP (copy), React (copy), getZOffset (copy), CurrentTabContext (copy), Roact (copy), SwitchNavigatorVisibleContext (copy), Panel3D (copy), AvatarScreen (copy), RoundedCornersFrame (copy), FFlagAXFixAvatarScreenVR (copy), CoreGui (copy), v25 (copy), OverlayProvider (copy)
	local v36 = useAvatarRoute()
	local v37 = useStyle()
	local v38 = Constants.VR.PanelInfo[t2.panelPlacement or "Left"]

	if t2.panelPlacement ~= "None" then
		local v39 = if FFlagLuaAppForceVrAppPanelWidthRollout or not GetFFlagVRPanelWidthIXPEnabled() then nil else IxpUtils.useTestVariables(VRPanelWidthIXP.VrAvatarPanelsSpreadMultiplier)
		local v40 = if FFlagLuaAppForceVrAppPanelWidthRollout or not GetFFlagVRPanelWidthIXPEnabled() then nil else IxpUtils.useTestVariables(VRPanelWidthIXP.VrAvatarPanelsDistanceOffset)
		local v41 = if FFlagLuaAppForceVrAppPanelWidthRollout or (not GetFFlagVRPanelWidthIXPEnabled() or not v38) then v38.Offset else CFrame.lookAt(Vector3.new(if not v39 then v38.Offset.Position.X else v38.Offset.Position.X * v39, v38.Offset.Position.Y, if not v40 then v38.Offset.Position.Z else v38.Offset.Position.Z + v40), (Vector3.new(0, Constants.VR.PANELS_HEIGHT_OFFSET, 0)))
		local v42 = React.useMemo(function() -- line: 113
			-- upvalues: getZOffset (copy), v36 (copy), t2 (copy)
			return (getZOffset(v36, t2.panelPlacement))
		end, {})
		local v43 = React.createElement(CurrentTabContext.Consumer, {
			render = function(p3) -- line: 117
				-- upvalues: Roact (copy), SwitchNavigatorVisibleContext (copy), React (copy), Panel3D (copy), t2 (copy), AvatarScreen (copy), v38 (copy), v41 (copy), v42 (copy), RoundedCornersFrame (copy), v37 (copy)
				return Roact.createElement(SwitchNavigatorVisibleContext.Consumer, {
					render = function(p4) -- line: 119
						-- upvalues: React (copy), Panel3D (copy), t2 (copy), p3 (copy), AvatarScreen (copy), v38 (copy), v41 (copy), v42 (copy), RoundedCornersFrame (copy), v37 (copy), Roact (copy)
						return React.createElement(Panel3D, {
							hidden = not p4 or (t2.visible == false or p3 ~= AvatarScreen.AvatarExperienceRoot),
							partSize = v38.PartSize,
							offset = v41 + v42,
							virtualScreenSize = v38.VirtualScreenSize,
							panelName = t2.panelPlacement
						}, if not t2.roundedCornersFrame then t2[Roact.Children] else React.createElement(RoundedCornersFrame, {
							cornerRadius = 10,
							backgroundTransparency = 0,
							backgroundColor = v37.Theme.BackgroundDefault.Color
						}, t2[Roact.Children]))
					end
				})
			end
		})

		if FFlagAXFixAvatarScreenVR then
			local LuaAppScreenGui = CoreGui:WaitForChild("LuaAppScreenGui", 5)

			if LuaAppScreenGui then
				local v45 = LuaAppScreenGui:FindFirstChild(v25[t2.panelPlacement or "Left"], true)

				if v45 then
					return React.createElement(OverlayProvider, {
						gui = v45
					}, v43)
				end
			end
		end

		return v43
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1)
	}, t2[Roact.Children])
end
