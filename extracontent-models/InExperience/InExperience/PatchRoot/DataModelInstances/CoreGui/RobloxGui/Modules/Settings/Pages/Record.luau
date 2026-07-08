local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")
local VRService = game:GetService("VRService")

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")

local Enums = require(CorePackages.Workspace.Packages.SocialLuaAnalytics).Analytics.Enums
local EventNames = require(CorePackages.Workspace.Packages.CapturesInExperience).Analytics.EventNames
local Utility = require(RobloxGui.Modules.Settings.Utility)
local Theme = require(RobloxGui.Modules.Settings.Theme)
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes

local function Initialize() -- line: 37
	-- upvalues: RobloxGui (copy), uiblox (copy), BuilderIcons (copy), VRService (copy), Theme (copy), Create (copy), TextService (copy), Utility (copy), RbxAnalyticsService (copy), Contexts (copy), EventTypes (copy), EventNames (copy), CoreGui (copy)
	local v19 = require(RobloxGui.Modules.Settings.SettingsPageFactory):CreateNewPage()
	local u20 = false
	local BindableEvent = Instance.new("BindableEvent")

	BindableEvent.Name = "RecordingEvent"
	v19.RecordingChanged = BindableEvent.Event

	function v19.IsRecording(_) -- line: 45
		-- upvalues: u20 (ref)
		return u20
	end

	local v22 = uiblox["icons/controls/screenrecord"]

	v19.TabHeader.TabLabel.Icon.Text = v22.name
	v19.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[v22.variant]
	v19.TabHeader.Name = "RecordTab"
	v19.TabHeader.TabLabel.Title.Text = "Record"

	local function onVREnabled() -- line: 55
		-- upvalues: v19 (copy), VRService (copy)
		v19.TabHeader.Visible = not VRService.VREnabled
	end

	v19.TabHeader.Visible = not VRService.VREnabled
	VRService:GetPropertyChangedSignal("VREnabled"):connect(onVREnabled)
	v19.Page.Name = "Record"

	local function makeTextLabel(p2, p3, p4, p5, p6) -- line: 64
		-- upvalues: Theme (copy), Create (copy), TextService (copy)
		local n1 = 10
		local n2 = 0
		local n3 = 10
		local v35 = Theme.textSize(24)
		local v36 = Theme.font(Enum.Font.SourceSans)

		if p4 then
			n1 = 10
			n2 = 0
			n3 = 0
			v35 = Theme.textSize(36)
			v36 = Theme.font(Enum.Font.SourceSansBold, "Bold")
		end

		local v37 = Create("Frame")({
			BackgroundTransparency = 1,
			ZIndex = 2,
			Name = p2 .. "Container",
			LayoutOrder = p6,
			Parent = p5
		})
		local v38 = Create("TextLabel")({
			BackgroundTransparency = 1,
			TextWrapped = true,
			ZIndex = 2,
			Name = p2,
			Text = p3,
			Font = v36,
			TextSize = v35,
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Position = UDim2.new(0, n1, 0, 0),
			Size = UDim2.new(1, -(n1 + n2), 1, 0),
			Parent = v37
		})

		local function onResized(p7) -- line: 96
			-- upvalues: TextService (copy), p3 (copy), v38 (copy), p5 (copy), n1 (ref), n2 (ref), v37 (copy), n3 (ref)
			if p7 == "AbsoluteSize" then
				local TextSize = TextService:GetTextSize(p3, v38.TextSize, v38.Font, Vector2.new(p5.AbsoluteSize.X - n1 - n2, 10000))

				v37.Size = UDim2.new(1, 0, 0, TextSize.Y + n3)
			end
		end

		local TextSize = TextService:GetTextSize(p3, v38.TextSize, v38.Font, Vector2.new(p5.AbsoluteSize.X - n1 - n2, 10000))

		v37.Size = UDim2.new(1, 0, 0, TextSize.Y + n3)
		p5.Changed:connect(onResized)

		return v38, v37
	end

	function v19.SetHub(_, p9) -- line: 110
		-- upvalues: v19 (copy), makeTextLabel (copy), Utility (copy), RbxAnalyticsService (copy), Contexts (copy), EventTypes (copy), u20 (ref), EventNames (copy), BindableEvent (copy), CoreGui (copy)
		v19.HubRef = p9

		local function v43() -- line: 114
			-- upvalues: v19 (copy)
			v19.HubRef:SetVisibility(false, true)
		end

		makeTextLabel("ScreenshotTitle", "Screenshot", true, v19.Page, 1)
		makeTextLabel("ScreenshotBody", "By clicking the 'Take Screenshot' button, the menu will close and take a screenshot and save it to your computer.", false, v19.Page, 2)

		local v44 = v19
		local v45 = v19
		local v46, v47 = Utility:AddButtonRow(v19, "ScreenshotButton", "Take Screenshot", UDim2.new(0, 300, 0, 44), v43)

		v44.ScreenshotButtonRow = v46
		v45.ScreenshotButton = v47
		v19.ScreenshotButtonRow.LayoutOrder = 3
		makeTextLabel("VideoTitle", "Video", true, v19.Page, 4)
		makeTextLabel("VideoBody", "By clicking the 'Record Video' button, the menu will close and start recording your screen.", false, v19.Page, 5)

		local v48, v49 = Utility:AddButtonRow(v19, "RecordButton", "Record Video", UDim2.new(0, 300, 0, 44), v43)

		v48.LayoutOrder = 6
		v49.MouseButton1Click:connect(function() -- line: 130
			-- upvalues: RbxAnalyticsService (copy), Contexts (copy), EventTypes (copy), u20 (ref), EventNames (copy), BindableEvent (copy)
			RbxAnalyticsService:SendEventDeferred("mobile", Contexts.Captures, EventTypes.ButtonClick, {
				btn = if u20 then EventNames.CapturesLegacyVideoRecordDeactivated else EventNames.CapturesLegacyVideoRecordActivated
			})
			BindableEvent:Fire(not u20)
		end)

		local v50 = settings():FindFirstChild("Game Options")

		if v50 then
			v50.VideoRecordingChangeRequest:connect(function(p10) -- line: 142
				-- upvalues: u20 (ref), v49 (copy)
				u20 = p10

				if p10 then
					v49.RecordButtonTextLabel.Text = "Stop Recording"

					return
				end

				v49.RecordButtonTextLabel.Text = "Record Video"
			end)
		end

		v49.Activated:Connect(function() -- line: 152
			-- upvalues: CoreGui (copy)
			CoreGui:ToggleRecording()
		end)
		v19.ScreenshotButton.Activated:Connect(function() -- line: 155
			-- upvalues: CoreGui (copy)
			CoreGui:TakeScreenshot()
		end)
		v19.Page.Size = UDim2.new(1, 0, 0, 400)
	end

	return v19
end

local u18 = Initialize()

u18.Displayed.Event:connect(function(p11) -- line: 169
	-- upvalues: GuiService (copy), u18 (ref)
	if p11 then
		GuiService.SelectedCoreObject = u18.ScreenshotButton
	end
end)

return u18
