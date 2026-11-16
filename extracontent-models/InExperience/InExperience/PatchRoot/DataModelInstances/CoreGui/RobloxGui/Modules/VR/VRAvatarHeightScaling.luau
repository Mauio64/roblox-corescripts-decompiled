local CorePackages = game:GetService("CorePackages")
local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Players = game:GetService("Players")
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local AvatarUtil = CoreScriptsCommon.AvatarUtil

local class = {}
class.__index = class

function class.new()
	local object = setmetatable({}, class)

	object.avatarUtil = AvatarUtil.new()
	VRService:GetPropertyChangedSignal("AutomaticScaling"):Connect(function()
		object:onScalingChanged()
	end)
	UserGameSettings:GetPropertyChangedSignal("PlayerHeight"):Connect(function()
		object:onPlayerHeightChanged()
	end)
	VRService.UserCFrameChanged:Connect(function(p, _)
		if p == Enum.UserCFrame.Floor then
			object:onPlayerHeightChanged()
		end
	end)

	object:onScalingChanged()
	return object
end

function class:setHeadScale(p)
	if VRService.AutomaticScaling ~= Enum.VRScaling.World then
		return
	end

	local subjectHeight = self:GetSubjectHeight(p)

	if not subjectHeight or subjectHeight <= 0 then
		return
	end

	local v = -VRService:GetUserCFrame(Enum.UserCFrame.Floor).Position.Y
	local headScale

	if v < 0.8 * UserGameSettings.PlayerHeight then
		headScale = subjectHeight / UserGameSettings.PlayerHeight
	else
		headScale = subjectHeight / v
	end

	local currentCamera = workspace.CurrentCamera

	if not currentCamera then
		return
	end

	currentCamera.HeadScale = headScale
end

function class:GetSubjectHeight(instance)
	local humanoid = instance:FindFirstChild("Humanoid")

	if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Dead then
		return
	end

	local rootPart = humanoid and humanoid.RootPart or instance:FindFirstChild("HumanoidRootPart")

	if not (rootPart and humanoid) then
		return nil
	end

	local hipHeight = humanoid.HipHeight

	local v = humanoid.RigType == Enum.HumanoidRigType.R6 and 2 or hipHeight

	if not humanoid.AutomaticScalingEnabled then
		return rootPart.Size.Y / 2 + v + 2 + humanoid.CameraOffset.Y
	end

	local v2 = rootPart.Size.Y / 2 + 0.5
	return rootPart.Size.Y / 2 + v + v2 + humanoid.CameraOffset.Y
end

function class:onPlayerHeightChanged()
	if Players.LocalPlayer and Players.LocalPlayer.Character then
		self:setHeadScale(Players.LocalPlayer.Character)
	end
end

function class:onScalingChanged()
	if VRService.AutomaticScaling == Enum.VRScaling.World then
		if not self.characterChangedConnection then
			self.characterChangedConnection = self.avatarUtil:connectLocalCharacterChanges(function(p)
				self:setHeadScale(p)
			end)
		end
	elseif self.characterChangedConnection then
		self.characterChangedConnection:Disconnect()
		self.characterChangedConnection = nil
	end
end

return class.new()
