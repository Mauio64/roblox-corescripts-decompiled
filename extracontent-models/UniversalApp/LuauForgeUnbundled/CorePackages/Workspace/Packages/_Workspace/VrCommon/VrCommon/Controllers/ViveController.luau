local VRService = game:GetService("VRService")

local create = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/AppCommonLib").Create

local v5 = {
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

local v6 = {
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

local granite = Enum.Material.Granite

local class = {}
class.__index = class

local v7 = {
	[Enum.UserCFrame.LeftHand] = Enum.VRTouchpad.Left,
	[Enum.UserCFrame.RightHand] = Enum.VRTouchpad.Right
}

function class.new(userCFrame)
	local object = setmetatable({}, class)
	object.userCFrame = userCFrame
	object.touchpad = v7[object.userCFrame]
	object.touchpadMode = VRService:GetTouchpadMode(object.touchpad)
	object.onTouchpadModeChangedConn = VRService.TouchpadModeChanged:connect(function(...)
		object:onTouchpadModeChanged(...)
	end)

	object.model = create("Model")({ Name = "ViveController", Archivable = false })

	object.origin = create("Part")({
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

	for k, v8 in pairs(v5) do
		local v9 = Vector3.new(0.033, 0.033, 0.033)

		if v8.scale then
			v9 *= v8.scale
		end

		local v10 = create("Part")({
			Parent = object.model,
			Name = k,
			Anchored = true,
			Material = granite,
			Size = v8.size or Vector3.new(0.05, 0.05, 0.05),
			CFrame = object.origin.CFrame * v8.offset,
			CanCollide = false,
			CanQuery = false,
			CanTouch = false
		})

		create("SpecialMesh")({
			Parent = v10,
			Name = "Mesh",
			MeshId = v8.meshId,
			TextureId = v8.textureId,
			Scale = v9
		})

		create("Weld")({
			Parent = v10,
			Name = "Weld",
			Part0 = object.origin,
			Part1 = v10,
			C0 = v8.offset
		})

		object.parts[k] = v10
	end

	local v8 = create("Part")({
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

	create("Weld")({
		Parent = v8,
		Name = "Weld",
		Part0 = object.origin,
		Part1 = v8,
		C0 = v5.Trackpad.offset
	})

	object.parts.TrackpadIndicator = v8
	object.model.PrimaryPart = object.origin

	object:onTouchpadModeChanged(object.touchpad, VRService:GetTouchpadMode(object.touchpad))

	return object
end

function class:setPartVisible(p3, p4)
	local part = self.parts[p3]

	if part then
		part.Transparency = p4 and 0 or 1
	end
end

function class:setABXYEnabled(p2)
	self:setPartVisible("ButtonA", p2)
	self:setPartVisible("ButtonB", p2)
	self:setPartVisible("ButtonX", p2)
	self:setPartVisible("ButtonY", p2)
end

function class:setCFrame(cframe)
	self.model:SetPrimaryPartCFrame(cframe)
end

function class:setCFrameAndScale(cframe, scale)
	self.model:SetPrimaryPartCFrame(cframe)

	if self.scale ~= scale then
		self.scale = scale

		for k, v8 in pairs(v5) do
			local part = self.parts[k]

			if not part then
				continue
			end

			local v9 = Vector3.new(0.033, 0.033, 0.033)

			if v8.scale then
				v9 *= v8.scale
			end

			local mesh = part:FindFirstChild("Mesh")
			local weld = part:FindFirstChild("Weld")

			local v10 = CFrame.new(v8.offset.p * self.scale) * (v8.offset - v8.offset.p)
			part.CFrame = cframe * v10

			if mesh then
				mesh.Scale = v9 * self.scale
			end

			if weld then
				weld.C0 = v10
			end
		end
	end
end

function class:setButtonState(p2, p3)
	local v8 = v5[p2]

	if not v8 then
		return
	end

	local offset = v8.offset
	local moveOffset = v8.moveOffset

	if offset and moveOffset then
		local v9 = CFrame.new(offset.p * self.scale) * (offset - offset.p)
		local v10 = CFrame.new(moveOffset.p * self.scale) * (moveOffset - moveOffset.p)

		local part = self.parts[p2]

		if part then
			local mesh = part:FindFirstChild("Mesh")
			local weld = part:FindFirstChild("Weld")

			if weld then
				if p3 then
					part.CFrame = self.origin.CFrame * v9 * v10
					weld.C0 = v9 * v10
				else
					part.CFrame = self.origin.CFrame * v9
					weld.C0 = v9
				end
			end

			if mesh then
				if p3 then
					mesh.VertexColor = Vector3.new(0.5, 0.5, 0.5)
				else
					mesh.VertexColor = Vector3.new(1, 1, 1)
				end
			end
		end
	end
end

function class:setTriggerState(p2)
	local offset = v5.Trigger.offset
	local v8 = CFrame.new(offset.p * self.scale) * (offset - offset.p)

	local trigger = self.parts.Trigger
	local weld = trigger:FindFirstChild("Weld")

	if weld then
		local vector3 = Vector3.new(0, 0.05 * self.scale, -0.025 * self.scale)
		local v9 = p2 * -0.3490658503988659 + 0
		local v10 = v8 * CFrame.new(vector3) * CFrame.Angles(v9, 0, 0) * CFrame.new(-vector3)
		trigger.CFrame = self.origin.CFrame * v10
		weld.C0 = v10
	end
end

function class:setTrackpadState(data2)
	local trackpadIndicator = self.parts.TrackpadIndicator
	local weld = trackpadIndicator:FindFirstChild("Weld")
	local offset = v5.Trackpad.offset
	local v8 = CFrame.new(offset.p * self.scale) * (offset - offset.p)

	if weld then
		local v9 = Vector3.new(data2.X, 0, -data2.Y) * 0.055
		local v10 = CFrame.Angles(0.11344640137963143, 0, 0) * CFrame.new(0, 0.002 * self.scale * data2.magnitude ^ 3, 0)
		local v11 = v8 * CFrame.new(0, 0.01 * self.scale, 0) * v10:toWorldSpace(CFrame.new(v9))
		trackpadIndicator.CFrame = self.origin.CFrame * v11
		weld.C0 = v11
	end
end

function class:onButtonInputChanged(p2, p3)
	if
		self.userCFrame == Enum.UserCFrame.RightHand and p2.KeyCode == Enum.KeyCode.ButtonR3
		or self.userCFrame == Enum.UserCFrame.LeftHand and p2.KeyCode == Enum.KeyCode.ButtonL3
	then
		self:setButtonState("Trackpad", p3)
	elseif
		self.userCFrame == Enum.UserCFrame.RightHand and p2.KeyCode == Enum.KeyCode.ButtonR1
		or self.userCFrame == Enum.UserCFrame.LeftHand and p2.KeyCode == Enum.KeyCode.ButtonL1
	then
		self:setButtonState("LeftGrip", p3)
		self:setButtonState("RightGrip", p3)
	elseif
		self.userCFrame == Enum.UserCFrame.RightHand and p2.KeyCode == Enum.KeyCode.ButtonStart
		or self.userCFrame == Enum.UserCFrame.LeftHand and p2.KeyCode == Enum.KeyCode.ButtonSelect
	then
		self:setButtonState("MenuButton", p3)
	elseif self.touchpadMode == Enum.VRTouchpadMode.ABXY then
		if p2.KeyCode == Enum.KeyCode.ButtonA then
			self:setButtonState("ButtonA", p3)
		elseif p2.KeyCode == Enum.KeyCode.ButtonB then
			self:setButtonState("ButtonB", p3)
		elseif p2.KeyCode == Enum.KeyCode.ButtonX then
			self:setButtonState("ButtonX", p3)
		elseif p2.KeyCode == Enum.KeyCode.ButtonY then
			self:setButtonState("ButtonY", p3)
		end
	end
end

function class:onInputBegan(p2)
	self:onButtonInputChanged(p2, true)

	if
		self.userCFrame == Enum.UserCFrame.RightHand and p2.KeyCode == Enum.KeyCode.Thumbstick2
		or self.userCFrame == Enum.UserCFrame.LeftHand and p2.KeyCode == Enum.KeyCode.Thumbstick1
	then
		self:setPartVisible("TrackpadIndicator", true)
	end
end

function class:onInputChanged(p2)
	if
		self.userCFrame == Enum.UserCFrame.RightHand and p2.KeyCode == Enum.KeyCode.ButtonR2
		or self.userCFrame == Enum.UserCFrame.LeftHand and p2.KeyCode == Enum.KeyCode.ButtonL2
	then
		self:setTriggerState(p2.Position.Z)
	end

	if
		self.userCFrame == Enum.UserCFrame.RightHand and p2.KeyCode == Enum.KeyCode.Thumbstick2
		or self.userCFrame == Enum.UserCFrame.LeftHand and p2.KeyCode == Enum.KeyCode.Thumbstick1
	then
		self:setTrackpadState(p2.Position)
	end
end

function class:onInputEnded(p2)
	self:onButtonInputChanged(p2, false)

	if
		self.userCFrame == Enum.UserCFrame.RightHand and p2.KeyCode == Enum.KeyCode.Thumbstick2
		or self.userCFrame == Enum.UserCFrame.LeftHand and p2.KeyCode == Enum.KeyCode.Thumbstick1
	then
		self:setPartVisible("TrackpadIndicator", false)
	end
end

function class:onTouchpadModeChanged(p2, touchpadMode)
	if p2 ~= self.touchpad then
		return
	end

	self.touchpadMode = touchpadMode

	if touchpadMode == Enum.VRTouchpadMode.ABXY then
		self:setABXYEnabled(true)
	else
		self:setABXYEnabled(false)
	end
end

function class:destroy()
	if self.onTouchpadModeChangedConn then
		self.onTouchpadModeChangedConn:disconnect()
		self.onTouchpadModeChangedConn = nil
	end

	self.model:Destroy()
end

function class:getButtonPart(p3)
	local v8 = v6[p3]

	if v8 then
		return self.parts[v8]
	end

	return nil
end

return class
