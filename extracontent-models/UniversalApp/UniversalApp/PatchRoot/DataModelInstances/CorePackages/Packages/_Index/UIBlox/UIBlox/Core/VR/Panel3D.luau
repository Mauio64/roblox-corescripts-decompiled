local RunService = game:GetService("RunService")

local parent = script.Parent
local Constants = require(parent.Constants)
local usePanel3DRenderStep = require(parent.usePanel3DRenderStep)

local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent
local React = require(parent3.React)
local Roact = require(parent3.Roact)
local LuauPolyfill = require(parent3.LuauPolyfill)
local Object = LuauPolyfill.Object
local GetEngineFeatureSafe = require(parent2.Core.Utility.GetEngineFeatureSafe)

local engineFeatureSafe = GetEngineFeatureSafe("CurvedSurfaceGuisEnabled")

local v = {
	partSize = Vector2.new(10, 10),
	virtualScreenSize = Vector2.new(10, 10),
	offset = CFrame.new(0, 0, 0),
	lerp = false,
	tilt = 0,
	anchoring = Constants.AnchoringTypes.World,
	faceCamera = false,
	panelName = "PanelBase",
	movementUpdateEvent = RunService.RenderStepped,
	vrService = game:GetService("VRService"),
	alwaysOnTop = true,
	parent = workspace,
	hidden = false,
	curvature = 1,
	zOffset = 0,
	connectPanelManagerFunction = nil,
	partRef = nil
}

local function Panel3D(p)
	local v2 = Object.assign({}, v, p)

	local partRef = v2.partRef or React.useRef(nil)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	usePanel3DRenderStep(v2, partRef)
	React.useEffect(function()
		if v2.anchoring ~= Constants.AnchoringTypes.PanelManaged then
			return function() end
		end

		if v2.connectPanelManagerFunction == nil then
			return function() end
		end

		if ref == nil or not v2.connectPanelManagerFunction then
			return function() end
		end

		v2.connectPanelManagerFunction(ref)
		return function()
			v2.connectPanelManagerFunction(nil)
		end
	end, { ref, v2.anchoring, v2.connectPanelManagerFunction })

	local createElement = React.createElement

	local createElement2 = React.createElement
	local portal = Roact.Portal
	local v3 = { target = v2.parent }
	local guiPart

	if not v2.hidden then
		guiPart = React.createElement("Part", {
			Name = v2.panelName .. "_Part",
			ref = partRef,
			Anchored = true,
			CFrame = v2.offset * CFrame.Angles(math.rad(v2.tilt), 0, 0),
			Size = Vector3.new(v2.partSize.X, v2.partSize.Y, 0.05),
			Transparency = 1,
			Color = Color3.new(0, 0, 0),
			CanCollide = false,
			CanTouch = false
		})
	end

	local children = {
		WorkspacePortal = createElement2(portal, v3, { GUIPart = guiPart }),
		AppUI = 0
	}

	local createElement3 = React.createElement
	local v4 = {
		Name = v2.panelName .. "_SurfaceGui",
		ref = ref,
		Adornee = partRef,
		Active = true,
		Enabled = not v2.hidden,
		CanvasSize = v2.virtualScreenSize,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		LightInfluence = 0,
		children = v2.children,
		AlwaysOnTop = v2.alwaysOnTop,
		Shape = 0,
		HorizontalCurvature = 0,
		ZOffset = 0
	}
	local shape

	if engineFeatureSafe and v2.curvature ~= 0 then
		shape = Enum.SurfaceGuiShape.CurvedHorizontally
	end

	v4.Shape = shape
	local horizontalCurvature

	if engineFeatureSafe then
		horizontalCurvature = v2.curvature
	end

	v4.HorizontalCurvature = horizontalCurvature
	v4.ZOffset = v2.zOffset
	children.AppUI = createElement3("SurfaceGui", v4)
	return createElement("Folder", { ref = ref2, Archivable = false }, children)
end

return Panel3D
