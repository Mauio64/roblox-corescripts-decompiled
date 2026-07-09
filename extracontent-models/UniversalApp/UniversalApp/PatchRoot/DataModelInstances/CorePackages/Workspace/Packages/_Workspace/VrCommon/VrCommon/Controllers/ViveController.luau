local VRService = game:GetService("VRService")
local Parent = script:FindFirstAncestor("VrCommon").Parent
local Create = require(Parent.AppCommonLib).Create
local t1 = {
	Body = {
		size = Vector3.new(0.39100000262260437, 0.2770000100135803, 0.7310000061988831),
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
		moveOffset = CFrame.new((Vector3.new(-0, -0.0009974209824576974, -7.177444058470428E-05)))
	},
	MenuButton = {
		meshId = "rbxassetid://433288124",
		textureId = "rbxassetid://433288134",
		offset = CFrame.new(0, 0.016, 0.068),
		moveOffset = CFrame.new((Vector3.new(-0, -0.000999877811409533, 1.5630490452167578E-05)))
	},
	Trackpad = {
		meshId = "rbxassetid://433288821",
		textureId = "rbxassetid://433288836",
		offset = CFrame.new(0, 0, 0.163),
		moveOffset = CFrame.new((Vector3.new(-0, -0.0009935068665072322, -0.000113772286567837)))
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
local t2 = {
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
local t3 = {}

t3.__index = t3

local t4 = {
	[Enum.UserCFrame.LeftHand] = Enum.VRTouchpad.Left,
	[Enum.UserCFrame.RightHand] = Enum.VRTouchpad.Right
}

function t3.new(p1) -- line: 109
	-- upvalues: t3 (copy), t4 (copy), VRService (copy), Create (copy), t1 (copy), Granite (copy)
	local self = setmetatable({}, t3)

	self.userCFrame = p1
	self.touchpad = t4[self.userCFrame]
	self.touchpadMode = VRService:GetTouchpadMode(self.touchpad)
	self.onTouchpadModeChangedConn = VRService.TouchpadModeChanged:connect(function(...) -- line: 114
		-- upvalues: self (copy)
		self:onTouchpadModeChanged(...)
	end)
	self.model = Create("Model")({
		Name = "ViveController",
		Archivable = false
	})
	self.origin = Create("Part")({
		Name = "Origin",
		Anchored = true,
		Transparency = 1,
		Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806),
		CanCollide = false,
		CanQuery = false,
		CanTouch = false,
		Parent = self.model
	})
	self.scale = 1
	self.parts = {}

	for k, v in pairs(t1) do
		local vector3 = Vector3.new(0.032999999821186066, 0.032999999821186066, 0.032999999821186066)

		if v.scale then
			vector3 *= v.scale
		end

		local v14 = Create("Part")({
			Anchored = true,
			CanCollide = false,
			CanQuery = false,
			CanTouch = false,
			Parent = self.model,
			Name = k,
			Material = Granite,
			Size = v.size or Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806),
			CFrame = self.origin.CFrame * v.offset
		})

		Create("SpecialMesh")({
			Name = "Mesh",
			Parent = v14,
			MeshId = v.meshId,
			TextureId = v.textureId,
			Scale = vector3
		})
		Create("Weld")({
			Name = "Weld",
			Parent = v14,
			Part0 = self.origin,
			Part1 = v14,
			C0 = v.offset
		})
		self.parts[k] = v14
	end

	local v15 = Create("Part")({
		Name = "TrackpadIndicator",
		Anchored = true,
		Transparency = 1,
		Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806),
		CanCollide = false,
		CanQuery = false,
		CanTouch = false,
		Parent = self.model,
		Material = Enum.Material.Neon,
		BrickColor = BrickColor.new("Institutional white"),
		Shape = Enum.PartType.Ball
	})

	Create("Weld")({
		Name = "Weld",
		Parent = v15,
		Part0 = self.origin,
		Part1 = v15,
		C0 = t1.Trackpad.offset
	})
	self.parts.TrackpadIndicator = v15
	self.model.PrimaryPart = self.origin
	self:onTouchpadModeChanged(self.touchpad, VRService:GetTouchpadMode(self.touchpad))

	return self
end
function t3.setPartVisible(p2, p3, p4) -- line: 200
	local v19 = p2.parts[p3]

	if v19 then
		v19.Transparency = not p4 and 1 or 0
	end
end
function t3.setABXYEnabled(p5, p6) -- line: 207
	p5:setPartVisible("ButtonA", p6)
	p5:setPartVisible("ButtonB", p6)
	p5:setPartVisible("ButtonX", p6)
	p5:setPartVisible("ButtonY", p6)
end
function t3.setCFrame(p7, p8) -- line: 214
	p7.model:SetPrimaryPartCFrame(p8)
end
function t3.setCFrameAndScale(p9, p10, p11) -- line: 218
	-- upvalues: t1 (copy)
	p9.model:SetPrimaryPartCFrame(p10)

	if p11 ~= p9.scale then
		p9.scale = p11

		for k, v in pairs(t1) do
			local v29 = p9.parts[k]

			if v29 then
				local vector3 = Vector3.new(0.032999999821186066, 0.032999999821186066, 0.032999999821186066)

				if v.scale then
					vector3 *= v.scale
				end

				local Mesh = v29:FindFirstChild("Mesh")
				local Weld = v29:FindFirstChild("Weld")
				local v33 = CFrame.new(v.offset.p * p9.scale) * (v.offset - v.offset.p)

				v29.CFrame = p10 * v33

				if Mesh then
					Mesh.Scale = vector3 * p9.scale
				end

				if Weld then
					Weld.C0 = v33
				end
			end
		end
	end
end
function t3.setButtonState(p12, p13, p14) -- line: 247
	-- upvalues: t1 (copy)
	local v37 = t1[p13]

	if not v37 then
		return
	end

	local offset = v37.offset
	local moveOffset = v37.moveOffset

	if offset and moveOffset then
		local v40 = CFrame.new(offset.p * p12.scale) * (offset - offset.p)
		local v41 = CFrame.new(moveOffset.p * p12.scale) * (moveOffset - moveOffset.p)
		local v42 = p12.parts[p13]

		if v42 then
			local Mesh = v42:FindFirstChild("Mesh")
			local Weld = v42:FindFirstChild("Weld")

			if Weld then
				if p14 then
					v42.CFrame = p12.origin.CFrame * v40 * v41
					Weld.C0 = v40 * v41
				else
					v42.CFrame = p12.origin.CFrame * v40
					Weld.C0 = v40
				end
			end

			if Mesh then
				if p14 then
					Mesh.VertexColor = Vector3.new(0.5, 0.5, 0.5)

					return
				end

				Mesh.VertexColor = Vector3.new(1, 1, 1)
			end
		end
	end
end
function t3.setTriggerState(p15, p16) -- line: 284
	-- upvalues: t1 (copy)
	local offset = t1.Trigger.offset
	local v48 = CFrame.new(offset.p * p15.scale) * (offset - offset.p)
	local Trigger = p15.parts.Trigger
	local Weld = Trigger:FindFirstChild("Weld")

	if Weld then
		local vector3 = Vector3.new(0, 0.05 * p15.scale, -0.025 * p15.scale)
		local v52 = p16 * -0.3490658503988659 + 0
		local v53 = v48 * CFrame.new(vector3) * CFrame.Angles(v52, 0, 0) * CFrame.new(-vector3)

		Trigger.CFrame = p15.origin.CFrame * v53
		Weld.C0 = v53
	end
end
function t3.setTrackpadState(p17, p18) -- line: 302
	-- upvalues: t1 (copy)
	local TrackpadIndicator = p17.parts.TrackpadIndicator
	local Weld = TrackpadIndicator:FindFirstChild("Weld")
	local offset = t1.Trackpad.offset
	local v59 = CFrame.new(offset.p * p17.scale) * (offset - offset.p)

	if Weld then
		local v60 = Vector3.new(p18.X, 0, -p18.Y) * 0.055
		local v61 = CFrame.Angles(0.11344640137963143, 0, 0) * CFrame.new(0, 0.002 * p17.scale * p18.magnitude ^ 3, 0)
		local v62 = v59 * CFrame.new(0, 0.01 * p17.scale, 0) * v61:toWorldSpace(CFrame.new(v60))

		TrackpadIndicator.CFrame = p17.origin.CFrame * v62
		Weld.C0 = v62
	end
end
function t3.onButtonInputChanged(p19, p20, p21) -- line: 318
	if p19.userCFrame == Enum.UserCFrame.RightHand and p20.KeyCode == Enum.KeyCode.ButtonR3 or p19.userCFrame == Enum.UserCFrame.LeftHand and p20.KeyCode == Enum.KeyCode.ButtonL3 then
		p19:setButtonState("Trackpad", p21)

		return
	end

	if p19.userCFrame == Enum.UserCFrame.RightHand and p20.KeyCode == Enum.KeyCode.ButtonR1 or p19.userCFrame == Enum.UserCFrame.LeftHand and p20.KeyCode == Enum.KeyCode.ButtonL1 then
		p19:setButtonState("LeftGrip", p21)
		p19:setButtonState("RightGrip", p21)

		return
	end

	if p19.userCFrame == Enum.UserCFrame.RightHand and p20.KeyCode == Enum.KeyCode.ButtonStart or p19.userCFrame == Enum.UserCFrame.LeftHand and p20.KeyCode == Enum.KeyCode.ButtonSelect then
		p19:setButtonState("MenuButton", p21)

		return
	end

	if p19.touchpadMode == Enum.VRTouchpadMode.ABXY then
		if p20.KeyCode == Enum.KeyCode.ButtonA then
			p19:setButtonState("ButtonA", p21)

			return
		end

		if p20.KeyCode == Enum.KeyCode.ButtonB then
			p19:setButtonState("ButtonB", p21)

			return
		end

		if p20.KeyCode == Enum.KeyCode.ButtonX then
			p19:setButtonState("ButtonX", p21)

			return
		end

		if p20.KeyCode == Enum.KeyCode.ButtonY then
			p19:setButtonState("ButtonY", p21)

			return
		end
	end
end
function t3.onInputBegan(p22, p23) -- line: 368
	p22:onButtonInputChanged(p23, true)

	if p22.userCFrame == Enum.UserCFrame.RightHand and p23.KeyCode == Enum.KeyCode.Thumbstick2 or p22.userCFrame == Enum.UserCFrame.LeftHand and p23.KeyCode == Enum.KeyCode.Thumbstick1 then
		p22:setPartVisible("TrackpadIndicator", true)
	end
end
function t3.onInputChanged(p24, p25) -- line: 378
	if p24.userCFrame == Enum.UserCFrame.RightHand and p25.KeyCode == Enum.KeyCode.ButtonR2 or p24.userCFrame == Enum.UserCFrame.LeftHand and p25.KeyCode == Enum.KeyCode.ButtonL2 then
		p24:setTriggerState(p25.Position.Z)
	end

	if p24.userCFrame == Enum.UserCFrame.RightHand and p25.KeyCode == Enum.KeyCode.Thumbstick2 or p24.userCFrame == Enum.UserCFrame.LeftHand and p25.KeyCode == Enum.KeyCode.Thumbstick1 then
		p24:setTrackpadState(p25.Position)
	end
end
function t3.onInputEnded(p26, p27) -- line: 393
	p26:onButtonInputChanged(p27, false)

	if p26.userCFrame == Enum.UserCFrame.RightHand and p27.KeyCode == Enum.KeyCode.Thumbstick2 or p26.userCFrame == Enum.UserCFrame.LeftHand and p27.KeyCode == Enum.KeyCode.Thumbstick1 then
		p26:setPartVisible("TrackpadIndicator", false)
	end
end
function t3.onTouchpadModeChanged(p28, p29, p30) -- line: 403
	if p29 ~= p28.touchpad then
		return
	end

	p28.touchpadMode = p30

	if p30 == Enum.VRTouchpadMode.ABXY then
		p28:setABXYEnabled(true)

		return
	end

	p28:setABXYEnabled(false)
end
function t3.destroy(p31) -- line: 417
	if p31.onTouchpadModeChangedConn then
		p31.onTouchpadModeChangedConn:disconnect()
		p31.onTouchpadModeChangedConn = nil
	end

	p31.model:Destroy()
end
function t3.getButtonPart(p32, p33) -- line: 425
	-- upvalues: t2 (copy)
	local v78 = t2[p33]

	if v78 then
		return p32.parts[v78]
	end

	return nil
end

return t3
