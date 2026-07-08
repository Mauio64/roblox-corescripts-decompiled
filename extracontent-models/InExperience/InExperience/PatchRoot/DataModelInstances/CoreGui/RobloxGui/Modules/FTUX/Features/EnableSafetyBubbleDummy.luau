local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CorePackages = game:GetService("CorePackages")
local Workspace = game:GetService("Workspace")
local GenerateDummy = require(script.Parent.Parent.Utility.GenerateDummy)
local CurrentCamera = workspace.CurrentCamera
local FIntSafetyBubbleRadius = require(CorePackages.Workspace.Packages.VrCommon).FIntSafetyBubbleRadius
local v9 = require(CorePackages.Workspace.Packages.VrCommon).FIntSafetyBubbleTransparencyPercent * 0.01
local u10 = true
local v11 = math.max(FIntSafetyBubbleRadius * CurrentCamera.HeadScale, 0.1)
local u12 = nil

function initDummy() -- line: 22
	-- upvalues: u12 (ref), GenerateDummy (copy), Workspace (copy)
	u12 = GenerateDummy(Vector3.new(0, 8.800000190734863, -50.5), (Vector3.new(0, 180, 0)))
	u12.Parent = Workspace
end

local function calculateTransparency(_, p2) -- line: 27
	-- upvalues: VRService (copy), CurrentCamera (copy), u12 (ref), v11 (copy), v9 (copy)
	if not p2 then
		return 0
	end

	local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
	local Magnitude = ((CurrentCamera.CFrame * UserCFrame).Position - u12.HumanoidRootPart.Position).Magnitude
	local v18 = v11 * 0.75

	return (math.clamp(if not (Magnitude < v18) then (1 - (Magnitude - v18) / (v11 - v18)) * v9 else v9, 0, 1))
end

function EnableSafetyBubbleDummy() -- line: 50
	-- upvalues: u12 (ref), UserGameSettings (copy), u10 (ref), calculateTransparency (copy), RunService (copy)
	initDummy()

	local function onStep() -- line: 53
		-- upvalues: u12 (ref), UserGameSettings (copy), u10 (ref), calculateTransparency (copy)
		local children = u12:GetChildren()

		if UserGameSettings.VRSafetyBubbleMode == Enum.VRSafetyBubbleMode.Anyone then
			u10 = false
		else
			u10 = true
		end

		for _, player in ipairs(game.Players:GetPlayers()) do
			if player.Character then
				local v23 = calculateTransparency(player, u10)

				u12.Head.Face.Transparency = v23

				for i = 1, #children do
					if children[i]:IsA("Part") then
						children[i].Transparency = v23
					end
				end
			end
		end
	end

	RunService.Stepped:Connect(onStep)
end

return EnableSafetyBubbleDummy
