local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CorePackages = game:GetService("CorePackages")

local Workspace = game:GetService("Workspace")

local GenerateDummy = require(script.Parent.Parent.Utility.GenerateDummy)
local CurrentCamera = workspace.CurrentCamera

local VrCommon = require(CorePackages.Workspace.Packages.VrCommon)
local FIntSafetyBubbleRadius = VrCommon.FIntSafetyBubbleRadius
local VrCommon2 = require(CorePackages.Workspace.Packages.VrCommon)
local v = VrCommon2.FIntSafetyBubbleTransparencyPercent * 0.01

local v2 = true

local v3 = math.max(FIntSafetyBubbleRadius * CurrentCamera.HeadScale, 0.1)

local v4 = nil
function initDummy()
	v4 = GenerateDummy(Vector3.new(0, 8.8, -50.5), Vector3.new(0, 180, 0))
	v4.Parent = Workspace
end

local function calculateTransparency(_, p)
	if not p then
		return 0
	end

	local userCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
	local magnitude = ((CurrentCamera.CFrame * userCFrame).Position - v4.HumanoidRootPart.Position).Magnitude

	local v5 = v3 * 0.75
	local v6

	if magnitude < v5 then
		v6 = v
	else
		v6 = (1 - (magnitude - v5) / (v3 - v5)) * v
	end

	return (math.clamp(v6, 0, 1))
end

function EnableSafetyBubbleDummy()
	initDummy()

	local function onStep()
		local children = v4:GetChildren()

		if UserGameSettings.VRSafetyBubbleMode == Enum.VRSafetyBubbleMode.Anyone then
			v2 = false
		else
			v2 = true
		end

		for _, v5 in ipairs(game.Players:GetPlayers()) do
			if not v5.Character then
				continue
			end

			local transparency = calculateTransparency(v5, v2)

			v4.Head.Face.Transparency = transparency

			for i = 1, #children do
				if children[i]:IsA("Part") then
					children[i].Transparency = transparency
				end
			end
		end
	end

	RunService.Stepped:Connect(onStep)
end

return EnableSafetyBubbleDummy
