local create = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/AppCommonLib").Create

local granite = Enum.Material.Granite

local class = {}
class.__index = class

function class.new(userCFrame)
	local object = setmetatable({}, class)
	object.userCFrame = userCFrame

	object.model = create("Model")({ Name = "RiftController", Archivable = false })

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

	object.parts = {}

	local v5 = create("Part")({
		Parent = object.model,
		Name = "body",
		Anchored = true,
		Material = granite,
		Size = Vector3.new(0.05, 0.05, 0.05),
		Transparency = 0.25,
		CFrame = object.origin.CFrame,
		CanCollide = false,
		CanQuery = false,
		CanTouch = false
	})

	object.mesh = create("SpecialMesh")({
		Parent = v5,
		Name = "Mesh",
		MeshId = userCFrame == Enum.UserCFrame.LeftHand and "rbxassetid://9597097835" or "rbxassetid://9597101144",
		TextureId = "rbxassetid://9597123835",
		Scale = Vector3.new(0.032, 0.032, 0.032)
	})
	create("Weld")({ Parent = v5, Name = "Weld", Part0 = object.origin, Part1 = v5 })

	object.parts.body = v5

	object.model.PrimaryPart = object.origin

	return object
end

function class:setCFrame(p3)
	self.model:SetPrimaryPartCFrame(p3 * CFrame.Angles(0.3490658503988659, 0, 0) * CFrame.new(0, -0.03, 0.06))
end

function class:setCFrameAndScale(p3, p4)
	self.model:SetPrimaryPartCFrame(p3 * CFrame.Angles(0.3490658503988659, 0, 0) * CFrame.new(0, -0.03 * p4, 0.06 * p4))

	self.mesh.Scale = Vector3.new(0.032, 0.032, 0.032) * p4
end

function class:onButtonInputChanged(p3, p4) end

function class:onInputBegan(p2)
	self:onButtonInputChanged(p2, true)
end

function class:onInputChanged(p3) end

function class:onInputEnded(p2)
	self:onButtonInputChanged(p2, false)
end

function class:onTouchpadModeChanged(p3, p4) end

return class
