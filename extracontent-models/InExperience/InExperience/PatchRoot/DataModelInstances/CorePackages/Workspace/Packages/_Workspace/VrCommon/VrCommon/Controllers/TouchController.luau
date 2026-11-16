local VrCommon = script:FindFirstAncestor("VrCommon")
local parent = VrCommon.Parent

local AppCommonLib = require(parent.AppCommonLib)
local Create = AppCommonLib.Create

local FIntVRTouchControllerTransparency = require(VrCommon.Flags.FIntVRTouchControllerTransparency)

local v = {
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

local v2 = {
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

local TouchController = {}
TouchController.__index = TouchController

function TouchController.new(userCFrame)
	local self = setmetatable({}, TouchController)
	self.userCFrame = userCFrame

	self.model = Create("Model")({ Name = "TouchController", Archivable = false })

	self.origin = Create("Part")({
		Parent = self.model,
		Name = "Origin",
		Anchored = true,
		Transparency = 1,
		Size = Vector3.new(0.05, 0.05, 0.05),
		CanCollide = false,
		CanQuery = false,
		CanTouch = false
	})

	self.scale = 1
	self.parts = {}

	for k, v3 in pairs(v[userCFrame]) do
		local scale = Vector3.new(0.032, 0.032, 0.032)

		if v3.scale then
			scale *= v3.scale
		end

		local v4 = Create("Part")({
			Parent = self.model,
			Name = k,
			Anchored = true,
			Material = Granite,
			Size = v3.size or Vector3.new(0.05, 0.05, 0.05),
			CFrame = self.origin.CFrame * v3.offset,
			CanCollide = false,
			CanQuery = false,
			CanTouch = false,
			Transparency = FIntVRTouchControllerTransparency / 100
		})

		Create("SpecialMesh")({
			Parent = v4,
			Name = "Mesh",
			MeshId = v3.meshId,
			TextureId = v3.textureId,
			Scale = scale
		})

		Create("Weld")({
			Parent = v4,
			Name = "Weld",
			Part0 = self.origin,
			Part1 = v4,
			C0 = v3.offset
		})

		self.parts[k] = v4
	end

	self.model.PrimaryPart = self.origin

	return self
end

function TouchController.setCFrame(p, p2)
	if p.userCFrame == Enum.UserCFrame.RightHand then
		p.model:SetPrimaryPartCFrame(p2 * CFrame.Angles(0.3490658503988659, 0, 0) * CFrame.new(-0.03, 0.08, -0.06))
	else
		p.model:SetPrimaryPartCFrame(p2 * CFrame.Angles(0.3490658503988659, 0, 0) * CFrame.new(0.03, 0.08, -0.06))
	end
end

function TouchController:setCFrameAndScale(p, scale)
	local v3 = self.userCFrame == Enum.UserCFrame.RightHand and 1 or -1
	self.model:SetPrimaryPartCFrame(p * CFrame.Angles(0.3490658503988659, 0, 0) * CFrame.new(-0.03 * scale * v3, 0.08 * scale, -0.06 * scale))

	if self.scale ~= scale then
		self.scale = scale

		for k, v4 in pairs(v[self.userCFrame]) do
			local part = self.parts[k]

			if not part then
				continue
			end

			local v5 = Vector3.new(0.032, 0.032, 0.032)

			if v4.scale then
				v5 *= v4.scale
			end

			local mesh = part:FindFirstChild("Mesh")
			local weld = part:FindFirstChild("Weld")

			local offset = v4.offset
			local c0 = CFrame.new(offset.p * self.scale) * (offset - offset.p)
			part.CFrame = self.origin.CFrame * c0

			if mesh then
				mesh.Scale = v5 * self.scale
			end

			if weld then
				weld.C0 = c0
			end
		end
	end
end

function TouchController:setButtonState(p, p2)
	local v3 = v[self.userCFrame][p]

	if not v3 then
		return
	end

	local offset = v3.offset
	local moveOffset = v3.moveOffset

	if offset and moveOffset then
		local c0 = CFrame.new(offset.p * self.scale) * (offset - offset.p)
		local v4 = CFrame.new(moveOffset.p * self.scale) * (moveOffset - moveOffset.p)

		local part = self.parts[p]

		if part then
			local mesh = part:FindFirstChild("Mesh")
			local weld = part:FindFirstChild("Weld")

			if weld then
				if p2 then
					part.CFrame = self.origin.CFrame * c0 * v4
					weld.C0 = c0 * v4
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

function TouchController:setTriggerState(p)
	local offset = v[self.userCFrame].Trigger.offset
	local v3 = CFrame.new(offset.p * self.scale) * (offset - offset.p)

	local trigger = self.parts.Trigger
	local weld = trigger:FindFirstChild("Weld")

	if weld then
		local v4 = Vector3.new(0, 0.05, 0.025) * self.scale

		local v5 = p * 0.3490658503988659 + 0
		local c0 = v3 * CFrame.new(v4) * CFrame.Angles(v5, 0, 0) * CFrame.new(-v4)
		trigger.CFrame = self.origin.CFrame * c0
		weld.C0 = c0
	end
end

function TouchController:setStickState(p)
	local offset = v[self.userCFrame].Stick.offset
	local v3 = CFrame.new(offset.p * self.scale) * (offset - offset.p)

	local stick = self.parts.Stick
	local weld = stick:FindFirstChild("Weld")

	if weld then
		local v4 = Vector3.new(-0.0008, -0.0269, 0.0013) * self.scale

		local v5 = p.X * 0.3490658503988659 + 0
		local v6 = p.Y * 0.3490658503988659 + 0
		local c0 = v3 * CFrame.new(v4) * CFrame.Angles(v6, 0, v5) * CFrame.new(-v4)
		stick.CFrame = self.origin.CFrame * c0
		weld.C0 = c0
	end
end

function TouchController:onInputPositionChanged(p)
	if
		self.userCFrame == Enum.UserCFrame.RightHand and p.KeyCode == Enum.KeyCode.ButtonR2
		or self.userCFrame == Enum.UserCFrame.LeftHand and p.KeyCode == Enum.KeyCode.ButtonL2
	then
		self:setTriggerState(p.Position.Z)
		return
	end

	if
		(self.userCFrame ~= Enum.UserCFrame.RightHand or p.KeyCode ~= Enum.KeyCode.Thumbstick2)
		and (self.userCFrame ~= Enum.UserCFrame.LeftHand or p.KeyCode ~= Enum.KeyCode.Thumbstick1)
	then
		return
	end

	self:setStickState(p.Position)
end

function TouchController:onButtonInputChanged(p, p2)
	if
		self.userCFrame == Enum.UserCFrame.LeftHand and p.KeyCode == Enum.KeyCode.ButtonL1
		or self.userCFrame == Enum.UserCFrame.RightHand and p.KeyCode == Enum.KeyCode.ButtonR1
		or self.userCFrame == Enum.UserCFrame.LeftHand and p.KeyCode == Enum.KeyCode.ButtonL3
		or self.userCFrame == Enum.UserCFrame.RightHand and p.KeyCode == Enum.KeyCode.ButtonR3
		or self.userCFrame == Enum.UserCFrame.LeftHand and p.KeyCode == Enum.KeyCode.ButtonSelect
		or self.userCFrame == Enum.UserCFrame.RightHand and p.KeyCode == Enum.KeyCode.ButtonStart
		or p.KeyCode == Enum.KeyCode.ButtonA
		or p.KeyCode == Enum.KeyCode.ButtonB
		or p.KeyCode == Enum.KeyCode.ButtonX
		or p.KeyCode == Enum.KeyCode.ButtonY
	then
		self:setButtonState(v2[p.KeyCode], p2)
	end
end

function TouchController:onInputBegan(p)
	self:onButtonInputChanged(p, true)
end

function TouchController:onInputChanged(p)
	self:onInputPositionChanged(p)
end

function TouchController:onInputEnded(p)
	self:onInputPositionChanged(p)
	self:onButtonInputChanged(p, false)
end

function TouchController.onTouchpadModeChanged(_, _, _) end

function TouchController.destroy(p)
	p.model:Destroy()
end

function TouchController.getButtonPart(p, p2)
	local v3 = v2[p2]

	if v3 then
		return p.parts[v3]
	end

	return nil
end

return TouchController
