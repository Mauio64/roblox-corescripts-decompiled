local create = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/AppCommonLib").Create

local FIntVRTouchControllerTransparency = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/VrCommon/Flags/FIntVRTouchControllerTransparency")

local v5 = {
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

local v6 = {
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

local granite = Enum.Material.Granite

local class = {}
class.__index = class

function class.new(userCFrame)
	local object = setmetatable({}, class)
	object.userCFrame = userCFrame

	object.model = create("Model")({ Name = "TouchController", Archivable = false })

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

	for k, v7 in pairs(v5[userCFrame]) do
		local v8 = Vector3.new(0.032, 0.032, 0.032)

		if v7.scale then
			v8 *= v7.scale
		end

		local v9 = create("Part")({
			Parent = object.model,
			Name = k,
			Anchored = true,
			Material = granite,
			Size = v7.size or Vector3.new(0.05, 0.05, 0.05),
			CFrame = object.origin.CFrame * v7.offset,
			CanCollide = false,
			CanQuery = false,
			CanTouch = false,
			Transparency = FIntVRTouchControllerTransparency / 100
		})

		create("SpecialMesh")({
			Parent = v9,
			Name = "Mesh",
			MeshId = v7.meshId,
			TextureId = v7.textureId,
			Scale = v8
		})

		create("Weld")({
			Parent = v9,
			Name = "Weld",
			Part0 = object.origin,
			Part1 = v9,
			C0 = v7.offset
		})

		object.parts[k] = v9
	end

	object.model.PrimaryPart = object.origin

	return object
end

function class:setCFrame(p3)
	if self.userCFrame == Enum.UserCFrame.RightHand then
		self.model:SetPrimaryPartCFrame(p3 * CFrame.Angles(0.3490658503988659, 0, 0) * CFrame.new(-0.03, 0.08, -0.06))
	else
		self.model:SetPrimaryPartCFrame(p3 * CFrame.Angles(0.3490658503988659, 0, 0) * CFrame.new(0.03, 0.08, -0.06))
	end
end

function class:setCFrameAndScale(p2, scale)
	local v7 = self.userCFrame == Enum.UserCFrame.RightHand and 1 or -1
	self.model:SetPrimaryPartCFrame(p2 * CFrame.Angles(0.3490658503988659, 0, 0) * CFrame.new(-0.03 * scale * v7, 0.08 * scale, -0.06 * scale))

	if self.scale ~= scale then
		self.scale = scale

		for k, v8 in pairs(v5[self.userCFrame]) do
			local part = self.parts[k]

			if not part then
				continue
			end

			local v9 = Vector3.new(0.032, 0.032, 0.032)

			if v8.scale then
				v9 *= v8.scale
			end

			local mesh = part:FindFirstChild("Mesh")
			local weld = part:FindFirstChild("Weld")

			local offset = v8.offset
			local v10 = CFrame.new(offset.p * self.scale) * (offset - offset.p)
			part.CFrame = self.origin.CFrame * v10

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
	local v7 = v5[self.userCFrame][p2]

	if not v7 then
		return
	end

	local offset = v7.offset
	local moveOffset = v7.moveOffset

	if offset and moveOffset then
		local v8 = CFrame.new(offset.p * self.scale) * (offset - offset.p)
		local v9 = CFrame.new(moveOffset.p * self.scale) * (moveOffset - moveOffset.p)

		local part = self.parts[p2]

		if part then
			local mesh = part:FindFirstChild("Mesh")
			local weld = part:FindFirstChild("Weld")

			if weld then
				if p3 then
					part.CFrame = self.origin.CFrame * v8 * v9
					weld.C0 = v8 * v9
				else
					part.CFrame = self.origin.CFrame * v8
					weld.C0 = v8
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
	local offset = v5[self.userCFrame].Trigger.offset
	local v7 = CFrame.new(offset.p * self.scale) * (offset - offset.p)

	local trigger = self.parts.Trigger
	local weld = trigger:FindFirstChild("Weld")

	if weld then
		local v8 = Vector3.new(0, 0.05, 0.025) * self.scale

		local v9 = p2 * 0.3490658503988659 + 0
		local v10 = v7 * CFrame.new(v8) * CFrame.Angles(v9, 0, 0) * CFrame.new(-v8)
		trigger.CFrame = self.origin.CFrame * v10
		weld.C0 = v10
	end
end

function class:setStickState(p2)
	local offset = v5[self.userCFrame].Stick.offset
	local v7 = CFrame.new(offset.p * self.scale) * (offset - offset.p)

	local stick = self.parts.Stick
	local weld = stick:FindFirstChild("Weld")

	if weld then
		local v8 = Vector3.new(-0.0008, -0.0269, 0.0013) * self.scale

		local v9 = p2.X * 0.3490658503988659 + 0
		local v10 = p2.Y * 0.3490658503988659 + 0
		local v11 = v7 * CFrame.new(v8) * CFrame.Angles(v10, 0, v9) * CFrame.new(-v8)
		stick.CFrame = self.origin.CFrame * v11
		weld.C0 = v11
	end
end

function class:onInputPositionChanged(p2)
	if
		self.userCFrame == Enum.UserCFrame.RightHand and p2.KeyCode == Enum.KeyCode.ButtonR2
		or self.userCFrame == Enum.UserCFrame.LeftHand and p2.KeyCode == Enum.KeyCode.ButtonL2
	then
		self:setTriggerState(p2.Position.Z)
		return
	end

	if
		(self.userCFrame ~= Enum.UserCFrame.RightHand or p2.KeyCode ~= Enum.KeyCode.Thumbstick2)
		and (self.userCFrame ~= Enum.UserCFrame.LeftHand or p2.KeyCode ~= Enum.KeyCode.Thumbstick1)
	then
		return
	end

	self:setStickState(p2.Position)
end

function class:onButtonInputChanged(p2, p3)
	if
		self.userCFrame == Enum.UserCFrame.LeftHand and p2.KeyCode == Enum.KeyCode.ButtonL1
		or self.userCFrame == Enum.UserCFrame.RightHand and p2.KeyCode == Enum.KeyCode.ButtonR1
		or self.userCFrame == Enum.UserCFrame.LeftHand and p2.KeyCode == Enum.KeyCode.ButtonL3
		or self.userCFrame == Enum.UserCFrame.RightHand and p2.KeyCode == Enum.KeyCode.ButtonR3
		or self.userCFrame == Enum.UserCFrame.LeftHand and p2.KeyCode == Enum.KeyCode.ButtonSelect
		or self.userCFrame == Enum.UserCFrame.RightHand and p2.KeyCode == Enum.KeyCode.ButtonStart
		or p2.KeyCode == Enum.KeyCode.ButtonA
		or p2.KeyCode == Enum.KeyCode.ButtonB
		or p2.KeyCode == Enum.KeyCode.ButtonX
		or p2.KeyCode == Enum.KeyCode.ButtonY
	then
		self:setButtonState(v6[p2.KeyCode], p3)
	end
end

function class:onInputBegan(p2)
	self:onButtonInputChanged(p2, true)
end

function class:onInputChanged(p2)
	self:onInputPositionChanged(p2)
end

function class:onInputEnded(p2)
	self:onInputPositionChanged(p2)
	self:onButtonInputChanged(p2, false)
end

function class:onTouchpadModeChanged(p3, p4) end

function class.destroy(p2)
	p2.model:Destroy()
end

function class:getButtonPart(p3)
	local v7 = v6[p3]

	if v7 then
		return self.parts[v7]
	end

	return nil
end

return class
