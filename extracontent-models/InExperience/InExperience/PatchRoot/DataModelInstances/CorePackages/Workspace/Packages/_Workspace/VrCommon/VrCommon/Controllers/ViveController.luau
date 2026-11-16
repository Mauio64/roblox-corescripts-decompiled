local VRService = game:GetService("VRService")
local parent = script:FindFirstAncestor("VrCommon").Parent

local AppCommonLib = require(parent.AppCommonLib)
local Create = AppCommonLib.Create

local v = {
	Body = {
		size = Vector3.new(0.391, 0.277, 0.731),
		meshId = "rbxassetid://433286977",
		textureId = "rbxassetid://433287000",
		offset = CFrame.new(0, -0.115, 0.213)
	},
	RightGrip = {
		meshId = "rbxassetid://433290663",
		textureId = "rbxassetid://433290688",
		offset = CFrame.new(0.057, -0.047, 0.29),
		moveOffset = CFrame.new(-0.005, 0, 0)
	},
	LeftGrip = {
		meshId = "rbxassetid://433289821",
		textureId = "rbxassetid://433289832",
		offset = CFrame.new(-0.057, -0.047, 0.29),
		moveOffset = CFrame.new(0.005, 0, 0)
	},
	SystemButton = {
		meshId = "rbxassetid://433291265",
		textureId = "rbxassetid://433291278",
		offset = CFrame.new(0, 0.005, 0.294),
		moveOffset = CFrame.new(-Vector3.new(0, 0.000997421, 0.00007177444))
	},
	MenuButton = {
		meshId = "rbxassetid://433288124",
		textureId = "rbxassetid://433288134",
		offset = CFrame.new(0, 0.016, 0.068),
		moveOffset = CFrame.new(Vector3.new(-0, -0.0009998778, 0.00001563049))
	},
	Trackpad = {
		meshId = "rbxassetid://433288821",
		textureId = "rbxassetid://433288836",
		offset = CFrame.new(0, 0, 0.163),
		moveOffset = CFrame.new(-Vector3.new(0, 0.0009935069, 0.00011377229))
	},
	Trigger = {
		meshId = "rbxassetid://433288767",
		textureId = "rbxassetid://433288775",
		offset = CFrame.new(0, -0.093, 0.163)
	},
	LED = {
		meshId = "rbxassetid://433293218",
		textureId = "rbxassetid://433293231",
		offset = CFrame.new(0, 0.007, 0.32)
	},
	ButtonA = {
		meshId = "rbxassetid://922444331",
		textureId = "rbxasset://textures/ui/VR/ButtonA.png",
		offset = CFrame.new(-0, 0.0115499999, 0.197307006) * CFrame.Angles(0, 3.141592653589793, 0),
		moveOffset = CFrame.new(0, -0.005, 0)
	},
	ButtonB = {
		meshId = "rbxassetid://922454202",
		textureId = "rbxasset://textures/ui/VR/ButtonB.png",
		offset = CFrame.new(0.0391042456, 0.0154935224, 0.161779419) * CFrame.Angles(0, 3.141592653589793, 0),
		moveOffset = CFrame.new(0, -0.005, 0)
	},
	ButtonX = {
		meshId = "rbxassetid://922453111",
		textureId = "rbxasset://textures/ui/VR/ButtonX.png",
		offset = CFrame.new(-0.0390719995, 0.0154770007, 0.161733001) * CFrame.Angles(0, 3.141592653589793, 0),
		moveOffset = CFrame.new(0, -0.005, 0)
	},
	ButtonY = {
		meshId = "rbxassetid://922455502",
		textureId = "rbxasset://textures/ui/VR/ButtonY.png",
		offset = CFrame.new(0, 0.0197229274, 0.126810834) * CFrame.Angles(0, 3.141592653589793, 0),
		moveOffset = CFrame.new(0, -0.005, 0)
	}
}

local v2 = {
	[Enum.KeyCode.ButtonL1] = "LeftGrip",
	[Enum.KeyCode.ButtonL2] = "Trigger",
	[Enum.KeyCode.ButtonL3] = "Trackpad",
	[Enum.KeyCode.ButtonR1] = "RightGrip",
	[Enum.KeyCode.ButtonR2] = "Trigger",
	[Enum.KeyCode.ButtonR3] = "Trackpad",
	[Enum.KeyCode.Thumbstick1] = "Trackpad",
	[Enum.KeyCode.Thumbstick2] = "Trackpad",
	[Enum.KeyCode.ButtonSelect] = "MenuButton",
	[Enum.KeyCode.ButtonStart] = "MenuButton",
	[Enum.KeyCode.ButtonA] = "ButtonA",
	[Enum.KeyCode.ButtonB] = "ButtonB",
	[Enum.KeyCode.ButtonX] = "ButtonX",
	[Enum.KeyCode.ButtonY] = "ButtonY"
}

local Granite = Enum.Material.Granite

local ViveController = {}
ViveController.__index = ViveController

local v3 = {
	[Enum.UserCFrame.LeftHand] = Enum.VRTouchpad.Left,
	[Enum.UserCFrame.RightHand] = Enum.VRTouchpad.Right
}

function ViveController.new(userCFrame)
	local object = setmetatable({}, ViveController)
	object.userCFrame = userCFrame
	object.touchpad = v3[object.userCFrame]
	object.touchpadMode = VRService:GetTouchpadMode(object.touchpad)
	object.onTouchpadModeChangedConn = VRService.TouchpadModeChanged:connect(function(...)
		object:onTouchpadModeChanged(...)
	end)

	object.model = Create("Model")({ Name = "ViveController", Archivable = false })

	object.origin = Create("Part")({
		Parent = object.model,
		Name = "Origin",
		Anchored = true,
		Transparency = 1,
		Size = Vector3.new(0.05, 0.05, 0.05),
		CanCollide = false,
		CanQuery = false,
		CanTouch = false
	})

	object.scale = 1
	object.parts = {}

	for k, v4 in pairs(v) do
		local scale = Vector3.new(0.033, 0.033, 0.033)

		if v4.scale then
			scale *= v4.scale
		end

		local v5 = Create("Part")({
			Parent = object.model,
			Name = k,
			Anchored = true,
			Material = Granite,
			Size = v4.size or Vector3.new(0.05, 0.05, 0.05),
			CFrame = object.origin.CFrame * v4.offset,
			CanCollide = false,
			CanQuery = false,
			CanTouch = false
		})

		Create("SpecialMesh")({
			Parent = v5,
			Name = "Mesh",
			MeshId = v4.meshId,
			TextureId = v4.textureId,
			Scale = scale
		})

		Create("Weld")({
			Parent = v5,
			Name = "Weld",
			Part0 = object.origin,
			Part1 = v5,
			C0 = v4.offset
		})

		object.parts[k] = v5
	end

	local v4 = Create("Part")({
		Parent = object.model,
		Name = "TrackpadIndicator",
		Material = Enum.Material.Neon,
		BrickColor = BrickColor.new("Institutional white"),
		Shape = Enum.PartType.Ball,
		Anchored = true,
		Transparency = 1,
		Size = Vector3.new(0.05, 0.05, 0.05),
		CanCollide = false,
		CanQuery = false,
		CanTouch = false
	})

	Create("Weld")({
		Parent = v4,
		Name = "Weld",
		Part0 = object.origin,
		Part1 = v4,
		C0 = v.Trackpad.offset
	})

	object.parts.TrackpadIndicator = v4
	object.model.PrimaryPart = object.origin

	object:onTouchpadModeChanged(object.touchpad, VRService:GetTouchpadMode(object.touchpad))

	return object
end

function ViveController:setPartVisible(p, p2)
	local part = self.parts[p]

	if part then
		part.Transparency = p2 and 0 or 1
	end
end

function ViveController:setABXYEnabled(p)
	self:setPartVisible("ButtonA", p)
	self:setPartVisible("ButtonB", p)
	self:setPartVisible("ButtonX", p)
	self:setPartVisible("ButtonY", p)
end

function ViveController.setCFrame(p, cframe)
	p.model:SetPrimaryPartCFrame(cframe)
end

function ViveController:setCFrameAndScale(cframe, scale)
	self.model:SetPrimaryPartCFrame(cframe)

	if self.scale ~= scale then
		self.scale = scale

		for k, v4 in pairs(v) do
			local part = self.parts[k]

			if not part then
				continue
			end

			local v5 = Vector3.new(0.033, 0.033, 0.033)

			if v4.scale then
				v5 *= v4.scale
			end

			local mesh = part:FindFirstChild("Mesh")
			local weld = part:FindFirstChild("Weld")

			local c0 = CFrame.new(v4.offset.p * self.scale) * (v4.offset - v4.offset.p)
			part.CFrame = cframe * c0

			if mesh then
				mesh.Scale = v5 * self.scale
			end

			if weld then
				weld.C0 = c0
			end
		end
	end
end

function ViveController:setButtonState(p, p2)
	local v4 = v[p]

	if not v4 then
		return
	end

	local offset = v4.offset
	local moveOffset = v4.moveOffset

	if offset and moveOffset then
		local c0 = CFrame.new(offset.p * self.scale) * (offset - offset.p)
		local v5 = CFrame.new(moveOffset.p * self.scale) * (moveOffset - moveOffset.p)

		local part = self.parts[p]

		if part then
			local mesh = part:FindFirstChild("Mesh")
			local weld = part:FindFirstChild("Weld")

			if weld then
				if p2 then
					part.CFrame = self.origin.CFrame * c0 * v5
					weld.C0 = c0 * v5
				else
					part.CFrame = self.origin.CFrame * c0
					weld.C0 = c0
				end
			end

			if mesh then
				if p2 then
					mesh.VertexColor = Vector3.new(0.5, 0.5, 0.5)
				else
					mesh.VertexColor = Vector3.new(1, 1, 1)
				end
			end
		end
	end
end

function ViveController:setTriggerState(p)
	local offset = v.Trigger.offset
	local v4 = CFrame.new(offset.p * self.scale) * (offset - offset.p)

	local trigger = self.parts.Trigger
	local weld = trigger:FindFirstChild("Weld")

	if weld then
		local vector3 = Vector3.new(0, 0.05 * self.scale, -0.025 * self.scale)
		local v5 = p * -0.3490658503988659 + 0
		local c0 = v4 * CFrame.new(vector3) * CFrame.Angles(v5, 0, 0) * CFrame.new(-vector3)
		trigger.CFrame = self.origin.CFrame * c0
		weld.C0 = c0
	end
end

function ViveController:setTrackpadState(data)
	local trackpadIndicator = self.parts.TrackpadIndicator
	local weld = trackpadIndicator:FindFirstChild("Weld")
	local offset = v.Trackpad.offset
	local v4 = CFrame.new(offset.p * self.scale) * (offset - offset.p)

	if weld then
		local v5 = Vector3.new(data.X, 0, -data.Y) * 0.055
		local v6 = CFrame.Angles(0.11344640137963143, 0, 0) * CFrame.new(0, 0.002 * self.scale * data.magnitude ^ 3, 0)
		local c0 = v4 * CFrame.new(0, 0.01 * self.scale, 0) * v6:toWorldSpace(CFrame.new(v5))
		trackpadIndicator.CFrame = self.origin.CFrame * c0
		weld.C0 = c0
	end
end

function ViveController:onButtonInputChanged(p, p2)
	if
		self.userCFrame == Enum.UserCFrame.RightHand and p.KeyCode == Enum.KeyCode.ButtonR3
		or self.userCFrame == Enum.UserCFrame.LeftHand and p.KeyCode == Enum.KeyCode.ButtonL3
	then
		self:setButtonState("Trackpad", p2)
	elseif
		self.userCFrame == Enum.UserCFrame.RightHand and p.KeyCode == Enum.KeyCode.ButtonR1
		or self.userCFrame == Enum.UserCFrame.LeftHand and p.KeyCode == Enum.KeyCode.ButtonL1
	then
		self:setButtonState("LeftGrip", p2)
		self:setButtonState("RightGrip", p2)
	elseif
		self.userCFrame == Enum.UserCFrame.RightHand and p.KeyCode == Enum.KeyCode.ButtonStart
		or self.userCFrame == Enum.UserCFrame.LeftHand and p.KeyCode == Enum.KeyCode.ButtonSelect
	then
		self:setButtonState("MenuButton", p2)
	elseif self.touchpadMode == Enum.VRTouchpadMode.ABXY then
		if p.KeyCode == Enum.KeyCode.ButtonA then
			self:setButtonState("ButtonA", p2)
		elseif p.KeyCode == Enum.KeyCode.ButtonB then
			self:setButtonState("ButtonB", p2)
		elseif p.KeyCode == Enum.KeyCode.ButtonX then
			self:setButtonState("ButtonX", p2)
		elseif p.KeyCode == Enum.KeyCode.ButtonY then
			self:setButtonState("ButtonY", p2)
		end
	end
end

function ViveController:onInputBegan(p)
	self:onButtonInputChanged(p, true)

	if
		self.userCFrame == Enum.UserCFrame.RightHand and p.KeyCode == Enum.KeyCode.Thumbstick2
		or self.userCFrame == Enum.UserCFrame.LeftHand and p.KeyCode == Enum.KeyCode.Thumbstick1
	then
		self:setPartVisible("TrackpadIndicator", true)
	end
end

function ViveController:onInputChanged(p)
	if
		self.userCFrame == Enum.UserCFrame.RightHand and p.KeyCode == Enum.KeyCode.ButtonR2
		or self.userCFrame == Enum.UserCFrame.LeftHand and p.KeyCode == Enum.KeyCode.ButtonL2
	then
		self:setTriggerState(p.Position.Z)
	end

	if
		self.userCFrame == Enum.UserCFrame.RightHand and p.KeyCode == Enum.KeyCode.Thumbstick2
		or self.userCFrame == Enum.UserCFrame.LeftHand and p.KeyCode == Enum.KeyCode.Thumbstick1
	then
		self:setTrackpadState(p.Position)
	end
end

function ViveController:onInputEnded(p)
	self:onButtonInputChanged(p, false)

	if
		self.userCFrame == Enum.UserCFrame.RightHand and p.KeyCode == Enum.KeyCode.Thumbstick2
		or self.userCFrame == Enum.UserCFrame.LeftHand and p.KeyCode == Enum.KeyCode.Thumbstick1
	then
		self:setPartVisible("TrackpadIndicator", false)
	end
end

function ViveController:onTouchpadModeChanged(p, touchpadMode)
	if p ~= self.touchpad then
		return
	end

	self.touchpadMode = touchpadMode

	if touchpadMode == Enum.VRTouchpadMode.ABXY then
		self:setABXYEnabled(true)
	else
		self:setABXYEnabled(false)
	end
end

function ViveController:destroy()
	if self.onTouchpadModeChangedConn then
		self.onTouchpadModeChangedConn:disconnect()
		self.onTouchpadModeChangedConn = nil
	end

	self.model:Destroy()
end

function ViveController.getButtonPart(p, p2)
	local v4 = v2[p2]

	if v4 then
		return p.parts[v4]
	end

	return nil
end

return ViveController
