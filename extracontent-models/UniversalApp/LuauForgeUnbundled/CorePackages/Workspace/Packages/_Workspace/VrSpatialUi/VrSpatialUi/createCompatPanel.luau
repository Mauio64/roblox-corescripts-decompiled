local CoreGui = game:GetService("CoreGui")

local engineFeature = game:GetEngineFeature("CurvedSurfaceGuisEnabled")
local FFlagSpatialUIHiddenPanelRaycastFix = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/Flags/FFlagSpatialUIHiddenPanelRaycastFix")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/Constants")
local spatialUIType = Constants.SpatialUIType
local object = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/LuauPolyfill").Object
local VRService = game:GetService("VRService")

local v5 = {
	spatialPanelProps = nil,
	screenGuiProps = nil,
	type = spatialUIType.ScreenUI
}

local screenGui = {
	Name = "ScreenGui",
	ResetOnSpawn = false,
	DisplayOrder = 0,
	ZIndexBehavior = nil
}

local v6 = {
	name = "",
	partSize = Constants.DEFAULT_VR_PANEL_SIZE,
	virtualScreenSize = Constants.DEFAULT_VR_PANEL_SIZE * Constants.VR_PANEL_RESOLUTION_MULTIPLIER,
	cframe = CFrame.new(0, 0, 0),
	alwaysOnTop = true,
	hidden = false,
	curvature = 1,
	transparency = 1
}

local function createPanelPart(data)
	local part = Instance.new("Part")
	part.Name = data.name .. "_Part"
	part.CFrame = data.cframe
	part.CastShadow = false
	part.Size = Vector3.new(data.partSize.X, data.partSize.Y, 0.002)
	part.Transparency = not data.transparency and 1 or data.transparency
	part.Color = Color3.new(0, 0, 0)
	part.CanCollide = false
	part.CanTouch = false
	part.Anchored = true
	part.Parent = workspace
	return part
end

local function createPanel(p2)
	local v7 = object.assign({}, v5, p2)

	if v7.type == spatialUIType.SpatialUIPartOnly then
		local panelPart = createPanelPart(object.assign({}, v6, v7.spatialPanelProps))

		if FFlagSpatialUIHiddenPanelRaycastFix then
			panelPart.CanQuery = false
		end

		return { type = v7.type, panelObject = panelPart }
	elseif v7.type == spatialUIType.SpatialUI then
		local v8 = object.assign({}, v6, v7.spatialPanelProps)
		local panelPart = createPanelPart(v8)
		local surfaceGui = Instance.new("SurfaceGui")
		surfaceGui.Parent = CoreGui
		surfaceGui.Name = v8.name .. "_SurfaceGui"
		surfaceGui.Enabled = not v8.hidden
		surfaceGui.CanvasSize = v8.virtualScreenSize
		surfaceGui.AlwaysOnTop = v8.alwaysOnTop
		local v9 = if engineFeature and v8.curvature ~= 0 then Enum.SurfaceGuiShape.CurvedHorizontally else Enum.SurfaceGuiShape.Flat
		surfaceGui.Shape = v9

		surfaceGui.HorizontalCurvature = not engineFeature and 0 or v8.curvature
		surfaceGui.Active = true
		surfaceGui.Adornee = panelPart
		surfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		surfaceGui.LightInfluence = 0
		surfaceGui.ZOffset = 0
		surfaceGui.Face = Enum.NormalId.Back
		return { type = v7.type, panelObject = surfaceGui }
	else
		if v7.type ~= spatialUIType.ScreenUI then
			print("Invalid panel type: " .. tostring(v7.type))
			return nil
		end

		local v8 = object.assign({}, screenGui, v7.screenGuiProps)
		local screenGui2 = Instance.new("ScreenGui")
		screenGui2.Parent = CoreGui
		screenGui2.Name = v8.Name
		screenGui2.ResetOnSpawn = v8.ResetOnSpawn
		screenGui2.DisplayOrder = v8.DisplayOrder

		if v8.ZIndexBehavior then
			screenGui2.ZIndexBehavior = v8.ZIndexBehavior
		end

		return { type = v7.type, panelObject = screenGui2 }
	end
end

return function(p2)
	if VRService.VREnabled then
		local panel = createPanel(Constants.COMPAT_PANEL_PROPS_MAP[p2.panelType])

		if panel == nil then
			return nil
		end

		return {
			panelObject = panel.panelObject,
			uiType = panel.type,
			panelType = p2.panelType,
			panelPositionProps = Constants.SPATIAL_PANEL_POSITION_PROPS_MAP[p2.panelType],
			headScale = 1
		}
	else
		local panel = createPanel({
			type = spatialUIType.ScreenUI,
			screenGuiProps = p2.screenGuiProps
		})

		if panel == nil then
			return nil
		end

		return {
			panelObject = panel.panelObject,
			uiType = panel.type,
			panelType = p2.panelType,
			panelPositionProps = nil
		}
	end
end
