local Parent = script:FindFirstAncestor("VrCommon").Parent
local Create = require(Parent.AppCommonLib).Create
local Granite = Enum.Material.Granite
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 13
	-- upvalues: t1 (copy), Create (copy), Granite (copy)
	local self = setmetatable({}, t1)

	self.userCFrame = p1
	self.model = Create("Model")({
		Name = "RiftController",
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
	self.parts = {}

	local v7 = Create("Part")({
		Name = "body",
		Anchored = true,
		Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806),
		Transparency = 0.25,
		CanCollide = false,
		CanQuery = false,
		CanTouch = false,
		Parent = self.model,
		Material = Granite,
		CFrame = self.origin.CFrame
	})

	self.mesh = Create("SpecialMesh")({
		Name = "Mesh",
		TextureId = "rbxassetid://9597123835",
		Scale = Vector3.new(0.03200000151991844, 0.03200000151991844, 0.03200000151991844),
		Parent = v7,
		MeshId = p1 ~= Enum.UserCFrame.LeftHand and "rbxassetid://9597101144" or "rbxassetid://9597097835"
	})
	Create("Weld")({
		Name = "Weld",
		Parent = v7,
		Part0 = self.origin,
		Part1 = v7
	})
	self.parts.body = v7
	self.model.PrimaryPart = self.origin

	return self
end
function t1.setCFrame(p2, p3) -- line: 68
	p2.model:SetPrimaryPartCFrame(p3 * CFrame.Angles(0.3490658503988659, 0, 0) * CFrame.new(0, -0.03, 0.06))
end
function t1.setCFrameAndScale(p4, p5, p6) -- line: 72
	p4.model:SetPrimaryPartCFrame(p5 * CFrame.Angles(0.3490658503988659, 0, 0) * CFrame.new(0, -0.03 * p6, 0.06 * p6))
	p4.mesh.Scale = Vector3.new(0.03200000151991844, 0.03200000151991844, 0.03200000151991844) * p6
end
function t1.onButtonInputChanged(_, _, _) -- line: 79
end
function t1.onInputBegan(p10, p11) -- line: 81
	p10:onButtonInputChanged(p11, true)
end
function t1.onInputChanged(_, _) -- line: 85
end
function t1.onInputEnded(p14, p15) -- line: 87
	p14:onButtonInputChanged(p15, false)
end
function t1.onTouchpadModeChanged(_, _, _) -- line: 91
end

return t1
