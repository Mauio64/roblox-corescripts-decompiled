local CorePackages = game:GetService("CorePackages")
local EngineFeature = game:GetEngineFeature("CurvedSurfaceGuisEnabled")
local CoreGui = game:GetService("CoreGui")
local scriptParent = script.Parent
local Constants = require(scriptParent.Constants)
local SpatialUIType = Constants.SpatialUIType
local Object = require(CorePackages.Packages.LuauPolyfill).Object
local VRService = game:GetService("VRService")
local t1 = {
	spatialPanelProps = nil,
	screenGuiProps = nil,
	type = SpatialUIType.ScreenUI
}
local t2 = {
	Name = "ScreenGui",
	ResetOnSpawn = false,
	DisplayOrder = 0,
	ZIndexBehavior = nil
}
local t3 = {
	name = "",
	alwaysOnTop = true,
	hidden = false,
	curvature = 1,
	transparency = 1,
	partSize = Constants.DEFAULT_VR_PANEL_SIZE,
	virtualScreenSize = Constants.DEFAULT_VR_PANEL_SIZE * Constants.VR_PANEL_RESOLUTION_MULTIPLIER,
	cframe = CFrame.new(0, 0, 0)
}

local function createPanelPart(p1) -- line: 35
	local Part = Instance.new("Part")

	Part.Parent = workspace.CurrentCamera
	Part.Name = p1.name .. "_Part"
	Part.CFrame = p1.cframe
	Part.CastShadow = false
	Part.Size = Vector3.new(p1.partSize.X, p1.partSize.Y, 0.002)
	Part.Transparency = not p1.transparency and 1 or p1.transparency
	Part.Color = Color3.new(0, 0, 0)
	Part.CanCollide = false
	Part.CanTouch = false
	Part.Anchored = true

	return Part
end
local function createPanel(p2) -- line: 50
	-- upvalues: Object (copy), t1 (copy), SpatialUIType (copy), t3 (copy), createPanelPart (copy), CoreGui (copy), EngineFeature (copy), t2 (copy)
	local v17 = Object.assign({}, t1, p2)

	if v17.type == SpatialUIType.SpatialUIPartOnly then
		local v18 = Object.assign({}, t3, v17.spatialPanelProps)
		local v19 = createPanelPart(v18)

		return {
			type = v17.type,
			panelObject = v19
		}
	end

	if v17.type == SpatialUIType.SpatialUI then
		local v20 = Object.assign({}, t3, v17.spatialPanelProps)
		local v21 = createPanelPart(v20)
		local SurfaceGui = Instance.new("SurfaceGui", CoreGui)

		SurfaceGui.Name = v20.name .. "_SurfaceGui"
		SurfaceGui.Enabled = not v20.hidden
		SurfaceGui.CanvasSize = v20.virtualScreenSize
		SurfaceGui.AlwaysOnTop = v20.alwaysOnTop
		SurfaceGui.Shape = if not EngineFeature or v20.curvature == 0 then Enum.SurfaceGuiShape.Flat else Enum.SurfaceGuiShape.CurvedHorizontally
		SurfaceGui.HorizontalCurvature = not EngineFeature and 0 or v20.curvature
		SurfaceGui.Active = true
		SurfaceGui.Adornee = v21
		SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		SurfaceGui.LightInfluence = 0
		SurfaceGui.ZOffset = 0
		SurfaceGui.Face = Enum.NormalId.Back

		return {
			type = v17.type,
			panelObject = SurfaceGui
		}
	end

	if v17.type == SpatialUIType.ScreenUI then
		local v23 = Object.assign({}, t2, v17.screenGuiProps)
		local ScreenGui = Instance.new("ScreenGui", CoreGui)

		ScreenGui.Name = v23.Name
		ScreenGui.ResetOnSpawn = v23.ResetOnSpawn
		ScreenGui.DisplayOrder = v23.DisplayOrder

		if v23.ZIndexBehavior then
			ScreenGui.ZIndexBehavior = v23.ZIndexBehavior
		end

		return {
			type = v17.type,
			panelObject = ScreenGui
		}
	end

	print("Invalid panel type: " .. tostring(v17.type))

	return nil
end

return function(p3) -- line: 102
	-- upvalues: VRService (copy), createPanel (copy), Constants (copy), SpatialUIType (copy)
	if VRService.VREnabled then
		local v26 = createPanel(Constants.COMPAT_PANEL_PROPS_MAP[p3.panelType])

		if v26 == nil then
			return nil
		end

		return {
			headScale = 1,
			panelObject = v26.panelObject,
			uiType = v26.type,
			panelType = p3.panelType,
			panelPositionProps = Constants.SPATIAL_PANEL_POSITION_PROPS_MAP[p3.panelType]
		}
	end

	local v27 = createPanel({
		type = SpatialUIType.ScreenUI,
		screenGuiProps = p3.screenGuiProps
	})

	if v27 == nil then
		return nil
	end

	return {
		panelPositionProps = nil,
		panelObject = v27.panelObject,
		uiType = v27.type,
		panelType = p3.panelType
	}
end
