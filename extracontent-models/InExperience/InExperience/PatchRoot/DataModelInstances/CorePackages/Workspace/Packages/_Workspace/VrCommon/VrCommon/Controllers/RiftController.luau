local parent = script:FindFirstAncestor("VrCommon").Parent

local AppCommonLib = require(parent.AppCommonLib)
local Create = AppCommonLib.Create

local Granite = Enum.Material.Granite

local RiftController = {}
RiftController.__index = RiftController

function RiftController.new(userCFrame)
	local self = setmetatable({}, RiftController)
	self.userCFrame = userCFrame

	self.model = Create("Model")({ Name = "RiftController", Archivable = false })

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

	self.parts = {}

	local v = Create("Part")({
		Parent = self.model,
		Name = "body",
		Anchored = true,
		Material = Granite,
		Size = Vector3.new(0.05, 0.05, 0.05),
		Transparency = 0.25,
		CFrame = self.origin.CFrame,
		CanCollide = false,
		CanQuery = false,
		CanTouch = false
	})

	self.mesh = Create("SpecialMesh")({
		Parent = v,
		Name = "Mesh",
		MeshId = userCFrame == Enum.UserCFrame.LeftHand and "rbxassetid://9597097835" or "rbxassetid://9597101144",
		TextureId = "rbxassetid://9597123835",
		Scale = Vector3.new(0.032, 0.032, 0.032)
	})
	Create("Weld")({ Parent = v, Name = "Weld", Part0 = self.origin, Part1 = v })

	self.parts.body = v

	self.model.PrimaryPart = self.origin

	return self
end

function RiftController.setCFrame(p, p2)
	p.model:SetPrimaryPartCFrame(p2 * CFrame.Angles(0.3490658503988659, 0, 0) * CFrame.new(0, -0.03, 0.06))
end

function RiftController.setCFrameAndScale(p, p2, p3)
	p.model:SetPrimaryPartCFrame(p2 * CFrame.Angles(0.3490658503988659, 0, 0) * CFrame.new(0, -0.03 * p3, 0.06 * p3))

	p.mesh.Scale = Vector3.new(0.032, 0.032, 0.032) * p3
end

function RiftController:onButtonInputChanged(_, _) end

function RiftController:onInputBegan(p)
	self:onButtonInputChanged(p, true)
end

function RiftController.onInputChanged(_, _) end

function RiftController:onInputEnded(p)
	self:onButtonInputChanged(p, false)
end

function RiftController.onTouchpadModeChanged(_, _, _) end

return RiftController
