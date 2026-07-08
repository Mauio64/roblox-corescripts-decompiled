local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")
local CorePackages = game:GetService("CorePackages")
local GameSettings = UserSettings().GameSettings
local Utility = require(RobloxGui.Modules.Settings.Utility)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)
local Theme = require(RobloxGui.Modules.Settings.Theme)
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")

local v14 = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local u17 = nil

if isInExperienceUIVREnabled then
	local LocalizationService = game:GetService("LocalizationService")

	u17 = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization.new(LocalizationService.RobloxLocaleId)
end

local v19 = if not isInExperienceUIVREnabled then nil else require(RobloxGui.Modules.Settings.Resources.HelpConstants)

local function Initialize() -- line: 66
	-- upvalues: RobloxGui (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), UserInputService (copy), Create (copy), Theme (copy), RobloxTranslator (copy), CachedPolicyService (copy), v14 (copy), TextService (copy), Utility (copy), GuiService (copy), v19 (copy), u17 (ref), GameSettings (copy), uiblox (copy), BuilderIcons (copy)
	local v22 = require(RobloxGui.Modules.Settings.SettingsPageFactory):CreateNewPage()

	v22.HelpPages = {}
	v22.HelpPageContents = {}
	v22.ActiveHelpScheme = nil

	local u23 = nil

	function v22.GetCurrentInputType(_) -- line: 75
		-- upvalues: isInExperienceUIVREnabled (copy), isSpatial (copy), u23 (ref), UserInputService (copy)
		if isInExperienceUIVREnabled and isSpatial() then
			return "SpatialGamepad"
		end

		if u23 == nil then
			local Platform = UserInputService:GetPlatform()

			if Platform == Enum.Platform.XBoxOne or Platform == Enum.Platform.WiiU then
				return "Gamepad"
			end

			if Platform == Enum.Platform.Windows or Platform == Enum.Platform.OSX then
				return "KeyboardMouse"
			end

			return "Touch"
		end

		if u23 == Enum.UserInputType.Keyboard or u23 == Enum.UserInputType.MouseMovement or u23 == Enum.UserInputType.MouseButton1 or u23 == Enum.UserInputType.MouseButton2 or u23 == Enum.UserInputType.MouseButton3 or u23 == Enum.UserInputType.MouseWheel then
			return "KeyboardMouse"
		end

		if u23 == Enum.UserInputType.Touch then
			return "Touch"
		end

		if u23 == Enum.UserInputType.Gamepad1 or u23 == Enum.UserInputType.Gamepad2 or u23 == Enum.UserInputType.Gamepad3 or u23 == Enum.UserInputType.Gamepad4 then
			return "Gamepad"
		end

		return "KeyboardMouse"
	end

	local function createPCHelp(p2) -- line: 107
		-- upvalues: Create (copy), Theme (copy), UserInputService (copy), RobloxTranslator (copy), CachedPolicyService (copy)
		local function createPCGroup(p3, p4) -- line: 108
			-- upvalues: Create (copy), Theme (copy)
			local v130 = Create("Frame")({
				BackgroundTransparency = 1,
				Size = UDim2.new(0.3333333333333333, -4, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Name = "PCGroupFrame" .. tostring(p3)
			})

			Create("UIListLayout")({
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 2),
				Parent = v130,
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			local v131 = Create("TextLabel")({
				BackgroundTransparency = 1,
				TextWrapped = true,
				ZIndex = 2,
				LayoutOrder = 1,
				Position = UDim2.new(0, 9, 0, 0),
				Size = UDim2.new(1, -9, 0, 30),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = p3,
				Font = Theme.font(Enum.Font.SourceSansBold, "HelpTitle"),
				FontSize = Theme.fontSize(Enum.FontSize.Size18, "HelpTitle"),
				TextColor3 = Color3.new(1, 1, 1),
				TextXAlignment = Enum.TextXAlignment.Left,
				Name = "PCGroupTitle" .. tostring(p3),
				Parent = v130
			})

			Create("UIPadding")({
				PaddingLeft = UDim.new(0, 9),
				Parent = v131
			})

			local n1 = 0
			local YOffset = v131.Size.Y.Offset

			for i = 1, #p4 do
				for k, v in pairs(p4[i]) do
					local v137 = Create("Frame")({
						BorderSizePixel = 0,
						ZIndex = 2,
						Size = UDim2.new(1, 0, 0, 42),
						Position = UDim2.new(0, 0, 0, YOffset + n1 * 44),
						BackgroundTransparency = Theme.transparency("InputActionBackground", 0.65),
						AutomaticSize = Enum.AutomaticSize.Y,
						LayoutOrder = i + 1,
						Name = "ActionInputBinding" .. tostring(k),
						Parent = v130
					})

					v137.BackgroundColor3 = Theme.color("InputActionBackground")
					Create("UICorner")({
						CornerRadius = UDim.new(0, 3),
						Parent = v137
					})

					local v138 = Create("TextLabel")({
						BackgroundTransparency = 1,
						ZIndex = 2,
						TextWrapped = true,
						Size = UDim2.new(0.4, -9, 0, 42),
						AutomaticSize = Enum.AutomaticSize.Y,
						Position = UDim2.new(0, 9, 0, 0),
						Text = k,
						Font = Theme.font(Enum.Font.SourceSansBold, "HelpTitle"),
						FontSize = Theme.fontSize(Enum.FontSize.Size18, "HelpTitle"),
						TextColor3 = Color3.new(1, 1, 1),
						TextXAlignment = Enum.TextXAlignment.Left,
						Name = k .. "Label",
						Parent = v137
					})

					Instance.new("UITextSizeConstraint", v138).MaxTextSize = Theme.textSize(28)
					Create("TextLabel")({
						BackgroundTransparency = 1,
						ZIndex = 2,
						TextWrapped = true,
						TextScaled = false,
						Size = UDim2.new(0.5, 0, 0, 42),
						Position = UDim2.new(0.5, -4, 0, 0),
						Text = v,
						Font = Theme.font(Enum.Font.SourceSans, "HelpText"),
						FontSize = Theme.fontSize(Enum.FontSize.Size18, "HelpText"),
						TextColor3 = Color3.new(1, 1, 1),
						TextXAlignment = Enum.TextXAlignment.Left,
						Name = v .. "Label",
						Parent = v137,
						AutomaticSize = Enum.AutomaticSize.Y
					})
					n1 += 1
				end
			end

			v130.Size = UDim2.new(v130.Size.X.Scale, v130.Size.X.Offset, 0, YOffset + n1 * 44)

			return v130
		end

		local v39 = UserInputService:GetPlatform() == Enum.Platform.OSX
		local v40 = createPCGroup("Character Movement", {
			[1] = {
				["Move Forward"] = UserInputService:GetStringForKeyCode(Enum.KeyCode.W) .. "/" .. RobloxTranslator:FormatByKey("InGame.HelpMenu.UpArrow")
			},
			[2] = {
				["Move Backward"] = UserInputService:GetStringForKeyCode(Enum.KeyCode.S) .. "/" .. RobloxTranslator:FormatByKey("InGame.HelpMenu.DownArrow")
			},
			[3] = {
				["Move Left"] = UserInputService:GetStringForKeyCode(Enum.KeyCode.A) .. "/" .. RobloxTranslator:FormatByKey("InGame.HelpMenu.LeftArrow")
			},
			[4] = {
				["Move Right"] = UserInputService:GetStringForKeyCode(Enum.KeyCode.D) .. "/" .. RobloxTranslator:FormatByKey("InGame.HelpMenu.RightArrow")
			},
			[5] = {
				Jump = "Space"
			}
		})

		v40.Parent = p2
		v40.LayoutOrder = 1

		local v41 = UserInputService:GetStringForKeyCode(Enum.KeyCode.One) .. "," .. UserInputService:GetStringForKeyCode(Enum.KeyCode.Two) .. "," .. UserInputService:GetStringForKeyCode(Enum.KeyCode.Three) .. "..."
		local v42 = createPCGroup("Accessories", {
			[1] = {
				["Equip Tools"] = v41
			},
			[2] = {
				["Unequip Tools"] = v41
			},
			[3] = {
				["Drop Tool"] = "Backspace"
			},
			[4] = {
				["Use Tool"] = "Left Mouse Button"
			}
		})

		v42.Position = UDim2.new(0.3333333333333333, 4, 0, 0)
		v42.Parent = p2
		v42.LayoutOrder = 2

		local t1 = {}

		table.insert(t1, {
			["UI Selection Toggle"] = UserInputService:GetStringForKeyCode(Enum.KeyCode.BackSlash)
		})

		local v44 = not CachedPolicyService:IsSubjectToChinaPolicies()

		if v44 then
			table.insert(t1, {
				Screenshot = not v39 and "Alt + 1" or "Opt + 1"
			})

			if not v39 then
				table.insert(t1, {
					["Record Video"] = "F12"
				})
			end
		end

		if v44 then
			table.insert(t1, {
				["Dev Console"] = not v39 and "F9" or "F9/fn + F9"
			})
		end

		table.insert(t1, {
			Mouselock = "Shift"
		})

		if v44 then
			table.insert(t1, {
				["Graphics Level"] = not v39 and "F10" or "F10/fn + F10"
			})
			table.insert(t1, {
				Fullscreen = not v39 and "F11" or "Ctrl + Cmd + F"
			})
		end

		if v44 then
			table.insert(t1, {
				["Perf. Stats"] = not v39 and "Ctrl + Shift + F7" or "Fn+Opt+Cmd+F7"
			})
		end

		local v45 = createPCGroup("Misc", t1)

		v45.Position = UDim2.new(0.6666666666666666, 8, 0, 0)
		v45.Parent = p2
		v45.LayoutOrder = 3

		local v46 = createPCGroup("Camera Movement", {
			[1] = {
				Rotate = "Right Mouse Button"
			},
			[2] = {
				["Zoom In/Out"] = "Mouse Wheel"
			},
			[3] = {
				["Zoom In"] = UserInputService:GetStringForKeyCode(Enum.KeyCode.I)
			},
			[4] = {
				["Zoom Out"] = UserInputService:GetStringForKeyCode(Enum.KeyCode.O)
			}
		})

		v46.Position = UDim2.new(0, 0, v40.Size.Y.Scale, v40.Size.Y.Offset + 50)
		v46.Parent = p2
		v46.LayoutOrder = 4

		local v47 = createPCGroup("Menu Items", {
			[1] = {
				["Roblox Menu"] = "Esc"
			},
			[2] = {
				Backpack = UserInputService:GetStringForKeyCode(Enum.KeyCode.Backquote)
			},
			[3] = {
				Playerlist = "Tab"
			},
			[4] = {
				Chat = UserInputService:GetStringForKeyCode(Enum.KeyCode.Slash)
			}
		})

		v47.Position = UDim2.new(0.3333333333333333, 4, v40.Size.Y.Scale, v40.Size.Y.Offset + 50)
		v47.Parent = p2
		v47.LayoutOrder = 5
		p2.Size = UDim2.new(p2.Size.X.Scale, p2.Size.X.Offset, 0, v47.Size.Y.Offset + v47.Position.Y.Offset)
	end
	local function createGamepadHelp(p5) -- line: 312
		-- upvalues: v22 (copy), Create (copy), v14 (copy), Theme (copy), TextService (copy), RobloxTranslator (copy)
		local v49 = math.max(v22.Page.AbsoluteSize.X * 0.58, 270)
		local uDim2 = UDim2.new(0, v49, 0, v49 * 0.64)
		local uDim2_2 = UDim2.new(0.5, -uDim2.X.Offset / 2 + 30, 0.5, -uDim2.Y.Offset / 2 + 7)
		local v52 = Create("ImageLabel")({
			Name = "GamepadImage",
			Image = "rbxasset://textures/ui/Settings/Help/PlatformController.png",
			BackgroundTransparency = 1,
			ZIndex = 2,
			Size = uDim2,
			Position = uDim2_2,
			Parent = p5
		})

		p5.Size = UDim2.new(p5.Size.X.Scale, p5.Size.X.Offset, 0, v52.Size.Y.Offset + 100)

		local v53 = v14 and Theme.fontSize(Enum.FontSize.Size36) or Theme.fontSize(Enum.FontSize.Size24)
		local v54 = v53 == Theme.fontSize(Enum.FontSize.Size36) and Theme.textSize(36) or Theme.textSize(24)

		local function createGamepadLabel(p6, p7, p8, p9) -- line: 332
			-- upvalues: Create (copy), Theme (copy), v53 (copy), v52 (copy), TextService (copy), v54 (copy), p5 (copy)
			local v143 = Create("TextLabel")({
				BackgroundTransparency = 1,
				ZIndex = 2,
				Position = p7,
				Size = p8,
				Text = p6,
				TextXAlignment = p9 and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left,
				AnchorPoint = p9 and Vector2.new(1, 0.5) or Vector2.new(0, 0.5),
				Font = Theme.font(Enum.Font.SourceSansBold, "HelpGamepad"),
				FontSize = v53,
				TextColor3 = Color3.new(1, 1, 1),
				Name = p6 .. "Label",
				Parent = v52,
				TextTruncate = Enum.TextTruncate.AtEnd
			})

			v143.TextWrapped = true

			local X = TextService:GetTextSize(p6, v54, Theme.font(Enum.Font.SourceSansBold, "Bold"), Vector2.new(0, 0)).X
			local v145 = math.abs(p7.X.Offset)
			local v146 = p5

			local function updateNameLabelSize() -- line: 356
				-- upvalues: p9 (copy), v146 (copy), v145 (copy), v143 (copy), v54 (copy), X (copy), v53 (copy)
				local v163 = p9 and v146.AbsoluteSize.X / 2 + 30 - v145 or v146.AbsoluteSize.X / 2 - 30 - v145

				v143.Size = UDim2.new(v143.Size.X.Scale, v163, v143.Size.Y.Scale, v54 * 2)
				v143.TextScaled = false

				if not (v163 < X) then
					v143.FontSize = v53
				end
			end

			v146:GetPropertyChangedSignal("AbsoluteSize"):connect(function() -- line: 369
				-- upvalues: updateNameLabelSize (copy)
				updateNameLabelSize()
			end)
			updateNameLabelSize()
		end

		local v56 = -v52.Size.X.Offset / 2 - 20
		local v57 = v52.Size.X.Offset / 2 - 20
		local v58 = v57 + 40

		createGamepadLabel("Switch Tool", UDim2.new(0.5, v56, 0, 15), UDim2.new(0, 100, 0, v54), true)
		createGamepadLabel(RobloxTranslator:FormatByKey("InGame.HelpMenu.Controls.ToggleGameMenu"), UDim2.new(0.5, v56, 0.15, 10), UDim2.new(0, 164, 0, v54), true)
		createGamepadLabel("Move", UDim2.new(0.5, v56, 0.31, 5), UDim2.new(0, 46, 0, v54), true)
		createGamepadLabel("Menu Navigation", UDim2.new(0.5, v56, 0.46, 0), UDim2.new(0, 164, 0, v54), true)
		createGamepadLabel("Use Tool", UDim2.new(0.5, v57, 0, 15), UDim2.new(0, 73, 0, v54))
		createGamepadLabel("Roblox Menu", UDim2.new(0.5, v57, 0.15, 10), UDim2.new(0, 122, 0, v54))
		createGamepadLabel("Back", UDim2.new(0.5, v57, 0.31, 5), UDim2.new(0, 43, 0, v54))
		createGamepadLabel("Jump", UDim2.new(0.5, v57, 0.46, 0), UDim2.new(0, 49, 0, v54))
		createGamepadLabel("Rotate Camera", UDim2.new(0.5, v58, 0.62, -10), UDim2.new(0, 132, 0, v54))
		createGamepadLabel("Camera Zoom", UDim2.new(0.5, v58, 0.77, -10), UDim2.new(0, 122, 0, v54))
	end
	local function updateTouchLayout(p10) -- line: 401
		-- upvalues: v22 (copy), Utility (copy)
		v22.ActiveHelpScheme = p10

		local v60 = Utility:IsPortrait()

		if v22.HelpPages.Touch then
			local Touch = v22.HelpPageContents.Touch

			local function hideUneeded(p11) -- line: 409
				-- upvalues: Touch (copy)
				if p11 then
					for k, v in pairs(Touch) do
						v.Visible = not p11[k]
					end
				end
			end

			local t2

			if p10 == Enum.TouchMovementMode.DynamicThumbstick or p10 == Enum.TouchMovementMode.Default then
				t2 = {
					MoveImageCTM = true
				}
				Touch.MoveLabel.Position = v60 and UDim2.new(0.25, -Touch.MoveLabel.AbsoluteSize.x / 2, 0.75, -50) or UDim2.new(0.15, -Touch.MoveLabel.AbsoluteSize.x / 2, 0.85, -Touch.MoveLabel.AbsoluteSize.y)
				Touch.JumpLabel.Position = v60 and UDim2.new(0.75, -Touch.JumpLabel.AbsoluteSize.x / 2, 0.75, -50) or UDim2.new(0.85, -60, 0.85, -Touch.JumpLabel.AbsoluteSize.y)
				Touch.RotateLabel.Position = v60 and UDim2.new(1, -Touch.RotateLabel.AbsoluteSize.x - 20, 0.02, 0) or UDim2.new(0.85, -Touch.RotateLabel.AbsoluteSize.x / 2, 0.02, 0)
				Touch.UseToolLabel.Position = v60 and UDim2.new(0.5, -Touch.UseToolLabel.AbsoluteSize.x / 2, 0.5, -100) or UDim2.new(0.5, -Touch.UseToolLabel.AbsoluteSize.x / 2, 0.5, -60)
				Touch.EquipLabel.Position = v60 and UDim2.new(0.5, -60, 0.75, 50) or UDim2.new(0.5, -60, 0.64, 0)
				Touch.ZoomLabel.Position = v60 and UDim2.new(0, 20, 0.02, 0) or UDim2.new(0.15, -60, 0.02, 0)
			elseif p10 == Enum.TouchMovementMode.ClickToMove then
				t2 = {
					MoveImageDTS = true,
					JumpLabel = true
				}
				Touch.MoveLabel.Position = v60 and UDim2.new(0.25, -Touch.MoveLabel.AbsoluteSize.x / 2, 0.5, 0) or UDim2.new(0.25, -Touch.MoveLabel.AbsoluteSize.x / 2, 0.5, 40)
				Touch.RotateLabel.Position = v60 and UDim2.new(1, -Touch.RotateLabel.AbsoluteSize.x - 20, 0.02, 0) or UDim2.new(0.5, -60, 0.02, 0)
				Touch.UseToolLabel.Position = v60 and UDim2.new(0.75, -Touch.UseToolLabel.AbsoluteSize.x / 2, 0.5, 0) or UDim2.new(0.85, -60, 0.02, 0)
				Touch.EquipLabel.Position = v60 and UDim2.new(0.5, -60, 0.75, 50) or UDim2.new(0.5, -60, 0.64, 0)
				Touch.ZoomLabel.Position = v60 and UDim2.new(0, 20, 0.02, 0) or UDim2.new(0.15, -60, 0.02, 0)
			else
				t2 = {
					MoveImageDTS = true,
					MoveImageCTM = true,
					JumpImage = true
				}
				Touch.MoveLabel.Position = v60 and UDim2.new(0.06, 0, 1, -120) or UDim2.new(0.06, 0, 0.58, 0)
				Touch.JumpLabel.Position = v60 and UDim2.new(0.94, -Touch.JumpLabel.AbsoluteSize.x, 1, -120) or UDim2.new(0.8, 0, 0.58, 0)
				Touch.RotateLabel.Position = v60 and UDim2.new(1, -Touch.RotateLabel.AbsoluteSize.x - 20, 0.02, 0) or UDim2.new(0.5, -60, 0.02, 0)
				Touch.UseToolLabel.Position = v60 and UDim2.new(0.5, -Touch.UseToolLabel.AbsoluteSize.x / 2, 0.25, 50) or UDim2.new(0.85, -60, 0.02, 0)
				Touch.EquipLabel.Position = v60 and UDim2.new(0.5, -60, 0.75, 50) or UDim2.new(0.5, -60, 0.64, 0)
				Touch.ZoomLabel.Position = v60 and UDim2.new(0, 20, 0.02, 0) or UDim2.new(0.15, -60, 0.02, 0)
			end

			if t2 then
				for k, v in pairs(Touch) do
					v.Visible = not t2[k]
				end
			end
		end
	end
	local function createTouchHelp(p12) -- line: 457
		-- upvalues: Utility (copy), GuiService (copy), Create (copy), Theme (copy)
		local t3 = {}
		local v68 = Utility:IsSmallTouchScreen()
		local v69 = GuiService:GetScreenResolution().y - 350

		if v68 then
			v69 = GuiService:GetScreenResolution().y - 100
		end

		p12.Size = UDim2.new(1, 0, 0, v69)

		local function createTouchLabel(p13, p14, p15, p16) -- line: 466
			-- upvalues: Create (copy), Theme (copy), v68 (copy)
			local v155 = Create("TextLabel")({
				BackgroundTransparency = 1,
				Position = p14,
				Size = p15,
				Name = p13 .. "Frame",
				Parent = p16
			})
			local v156 = Create("TextLabel")({
				BackgroundTransparency = 1,
				ZIndex = 3,
				TextScaled = true,
				TextWrapped = true,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				Text = p13,
				Font = Theme.font(Enum.Font.SourceSansBold, "HelpTouch"),
				FontSize = Theme.fontSize(Enum.FontSize.Size14, "HelpTouch"),
				TextColor3 = Color3.new(1, 1, 1),
				Name = p13 .. "Label",
				Parent = v155
			})

			if not v68 then
				v156.FontSize = Theme.fontSize(Enum.FontSize.Size18, "HelpTitle")
				v156.Size = UDim2.new(v156.Size.X.Scale, v156.Size.X.Offset, v156.Size.Y.Scale, v156.Size.Y.Offset + 4)
			end

			Create("ImageLabel")({
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/Settings/Radial/RadialLabel.png",
				ZIndex = 2,
				Name = p13 .. "BackgroundImage",
				Size = UDim2.new(1.25, 0, 1.25, 0),
				Position = UDim2.new(-0.125, 0, -0.065, 0),
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(12, 2, 65, 21),
				Parent = v155
			})
			Instance.new("UITextSizeConstraint", v156).MaxTextSize = Theme.textSize(18, "HelpText")

			return v155
		end
		local function createTouchGestureImage(p17, p18, p19, p20, p21) -- line: 516
			-- upvalues: Create (copy)
			return (Create("ImageLabel")({
				BackgroundTransparency = 1,
				ZIndex = 2,
				Name = p17,
				Size = p20,
				Position = p19,
				Image = p18,
				Parent = p21
			}))
		end

		local n2 = 30

		if v68 then
			n2 = 0
		end

		t3.MoveLabel = createTouchLabel("Move", UDim2.new(0.06, 0, 0.58, 0), UDim2.new(0, n2 + 77, 0, 25), p12)

		local uDim2 = UDim2.new(0.5, -32, 1, 3)
		local uDim2_3 = UDim2.new(0, 65, 0, 48)
		local MoveLabel = t3.MoveLabel

		t3.MoveImageDTS = Create("ImageLabel")({
			Name = "MoveImageDTS",
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/Settings/Help/RotateCameraGesture.png",
			ZIndex = 2,
			Size = uDim2_3,
			Position = uDim2,
			Parent = MoveLabel
		})

		local uDim2_4 = UDim2.new(0.5, -19, 1, 3)
		local uDim2_5 = UDim2.new(0, 38, 0, 52)
		local MoveLabel2 = t3.MoveLabel

		t3.MoveImageCTM = Create("ImageLabel")({
			Name = "MoveImageCTM",
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/Settings/Help/UseToolGesture.png",
			ZIndex = 2,
			Size = uDim2_5,
			Position = uDim2_4,
			Parent = MoveLabel2
		})
		t3.JumpLabel = createTouchLabel("Jump", UDim2.new(0.8, 0, 0.58, 0), UDim2.new(0, n2 + 77, 0, 25), p12)

		local uDim2_6 = UDim2.new(0.5, -19, 1, 3)
		local uDim2_7 = UDim2.new(0, 38, 0, 52)
		local JumpLabel = t3.JumpLabel

		t3.JumpImage = Create("ImageLabel")({
			Name = "JumpImage",
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/Settings/Help/UseToolGesture.png",
			ZIndex = 2,
			Size = uDim2_7,
			Position = uDim2_6,
			Parent = JumpLabel
		})
		t3.EquipLabel = createTouchLabel("Equip/Unequip Tools", UDim2.new(0.5, -60, 0.64, 0), UDim2.new(0, n2 + 120, 0, 25), p12)
		t3.ZoomLabel = createTouchLabel("Zoom In/Out", UDim2.new(0.15, -60, 0.02, 0), UDim2.new(0, 120, 0, 25), p12)

		local uDim2_8 = UDim2.new(0.5, -26, 1, 3)
		local uDim2_9 = UDim2.new(0, 53, 0, 59)
		local ZoomLabel = t3.ZoomLabel

		t3.ZoomImage = Create("ImageLabel")({
			Name = "ZoomImage",
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/Settings/Help/ZoomGesture.png",
			ZIndex = 2,
			Size = uDim2_9,
			Position = uDim2_8,
			Parent = ZoomLabel
		})
		t3.RotateLabel = createTouchLabel("Rotate Camera", UDim2.new(0.5, -60, 0.02, 0), UDim2.new(0, 120, 0, 25), p12)

		local uDim2_10 = UDim2.new(0.5, -32, 1, 3)
		local uDim2_11 = UDim2.new(0, 65, 0, 48)
		local RotateLabel = t3.RotateLabel

		t3.RotateImage = Create("ImageLabel")({
			Name = "RotateImage",
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/Settings/Help/RotateCameraGesture.png",
			ZIndex = 2,
			Size = uDim2_11,
			Position = uDim2_10,
			Parent = RotateLabel
		})
		t3.UseToolLabel = createTouchLabel("Use Tool", UDim2.new(0.85, -60, 0.02, 0), UDim2.new(0, 120, 0, 25), p12)

		local uDim2_12 = UDim2.new(0.5, -19, 1, 3)
		local uDim2_13 = UDim2.new(0, 38, 0, 52)
		local UseToolLabel = t3.UseToolLabel

		t3.ToolImage = Create("ImageLabel")({
			Name = "ToolImage",
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/Settings/Help/UseToolGesture.png",
			ZIndex = 2,
			Size = uDim2_13,
			Position = uDim2_12,
			Parent = UseToolLabel
		})

		return t3
	end
	local function createSpatialGamepadHelp(p22) -- line: 556
		-- upvalues: v19 (copy), Create (copy), v22 (copy), u17 (ref), Theme (copy)
		local GamepadQuest = v19.Images.GamepadQuest
		local QuestGamepadLabels = v19.Labels.QuestGamepadLabels
		local GamepadQuestImage = GamepadQuest.Image
		local HeightRatio = GamepadQuest.HeightRatio
		local LocalizationKeyPrefix = QuestGamepadLabels.LocalizationKeyPrefix
		local LabelRelativeTextHeight = QuestGamepadLabels.LabelRelativeTextHeight
		local LabelsInfo = QuestGamepadLabels.LabelsInfo
		local v99 = Create("ImageLabel")({
			Name = "SpatialGamepadImage",
			BackgroundTransparency = 1,
			ZIndex = 2,
			Size = UDim2.new(1, 0, HeightRatio, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			Image = GamepadQuestImage,
			Parent = p22
		})
		local UIPadding = v22.Page:FindFirstChildOfClass("UIPadding")
		local v101 = not UIPadding and 0 or UIPadding.PaddingLeft.Offset + UIPadding.PaddingRight.Offset

		p22.Size = UDim2.new(p22.Size.X.Scale, p22.Size.X.Offset, 0, (v22.Page.AbsoluteSize.X - v101) * HeightRatio)

		for _, v103 in LabelsInfo do
			local v104 = LocalizationKeyPrefix .. v103.labelKey
			local v105 = u17:Format(v104)

			Create("TextLabel")({
				BackgroundTransparency = 1,
				ZIndex = 2,
				TextScaled = true,
				Name = v103.labelKey,
				Position = UDim2.fromScale(v103.xPosition, v103.yPosition),
				Size = UDim2.fromScale(v103.width, LabelRelativeTextHeight),
				Text = v105,
				TextXAlignment = v103.xAlignment or Enum.TextXAlignment.Right,
				Font = Theme.font(nil, "HelpGamepad"),
				TextColor3 = Theme.color("TextEmphasis"),
				TextTransparency = Theme.transparency("TextEmphasis"),
				Parent = v99
			})
		end
	end
	local function createHelpDisplay(p23) -- line: 608
		-- upvalues: Create (copy), createPCHelp (copy), createGamepadHelp (copy), createTouchHelp (copy), isInExperienceUIVREnabled (copy), createSpatialGamepadHelp (copy)
		local v107 = nil
		local v108 = Create("Frame")({
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Name = "HelpFrame" .. tostring(p23)
		})

		if p23 == "KeyboardMouse" then
			Create("UIListLayout")({
				Wraps = true,
				FillDirection = Enum.FillDirection.Horizontal,
				Parent = v108,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			})
		end

		if p23 == "KeyboardMouse" then
			createPCHelp(v108)
		elseif p23 == "Gamepad" then
			createGamepadHelp(v108)
		elseif p23 == "Touch" then
			v107 = createTouchHelp(v108)
		elseif isInExperienceUIVREnabled and p23 == "SpatialGamepad" then
			createSpatialGamepadHelp(v108)
		end

		return v108, v107
	end
	local function displayHelp(p24) -- line: 642
		-- upvalues: v22 (copy), v14 (copy), UserInputService (copy)
		for _, v in pairs(v22.HelpPages) do
			if v == p24 then
				v.Parent = v22.Page
				v22.Page.Size = v.Size

				if v14 then
					v22.Page.Size = UDim2.new(v.Size.X.Scale, v.Size.X.Offset, v.Size.Y.Scale, 0)
				end
			else
				v.Parent = nil
			end
		end

		if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
			v22.HubRef.PageViewClipper.ClipsDescendants = false
			v22.HubRef.PageView.ClipsDescendants = false
		end
	end
	local function switchToHelp(p25) -- line: 660
		-- upvalues: v22 (copy), displayHelp (copy), GameSettings (copy), updateTouchLayout (copy), createHelpDisplay (copy), switchToHelp (copy)
		local v113 = v22.HelpPages[p25]

		if v113 then
			displayHelp(v113)

			if p25 == "Touch" then
				local TouchMovementMode = GameSettings.TouchMovementMode

				if TouchMovementMode ~= v22.ActiveHelpScheme then
					updateTouchLayout(TouchMovementMode)

					return
				end
			end
		else
			local HelpPages = v22.HelpPages
			local HelpPageContents = v22.HelpPageContents
			local v117, v118 = createHelpDisplay(p25)

			HelpPages[p25] = v117
			HelpPageContents[p25] = v118
			switchToHelp(p25)
		end
	end
	local function showTypeOfHelp() -- line: 677
		-- upvalues: switchToHelp (copy), v22 (copy)
		switchToHelp(v22:GetCurrentInputType())
	end

	function v22.PageDisplayed(_) -- line: 681
		-- upvalues: v22 (copy), UserInputService (copy), u23 (ref), switchToHelp (copy)
		if not v22.LastInputTypeChangedConnection then
			v22.LastInputTypeChangedConnection = UserInputService.LastInputTypeChanged:Connect(function(p27) -- line: 683
				-- upvalues: u23 (ref), switchToHelp (copy), v22 (copy)
				if p27 ~= Enum.UserInputType.Focus and p27 ~= Enum.UserInputType.None then
					u23 = p27
					switchToHelp(v22:GetCurrentInputType())
				end
			end)
		end

		u23 = UserInputService:GetLastInputType()
		switchToHelp(v22:GetCurrentInputType())
	end
	function v22.PageHidden(_) -- line: 694
		-- upvalues: v22 (copy)
		if v22.LastInputTypeChangedConnection then
			v22.LastInputTypeChangedConnection:Disconnect()
			v22.LastInputTypeChangedConnection = nil
		end
	end

	local function adjustForScreenLayout(p29) -- line: 701
		-- upvalues: v22 (copy), GameSettings (copy), Utility (copy), GuiService (copy), updateTouchLayout (copy)
		if v22:GetCurrentInputType() == "Touch" then
			local TouchMovementMode = GameSettings.TouchMovementMode
			local v123 = Utility:IsSmallTouchScreen()
			local v124 = p29 or GuiService:GetScreenResolution()
			local v125 = v124.y - 350

			if v123 then
				v125 = v124.y - 120
			end

			v22.HelpPages.Touch.Size = UDim2.new(1, 0, 0, v125)
			updateTouchLayout(TouchMovementMode)
		end
	end

	v22.TabHeader.Name = "HelpTab"

	local v34 = uiblox["icons/menu/help"]

	v22.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[v34.variant]
	v22.TabHeader.TabLabel.Icon.Text = v34.name
	v22.TabHeader.TabLabel.Title.Text = "Help"
	v22.Page.Name = "Help"
	Utility:OnResized(v22, function(p30, _) -- line: 725
		-- upvalues: v22 (copy), adjustForScreenLayout (copy)
		if v22.HelpPages.Touch then
			adjustForScreenLayout(p30)
		end
	end)

	return v22
end

local u21 = Initialize()

u21.Displayed.Event:connect(function() -- line: 739
	-- upvalues: u21 (ref)
	u21:PageDisplayed()

	if u21.HubRef.VersionContainer then
		u21.HubRef.VersionContainer.Visible = true
	end
end)
u21.Hidden.Event:connect(function() -- line: 746
	-- upvalues: u21 (ref)
	u21:PageHidden()
	u21.HubRef.PageViewClipper.ClipsDescendants = true
	u21.HubRef.PageView.ClipsDescendants = true
	u21.HubRef:ShowShield()

	if u21.HubRef.VersionContainer then
		u21.HubRef.VersionContainer.Visible = false
	end
end)

return u21
