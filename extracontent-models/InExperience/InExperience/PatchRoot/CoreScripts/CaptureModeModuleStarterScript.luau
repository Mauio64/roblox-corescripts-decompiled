local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

RobloxGui:WaitForChild("Modules")

local UIBlox = require(CorePackages.Packages.UIBlox)
local UIBloxInGameConfig = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).UIBloxInGameConfig

UIBlox.init(UIBloxInGameConfig)

if game:DefineFastFlag("FeedbackModuleEarlyFontInitialization", false) then
	local TextService = game:GetService("TextService")
	local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

	GetTextBoundsParams.Text = "random text"
	GetTextBoundsParams.Font = Font.fromEnum(Enum.Font.Gotham)
	GetTextBoundsParams.Size = 19
	GetTextBoundsParams.Width = 0
	TextService:GetTextBoundsAsync(GetTextBoundsParams)
end

local MessageBusService = game:GetService("MessageBusService")
local MessageId = MessageBusService:GetMessageId("CaptureMode", "sceneSelectionExitReason")

local function handleNativeExit() -- line: 28
	-- upvalues: MessageBusService (copy), MessageId (copy)
	MessageBusService:Publish(MessageId, {
		reason = "nativeExit"
	})
	game:GetService("ExperienceStateCaptureService"):ToggleCaptureMode()
end

game:GetService("GuiService").NativeClose:Connect(handleNativeExit)
game:WaitForChild("SafetyService")

if game:GetService("SafetyService").IsCaptureModeForReport then
	require(CorePackages.Workspace.Packages.InGameAssetReporting).initialize()

	return
end

require(RobloxGui.Modules.Feedback).initialize()
