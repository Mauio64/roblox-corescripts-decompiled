local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ParentParent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local Colors = require(ParentParent.Colors)
local CharacterModelPool = require(ParentParent.CharacterModelPool)
local InspectAndBuyContext = require(ParentParent.Components.InspectAndBuyContext)
local FFlagEnableNewAvatarViewportProps = require(ParentParent.Flags.FFlagEnableNewAvatarViewportProps)
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local FFlagEnableInExperienceUIPCVRFix = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableInExperienceUIPCVRFix
local FFlagEnableInspectAndBuyV2RootFlag = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableInspectAndBuyV2RootFlag
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local v17 = Roact.PureComponent:extend("AvatarViewport")

function v17.init(p1) -- line: 30
	-- upvalues: Roact (copy)
	p1.viewportFrameRef = Roact.createRef()
	p1.worldModelRef = Roact.createRef()
	p1.connections = {}
	p1.xRotation = 0
	p1.yRotation = 0
	p1.rotationDeltaX = 0
	p1.rotationDeltaY = 0
	p1.mouseOrTouchDown = false
	p1.delta = 0
	p1.keys = {}
	p1.lastPosition = Vector3.new(0, 0, 0)
	p1.viewportCamera = Instance.new("Camera")
	p1.viewportCamera.CameraType = Enum.CameraType.Scriptable
	p1.model = p1.props.model
	p1.lastInputTime = 2
	p1.initialHrpPosition = p1.props.model ~= nil and p1.props.model.HumanoidRootPart.Position or nil
end
function v17.didMount(p2) -- line: 49
	-- upvalues: CharacterModelPool (copy)
	if p2.props.humanoidDescription and p2.model then
		p2.viewportCamera.Parent = p2.viewportFrameRef.current
		p2.viewportFrameRef.current.CurrentCamera = p2.viewportCamera
		p2:setRotation()

		local RigType = p2.model.Humanoid.RigType

		p2.characterModelPool = CharacterModelPool.new(p2.worldModelRef, p2.initialHrpPosition, RigType)
	end

	p2.isMounted = true
	p2:handleSpin()
	p2:setUpGamepad()
end
function v17.didUpdate(p3, p4, _) -- line: 64
	-- upvalues: FFlagEnableNewAvatarViewportProps (copy)
	if p3.props.visible and (p3.props.humanoidDescription ~= p4.humanoidDescription and p3.model) then
		if FFlagEnableNewAvatarViewportProps and p3.props.resetCameraAndAutoRotationOnModelChange then
			p3.xRotation = 0
			p3.yRotation = 0

			if not p3.props.disableAutoRotation then
				p3.lastInputTime = tick()
			end
		end

		coroutine.wrap(function() -- line: 75
			-- upvalues: p3 (copy)
			p3.characterModelPool:maybeUpdateCharacter(p3.props.humanoidDescription)
		end)()
	end

	p3.gamepadRotating = false
	p3.viewportCamera.Parent = p3.viewportFrameRef.current
	p3.viewportFrameRef.current.CurrentCamera = p3.viewportCamera

	if p3.props.gamepadEnabled ~= p4.gamepadEnabled then
		if p3.props.gamepadEnabled then
			p3:setUpGamepad()

			return
		end

		p3:unbindActions()
	end
end
function v17.setRotation(p6) -- line: 94
	-- upvalues: FFlagEnableNewAvatarViewportProps (copy)
	local model = p6.model

	if model then
		local HumanoidRootPart = model.HumanoidRootPart
		local v28 = p6.initialHrpPosition or HumanoidRootPart.Position
		local defaultCameraOffset

		if FFlagEnableNewAvatarViewportProps and p6.props.offsetOptions then
			defaultCameraOffset = p6.props.offsetOptions.defaultCameraOffset

			if p6.model:FindFirstChildOfClass("Tool") then
				defaultCameraOffset = p6.props.offsetOptions.toolOffset
			end
		else
			local view = p6.props.view
			local v31 = p6.props.views[view]

			defaultCameraOffset = v31.DefaultCameraOffset

			if p6.model:FindFirstChildOfClass("Tool") then
				defaultCameraOffset = v31.ToolOffset
			end
		end

		local p = (CFrame.new(v28) * CFrame.Angles(0, -p6.yRotation, 0) * CFrame.Angles(p6.xRotation, 0, 0) * defaultCameraOffset).p

		p6.viewportCamera.CFrame = CFrame.new(p, v28)

		if FFlagEnableNewAvatarViewportProps and p6.props.cameraFieldOfView then
			p6.viewportCamera.FieldOfView = p6.props.cameraFieldOfView
		end
	end
end
function v17.render(p7) -- line: 135
	-- upvalues: Roact (copy), Colors (copy), FFlagEnableNewAvatarViewportProps (copy), UserInputService (copy)
	local size = p7.props.size
	local position = p7.props.position
	local visible = p7.props.visible
	local backgroundTransparency = p7.props.backgroundTransparency
	local setScrollingEnabled = p7.props.setScrollingEnabled

	return Roact.createElement("ViewportFrame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = position,
		Size = size,
		BackgroundTransparency = backgroundTransparency,
		BackgroundColor3 = Colors.Graphite,
		BorderSizePixel = 0,
		Active = true,
		Visible = visible,
		[Roact.Ref] = p7.viewportFrameRef,
		[Roact.Event.InputBegan] = function(_, p9) -- line: 152
			-- upvalues: p7 (copy), FFlagEnableNewAvatarViewportProps (copy), setScrollingEnabled (copy), UserInputService (copy)
			if p9.UserInputState == Enum.UserInputState.Begin then
				p7.mouseOrTouchDown = true
				p7.lastPosition = p9.Position

				if FFlagEnableNewAvatarViewportProps then
					if setScrollingEnabled then
						setScrollingEnabled(false)
					end
				else
					setScrollingEnabled(false)
				end

				local v53 = UserInputService.InputChanged:connect(function(p10, _) -- line: 166
					-- upvalues: p7 (copy)
					if p10.UserInputType == Enum.UserInputType.MouseMovement and p7.mouseOrTouchDown or p10.UserInputType == Enum.UserInputType.Touch then
						local v67 = p10.Position - p7.lastPosition

						p7.lastPosition = p10.Position
						p7.yRotation = p7.yRotation + v67.x * 0.0065
						p7.xRotation = p7.xRotation + v67.y * 0.0065
						p7.lastInputTime = tick()
					end
				end)
				local v54 = UserInputService.InputEnded:connect(function(p12, _) -- line: 179
					-- upvalues: p7 (copy), FFlagEnableNewAvatarViewportProps (copy), setScrollingEnabled (copy)
					if p12.UserInputType == Enum.UserInputType.MouseButton1 or p12.UserInputType == Enum.UserInputType.Touch then
						if p7.mouseOrTouchDown then
							p7.mouseOrTouchDown = false
							p7.lastInputTime = tick()
							p7:removeConnections()
						end

						if FFlagEnableNewAvatarViewportProps then
							if setScrollingEnabled then
								setScrollingEnabled(true)

								return
							end
						else
							setScrollingEnabled(true)
						end
					end
				end)

				table.insert(p7.connections, v53)
				table.insert(p7.connections, v54)
			end
		end
	}, {
		WorldModel = Roact.createElement("WorldModel", {
			[Roact.Ref] = p7.worldModelRef
		})
	})
end
function v17.handleSpin(p14) -- line: 214
	-- upvalues: FFlagEnableNewAvatarViewportProps (copy), RunService (copy)
	local u40 = false

	spawn(function() -- line: 216
		-- upvalues: p14 (copy), FFlagEnableNewAvatarViewportProps (copy), u40 (ref), RunService (copy)
		local g58 = nil
		local v59 = nil

		while p14.isMounted do
			if tick() - p14.lastInputTime > 2 and not p14.mouseOrTouchDown and not p14.gamepadRotating then
				if not FFlagEnableNewAvatarViewportProps or not p14.props.disableAutoRotation then
					u40 = true
				end
			else
				u40 = false
			end

			local function returnToDefaultPosition(p15, p16) -- line: 231
				local v72 = p15 % 6.283185307179586
				local v73

				if v72 > 3.141592653589793 then
					v73 = v72 + p16

					if v73 > 6.283185307179586 then
						return 0
					end
				else
					v73 = v72 - p16

					if v73 < 0 then
						return 0
					end
				end

				return v73
			end

			if u40 then
				local v56 = p14
				local v57 = p14.xRotation % 6.283185307179586

				repeat
					if not g58 and v57 > 3.141592653589793 then
						v59 = v57 + 0.03490658503988659

						if not (v59 > 6.283185307179586) then
							g58 = true
						end

						if not g58 then
							v59 = 0
						end
					else
						if not g58 then
							v59 = v57 - 0.03490658503988659
						end

						if not g58 and v59 < 0 then
							v59 = 0
						else
							g58 = false
						end
					end
				until not g58

				v56.xRotation = v59
				p14.yRotation = p14.yRotation + 0.012217304763960306
			elseif p14.gamepadRotating then
				p14.yRotation = p14.yRotation + p14.delta * p14.rotationDeltaY
				p14.xRotation = p14.xRotation + p14.delta * p14.rotationDeltaX
			end

			p14:setRotation()
			p14.delta = RunService.RenderStepped:wait()
		end
	end)
end
function v17.setUpGamepad(p17) -- line: 261
	-- upvalues: isInExperienceUIVREnabled (copy), FFlagEnableInExperienceUIPCVRFix (copy), isSpatial (copy), FFlagEnableInspectAndBuyV2RootFlag (copy), UserInputService (copy), ContextActionService (copy)
	if isInExperienceUIVREnabled and (FFlagEnableInExperienceUIPCVRFix and isSpatial() and FFlagEnableInspectAndBuyV2RootFlag) then
		return
	end

	if UserInputService.GamepadEnabled then
		local vector2 = Vector2.new(0, 0)

		ContextActionService:UnbindCoreAction("RotateModel")
		ContextActionService:BindCoreAction("RotateModel", function(_, p19, p20) -- line: 277
			-- upvalues: vector2 (ref), p17 (copy)
			if p19 == Enum.UserInputState.Change then
				vector2 = p20.Position or vector2
				vector2 = Vector2.new(vector2.X, vector2.Y)

				if math.abs(vector2.X) > 0.2 or math.abs(vector2.Y) > 0.2 then
					p17.lastInputTime = tick()
					p17.gamepadRotating = true
					p17.rotationDeltaY = 3 * vector2.X
					p17.rotationDeltaX = 3 * vector2.Y
				else
					p17.gamepadRotating = false
				end
			end

			return Enum.ContextActionResult.Sink
		end, false, Enum.KeyCode.Thumbstick2, Enum.KeyCode.ButtonA)
	end
end
function v17.unbindActions(_) -- line: 296
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("RotateModel")
end
function v17.removeConnections(p22) -- line: 300
	for _, v in pairs(p22.connections) do
		v:disconnect()
	end
end
function v17.willUnmount(p23) -- line: 306
	p23.isMounted = false

	if p23.characterModelPool then
		p23.characterModelPool:onDestroy()
	end

	p23:unbindActions()
	p23:removeConnections()
end

local function AvatarViewportWrapper(p24) -- line: 316
	-- upvalues: Roact (copy), InspectAndBuyContext (copy), Cryo (copy), v17 (copy)
	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(p25) -- line: 318
			-- upvalues: Cryo (copy), p24 (copy), Roact (copy), v17 (copy)
			local v64 = Cryo.Dictionary.join(p24, {
				views = p25
			})

			return Roact.createElement(v17, v64)
		end
	})
end

return RoactRodux.UNSTABLE_connect2(function(p26, _) -- line: 325
	return {
		view = p26.view,
		tryingOnInfo = p26.tryingOnInfo,
		gamepadEnabled = p26.gamepadEnabled
	}
end)(AvatarViewportWrapper)
