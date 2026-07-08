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
local v14 = game:DefineFastFlag("TrackerPromptNewCopyForCameraPerformanceEnabled", false)
local v15 = game:DefineFastString("CameraUnavailableUrl", "https://help.roblox.com/hc/articles/17877687557396")
local v16 = Roact.PureComponent:extend("TrackerPrompt")

v16.validateProps = t.strictInterface({
	promptType = t.optional(t.string)
})

local t1 = {
	[TrackerPromptType.None] = "",
	[TrackerPromptType.VideoNoPermission] = RobloxTranslator:FormatByKey("Feature.FaceChat.Heading.UnableToAccessCamera"),
	[TrackerPromptType.NotAvailable] = RobloxTranslator:FormatByKey("Feature.FaceChat.Heading.NotAvailable"),
	[TrackerPromptType.FeatureDisabled] = RobloxTranslator:FormatByKey("Feature.FaceChat.Heading.FacialAnimation"),
	[TrackerPromptType.LODCameraRecommendDisable] = if not v14 then RobloxTranslator:FormatByKey("Feature.FaceChat.Heading.VideoPerformancePromptDisable") else RobloxTranslator:FormatByKey("Feature.FaceChat.Heading.LowPerformanceDetected"),
	[TrackerPromptType.NoDynamicHeadEquipped] = RobloxTranslator:FormatByKey("Feature.FaceChat.Heading.PromptNoDynamicHeadEquipped"),
	[TrackerPromptType.VideoUnsupported] = RobloxTranslator:FormatByKey("Feature.FaceChat.Heading.VideoUnsupported"),
	[TrackerPromptType.UnsupportedDevice] = RobloxTranslator:FormatByKey("Feature.FaceChat.Heading.NotAvailable"),
	[TrackerPromptType.CameraUnavailable] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.CameraUnavailable")
}
local t2 = {
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
local _ = {
	FullScreen = 0,
	FormSheet = 2
}

local function openWebview(p1) -- line: 77
	-- upvalues: HttpService (copy), RobloxTranslator (copy), GuiService (copy)
	local json = HttpService:JSONEncode({
		presentationStyle = 2,
		visible = true,
		title = if not game:GetEngineFeature("SetWebViewTitle") then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.CameraUnavailable"),
		url = p1
	})

	GuiService:BroadcastNotification(json, 20)
end

function v16.init(p2) -- line: 90
	p2.promptType = p2.props.promptType
end
function v16.render(p3) -- line: 94
	-- upvalues: Roact (copy), TrackerPromptType (copy), Toast (copy), Images (copy), t1 (copy), t2 (copy), openWebview (copy), v15 (copy), renderWithCoreScriptsStyleProvider (copy)
	p3.promptType = p3.props.promptType

	local v25 = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, {
		Toast = p3.promptType ~= TrackerPromptType.None and Roact.createElement(Toast, {
			duration = 8,
			toastContent = {
				iconImage = Images["icons/status/alert"],
				toastTitle = t1[p3.promptType],
				toastSubtitle = t2[p3.promptType],
				onDismissed = function() -- line: 106
				end,
				onActivated = function() -- line: 107
					-- upvalues: p3 (copy), TrackerPromptType (copy), openWebview (copy), v15 (copy)
					if p3.promptType == TrackerPromptType.CameraUnavailable then
						openWebview(v15)
					end
				end
			}
		})
	})
	local v26 = renderWithCoreScriptsStyleProvider({
		TrackerPrompt = v25
	})

	return Roact.createElement("ScreenGui", {
		AutoLocalize = false,
		DisplayOrder = 10,
		IgnoreGuiInset = true,
		OnTopOfCoreBlur = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		Content = v26
	})
end

return v16
