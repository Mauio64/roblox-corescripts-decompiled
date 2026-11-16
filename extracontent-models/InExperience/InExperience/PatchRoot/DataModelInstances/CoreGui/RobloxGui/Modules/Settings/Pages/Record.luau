local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")
local VRService = game:GetService("VRService")

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")
local SocialLuaAnalytics = require(CorePackages.Workspace.Packages.SocialLuaAnalytics)
local Enums = SocialLuaAnalytics.Analytics.Enums
local CapturesInExperience = require(CorePackages.Workspace.Packages.CapturesInExperience)
local EventNames = CapturesInExperience.Analytics.EventNames
local Utility = require(RobloxGui.Modules.Settings.Utility)
local Theme = require(RobloxGui.Modules.Settings.Theme)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox

local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes

local function Initialize()
	local SettingsPageFactory = require(RobloxGui.Modules.Settings.SettingsPageFactory)
	local newPage = SettingsPageFactory:CreateNewPage()
	local v = false

	local recordingEvent = Instance.new("BindableEvent")
	recordingEvent.Name = "RecordingEvent"
	newPage.RecordingChanged = recordingEvent.Event
	function newPage.IsRecording(_)
		return v
	end

	local iconscontrolsscreenrecord = uiblox["icons/controls/screenrecord"]
	newPage.TabHeader.TabLabel.Icon.Text = iconscontrolsscreenrecord.name
	newPage.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[iconscontrolsscreenrecord.variant]
	newPage.TabHeader.Name = "RecordTab"
	newPage.TabHeader.TabLabel.Title.Text = "Record"

	local function onVREnabled() -- 1 equivalent call inferred from this helper
		newPage.TabHeader.Visible = not VRService.VREnabled
	end

	onVREnabled() -- inferred equivalent call
	VRService:GetPropertyChangedSignal("VREnabled"):connect(onVREnabled)

	newPage.Page.Name = "Record"

	local function makeTextLabel(name, text, p, page, layoutOrder)
		local textSize2 = Theme.textSize(24)
		local font = Theme.font(Enum.Font.SourceSans)
		local v2, v3, v4

		if p then
			textSize2 = Theme.textSize(36)
			font = Theme.font(Enum.Font.SourceSansBold, "Bold")
			v2 = 10
			v3 = 0
			v4 = 0
		else
			v2 = 10
			v3 = 0
			v4 = 10
		end

		local parent = Create("Frame")({
			Name = name .. "Container",
			BackgroundTransparency = 1,
			ZIndex = 2,
			LayoutOrder = layoutOrder,
			Parent = page
		})

		local v5 = Create("TextLabel")({
			Name = name,
			BackgroundTransparency = 1,
			Text = text,
			TextWrapped = true,
			Font = font,
			TextSize = textSize2,
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Position = UDim2.new(0, v2, 0, 0),
			Size = UDim2.new(1, -(v2 + v3), 1, 0),
			ZIndex = 2,
			Parent = parent
		})

		local function onResized(p2) -- 1 equivalent call inferred from this helper
			if p2 == "AbsoluteSize" then
				local textSize = TextService:GetTextSize(
					text,
					v5.TextSize,
					v5.Font,
					Vector2.new(page.AbsoluteSize.X - v2 - v3, 10000)
				)
				parent.Size = UDim2.new(1, 0, 0, textSize.Y + v4)
			end
		end

		onResized("AbsoluteSize") -- inferred equivalent call
		page.Changed:connect(onResized)

		return v5, parent
	end

	function newPage.SetHub(_, hubRef)
		newPage.HubRef = hubRef

		local function fn()
			newPage.HubRef:SetVisibility(false, true)
		end

		makeTextLabel("ScreenshotTitle", "Screenshot", true, newPage.Page, 1)
		makeTextLabel(
			"ScreenshotBody",
			"By clicking the 'Take Screenshot' button, the menu will close and take a screenshot and save it to your computer.",
			false,
			newPage.Page,
			2
		)

		local screenshotButtonRow, screenshotButton = Utility:AddButtonRow(
			newPage,
			"ScreenshotButton",
			"Take Screenshot",
			UDim2.new(0, 300, 0, 44),
			fn
		)
		newPage.ScreenshotButtonRow = screenshotButtonRow
		newPage.ScreenshotButton = screenshotButton
		newPage.ScreenshotButtonRow.LayoutOrder = 3

		makeTextLabel("VideoTitle", "Video", true, newPage.Page, 4)
		makeTextLabel(
			"VideoBody",
			"By clicking the 'Record Video' button, the menu will close and start recording your screen.",
			false,
			newPage.Page,
			5
		)

		local v2, v3 = Utility:AddButtonRow(newPage, "RecordButton", "Record Video", UDim2.new(0, 300, 0, 44), fn)
		v2.LayoutOrder = 6
		v3.MouseButton1Click:connect(function()
			local captures = Contexts.Captures
			local buttonClick = EventTypes.ButtonClick
			local btn

			if v then
				btn = EventNames.CapturesLegacyVideoRecordDeactivated
			else
				btn = EventNames.CapturesLegacyVideoRecordActivated
			end

			RbxAnalyticsService:SendEventDeferred("mobile", captures, buttonClick, { btn = btn })

			recordingEvent:Fire(not v)
		end)

		local gameOptions = settings():FindFirstChild("Game Options")

		if gameOptions then
			gameOptions.VideoRecordingChangeRequest:connect(function(p)
				v = p

				if p then
					v3.RecordButtonTextLabel.Text = "Stop Recording"
				else
					v3.RecordButtonTextLabel.Text = "Record Video"
				end
			end)
		end

		v3.Activated:Connect(function()
			CoreGui:ToggleRecording()
		end)
		newPage.ScreenshotButton.Activated:Connect(function()
			CoreGui:TakeScreenshot()
		end)

		newPage.Page.Size = UDim2.new(1, 0, 0, 400)
	end

	return newPage
end

local initialize = Initialize()

initialize.Displayed.Event:connect(function(p)
	if p then
		GuiService.SelectedCoreObject = initialize.ScreenshotButton
	end
end)

return initialize
