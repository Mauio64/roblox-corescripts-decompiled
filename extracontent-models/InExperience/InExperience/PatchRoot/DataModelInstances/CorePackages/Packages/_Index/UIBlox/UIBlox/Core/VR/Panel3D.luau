local RunService = game:GetService("RunService")
local scriptParent = script.Parent
local Constants = require(scriptParent.Constants)
local usePanel3DRenderStep = require(scriptParent.usePanel3DRenderStep)
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Roact = require(ParentParentParent.Roact)
local Object = require(ParentParentParent.LuauPolyfill).Object
local v10 = require(ParentParent.Core.Utility.GetEngineFeatureSafe)("CurvedSurfaceGuisEnabled")
local t1 = {
	lerp = false,
	tilt = 0,
	faceCamera = false,
	panelName = "PanelBase",
	alwaysOnTop = true,
	hidden = false,
	curvature = 1,
	zOffset = 0,
	connectPanelManagerFunction = nil,
	partRef = nil,
	partSize = Vector2.new(10, 10),
	virtualScreenSize = Vector2.new(10, 10),
	offset = CFrame.new(0, 0, 0),
	anchoring = Constants.AnchoringTypes.World,
	movementUpdateEvent = RunService.RenderStepped,
	vrService = game:GetService("VRService"),
	parent = workspace
}

local function Panel3D(p1) -- line: 43
	-- upvalues: Object (copy), t1 (copy), React (copy), usePanel3DRenderStep (copy), Constants (copy), Roact (copy), v10 (copy)
	local v14 = Object.assign({}, t1, p1)
	local v15 = v14.partRef or React.useRef(nil)
	local v16 = React.useRef(nil)
	local v17 = React.useRef(nil)

	usePanel3DRenderStep(v14, v15)
	React.useEffect(function() -- line: 51
		-- upvalues: v14 (copy), Constants (copy), v16 (copy)
		if v14.anchoring ~= Constants.AnchoringTypes.PanelManaged then
			return function() -- line: 53
			end
		end

		if v14.connectPanelManagerFunction == nil then
			return function() -- line: 57
			end
		end

		if v16 ~= nil and v14.connectPanelManagerFunction then
			v14.connectPanelManagerFunction(v16)

			return function() -- line: 63
				-- upvalues: v14 (copy)
				v14.connectPanelManagerFunction(nil)
			end
		end

		return function() -- line: 68
		end
	end, {
		v16,
		v14.anchoring,
		v14.connectPanelManagerFunction
	})

	return React.createElement("Folder", {
		Archivable = false,
		ref = v17
	}, {
		WorkspacePortal = React.createElement(Roact.Portal, {
			target = v14.parent
		}, {
			GUIPart = if not v14.hidden then React.createElement("Part", {
				Anchored = true,
				Transparency = 1,
				CanCollide = false,
				CanTouch = false,
				Name = v14.panelName .. "_Part",
				ref = v15,
				CFrame = v14.offset * CFrame.Angles(math.rad(v14.tilt), 0, 0),
				Size = Vector3.new(v14.partSize.X, v14.partSize.Y, 0.05),
				Color = Color3.new(0, 0, 0)
			}) else nil
		}),
		AppUI = React.createElement("SurfaceGui", {
			Active = true,
			LightInfluence = 0,
			Name = v14.panelName .. "_SurfaceGui",
			ref = v16,
			Adornee = v15,
			Enabled = not v14.hidden,
			CanvasSize = v14.virtualScreenSize,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			children = v14.children,
			AlwaysOnTop = v14.alwaysOnTop,
			Shape = if not v10 or v14.curvature == 0 then nil else Enum.SurfaceGuiShape.CurvedHorizontally,
			HorizontalCurvature = if not v10 then nil else v14.curvature,
			ZOffset = v14.zOffset
		})
	})
end

return Panel3D
