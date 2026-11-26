local engineFeature = game:GetEngineFeature("OpenXrForWin32")

local create = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/AppCommonLib").Create

local granite = Enum.Material.Granite
local v5 = engineFeature and Vector3.new(3.4, 3.4, 3.4) or Vector3.new(3.6, 3.6, 3.6)
local class = {}
class.__index = class

function class.new(userCFrame)
	local object = setmetatable({}, class)
	object.userCFrame = userCFrame

	object.model = create("Model")({ Name = "IndexController", Archivable = false })

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

	local v6 = create("Part")({
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
		Parent = v6,
		Name = "Mesh",
		MeshId = userCFrame == Enum.UserCFrame.LeftHand and "rbxassetid://9605099531" or "rbxassetid://9605114549",
		TextureId = userCFrame == Enum.UserCFrame.LeftHand and "rbxassetid://9605099774" or "rbxassetid://9605114771",
		Scale = v5
	})
	create("Weld")({ Parent = v6, Name = "Weld", Part0 = object.origin, Part1 = v6 })

	object.parts.body = v6

	object.model.PrimaryPart = object.origin

	return object
end

function class:setCFrame(p3)
	if engineFeature then
		if self.userCFrame == Enum.UserCFrame.RightHand then
			self.model:SetPrimaryPartCFrame(p3 * CFrame.Angles(0.6981317007977318, 3.141592653589793, 0) * CFrame.new(-0.1, 0.08, -0.01))
		else
			self.model:SetPrimaryPartCFrame(p3 * CFrame.Angles(0.6981317007977318, 3.141592653589793, 0) * CFrame.new(0.1, 0.08, -0.01))
		end
	elseif self.userCFrame == Enum.UserCFrame.RightHand then
		self.model:SetPrimaryPartCFrame(p3 * CFrame.Angles(0.3490658503988659, 3.141592653589793, 0) * CFrame.new(-0.1, -0.03, -0.4))
	else
		self.model:SetPrimaryPartCFrame(p3 * CFrame.Angles(0.3490658503988659, 3.141592653589793, 0) * CFrame.new(0.1, -0.03, -0.4))
	end
end

function class:setCFrameAndScale(p2, p3)
	local v6 = self.userCFrame == Enum.UserCFrame.RightHand and 1 or -1

	if engineFeature then
		self.model:SetPrimaryPartCFrame(p2 * CFrame.Angles(0.6981317007977318, 3.141592653589793, 0) * CFrame.new(-0.1 * p3 * v6, 0.08 * p3, -0.01 * p3))
	else
		self.model:SetPrimaryPartCFrame(p2 * CFrame.Angles(0.3490658503988659, 3.141592653589793, 0) * CFrame.new(-0.1 * p3 * v6, -0.03 * p3, -0.4 * p3))
	end

	self.mesh.Scale = v5 * p3
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
