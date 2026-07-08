local VrCommon = script:FindFirstAncestor("VrCommon")
local VrCommonParent = VrCommon.Parent
local Create = require(VrCommonParent.AppCommonLib).Create
local FIntVRTouchControllerTransparency = require(VrCommon.Flags.FIntVRTouchControllerTransparency)
local t1 = {
	[Enum.UserCFrame.RightHand] = {
		Body = {
			meshId = "rbxassetid://12954883737",
			textureId = "rbxassetid://12954905146",
			offset = CFrame.new(0, 0, 0) * CFrame.Angles(0, 3.141592653589793, 0)
		},
		Grip = {
			meshId = "rbxassetid://12954884971",
			textureId = "rbxassetid://12954905146",
			offset = CFrame.new(0.015, -0.078, 0.005) * CFrame.Angles(0, 3.141592653589793, 0),
			moveOffset = CFrame.new(-0.01, 0.005, 0) * CFrame.Angles(0, 0, -0.12217304763960307)
		},
		Stick = {
			meshId = "rbxassetid://12954884012",
			textureId = "rbxassetid://12954905146",
			offset = CFrame.new(0.056, 0.027, -0.074) * CFrame.Angles(0, 3.141592653589793, 0),
			moveOffset = CFrame.new(0, -0.001, 0)
		},
		Trigger = {
			meshId = "rbxassetid://12954885295",
			textureId = "rbxassetid://12954905146",
			offset = CFrame.new(0.014, -0.049, -0.131) * CFrame.Angles(0, 3.141592653589793, 0)
		},
		MenuButton = {
			meshId = "rbxassetid://12954884231",
			textureId = "rbxassetid://12954905146",
			offset = CFrame.new(0.07, 0.017, -0.017) * CFrame.Angles(0, 3.141592653589793, 0),
			moveOffset = CFrame.new(0, -0.001, 0)
		},
		ButtonA = {
			meshId = "rbxassetid://12954884749",
			textureId = "rbxassetid://12954905146",
			offset = CFrame.new(0.011, 0.014, -0.026) * CFrame.Angles(0, 3.141592653589793, 0),
			moveOffset = CFrame.new(0, -0.005, 0)
		},
		ButtonB = {
			meshId = "rbxassetid://12954884464",
			textureId = "rbxassetid://12954905146",
			offset = CFrame.new(-0.013, 0.015, -0.07) * CFrame.Angles(0, 3.141592653589793, 0),
			moveOffset = CFrame.new(0, -0.005, 0)
		}
	},
	[Enum.UserCFrame.LeftHand] = {
		Body = {
			meshId = "rbxassetid://12954878407",
			textureId = "rbxassetid://12954905425",
			offset = CFrame.new(0, 0, 0) * CFrame.Angles(0, 3.141592653589793, 0)
		},
		Grip = {
			meshId = "rbxassetid://12954878772",
			textureId = "rbxassetid://12954905425",
			offset = CFrame.new(-0.015, -0.078, 0.005) * CFrame.Angles(0, 3.141592653589793, 0),
			moveOffset = CFrame.new(0.0125, 0.005, 0.001)
		},
		Stick = {
			meshId = "rbxassetid://12954879211",
			textureId = "rbxassetid://12954905425",
			offset = CFrame.new(-0.056, 0.027, -0.074) * CFrame.Angles(0, 3.141592653589793, 0),
			moveOffset = CFrame.new(0, -0.001, 0)
		},
		Trigger = {
			meshId = "rbxassetid://12954878599",
			textureId = "rbxassetid://12954905425",
			offset = CFrame.new(-0.014, -0.049, -0.131) * CFrame.Angles(0, 3.141592653589793, 0)
		},
		MenuButton = {
			meshId = "rbxassetid://12954879390",
			textureId = "rbxassetid://12954905425",
			offset = CFrame.new(-0.07, 0.017, -0.017) * CFrame.Angles(0, 3.141592653589793, 0),
			moveOffset = CFrame.new(0, -0.001, 0)
		},
		ButtonX = {
			meshId = "rbxassetid://12954879064",
			textureId = "rbxassetid://12954905425",
			offset = CFrame.new(-0.011, 0.013, -0.026) * CFrame.Angles(0, 3.141592653589793, 0),
			moveOffset = CFrame.new(0, -0.005, 0)
		},
		ButtonY = {
			meshId = "rbxassetid://12954878913",
			textureId = "rbxassetid://12954905425",
			offset = CFrame.new(0.013, 0.015, -0.07) * CFrame.Angles(0, 3.141592653589793, 0),
			moveOffset = CFrame.new(0, -0.005, 0)
		}
	}
}
local t2 = {
	[Enum.KeyCode.ButtonL1] = "Grip",
	[Enum.KeyCode.ButtonL2] = "Trigger",
	[Enum.KeyCode.ButtonL3] = "Stick",
	[Enum.KeyCode.ButtonR1] = "Grip",
	[Enum.KeyCode.ButtonR2] = "Trigger",
	[Enum.KeyCode.ButtonR3] = "Stick",
	[Enum.KeyCode.Thumbstick1] = "Stick",
	[Enum.KeyCode.Thumbstick2] = "Stick",
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

function t3.new(p1) -- line: 119
	-- upvalues: t3 (copy), Create (copy), t1 (copy), Granite (copy), FIntVRTouchControllerTransparency (copy)
	local self = setmetatable({}, t3)

	self.userCFrame = p1
	self.model = Create("Model")({
		Name = "TouchController",
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

	for k, v in pairs(t1[p1]) do
		local vector3 = Vector3.new(0.03200000151991844, 0.03200000151991844, 0.03200000151991844)

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
			CFrame = self.origin.CFrame * v.offset,
			Transparency = FIntVRTouchControllerTransparency / 100
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

	self.model.PrimaryPart = self.origin

	return self
end
function t3.setCFrame(p2, p3) -- line: 183
	if p2.userCFrame == Enum.UserCFrame.RightHand then
		p2.model:SetPrimaryPartCFrame(p3 * CFrame.Angles(0.3490658503988659, 0, 0) * CFrame.new(-0.03, 0.08, -0.06))

		return
	end

	p2.model:SetPrimaryPartCFrame(p3 * CFrame.Angles(0.3490658503988659, 0, 0) * CFrame.new(0.03, 0.08, -0.06))
end
function t3.setCFrameAndScale(p4, p5, p6) -- line: 191
	-- upvalues: t1 (copy)
	local v20 = p4.userCFrame ~= Enum.UserCFrame.RightHand and -1 or 1

	p4.model:SetPrimaryPartCFrame(p5 * CFrame.Angles(0.3490658503988659, 0, 0) * CFrame.new(-0.03 * p6 * v20, 0.08 * p6, -0.06 * p6))

	if p6 ~= p4.scale then
		p4.scale = p6

		for k, v in pairs(t1[p4.userCFrame]) do
			local v23 = p4.parts[k]

			if v23 then
				local vector3 = Vector3.new(0.03200000151991844, 0.03200000151991844, 0.03200000151991844)

				if v.scale then
					vector3 *= v.scale
				end

				local Mesh = v23:FindFirstChild("Mesh")
				local Weld = v23:FindFirstChild("Weld")
				local offset = v.offset
				local v28 = CFrame.new(offset.p * p4.scale) * (offset - offset.p)

				v23.CFrame = p4.origin.CFrame * v28

				if Mesh then
					Mesh.Scale = vector3 * p4.scale
				end

				if Weld then
					Weld.C0 = v28
				end
			end
		end
	end
end
function t3.setButtonState(p7, p8, p9) -- line: 224
	-- upvalues: t1 (copy)
	local v32 = t1[p7.userCFrame][p8]

	if not v32 then
		return
	end

	local offset = v32.offset
	local moveOffset = v32.moveOffset

	if offset and moveOffset then
		local v35 = CFrame.new(offset.p * p7.scale) * (offset - offset.p)
		local v36 = CFrame.new(moveOffset.p * p7.scale) * (moveOffset - moveOffset.p)
		local v37 = p7.parts[p8]

		if v37 then
			local Mesh = v37:FindFirstChild("Mesh")
			local Weld = v37:FindFirstChild("Weld")

			if Weld then
				if p9 then
					v37.CFrame = p7.origin.CFrame * v35 * v36
					Weld.C0 = v35 * v36
				else
					v37.CFrame = p7.origin.CFrame * v35
					Weld.C0 = v35
				end
			end

			if Mesh then
				if p9 then
					Mesh.VertexColor = Vector3.new(0.5, 0.5, 0.5)

					return
				end

				Mesh.VertexColor = Vector3.new(1, 1, 1)
			end
		end
	end
end
function t3.setTriggerState(p10, p11) -- line: 261
	-- upvalues: t1 (copy)
	local offset = t1[p10.userCFrame].Trigger.offset
	local v43 = CFrame.new(offset.p * p10.scale) * (offset - offset.p)
	local Trigger = p10.parts.Trigger
	local Weld = Trigger:FindFirstChild("Weld")

	if Weld then
		local v46 = Vector3.new(0, 0.05000000074505806, 0.02500000037252903) * p10.scale
		local v47 = p11 * 0.3490658503988659 + 0
		local v48 = v43 * CFrame.new(v46) * CFrame.Angles(v47, 0, 0) * CFrame.new(-v46)

		Trigger.CFrame = p10.origin.CFrame * v48
		Weld.C0 = v48
	end
end
function t3.setStickState(p12, p13) -- line: 278
	-- upvalues: t1 (copy)
	local offset = t1[p12.userCFrame].Stick.offset
	local v52 = CFrame.new(offset.p * p12.scale) * (offset - offset.p)
	local Stick = p12.parts.Stick
	local Weld = Stick:FindFirstChild("Weld")

	if Weld then
		local v55 = Vector3.new(-0.0007999999797903001, -0.026900000870227814, 0.0013000000035390258) * p12.scale
		local v56 = p13.X * 0.3490658503988659 + 0
		local v57 = p13.Y * 0.3490658503988659 + 0
		local v58 = v52 * CFrame.new(v55) * CFrame.Angles(v57, 0, v56) * CFrame.new(-v55)

		Stick.CFrame = p12.origin.CFrame * v58
		Weld.C0 = v58
	end
end
function t3.onInputPositionChanged(p14, p15) -- line: 296
	if p14.userCFrame == Enum.UserCFrame.RightHand and p15.KeyCode == Enum.KeyCode.ButtonR2 or p14.userCFrame == Enum.UserCFrame.LeftHand and p15.KeyCode == Enum.KeyCode.ButtonL2 then
		p14:setTriggerState(p15.Position.Z)

		return
	end

	if p14.userCFrame == Enum.UserCFrame.RightHand and p15.KeyCode == Enum.KeyCode.Thumbstick2 or p14.userCFrame == Enum.UserCFrame.LeftHand and p15.KeyCode == Enum.KeyCode.Thumbstick1 then
		p14:setStickState(p15.Position)

		return
	end
end
function t3.onButtonInputChanged(p16, p17, p18) -- line: 314
	-- upvalues: t2 (copy)
	if p16.userCFrame == Enum.UserCFrame.LeftHand and p17.KeyCode == Enum.KeyCode.ButtonL1 or p16.userCFrame == Enum.UserCFrame.RightHand and p17.KeyCode == Enum.KeyCode.ButtonR1 or p16.userCFrame == Enum.UserCFrame.LeftHand and p17.KeyCode == Enum.KeyCode.ButtonL3 or p16.userCFrame == Enum.UserCFrame.RightHand and p17.KeyCode == Enum.KeyCode.ButtonR3 or p16.userCFrame == Enum.UserCFrame.LeftHand and p17.KeyCode == Enum.KeyCode.ButtonSelect or (p16.userCFrame == Enum.UserCFrame.RightHand and p17.KeyCode == Enum.KeyCode.ButtonStart or p17.KeyCode == Enum.KeyCode.ButtonA or p17.KeyCode == Enum.KeyCode.ButtonB or p17.KeyCode == Enum.KeyCode.ButtonX or p17.KeyCode == Enum.KeyCode.ButtonY) then
		p16:setButtonState(t2[p17.KeyCode], p18)
	end
end
function t3.onInputBegan(p19, p20) -- line: 335
	p19:onButtonInputChanged(p20, true)
end
function t3.onInputChanged(p21, p22) -- line: 339
	p21:onInputPositionChanged(p22)
end
function t3.onInputEnded(p23, p24) -- line: 343
	p23:onInputPositionChanged(p24)
	p23:onButtonInputChanged(p24, false)
end
function t3.onTouchpadModeChanged(_, _, _) -- line: 348
end
function t3.destroy(p28) -- line: 350
	p28.model:Destroy()
end
function t3.getButtonPart(p29, p30) -- line: 354
	-- upvalues: t2 (copy)
	local v76 = t2[p30]

	if v76 then
		return p29.parts[v76]
	end

	return nil
end

return t3
