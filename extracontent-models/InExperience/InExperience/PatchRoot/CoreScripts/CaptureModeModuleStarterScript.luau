local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
RobloxGui:WaitForChild("Modules")

local UIBlox = require(CorePackages.Packages.UIBlox)
local CoreScriptsInitializer = require(CorePackages.Workspace.Packages.CoreScriptsInitializer)
local UIBloxInGameConfig = CoreScriptsInitializer.UIBloxInGameConfig
UIBlox.init(UIBloxInGameConfig)

local defineFastFlag = game:DefineFastFlag("FeedbackModuleEarlyFontInitialization", false)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagBuildExperienceInstanceSelection = SharedFlags.FFlagBuildExperienceInstanceSelection
local InstanceSelectionProtocol

if FFlagBuildExperienceInstanceSelection then
	InstanceSelectionProtocol = require(CorePackages.Workspace.Packages.BuildExperience.InstanceSelectionProtocol)
else
	InstanceSelectionProtocol = nil
end

local function isSelectingInstance() -- 2 equivalent calls inferred from this helper
	return FFlagBuildExperienceInstanceSelection and InstanceSelectionProtocol.getActiveRequest() ~= nil
end

if defineFastFlag then
	local TextService = game:GetService("TextService")
	local getTextBoundsParams = Instance.new("GetTextBoundsParams")
	getTextBoundsParams.Text = "random text"
	getTextBoundsParams.Font = Font.fromEnum(Enum.Font.Gotham)
	getTextBoundsParams.Size = 19
	getTextBoundsParams.Width = 0
	TextService:GetTextBoundsAsync(getTextBoundsParams)
end

local MessageBusService = game:GetService("MessageBusService")
local messageId = MessageBusService:GetMessageId("CaptureMode", "sceneSelectionExitReason")

local function handleNativeExit()
	if isSelectingInstance() then -- inferred equivalent call
		InstanceSelectionProtocol.finishSelection({ status = "cancelled" })
		return
	end

	MessageBusService:Publish(messageId, { reason = "nativeExit" })
	local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
	ExperienceStateCaptureService:ToggleCaptureMode()
end

local GuiService = game:GetService("GuiService")
GuiService.NativeClose:Connect(handleNativeExit)

game:WaitForChild("SafetyService")
local SafetyService = game:GetService("SafetyService")

if isSelectingInstance() then -- inferred equivalent call
	local mountInstanceSelection = require(CorePackages.Workspace.Packages.BuildExperience.mountInstanceSelection)
	mountInstanceSelection()
elseif SafetyService.IsCaptureModeForReport then
	local InGameAssetReporting = require(CorePackages.Workspace.Packages.InGameAssetReporting)
	InGameAssetReporting.initialize()
else
	local Feedback = require(RobloxGui.Modules.Feedback)
	Feedback.initialize()
end
