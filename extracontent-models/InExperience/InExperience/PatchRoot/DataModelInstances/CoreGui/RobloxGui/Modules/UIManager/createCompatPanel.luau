local CorePackages = game:GetService("CorePackages")
local engineFeature = game:GetEngineFeature("CurvedSurfaceGuisEnabled")
local CoreGui = game:GetService("CoreGui")
local parent = script.Parent
local Constants = require(parent.Constants)
local SpatialUIType = Constants.SpatialUIType
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local Object = LuauPolyfill.Object
local VRService = game:GetService("VRService")

local v = { spatialPanelProps = nil, screenGuiProps = nil, type = SpatialUIType.ScreenUI }

local screenGui = {
	Name = "ScreenGui",
	ResetOnSpawn = false,
	DisplayOrder = 0,
	ZIndexBehavior = nil
}

local v2 = {
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
	part.Parent = workspace.CurrentCamera
	part.Name = data.name .. "_Part"
	part.CFrame = data.cframe
	part.CastShadow = false
	part.Size = Vector3.new(data.partSize.X, data.partSize.Y, 0.002)
	part.Transparency = not data.transparency and 1 or data.transparency
	part.Color = Color3.new(0, 0, 0)
	part.CanCollide = false
	part.CanTouch = false
	part.Anchored = true
	return part
end

local function createPanel(p)
	local v3 = Object.assign({}, v, p)

	if v3.type == SpatialUIType.SpatialUIPartOnly then
		local panelPart = createPanelPart(Object.assign({}, v2, v3.spatialPanelProps))
		return { type = v3.type, panelObject = panelPart }
	elseif v3.type == SpatialUIType.SpatialUI then
		local v4 = Object.assign({}, v2, v3.spatialPanelProps)
		local panelPart = createPanelPart(v4)
		local surfaceGui = Instance.new("SurfaceGui", CoreGui)
		surfaceGui.Name = v4.name .. "_SurfaceGui"
		surfaceGui.Enabled = not v4.hidden
		surfaceGui.CanvasSize = v4.virtualScreenSize
		surfaceGui.AlwaysOnTop = v4.alwaysOnTop
		local shape

		if engineFeature and v4.curvature ~= 0 then
			shape = Enum.SurfaceGuiShape.CurvedHorizontally
		else
			shape = Enum.SurfaceGuiShape.Flat
		end

		surfaceGui.Shape = shape

		surfaceGui.HorizontalCurvature = not engineFeature and 0 or v4.curvature
		surfaceGui.Active = true
		surfaceGui.Adornee = panelPart
		surfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		surfaceGui.LightInfluence = 0
		surfaceGui.ZOffset = 0
		surfaceGui.Face = Enum.NormalId.Back
		return { type = v3.type, panelObject = surfaceGui }
	else
		if v3.type ~= SpatialUIType.ScreenUI then
			print("Invalid panel type: " .. tostring(v3.type))
			return nil
		end

		local v4 = Object.assign({}, screenGui, v3.screenGuiProps)
		local screenGui2 = Instance.new("ScreenGui", CoreGui)
		screenGui2.Name = v4.Name
		screenGui2.ResetOnSpawn = v4.ResetOnSpawn
		screenGui2.DisplayOrder = v4.DisplayOrder

		if v4.ZIndexBehavior then
			screenGui2.ZIndexBehavior = v4.ZIndexBehavior
		end

		return { type = v3.type, panelObject = screenGui2 }
	end
end

return function(p)
	if VRService.VREnabled then
		local panel = createPanel(Constants.COMPAT_PANEL_PROPS_MAP[p.panelType])

		if panel == nil then
			return nil
		end

		return {
			panelObject = panel.panelObject,
			uiType = panel.type,
			panelType = p.panelType,
			panelPositionProps = Constants.SPATIAL_PANEL_POSITION_PROPS_MAP[p.panelType],
			headScale = 1
		}
	else
		local panel = createPanel({
			type = SpatialUIType.ScreenUI,
			screenGuiProps = p.screenGuiProps
		})

		if panel == nil then
			return nil
		end

		return {
			panelObject = panel.panelObject,
			uiType = panel.type,
			panelType = p.panelType,
			panelPositionProps = nil
		}
	end
end
