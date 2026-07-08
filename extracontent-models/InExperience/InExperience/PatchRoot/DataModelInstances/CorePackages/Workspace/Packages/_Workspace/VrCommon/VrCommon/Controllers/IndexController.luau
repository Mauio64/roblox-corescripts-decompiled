local Parent = script:FindFirstAncestor("VrCommon").Parent
local EngineFeature = game:GetEngineFeature("OpenXrForWin32")
local Create = require(Parent.AppCommonLib).Create
local Granite = Enum.Material.Granite
local v5 = if not EngineFeature then Vector3.new(3.5999999046325684, 3.5999999046325684, 3.5999999046325684) else Vector3.new(3.4000000953674316, 3.4000000953674316, 3.4000000953674316)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 15
	-- upvalues: t1 (copy), Create (copy), Granite (copy), v5 (copy)
	local self = setmetatable({}, t1)

	self.userCFrame = p1
	self.model = Create("Model")({
		Name = "IndexController",
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

	local v9 = Create("Part")({
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
		Parent = v9,
		MeshId = p1 ~= Enum.UserCFrame.LeftHand and "rbxassetid://9605114549" or "rbxassetid://9605099531",
		TextureId = p1 ~= Enum.UserCFrame.LeftHand and "rbxassetid://9605114771" or "rbxassetid://9605099774",
		Scale = v5
	})
	Create("Weld")({
		Name = "Weld",
		Parent = v9,
		Part0 = self.origin,
		Part1 = v9
	})
	self.parts.body = v9
	self.model.PrimaryPart = self.origin

	return self
end
function t1.setCFrame(p2, p3) -- line: 70
	-- upvalues: EngineFeature (copy)
	if EngineFeature then
		if p2.userCFrame == Enum.UserCFrame.RightHand then
			p2.model:SetPrimaryPartCFrame(p3 * CFrame.Angles(0.6981317007977318, 3.141592653589793, 0) * CFrame.new(-0.1, 0.08, -0.01))

			return
		end

		p2.model:SetPrimaryPartCFrame(p3 * CFrame.Angles(0.6981317007977318, 3.141592653589793, 0) * CFrame.new(0.1, 0.08, -0.01))

		return
	end

	if p2.userCFrame == Enum.UserCFrame.RightHand then
		p2.model:SetPrimaryPartCFrame(p3 * CFrame.Angles(0.3490658503988659, 3.141592653589793, 0) * CFrame.new(-0.1, -0.03, -0.4))

		return
	end

	p2.model:SetPrimaryPartCFrame(p3 * CFrame.Angles(0.3490658503988659, 3.141592653589793, 0) * CFrame.new(0.1, -0.03, -0.4))
end
function t1.setCFrameAndScale(p4, p5, p6) -- line: 94
	-- upvalues: EngineFeature (copy), v5 (copy)
	local v15 = p4.userCFrame ~= Enum.UserCFrame.RightHand and -1 or 1

	if EngineFeature then
		p4.model:SetPrimaryPartCFrame(p5 * CFrame.Angles(0.6981317007977318, 3.141592653589793, 0) * CFrame.new(-0.1 * p6 * v15, 0.08 * p6, -0.01 * p6))
	else
		p4.model:SetPrimaryPartCFrame(p5 * CFrame.Angles(0.3490658503988659, 3.141592653589793, 0) * CFrame.new(-0.1 * p6 * v15, -0.03 * p6, -0.4 * p6))
	end

	p4.mesh.Scale = v5 * p6
end
function t1.onButtonInputChanged(_, _, _) -- line: 112
end
function t1.onInputBegan(p10, p11) -- line: 114
	p10:onButtonInputChanged(p11, true)
end
function t1.onInputChanged(_, _) -- line: 118
end
function t1.onInputEnded(p14, p15) -- line: 120
	p14:onButtonInputChanged(p15, false)
end
function t1.onTouchpadModeChanged(_, _, _) -- line: 124
end

return t1
