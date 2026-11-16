local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")
local CorePackages = game:GetService("CorePackages")
local gameSettings = UserSettings().GameSettings

local Utility = require(RobloxGui.Modules.Settings.Utility)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)
local Theme = require(RobloxGui.Modules.Settings.Theme)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagResponsiveUnitsDeprecateTenFoot = SharedFlags.FFlagResponsiveUnitsDeprecateTenFoot

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local v = TenFootInterface:IsEnabled() and not FFlagResponsiveUnitsDeprecateTenFoot
local AppCommonLib2 = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib2.isSpatial
local localization

if isInExperienceUIVREnabled then
	local LocalizationService = game:GetService("LocalizationService")
	local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
	localization = InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
else
	localization = nil
end

local HelpConstants

if isInExperienceUIVREnabled then
	HelpConstants = require(RobloxGui.Modules.Settings.Resources.HelpConstants)
else
	HelpConstants = nil
end

local function Initialize()
	local SettingsPageFactory = require(RobloxGui.Modules.Settings.SettingsPageFactory)
	local newPage = SettingsPageFactory:CreateNewPage()
	newPage.HelpPages = {}
	newPage.HelpPageContents = {}
	newPage.ActiveHelpScheme = nil

	local v2 = nil

	function newPage:GetCurrentInputType(): string
		if isInExperienceUIVREnabled and isSpatial() then
			return "SpatialGamepad"
		end

		if v2 == nil then
			local platform = UserInputService:GetPlatform()

			if platform == Enum.Platform.XBoxOne or platform == Enum.Platform.WiiU then
				return "Gamepad"
			end

			if platform == Enum.Platform.Windows or platform == Enum.Platform.OSX then
				return "KeyboardMouse"
			end

			return "Touch"
		end

		if
			v2 == Enum.UserInputType.Keyboard
			or v2 == Enum.UserInputType.MouseMovement
			or v2 == Enum.UserInputType.MouseButton1
			or v2 == Enum.UserInputType.MouseButton2
			or v2 == Enum.UserInputType.MouseButton3
			or v2 == Enum.UserInputType.MouseWheel
		then
			return "KeyboardMouse"
		end

		if v2 == Enum.UserInputType.Touch then
			return "Touch"
		end

		if
			v2 == Enum.UserInputType.Gamepad1
			or v2 == Enum.UserInputType.Gamepad2
			or v2 == Enum.UserInputType.Gamepad3
			or v2 == Enum.UserInputType.Gamepad4
		then
			return "Gamepad"
		end

		return "KeyboardMouse"
	end

	local function createPCHelp(parent)
		local function createPCGroup(text, list)
			local pcGroup = Create("Frame")({
				Size = UDim2.new(1 / 3, -4, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Name = "PCGroupFrame" .. tostring(text)
			})

			Create("UIListLayout")({
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 2),
				Parent = pcGroup,
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			local parent2 = Create("TextLabel")({
				Position = UDim2.new(0, 9, 0, 0),
				Size = UDim2.new(1, -9, 0, 30),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Text = text,
				Font = Theme.font(Enum.Font.SourceSansBold, "HelpTitle"),
				FontSize = Theme.fontSize(Enum.FontSize.Size18, "HelpTitle"),
				TextColor3 = Color3.new(1, 1, 1),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				Name = "PCGroupTitle" .. tostring(text),
				ZIndex = 2,
				LayoutOrder = 1,
				Parent = pcGroup
			})

			Create("UIPadding")({ PaddingLeft = UDim.new(0, 9), Parent = parent2 })

			local offset = parent2.Size.Y.Offset
			local count = 0

			for i = 1, #list do
				for k, text2 in pairs(list[i]) do
					local parent3 = Create("Frame")({
						Size = UDim2.new(1, 0, 0, 42),
						Position = UDim2.new(0, 0, 0, offset + count * 44),
						BackgroundTransparency = Theme.transparency("InputActionBackground", 0.65),
						AutomaticSize = Enum.AutomaticSize.Y,
						LayoutOrder = i + 1,
						BorderSizePixel = 0,
						ZIndex = 2,
						Name = "ActionInputBinding" .. tostring(k),
						Parent = pcGroup
					})

					parent3.BackgroundColor3 = Theme.color("InputActionBackground")
					Create("UICorner")({ CornerRadius = UDim.new(0, 3), Parent = parent3 })

					local v3 = Create("TextLabel")({
						Size = UDim2.new(0.4, -9, 0, 42),
						AutomaticSize = Enum.AutomaticSize.Y,
						Position = UDim2.new(0, 9, 0, 0),
						BackgroundTransparency = 1,
						Text = k,
						Font = Theme.font(Enum.Font.SourceSansBold, "HelpTitle"),
						FontSize = Theme.fontSize(Enum.FontSize.Size18, "HelpTitle"),
						TextColor3 = Color3.new(1, 1, 1),
						TextXAlignment = Enum.TextXAlignment.Left,
						Name = k .. "Label",
						ZIndex = 2,
						Parent = parent3,
						TextWrapped = true
					})

					local uiTextSizeConstraint = Instance.new("UITextSizeConstraint", v3)
					uiTextSizeConstraint.MaxTextSize = Theme.textSize(28)

					Create("TextLabel")({
						Size = UDim2.new(0.5, 0, 0, 42),
						Position = UDim2.new(0.5, -4, 0, 0),
						BackgroundTransparency = 1,
						Text = text2,
						Font = Theme.font(Enum.Font.SourceSans, "HelpText"),
						FontSize = Theme.fontSize(Enum.FontSize.Size18, "HelpText"),
						TextColor3 = Color3.new(1, 1, 1),
						TextXAlignment = Enum.TextXAlignment.Left,
						Name = text2 .. "Label",
						ZIndex = 2,
						Parent = parent3,
						TextWrapped = true,
						TextScaled = false,
						AutomaticSize = Enum.AutomaticSize.Y
					})

					count += 1
				end
			end

			pcGroup.Size = UDim2.new(pcGroup.Size.X.Scale, pcGroup.Size.X.Offset, 0, offset + count * 44)

			return pcGroup
		end

		local v3 = UserInputService:GetPlatform() == Enum.Platform.OSX

		local pcGroup = createPCGroup("Character Movement", {
			{
				["Move Forward"] = UserInputService:GetStringForKeyCode(Enum.KeyCode.W) .. "/" .. RobloxTranslator:FormatByKey("InGame.HelpMenu.UpArrow")
			},
			{
				["Move Backward"] = UserInputService:GetStringForKeyCode(Enum.KeyCode.S) .. "/" .. RobloxTranslator:FormatByKey("InGame.HelpMenu.DownArrow")
			},
			{
				["Move Left"] = UserInputService:GetStringForKeyCode(Enum.KeyCode.A) .. "/" .. RobloxTranslator:FormatByKey("InGame.HelpMenu.LeftArrow")
			},
			{
				["Move Right"] = UserInputService:GetStringForKeyCode(Enum.KeyCode.D) .. "/" .. RobloxTranslator:FormatByKey("InGame.HelpMenu.RightArrow")
			},
			{ Jump = "Space" }
		})
		pcGroup.Parent = parent
		pcGroup.LayoutOrder = 1

		local v4 = UserInputService:GetStringForKeyCode(Enum.KeyCode.One) .. "," .. UserInputService:GetStringForKeyCode(Enum.KeyCode.Two) .. "," .. UserInputService:GetStringForKeyCode(Enum.KeyCode.Three) .. "..."
		local pcGroup2 = createPCGroup("Accessories", {
			{ ["Equip Tools"] = v4 },
			{ ["Unequip Tools"] = v4 },
			{ ["Drop Tool"] = "Backspace" },
			{ ["Use Tool"] = "Left Mouse Button" }
		})
		pcGroup2.Position = UDim2.new(1 / 3, 4, 0, 0)
		pcGroup2.Parent = parent
		pcGroup2.LayoutOrder = 2

		local v5 = {}

		table.insert(v5, {
			["UI Selection Toggle"] = UserInputService:GetStringForKeyCode(Enum.KeyCode.BackSlash)
		})

		local v6 = not CachedPolicyService:IsSubjectToChinaPolicies()

		if v6 then
			table.insert(v5, {
				Screenshot = v3 and "Opt + 1" or "Alt + 1"
			})

			if not v3 then
				table.insert(v5, { ["Record Video"] = "F12" })
			end
		end

		if v6 then
			table.insert(v5, {
				["Dev Console"] = v3 and "F9/fn + F9" or "F9"
			})
		end

		table.insert(v5, { Mouselock = "Shift" })

		if v6 then
			table.insert(v5, {
				["Graphics Level"] = v3 and "F10/fn + F10" or "F10"
			})
			table.insert(v5, {
				Fullscreen = v3 and "Ctrl + Cmd + F" or "F11"
			})
		end

		if v6 then
			table.insert(v5, {
				["Perf. Stats"] = v3 and "Fn+Opt+Cmd+F7" or "Ctrl + Shift + F7"
			})
		end

		local pcGroup3 = createPCGroup("Misc", v5)

		pcGroup3.Position = UDim2.new(2 / 3, 8, 0, 0)
		pcGroup3.Parent = parent
		pcGroup3.LayoutOrder = 3

		local pcGroup4 = createPCGroup("Camera Movement", {
			{ Rotate = "Right Mouse Button" },
			{ ["Zoom In/Out"] = "Mouse Wheel" },
			{
				["Zoom In"] = UserInputService:GetStringForKeyCode(Enum.KeyCode.I)
			},
			{
				["Zoom Out"] = UserInputService:GetStringForKeyCode(Enum.KeyCode.O)
			}
		})

		pcGroup4.Position = UDim2.new(0, 0, pcGroup.Size.Y.Scale, pcGroup.Size.Y.Offset + 50)
		pcGroup4.Parent = parent
		pcGroup4.LayoutOrder = 4

		local pcGroup5 = createPCGroup("Menu Items", {
			{ ["Roblox Menu"] = "Esc" },
			{
				Backpack = UserInputService:GetStringForKeyCode(Enum.KeyCode.Backquote)
			},
			{ Playerlist = "Tab" },
			{
				Chat = UserInputService:GetStringForKeyCode(Enum.KeyCode.Slash)
			}
		})
		pcGroup5.Position = UDim2.new(1 / 3, 4, pcGroup.Size.Y.Scale, pcGroup.Size.Y.Offset + 50)
		pcGroup5.Parent = parent
		pcGroup5.LayoutOrder = 5

		parent.Size = UDim2.new(
			parent.Size.X.Scale,
			parent.Size.X.Offset,
			0,
			pcGroup5.Size.Y.Offset + pcGroup5.Position.Y.Offset
		)
	end

	local function createGamepadHelp(parent)
		local v3 = math.max(newPage.Page.AbsoluteSize.X * 0.58, 270)
		local udim = UDim2.new(0, v3, 0, v3 * 0.64)
		local udim2 = UDim2.new(0.5, -udim.X.Offset / 2 + 30, 0.5, -udim.Y.Offset / 2 + 7)

		local parent2 = Create("ImageLabel")({
			Name = "GamepadImage",
			Size = udim,
			Position = udim2,
			Image = "rbxasset://textures/ui/Settings/Help/PlatformController.png",
			BackgroundTransparency = 1,
			ZIndex = 2,
			Parent = parent
		})

		parent.Size = UDim2.new(parent.Size.X.Scale, parent.Size.X.Offset, 0, parent2.Size.Y.Offset + 100)

		local fontSize = v and Theme.fontSize(Enum.FontSize.Size36) or Theme.fontSize(Enum.FontSize.Size24)
		local v4 = fontSize == Theme.fontSize(Enum.FontSize.Size36) and Theme.textSize(36) or Theme.textSize(24)
		local function createGamepadLabel(text, position, size, p)
			local v5 = Create("TextLabel")({
				Position = position,
				Size = size,
				BackgroundTransparency = 1,
				Text = text,
				TextXAlignment = p and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left,
				AnchorPoint = p and Vector2.new(1, 0.5) or Vector2.new(0, 0.5),
				Font = Theme.font(Enum.Font.SourceSansBold, "HelpGamepad"),
				FontSize = fontSize,
				TextColor3 = Color3.new(1, 1, 1),
				Name = text .. "Label",
				ZIndex = 2,
				Parent = parent2,
				TextTruncate = Enum.TextTruncate.AtEnd
			})

			v5.TextWrapped = true

			local x = TextService:GetTextSize(text, v4, Theme.font(Enum.Font.SourceSansBold, "Bold"), Vector2.new(0, 0)).X
			local offset = math.abs(position.X.Offset)
			local parent3 = parent

			local function updateNameLabelSize()
				local v6 = p and parent3.AbsoluteSize.X / 2 + 30 - offset or parent3.AbsoluteSize.X / 2 - 30 - offset

				v5.Size = UDim2.new(v5.Size.X.Scale, v6, v5.Size.Y.Scale, v4 * 2)
				v5.TextScaled = false

				if not (v6 < x) then
					v5.FontSize = fontSize
				end
			end

			parent3:GetPropertyChangedSignal("AbsoluteSize"):connect(function()
				updateNameLabelSize()
			end)

			updateNameLabelSize()
		end

		local v5 = -parent2.Size.X.Offset / 2 - 20
		local v6 = parent2.Size.X.Offset / 2 - 20
		local v7 = v6 + 40

		createGamepadLabel("Switch Tool", UDim2.new(0.5, v5, 0, 15), UDim2.new(0, 100, 0, v4), true)
		createGamepadLabel(
			RobloxTranslator:FormatByKey("InGame.HelpMenu.Controls.ToggleGameMenu"),
			UDim2.new(0.5, v5, 0.15, 10),
			UDim2.new(0, 164, 0, v4),
			true
		)

		createGamepadLabel("Move", UDim2.new(0.5, v5, 0.31, 5), UDim2.new(0, 46, 0, v4), true)
		createGamepadLabel("Menu Navigation", UDim2.new(0.5, v5, 0.46, 0), UDim2.new(0, 164, 0, v4), true)

		createGamepadLabel("Use Tool", UDim2.new(0.5, v6, 0, 15), UDim2.new(0, 73, 0, v4))
		createGamepadLabel("Roblox Menu", UDim2.new(0.5, v6, 0.15, 10), UDim2.new(0, 122, 0, v4))
		createGamepadLabel("Back", UDim2.new(0.5, v6, 0.31, 5), UDim2.new(0, 43, 0, v4))
		createGamepadLabel("Jump", UDim2.new(0.5, v6, 0.46, 0), UDim2.new(0, 49, 0, v4))
		createGamepadLabel("Rotate Camera", UDim2.new(0.5, v7, 0.62, -10), UDim2.new(0, 132, 0, v4))
		createGamepadLabel("Camera Zoom", UDim2.new(0.5, v7, 0.77, -10), UDim2.new(0, 122, 0, v4))
	end

	local function updateTouchLayout(touchMovementMode)
		newPage.ActiveHelpScheme = touchMovementMode
		local isPortrait = Utility:IsPortrait()

		if newPage.HelpPages.Touch then
			local touch = newPage.HelpPageContents.Touch

			local function hideUneeded(p) -- 1 equivalent call inferred from this helper
				if p then
					for k, v3 in pairs(touch) do
						v3.Visible = not p[k]
					end
				end
			end

			local v3

			if
				touchMovementMode == Enum.TouchMovementMode.DynamicThumbstick
				or touchMovementMode == Enum.TouchMovementMode.Default
			then
				touch.MoveLabel.Position = isPortrait
					and UDim2.new(0.25, -touch.MoveLabel.AbsoluteSize.x / 2, 0.75, -50)
					or UDim2.new(0.15, -touch.MoveLabel.AbsoluteSize.x / 2, 0.85, -touch.MoveLabel.AbsoluteSize.y)
				touch.JumpLabel.Position = isPortrait
					and UDim2.new(0.75, -touch.JumpLabel.AbsoluteSize.x / 2, 0.75, -50)
					or UDim2.new(0.85, -60, 0.85, -touch.JumpLabel.AbsoluteSize.y)
				touch.RotateLabel.Position = isPortrait
					and UDim2.new(1, -touch.RotateLabel.AbsoluteSize.x - 20, 0.02, 0)
					or UDim2.new(0.85, -touch.RotateLabel.AbsoluteSize.x / 2, 0.02, 0)
				touch.UseToolLabel.Position = isPortrait
					and UDim2.new(0.5, -touch.UseToolLabel.AbsoluteSize.x / 2, 0.5, -100)
					or UDim2.new(0.5, -touch.UseToolLabel.AbsoluteSize.x / 2, 0.5, -60)

				touch.EquipLabel.Position = isPortrait and UDim2.new(0.5, -60, 0.75, 50) or UDim2.new(0.5, -60, 0.64, 0)
				touch.ZoomLabel.Position = isPortrait and UDim2.new(0, 20, 0.02, 0) or UDim2.new(0.15, -60, 0.02, 0)
				v3 = { MoveImageCTM = true }
			elseif touchMovementMode == Enum.TouchMovementMode.ClickToMove then
				touch.MoveLabel.Position = isPortrait
					and UDim2.new(0.25, -touch.MoveLabel.AbsoluteSize.x / 2, 0.5, 0)
					or UDim2.new(0.25, -touch.MoveLabel.AbsoluteSize.x / 2, 0.5, 40)
				touch.RotateLabel.Position = isPortrait
					and UDim2.new(1, -touch.RotateLabel.AbsoluteSize.x - 20, 0.02, 0)
					or UDim2.new(0.5, -60, 0.02, 0)
				touch.UseToolLabel.Position = isPortrait
					and UDim2.new(0.75, -touch.UseToolLabel.AbsoluteSize.x / 2, 0.5, 0)
					or UDim2.new(0.85, -60, 0.02, 0)

				touch.EquipLabel.Position = isPortrait and UDim2.new(0.5, -60, 0.75, 50) or UDim2.new(0.5, -60, 0.64, 0)
				touch.ZoomLabel.Position = isPortrait and UDim2.new(0, 20, 0.02, 0) or UDim2.new(0.15, -60, 0.02, 0)
				v3 = { MoveImageDTS = true, JumpLabel = true }
			else
				touch.MoveLabel.Position = isPortrait and UDim2.new(0.06, 0, 1, -120) or UDim2.new(0.06, 0, 0.58, 0)
				touch.JumpLabel.Position = isPortrait and UDim2.new(0.94, -touch.JumpLabel.AbsoluteSize.x, 1, -120)
					or UDim2.new(0.8, 0, 0.58, 0)
				touch.RotateLabel.Position = isPortrait
					and UDim2.new(1, -touch.RotateLabel.AbsoluteSize.x - 20, 0.02, 0)
					or UDim2.new(0.5, -60, 0.02, 0)
				touch.UseToolLabel.Position = isPortrait
					and UDim2.new(0.5, -touch.UseToolLabel.AbsoluteSize.x / 2, 0.25, 50)
					or UDim2.new(0.85, -60, 0.02, 0)

				touch.EquipLabel.Position = isPortrait and UDim2.new(0.5, -60, 0.75, 50) or UDim2.new(0.5, -60, 0.64, 0)
				touch.ZoomLabel.Position = isPortrait and UDim2.new(0, 20, 0.02, 0) or UDim2.new(0.15, -60, 0.02, 0)
				v3 = { MoveImageDTS = true, MoveImageCTM = true, JumpImage = true }
			end

			hideUneeded(v3) -- inferred equivalent call
		end
	end

	local function createTouchHelp(parent)
		local touchHelp = {}
		local isSmallTouchScreen = Utility:IsSmallTouchScreen()
		local v3 = GuiService:GetScreenResolution().y - 350

		if isSmallTouchScreen then
			v3 = GuiService:GetScreenResolution().y - 100
		end

		parent.Size = UDim2.new(1, 0, 0, v3)

		local function createTouchLabel(text, position, size, parent2)
			local touchLabel = Create("TextLabel")({
				Position = position,
				Size = size,
				BackgroundTransparency = 1,
				Name = text .. "Frame",
				Parent = parent2
			})

			local v4 = Create("TextLabel")({
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = text,
				Font = Theme.font(Enum.Font.SourceSansBold, "HelpTouch"),
				FontSize = Theme.fontSize(Enum.FontSize.Size14, "HelpTouch"),
				TextColor3 = Color3.new(1, 1, 1),
				Name = text .. "Label",
				ZIndex = 3,
				Parent = touchLabel,
				TextScaled = true,
				TextWrapped = true
			})

			if not isSmallTouchScreen then
				v4.FontSize = Theme.fontSize(Enum.FontSize.Size18, "HelpTitle")
				v4.Size = UDim2.new(v4.Size.X.Scale, v4.Size.X.Offset, v4.Size.Y.Scale, v4.Size.Y.Offset + 4)
			end

			Create("ImageLabel")({
				Name = text .. "BackgroundImage",
				Size = UDim2.new(1.25, 0, 1.25, 0),
				Position = UDim2.new(-0.125, 0, -0.065, 0),
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/Settings/Radial/RadialLabel.png",
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(12, 2, 65, 21),
				ZIndex = 2,
				Parent = touchLabel
			})

			local uiTextSizeConstraint = Instance.new("UITextSizeConstraint", v4)
			uiTextSizeConstraint.MaxTextSize = Theme.textSize(18, "HelpText")

			return touchLabel
		end

		local function createTouchGestureImage(name, image, position, size, parent2) -- 6 equivalent calls inferred from this helper
			return (Create("ImageLabel")({
				Name = name,
				Size = size,
				Position = position,
				BackgroundTransparency = 1,
				Image = image,
				ZIndex = 2,
				Parent = parent2
			}))
		end

		local v4 = isSmallTouchScreen and 0 or 30
		touchHelp.MoveLabel = createTouchLabel(
			"Move",
			UDim2.new(0.06, 0, 0.58, 0),
			UDim2.new(0, v4 + 77, 0, 25),
			parent
		)
		touchHelp.MoveImageDTS = createTouchGestureImage( -- inferred equivalent call
			"MoveImageDTS",
			"rbxasset://textures/ui/Settings/Help/RotateCameraGesture.png",
			UDim2.new(0.5, -32, 1, 3),
			UDim2.new(0, 65, 0, 48),
			touchHelp.MoveLabel
		)
		touchHelp.MoveImageCTM = createTouchGestureImage( -- inferred equivalent call
			"MoveImageCTM",
			"rbxasset://textures/ui/Settings/Help/UseToolGesture.png",
			UDim2.new(0.5, -19, 1, 3),
			UDim2.new(0, 38, 0, 52),
			touchHelp.MoveLabel
		)

		touchHelp.JumpLabel = createTouchLabel("Jump", UDim2.new(0.8, 0, 0.58, 0), UDim2.new(0, v4 + 77, 0, 25), parent)
		touchHelp.JumpImage = createTouchGestureImage( -- inferred equivalent call
			"JumpImage",
			"rbxasset://textures/ui/Settings/Help/UseToolGesture.png",
			UDim2.new(0.5, -19, 1, 3),
			UDim2.new(0, 38, 0, 52),
			touchHelp.JumpLabel
		)

		touchHelp.EquipLabel = createTouchLabel(
			"Equip/Unequip Tools",
			UDim2.new(0.5, -60, 0.64, 0),
			UDim2.new(0, v4 + 120, 0, 25),
			parent
		)

		touchHelp.ZoomLabel = createTouchLabel(
			"Zoom In/Out",
			UDim2.new(0.15, -60, 0.02, 0),
			UDim2.new(0, 120, 0, 25),
			parent
		)
		touchHelp.ZoomImage = createTouchGestureImage( -- inferred equivalent call
			"ZoomImage",
			"rbxasset://textures/ui/Settings/Help/ZoomGesture.png",
			UDim2.new(0.5, -26, 1, 3),
			UDim2.new(0, 53, 0, 59),
			touchHelp.ZoomLabel
		)
		touchHelp.RotateLabel = createTouchLabel(
			"Rotate Camera",
			UDim2.new(0.5, -60, 0.02, 0),
			UDim2.new(0, 120, 0, 25),
			parent
		)
		touchHelp.RotateImage = createTouchGestureImage( -- inferred equivalent call
			"RotateImage",
			"rbxasset://textures/ui/Settings/Help/RotateCameraGesture.png",
			UDim2.new(0.5, -32, 1, 3),
			UDim2.new(0, 65, 0, 48),
			touchHelp.RotateLabel
		)
		touchHelp.UseToolLabel = createTouchLabel(
			"Use Tool",
			UDim2.new(0.85, -60, 0.02, 0),
			UDim2.new(0, 120, 0, 25),
			parent
		)
		touchHelp.ToolImage = createTouchGestureImage( -- inferred equivalent call
			"ToolImage",
			"rbxasset://textures/ui/Settings/Help/UseToolGesture.png",
			UDim2.new(0.5, -19, 1, 3),
			UDim2.new(0, 38, 0, 52),
			touchHelp.UseToolLabel
		)

		return touchHelp
	end

	local function createSpatialGamepadHelp(parent)
		local gamepadQuest = HelpConstants.Images.GamepadQuest
		local questGamepadLabels = HelpConstants.Labels.QuestGamepadLabels

		local image = gamepadQuest.Image
		local heightRatio = gamepadQuest.HeightRatio
		local localizationKeyPrefix = questGamepadLabels.LocalizationKeyPrefix
		local labelRelativeTextHeight = questGamepadLabels.LabelRelativeTextHeight
		local labelsInfo = questGamepadLabels.LabelsInfo

		local parent2 = Create("ImageLabel")({
			Name = "SpatialGamepadImage",
			Size = UDim2.new(1, 0, heightRatio, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			Image = image,
			BackgroundTransparency = 1,
			ZIndex = 2,
			Parent = parent
		})

		local uiPadding = newPage.Page:FindFirstChildOfClass("UIPadding")
		local v3 = not uiPadding and 0 or uiPadding.PaddingLeft.Offset + uiPadding.PaddingRight.Offset
		parent.Size = UDim2.new(
			parent.Size.X.Scale,
			parent.Size.X.Offset,
			0,
			(newPage.Page.AbsoluteSize.X - v3) * heightRatio
		)

		for _, v4 in labelsInfo do
			local formatted = localization:Format(localizationKeyPrefix .. v4.labelKey)

			Create("TextLabel")({
				Name = v4.labelKey,
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(v4.xPosition, v4.yPosition),
				Size = UDim2.fromScale(v4.width, labelRelativeTextHeight),
				Text = formatted,
				TextXAlignment = v4.xAlignment or Enum.TextXAlignment.Right,
				Font = Theme.font(nil, "HelpGamepad"),
				TextColor3 = Theme.color("TextEmphasis"),
				TextTransparency = Theme.transparency("TextEmphasis"),
				ZIndex = 2,
				TextScaled = true,
				Parent = parent2
			})
		end
	end

	local function createHelpDisplay(p)
		local v3 = nil
		local parent = Create("Frame")({
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Name = "HelpFrame" .. tostring(p)
		})

		if p == "KeyboardMouse" then
			Create("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				Wraps = true,
				Parent = parent,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			})
		end

		if p == "KeyboardMouse" then
			createPCHelp(parent)
		elseif p == "Gamepad" then
			createGamepadHelp(parent)
		elseif p == "Touch" then
			v3 = createTouchHelp(parent)
		elseif isInExperienceUIVREnabled and p == "SpatialGamepad" then
			createSpatialGamepadHelp(parent)
		end

		return parent, v3
	end

	local function displayHelp(helpPage)
		for _, helpPage2 in pairs(newPage.HelpPages) do
			if helpPage2 == helpPage then
				helpPage2.Parent = newPage.Page
				newPage.Page.Size = helpPage2.Size

				if v then
					newPage.Page.Size = UDim2.new(
						helpPage2.Size.X.Scale,
						helpPage2.Size.X.Offset,
						helpPage2.Size.Y.Scale,
						0
					)
				end
			else
				helpPage2.Parent = nil
			end
		end

		if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
			newPage.HubRef.PageViewClipper.ClipsDescendants = false
			newPage.HubRef.PageView.ClipsDescendants = false
		end
	end

	local function switchToHelp(currentInputType)
		local helpPage = newPage.HelpPages[currentInputType]

		if helpPage then
			displayHelp(helpPage)

			if currentInputType == "Touch" then
				local touchMovementMode = gameSettings.TouchMovementMode

				if newPage.ActiveHelpScheme ~= touchMovementMode then
					updateTouchLayout(touchMovementMode)
				end
			end
		else
			local helpPages = newPage.HelpPages
			local helpPageContents = newPage.HelpPageContents
			local helpDisplay, v3 = createHelpDisplay(currentInputType)
			helpPages[currentInputType] = helpDisplay
			helpPageContents[currentInputType] = v3
			switchToHelp(currentInputType)
		end
	end

	local function showTypeOfHelp() -- 2 equivalent calls inferred from this helper
		switchToHelp(newPage:GetCurrentInputType())
	end

	function newPage:PageDisplayed()
		if not newPage.LastInputTypeChangedConnection then
			newPage.LastInputTypeChangedConnection = UserInputService.LastInputTypeChanged:Connect(function(p)
				if p ~= Enum.UserInputType.Focus and p ~= Enum.UserInputType.None then
					v2 = p
					showTypeOfHelp() -- inferred equivalent call
				end
			end)
		end

		v2 = UserInputService:GetLastInputType()
		showTypeOfHelp() -- inferred equivalent call
	end

	function newPage:PageHidden()
		if newPage.LastInputTypeChangedConnection then
			newPage.LastInputTypeChangedConnection:Disconnect()
			newPage.LastInputTypeChangedConnection = nil
		end
	end

	local function adjustForScreenLayout(p)
		if newPage:GetCurrentInputType() == "Touch" then
			local touchMovementMode = gameSettings.TouchMovementMode
			local isSmallTouchScreen = Utility:IsSmallTouchScreen()
			local v3 = p or GuiService:GetScreenResolution()
			local v4 = v3.y - 350

			if isSmallTouchScreen then
				v4 = v3.y - 120
			end

			newPage.HelpPages.Touch.Size = UDim2.new(1, 0, 0, v4)
			updateTouchLayout(touchMovementMode)
		end
	end

	newPage.TabHeader.Name = "HelpTab"
	local iconsmenuhelp = uiblox["icons/menu/help"]
	newPage.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[iconsmenuhelp.variant]
	newPage.TabHeader.TabLabel.Icon.Text = iconsmenuhelp.name
	newPage.TabHeader.TabLabel.Title.Text = "Help"

	newPage.Page.Name = "Help"

	Utility:OnResized(newPage, function(p, _)
		if newPage.HelpPages.Touch then
			adjustForScreenLayout(p)
		end
	end)

	return newPage
end

local initialize = Initialize()

initialize.Displayed.Event:connect(function()
	initialize:PageDisplayed()

	if initialize.HubRef.VersionContainer then
		initialize.HubRef.VersionContainer.Visible = true
	end
end)

initialize.Hidden.Event:connect(function()
	initialize:PageHidden()
	initialize.HubRef.PageViewClipper.ClipsDescendants = true
	initialize.HubRef.PageView.ClipsDescendants = true

	initialize.HubRef:ShowShield()

	if initialize.HubRef.VersionContainer then
		initialize.HubRef.VersionContainer.Visible = false
	end
end)

return initialize
