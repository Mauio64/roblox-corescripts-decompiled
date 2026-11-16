local parent = script:FindFirstAncestor("VrCommon").Parent

local engineFeature = game:GetEngineFeature("OpenXrForWin32")

local AppCommonLib = require(parent.AppCommonLib)
local Create = AppCommonLib.Create

local Granite = Enum.Material.Granite
local scale = engineFeature and Vector3.new(3.4, 3.4, 3.4) or Vector3.new(3.6, 3.6, 3.6)
local IndexController = {}
IndexController.__index = IndexController

function IndexController.new(userCFrame)
	local self = setmetatable({}, IndexController)
	self.userCFrame = userCFrame

	self.model = Create("Model")({ Name = "IndexController", Archivable = false })

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
		MeshId = userCFrame == Enum.UserCFrame.LeftHand and "rbxassetid://9605099531" or "rbxassetid://9605114549",
		TextureId = userCFrame == Enum.UserCFrame.LeftHand and "rbxassetid://9605099774" or "rbxassetid://9605114771",
		Scale = scale
	})
	Create("Weld")({ Parent = v, Name = "Weld", Part0 = self.origin, Part1 = v })

	self.parts.body = v

	self.model.PrimaryPart = self.origin

	return self
end

function IndexController.setCFrame(p, p2)
	if engineFeature then
		if p.userCFrame == Enum.UserCFrame.RightHand then
			p.model:SetPrimaryPartCFrame(p2 * CFrame.Angles(0.6981317007977318, 3.141592653589793, 0) * CFrame.new(-0.1, 0.08, -0.01))
		else
			p.model:SetPrimaryPartCFrame(p2 * CFrame.Angles(0.6981317007977318, 3.141592653589793, 0) * CFrame.new(0.1, 0.08, -0.01))
		end
	elseif p.userCFrame == Enum.UserCFrame.RightHand then
		p.model:SetPrimaryPartCFrame(p2 * CFrame.Angles(0.3490658503988659, 3.141592653589793, 0) * CFrame.new(-0.1, -0.03, -0.4))
	else
		p.model:SetPrimaryPartCFrame(p2 * CFrame.Angles(0.3490658503988659, 3.141592653589793, 0) * CFrame.new(0.1, -0.03, -0.4))
	end
end

function IndexController.setCFrameAndScale(data, p, p2)
	local v = data.userCFrame == Enum.UserCFrame.RightHand and 1 or -1

	if engineFeature then
		data.model:SetPrimaryPartCFrame(p * CFrame.Angles(0.6981317007977318, 3.141592653589793, 0) * CFrame.new(-0.1 * p2 * v, 0.08 * p2, -0.01 * p2))
	else
		data.model:SetPrimaryPartCFrame(p * CFrame.Angles(0.3490658503988659, 3.141592653589793, 0) * CFrame.new(-0.1 * p2 * v, -0.03 * p2, -0.4 * p2))
	end

	data.mesh.Scale = scale * p2
end

function IndexController:onButtonInputChanged(_, _) end

function IndexController:onInputBegan(p)
	self:onButtonInputChanged(p, true)
end

function IndexController.onInputChanged(_, _) end

function IndexController:onInputEnded(p)
	self:onButtonInputChanged(p, false)
end

function IndexController.onTouchpadModeChanged(_, _, _) end

return IndexController
