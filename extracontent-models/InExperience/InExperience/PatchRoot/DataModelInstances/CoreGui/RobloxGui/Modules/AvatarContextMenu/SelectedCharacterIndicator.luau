local t1 = {}

t1.__index = t1

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

game:GetService("InsertService")

local CurrentCamera = Workspace.CurrentCamera

local function removeScripts(p1) -- line: 22
	for _, descendant in ipairs(p1:GetDescendants()) do
		if descendant:IsA("LuaSourceContainer") then
			descendant:Destroy()
		end
	end
end
local function ApplyArrow(p2, p3) -- line: 30
	-- upvalues: CurrentCamera (copy), removeScripts (copy), TweenService (copy), RunService (copy)
	local Model = Instance.new("Model")

	Model.Name = "ContextMenuArrow"
	Model.Parent = CurrentCamera

	local Humanoid = p2:FindFirstChildOfClass("Humanoid")

	if Humanoid == nil then
		Humanoid = p2:WaitForChild("Humanoid", 15)

		if Humanoid == nil then
			return
		end
	end

	local HumanoidRootPart = p2:WaitForChild("HumanoidRootPart")
	local clone = p3.SelectedCharacterIndicator:Clone()

	removeScripts(clone)
	clone.Anchored = true
	clone.Transparency = 0
	clone.CanCollide = false
	clone.Parent = Model

	local tween = TweenService:Create(clone, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, false), {
		Orientation = Vector3.new(0, 360, 180)
	})

	tween:Play()

	local function update() -- line: 59
		-- upvalues: clone (copy), HumanoidRootPart (copy)
		clone.Position = HumanoidRootPart.Position + Vector3.new(0, 5, 0)
	end

	local u19 = false

	local function kill() -- line: 64
		-- upvalues: u19 (ref), Model (copy), tween (copy), RunService (copy)
		if u19 then
			return
		end

		u19 = true
		Model:Destroy()
		tween:Destroy()
		RunService:UnbindFromRenderStep("ContextActionMenuRenderArrow")
	end

	Humanoid.Died:Connect(kill)
	p2.AncestryChanged:Connect(kill)
	RunService:BindToRenderStep("ContextActionMenuRenderArrow", Enum.RenderPriority.Camera.Value + 1, update)
	Model.Parent = CurrentCamera

	return kill
end

function t1.ChangeSelectedPlayer(p4, p5, p6) -- line: 82
	-- upvalues: ApplyArrow (copy)
	coroutine.wrap(function() -- line: 83
		-- upvalues: p4 (copy), p5 (copy), ApplyArrow (copy), p6 (copy)
		if p4.SelectedPlayer then
			p4.SelectedPlayer = nil
			p4.CharacterAddedConn:Disconnect()
			p4.CharacterAddedConn = nil

			if p4.KillOldRenderFunction then
				p4.KillOldRenderFunction()
				p4.KillOldRenderFunction = nil
			end
		end

		if p5 then
			p4.SelectedPlayer = p5
			p4.CharacterAddedConn = p5.CharacterAdded:Connect(function(character) -- line: 96
				-- upvalues: p4 (copy), ApplyArrow (copy), p6 (copy)
				if p4.KillOldRenderFunction then
					p4.KillOldRenderFunction()
				end

				p4.KillOldRenderFunction = ApplyArrow(character, p6)
			end)

			if p5.Character then
				p4.KillOldRenderFunction = ApplyArrow(p5.Character, p6)
			end
		end
	end)()
end
function t1.new() -- line: 109
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self.KillOldRenderFunction = nil
	self.SelectedPlayer = nil
	self.CharacterAddedConn = nil

	return self
end

return t1.new()
