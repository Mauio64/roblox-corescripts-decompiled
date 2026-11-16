local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local BuildModeLaunch = require(parent.BuildExperiencePlaytestLaunch.BuildModeLaunch)
local GetLibraryStore = require(BuildExperience.Stores.GetLibraryStore)
local createTeamCreateFreeCamera = require(BuildExperience.createTeamCreateFreeCamera)
local mountChatSheet = require(BuildExperience.mountChatSheet)
local mountLibrary = require(BuildExperience.mountLibrary)

local v = false
local v2 = false

local function mountTeamCreateViewer(p: number, p2)
	if not v then
		v = true
		BuildModeLaunch:applyViewerTheme()
		mountLibrary(nil, BuildModeLaunch:getChatSessionId(p))
	end

	if p2 == nil or v2 then
		return
	end

	v2 = true
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

	local teamCreateFreeCamera = createTeamCreateFreeCamera(workspace.CurrentCamera, p2, GetLibraryStore())
	RunService.RenderStepped:Connect(teamCreateFreeCamera.step)
	mountChatSheet()
end

return mountTeamCreateViewer
