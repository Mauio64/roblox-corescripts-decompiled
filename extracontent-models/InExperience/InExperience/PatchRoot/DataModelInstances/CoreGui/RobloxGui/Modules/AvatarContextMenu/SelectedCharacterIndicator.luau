local class = {}
class.__index = class

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
game:GetService("InsertService")

local CurrentCamera = Workspace.CurrentCamera

local function removeScripts(folder)
	for _, luaSourceContainer in ipairs(folder:GetDescendants()) do
		if luaSourceContainer:IsA("LuaSourceContainer") then
			luaSourceContainer:Destroy()
		end
	end
end

local function ApplyArrow(character, p)
	local contextMenuArrow = Instance.new("Model")
	contextMenuArrow.Name = "ContextMenuArrow"
	contextMenuArrow.Parent = CurrentCamera

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid == nil then
		humanoid = character:WaitForChild("Humanoid", 15)

		if humanoid == nil then
			return
		end
	end

	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	local clone = p.SelectedCharacterIndicator:Clone()
	removeScripts(clone)
	clone.Anchored = true
	clone.Transparency = 0
	clone.CanCollide = false
	clone.Parent = contextMenuArrow

	local tween = TweenService:Create(
		clone,
		TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, false),
		{ Orientation = Vector3.new(0, 360, 180) }
	)

	tween:Play()

	local function update()
		clone.Position = humanoidRootPart.Position + Vector3.new(0, 5, 0)
	end

	local flag = false
	local function kill()
		if flag then
			return
		end

		flag = true
		contextMenuArrow:Destroy()
		tween:Destroy()
		RunService:UnbindFromRenderStep("ContextActionMenuRenderArrow")
	end

	humanoid.Died:Connect(kill)
	character.AncestryChanged:Connect(kill)
	RunService:BindToRenderStep("ContextActionMenuRenderArrow", Enum.RenderPriority.Camera.Value + 1, update)
	contextMenuArrow.Parent = CurrentCamera

	return kill
end

function class:ChangeSelectedPlayer(selectedPlayer, p)
	coroutine.wrap(function()
		if self.SelectedPlayer then
			self.SelectedPlayer = nil
			self.CharacterAddedConn:Disconnect()
			self.CharacterAddedConn = nil

			if self.KillOldRenderFunction then
				self.KillOldRenderFunction()
				self.KillOldRenderFunction = nil
			end
		end

		if selectedPlayer then
			self.SelectedPlayer = selectedPlayer
			self.CharacterAddedConn = selectedPlayer.CharacterAdded:Connect(function(character)
				if self.KillOldRenderFunction then
					self.KillOldRenderFunction()
				end

				self.KillOldRenderFunction = ApplyArrow(character, p)
			end)

			if selectedPlayer.Character then
				self.KillOldRenderFunction = ApplyArrow(selectedPlayer.Character, p)
			end
		end
	end)()
end

function class.new()
	local self = setmetatable({}, class)

	self.KillOldRenderFunction = nil
	self.SelectedPlayer = nil
	self.CharacterAddedConn = nil

	return self
end

return class.new()
