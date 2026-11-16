local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
game:GetService("ContentProvider")

local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local Toast = UIBlox.App.Dialog.Toast
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local renderWithCoreScriptsStyleProvider = require(RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)

local TrackerPromptType = require(RobloxGui.Modules.Tracker.TrackerPromptType)

local defineFastFlag = game:DefineFastFlag("TrackerPromptNewCopyForCameraPerformanceEnabled", false)

local defineFastString = game:DefineFastString(
	"CameraUnavailableUrl",
	"https://help.roblox.com/hc/articles/17877687557396"
)

local extended = Roact.PureComponent:extend("TrackerPrompt")

extended.validateProps = t.strictInterface({ promptType = t.optional(t.string) })

local v = {
	[TrackerPromptType.None] = "",
	[TrackerPromptType.VideoNoPermission] = RobloxTranslator:FormatByKey("Feature.FaceChat.Heading.UnableToAccessCamera"),
	[TrackerPromptType.NotAvailable] = RobloxTranslator:FormatByKey("Feature.FaceChat.Heading.NotAvailable"),
	[TrackerPromptType.FeatureDisabled] = RobloxTranslator:FormatByKey("Feature.FaceChat.Heading.FacialAnimation")
}
local LODCameraRecommendDisable = TrackerPromptType.LODCameraRecommendDisable
local v2

if defineFastFlag then
	v2 = RobloxTranslator:FormatByKey("Feature.FaceChat.Heading.LowPerformanceDetected")
else
	v2 = RobloxTranslator:FormatByKey("Feature.FaceChat.Heading.VideoPerformancePromptDisable")
end

v[LODCameraRecommendDisable] = v2

v[TrackerPromptType.NoDynamicHeadEquipped] = RobloxTranslator:FormatByKey("Feature.FaceChat.Heading.PromptNoDynamicHeadEquipped")

v[TrackerPromptType.VideoUnsupported] = RobloxTranslator:FormatByKey("Feature.FaceChat.Heading.VideoUnsupported")
v[TrackerPromptType.UnsupportedDevice] = RobloxTranslator:FormatByKey("Feature.FaceChat.Heading.NotAvailable")
v[TrackerPromptType.CameraUnavailable] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.CameraUnavailable")

local v3 = {
	[TrackerPromptType.None] = "",
	[TrackerPromptType.VideoNoPermission] = RobloxTranslator:FormatByKey("Feature.FaceChat.Subtitle.UnableToAccessCamera"),
	[TrackerPromptType.NotAvailable] = RobloxTranslator:FormatByKey("Feature.FaceChat.Subtitle.NotAvailable"),
	[TrackerPromptType.FeatureDisabled] = RobloxTranslator:FormatByKey("Feature.FaceChat.Subtitle.FeatureDisabled"),
	[TrackerPromptType.LODCameraRecommendDisable] = RobloxTranslator:FormatByKey("Feature.FaceChat.Subtitle.VideoPerformancePromptDisable"),
	[TrackerPromptType.NoDynamicHeadEquipped] = RobloxTranslator:FormatByKey("Feature.FaceChat.Subtitle.PromptNoDynamicHeadEquipped"),
	[TrackerPromptType.VideoUnsupported] = RobloxTranslator:FormatByKey("Feature.FaceChat.Subtitle.VideoUnsupported"),
	[TrackerPromptType.UnsupportedDevice] = RobloxTranslator:FormatByKey("Feature.FaceChat.Subtitle.UnsupportedDevice"),
	[TrackerPromptType.CameraUnavailable] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.CameraUnavailable")
}

local _ = { FullScreen = 0, FormSheet = 2 }

local function openWebview(url)
	local title

	if game:GetEngineFeature("SetWebViewTitle") then
		title = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.CameraUnavailable")
	end

	GuiService:BroadcastNotification(
		HttpService:JSONEncode({ title = title, presentationStyle = 2, visible = true, url = url }),
		20
	)
end

function extended:init()
	self.promptType = self.props.promptType
end

function extended:render()
	self.promptType = self.props.promptType
	local createElement = Roact.createElement
	local v4 = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }
	local toast

	if self.promptType == TrackerPromptType.None then
		toast = false
	else
		toast = Roact.createElement(Toast, {
			duration = 8,
			toastContent = {
				iconImage = Images["icons/status/alert"],
				toastTitle = v[self.promptType],
				toastSubtitle = v3[self.promptType],
				onDismissed = function() end,
				onActivated = function()
					if self.promptType == TrackerPromptType.CameraUnavailable then
						openWebview(defineFastString)
					end
				end
			}
		})
	end

	local content = renderWithCoreScriptsStyleProvider({
		TrackerPrompt = createElement("Frame", v4, { Toast = toast })
	})

	return Roact.createElement("ScreenGui", {
		AutoLocalize = false,
		DisplayOrder = 10,
		IgnoreGuiInset = true,
		OnTopOfCoreBlur = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, { Content = content })
end

return extended
