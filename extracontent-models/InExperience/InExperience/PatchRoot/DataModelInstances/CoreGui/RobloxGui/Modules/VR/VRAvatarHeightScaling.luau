local CorePackages = game:GetService("CorePackages")
local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Players = game:GetService("Players")
local AvatarUtil = require(CorePackages.Workspace.Packages.CoreScriptsCommon).AvatarUtil
local t1 = {}

t1.__index = t1

function t1.new() -- line: 13
	-- upvalues: t1 (copy), AvatarUtil (copy), VRService (copy), UserGameSettings (copy)
	local self = setmetatable({}, t1)

	self.avatarUtil = AvatarUtil.new()
	VRService:GetPropertyChangedSignal("AutomaticScaling"):Connect(function() -- line: 17
		-- upvalues: self (copy)
		self:onScalingChanged()
	end)
	UserGameSettings:GetPropertyChangedSignal("PlayerHeight"):Connect(function() -- line: 20
		-- upvalues: self (copy)
		self:onPlayerHeightChanged()
	end)
	VRService.UserCFrameChanged:Connect(function(p1, _) -- line: 23
		-- upvalues: self (copy)
		if p1 == Enum.UserCFrame.Floor then
			self:onPlayerHeightChanged()
		end
	end)
	self:onScalingChanged()

	return self
end
function t1.setHeadScale(p3, p4) -- line: 35
	-- upvalues: VRService (copy), UserGameSettings (copy)
	if VRService.AutomaticScaling ~= Enum.VRScaling.World then
		return
	end

	local SubjectHeight = p3:GetSubjectHeight(p4)

	if not SubjectHeight or SubjectHeight <= 0 then
		return
	end

	local v11 = -VRService:GetUserCFrame(Enum.UserCFrame.Floor).Position.Y
	local v12 = if not (v11 < 0.8 * UserGameSettings.PlayerHeight) then SubjectHeight / v11 else SubjectHeight / UserGameSettings.PlayerHeight
	local CurrentCamera = workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	CurrentCamera.HeadScale = v12
end
function t1.GetSubjectHeight(_, p6) -- line: 64
	local Humanoid = p6:FindFirstChild("Humanoid")

	if Humanoid and Humanoid:GetState() == Enum.HumanoidStateType.Dead then
		return
	end

	local v17 = Humanoid and Humanoid.RootPart or p6:FindFirstChild("HumanoidRootPart")

	if v17 and Humanoid then
		local HipHeight = Humanoid.HipHeight

		if Humanoid.RigType == Enum.HumanoidRigType.R6 then
			HipHeight = 2
		end

		if Humanoid.AutomaticScalingEnabled then
			local v19 = v17.Size.Y / 2 + 0.5

			return v17.Size.Y / 2 + HipHeight + v19 + Humanoid.CameraOffset.Y
		end

		return v17.Size.Y / 2 + HipHeight + 2 + Humanoid.CameraOffset.Y
	end

	return nil
end
function t1.onPlayerHeightChanged(p7) -- line: 93
	-- upvalues: Players (copy)
	if Players.LocalPlayer and Players.LocalPlayer.Character then
		p7:setHeadScale(Players.LocalPlayer.Character)
	end
end
function t1.onScalingChanged(p8) -- line: 100
	-- upvalues: VRService (copy)
	if VRService.AutomaticScaling == Enum.VRScaling.World then
		if not p8.characterChangedConnection then
			p8.characterChangedConnection = p8.avatarUtil:connectLocalCharacterChanges(function(p9) -- line: 104
				-- upvalues: p8 (copy)
				p8:setHeadScale(p9)
			end)

			return
		end
	elseif p8.characterChangedConnection then
		p8.characterChangedConnection:Disconnect()
		p8.characterChangedConnection = nil
	end
end

return t1.new()
