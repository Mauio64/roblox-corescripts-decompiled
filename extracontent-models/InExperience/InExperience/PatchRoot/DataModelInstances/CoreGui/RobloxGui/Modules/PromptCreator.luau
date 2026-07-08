local t1 = {}
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local TextService = game:GetService("TextService")
local GuiService = game:GetService("GuiService")
local EngineFeature = game:GetEngineFeature("DeprecateOldGuiObjectProperties")
local v8 = game:DefineFastFlag("PromptCreatorTransientDialog", false)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Modules = RobloxGui:WaitForChild("Modules")
local TenFootInterface = require(Modules:WaitForChild("TenFootInterface"))
local VR = Modules:WaitForChild("VR")
local Dialog = require(VR:WaitForChild("Dialog"))
local u14 = nil
local u15 = nil
local u16 = nil

function getViewportSize() -- line: 34
	while not game.Workspace.CurrentCamera do
		game.Workspace.Changed:Wait()
	end

	assert(game.Workspace.CurrentCamera, "")

	while game.Workspace.CurrentCamera.ViewportSize == Vector2.new(0, 0) or game.Workspace.CurrentCamera.ViewportSize == Vector2.new(1, 1) do
		game.Workspace.CurrentCamera.Changed:Wait()
	end

	return game.Workspace.CurrentCamera.ViewportSize
end

local v17 = TenFootInterface:IsEnabled()
local u18 = false
local v19 = UserInputService.TouchEnabled == true and UserInputService.MouseEnabled == false
local v20 = v19 and getViewportSize().Y <= 370
local v21 = v19 and not v20
local u22 = false
local u23 = false
local u24 = false
local u25 = false
local u26 = false
local t2 = {
	WindowTitle = "Confirm",
	MainText = "Is this okay?",
	ConfirmationText = "Confirm",
	CancelText = "Cancel",
	CancelActive = true,
	Image = nil,
	ImageConsoleVR = nil,
	PromptCompletedCallback = nil,
	StripeColor = Color3.new(0.01, 0.72, 0.34)
}
local PromptCompletedCallback = nil
local u29 = nil
local t3 = {}
local uDim2 = UDim2.new(0, 438, 0, 300)
local uDim2_2 = UDim2.new(0.5, -219, 0, -300)
local uDim2_3 = UDim2.new(0.5, -219, 0.5, -150)
local n1 = 52
local n2 = 24

if v17 or u18 then
	uDim2 = UDim2.new(1, 0, 0, 690)
	uDim2_2 = UDim2.new(0, 0, 0, -690)
	uDim2_3 = UDim2.new(0, 0, 0.5, -345)
elseif v20 then
	uDim2 = UDim2.new(0.9, 0, 0.9, 0)
	uDim2_2 = UDim2.new(0.05, 0, -0.9, 0)
	uDim2_3 = UDim2.new(0.05, 0, 0.05, 0)
elseif v21 then
	uDim2 = UDim2.new(0, 400, 0, 305)
	uDim2_2 = UDim2.new(0.5, -200, 0, -305)
	uDim2_3 = UDim2.new(0.5, -200, 0.5, -152)
end

if v20 then
	n1 = 44
end

if v17 or u18 then
	n2 = 42
end

local function createFrame(p1, p2, p3, p4, p5) -- line: 127
	local Frame = Instance.new("Frame")

	Frame.Name = p1
	Frame.Size = p2
	Frame.Position = p3 or UDim2.new(0, 0, 0, 0)
	Frame.BackgroundTransparency = p4
	Frame.BackgroundColor3 = p5 or Color3.new()
	Frame.BorderSizePixel = 0
	Frame.ZIndex = 8

	return Frame
end
local function createTextLabel(p6, p7, p8, p9, p10, p11) -- line: 140
	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = p6
	TextLabel.Size = p7 or UDim2.new(0, 0, 0, 0)
	TextLabel.Position = p8
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = p9
	TextLabel.TextSize = p10
	TextLabel.TextColor3 = Color3.new(1, 1, 1)
	TextLabel.Text = p11
	TextLabel.ZIndex = 8

	return TextLabel
end
local function createScrollingTextLabel(p12, p13, p14, p15, p16, p17, p18) -- line: 155
	-- upvalues: createTextLabel (copy), TextService (copy)
	local v65 = createTextLabel(p12, p13, p14, p15, p16, p17)

	v65.TextXAlignment = Enum.TextXAlignment.Left
	v65.TextYAlignment = Enum.TextYAlignment.Top
	v65.TextWrapped = true

	if TextService:GetTextSize(p17, p16, p15, Vector2.new(p13.X.Offset, 10000)).Y > p13.Y.Offset then
		local vector2 = Vector2.new(p13.X.Offset - (p18 + 20), 10000)
		local TextSize = TextService:GetTextSize(p17, p16, p15, vector2)
		local Frame = Instance.new("Frame")

		Frame.Name = "ScrollingTextParent"
		Frame.BackgroundTransparency = 1
		Frame.BackgroundColor3 = Color3.new(1, 1, 1)
		Frame.BorderSizePixel = 0
		Frame.Position = p14
		Frame.Size = p13 - UDim2.new(0, p18 * 2, 0, 0)

		local ScrollingFrame = Instance.new("ScrollingFrame")

		ScrollingFrame.Selectable = true
		ScrollingFrame.Name = "ScrollingFrame"
		ScrollingFrame.BackgroundTransparency = 1
		ScrollingFrame.BackgroundColor3 = Color3.new(1, 1, 1)
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
		ScrollingFrame.Size = p13
		ScrollingFrame.CanvasSize = UDim2.new(0, vector2.X - p18 * 2, 0, TextSize.Y)
		ScrollingFrame.ScrollBarThickness = p18
		ScrollingFrame.SelectionImageObject = Instance.new("ImageLabel")
		ScrollingFrame.SelectionImageObject.Name = "EmptySelectionImage"
		ScrollingFrame.SelectionImageObject.BackgroundTransparency = 1
		ScrollingFrame.SelectionImageObject.Image = ""
		ScrollingFrame.Active = false
		ScrollingFrame.SelectionGained:connect(function() -- line: 191
			-- upvalues: Frame (copy)
			Frame.BackgroundTransparency = 0.15
		end)
		ScrollingFrame.SelectionLost:connect(function() -- line: 195
			-- upvalues: Frame (copy)
			Frame.BackgroundTransparency = 1
		end)
		v65.Position = UDim2.new(0, 10, 0, 0)
		v65.Size = UDim2.new(0, vector2.X, 0, TextSize.Y)
		v65.Parent = ScrollingFrame
		ScrollingFrame.Parent = Frame

		return Frame
	end

	return v65
end
local function createImageLabel(p19, p20, p21, p22, p23) -- line: 212
	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Name = p19
	ImageLabel.Size = p20
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Position = p21
	ImageLabel.Image = p22

	if p23 then
		p23(ImageLabel)
	end

	return ImageLabel
end
local function createImageButtonWithText(p24, p25, p26, p27, p28, p29, p30) -- line: 227
	-- upvalues: createTextLabel (copy), n2 (ref)
	local ImageButton = Instance.new("ImageButton")

	ImageButton.Name = p24
	ImageButton.Size = p25
	ImageButton.Position = p26
	ImageButton.Image = p27
	ImageButton.BackgroundTransparency = 1
	ImageButton.AutoButtonColor = false
	ImageButton.ZIndex = 8
	ImageButton.Modal = true
	ImageButton.Selectable = true
	ImageButton.SelectionImageObject = Instance.new("ImageLabel")
	ImageButton.SelectionImageObject.Name = "EmptySelectionImage"
	ImageButton.SelectionImageObject.BackgroundTransparency = 1
	ImageButton.SelectionImageObject.Image = ""

	local v84 = createTextLabel(p24 .. "Text", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), p30, n2, p29)

	v84.ZIndex = 9
	v84.Parent = ImageButton
	ImageButton.MouseEnter:connect(function() -- line: 247
		-- upvalues: ImageButton (copy), p28 (copy)
		ImageButton.Image = p28
	end)
	ImageButton.MouseLeave:connect(function() -- line: 250
		-- upvalues: ImageButton (copy), p27 (copy)
		ImageButton.Image = p27
	end)
	ImageButton.MouseButton1Click:connect(function() -- line: 253
		-- upvalues: ImageButton (copy), p27 (copy)
		ImageButton.Image = p27
	end)
	ImageButton.SelectionGained:connect(function() -- line: 256
		-- upvalues: ImageButton (copy), p28 (copy)
		ImageButton.Image = p28
	end)
	ImageButton.SelectionLost:connect(function() -- line: 259
		-- upvalues: ImageButton (copy), p27 (copy)
		ImageButton.Image = p27
	end)

	return ImageButton
end
local function createPromptDialog() -- line: 267
	-- upvalues: u15 (ref), createFrame (copy), uDim2 (ref), uDim2_2 (ref), RobloxGui (copy), u16 (ref)
	u15 = createFrame("PromptDialog", uDim2, uDim2_2, 1, nil)
	u15.Visible = false
	u15.Active = true
	u15.Parent = RobloxGui
	u16 = createFrame("ContainerFrame", UDim2.new(1, 0, 1, 0), nil, 0.36, Color3.new(0, 0, 0))
	u16.ZIndex = 8
	u16.Parent = u15
end
local function destroyPromptDialog() -- line: 278
	-- upvalues: u15 (ref), u16 (ref)
	if u15 then
		u15:Destroy()
		u15 = nil
		u16 = nil
	end
end

function AddDefaultsToPromptOptions(p31, p32) -- line: 286
	for k, v in pairs(p32) do
		if p31[k] == nil then
			p31[k] = v
		end
	end
end
function CreatePromptVRorConsole(p33) -- line: 295
	-- upvalues: u16 (ref), createTextLabel (copy), createFrame (copy), createScrollingTextLabel (copy), createImageButtonWithText (copy)
	local n3 = 90

	if p33.ImageConsoleVR then
		local uDim2_4 = UDim2.new(0, 600, 0, 600)
		local uDim2_5 = UDim2.new(0, 100, 0, 45)
		local ImageConsoleVR = p33.ImageConsoleVR
		local FetchImageFunctionConsoleVR = p33.FetchImageFunctionConsoleVR
		local ImageLabel = Instance.new("ImageLabel")

		ImageLabel.Name = "Image"
		ImageLabel.Size = uDim2_4
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.Position = uDim2_5
		ImageLabel.Image = ImageConsoleVR

		if FetchImageFunctionConsoleVR then
			FetchImageFunctionConsoleVR(ImageLabel)
		end

		ImageLabel.ZIndex = 9
		ImageLabel.Parent = u16
		n3 = 800
	end

	local v96 = createTextLabel("WindowTitle", UDim2.new(0, 800, 0, 60), UDim2.new(0, n3, 0, 60), Enum.Font.SourceSansBold, 48, p33.WindowTitle)

	v96.TextXAlignment = Enum.TextXAlignment.Left
	v96.TextYAlignment = Enum.TextYAlignment.Center
	v96.Parent = u16
	v96.ZIndex = 9

	local v97 = createFrame("ColorStripe", UDim2.new(0, 832, 0, 4), UDim2.new(0, n3, 0, 120), 0, p33.StripeColor)

	v97.ZIndex = 9
	v97.Parent = u16
	createScrollingTextLabel("MainText", UDim2.new(0, 800, 0, 450), UDim2.new(0, n3, 0, 152), Enum.Font.SourceSansBold, 44, p33.MainText, 16).Parent = u16

	local rect = Rect.new(8, 8, 56, 56)
	local Slice = Enum.ScaleType.Slice
	local v100 = createImageButtonWithText("ConfirmButton", UDim2.new(0, 320, 0, 80), UDim2.new(0, n3, 1, -125), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p33.ConfirmationText, Enum.Font.SourceSans)

	v100.Parent = u16
	v100.ScaleType = Slice
	v100.SliceCenter = rect
	v100.MouseButton1Click:connect(function() -- line: 332
		OnPromptEnded(true)
	end)

	if p33.CancelActive then
		local v101 = createImageButtonWithText("CancelButton", UDim2.new(0, 320, 0, 80), UDim2.new(0, n3 + 340, 1, -125), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p33.CancelText, Enum.Font.SourceSans)

		v101.Parent = u16
		v101.ScaleType = Slice
		v101.SliceCenter = rect
		v101.MouseButton1Click:connect(function() -- line: 344
			OnPromptEnded(false)
		end)
	end
end
function CreatePromptPCorTablet(p34) -- line: 350
	-- upvalues: createTextLabel (copy), n1 (ref), u16 (ref), createFrame (copy), v21 (copy), createScrollingTextLabel (copy), createImageButtonWithText (copy)
	local v103 = createTextLabel("WindowTitle", UDim2.new(1, 0, 0, n1), UDim2.new(0, 0, 0, 0), Enum.Font.SourceSansBold, 24, p34.WindowTitle)

	v103.Parent = u16
	v103.ZIndex = 9

	local v104 = createFrame("ColorStripe", UDim2.new(1, 0, 0, 2), nil, 0, p34.StripeColor)

	v104.Position = UDim2.new(0, 0, 0, n1)
	v104.ZIndex = 9
	v104.Parent = u16

	local v110

	if p34.Image then
		local uDim2_6 = UDim2.new(0, 150, 0, 150)
		local uDim2_7 = UDim2.new(0, 15, 0, n1 + 17)
		local p34Image = p34.Image
		local FetchImageFunction = p34.FetchImageFunction
		local ImageLabel = Instance.new("ImageLabel")

		ImageLabel.Name = "Image"
		ImageLabel.Size = uDim2_6
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.Position = uDim2_7
		ImageLabel.Image = p34Image

		if FetchImageFunction then
			FetchImageFunction(ImageLabel)
		end

		ImageLabel.ZIndex = 9
		ImageLabel.Parent = u16
		v110 = if not v21 then createScrollingTextLabel("MainText", UDim2.new(0, 233, 0, 150), UDim2.new(0, 185, 0, n1 + 17), Enum.Font.SourceSansBold, 22, p34.MainText, 8) else createScrollingTextLabel("MainText", UDim2.new(0, 195, 0, 150), UDim2.new(0, 185, 0, n1 + 17), Enum.Font.SourceSansBold, 22, p34.MainText, 8)
	else
		v110 = if not v21 then createScrollingTextLabel("MainText", UDim2.new(0, 398, 0, 150), UDim2.new(0, 20, 0, n1 + 17), Enum.Font.SourceSansBold, 22, p34.MainText, 8) else createScrollingTextLabel("MainText", UDim2.new(0, 360, 0, 150), UDim2.new(0, 20, 0, n1 + 17), Enum.Font.SourceSansBold, 22, p34.MainText, 8)
	end

	v110.Parent = u16

	local rect = Rect.new(8, 8, 56, 56)
	local Slice = Enum.ScaleType.Slice
	local v113 = if not v21 then if not p34.CancelActive then createImageButtonWithText("ConfirmButton", UDim2.new(0, 128, 0, 38), UDim2.new(0.5, -64, 1, -53), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p34.ConfirmationText, Enum.Font.SourceSans) else createImageButtonWithText("ConfirmButton", UDim2.new(0, 128, 0, 38), UDim2.new(0.5, -138, 1, -53), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p34.ConfirmationText, Enum.Font.SourceSansBold) else if not p34.CancelActive then createImageButtonWithText("ConfirmButton", UDim2.new(0, 128, 0, 44), UDim2.new(0.5, -64, 1, -59), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p34.ConfirmationText, Enum.Font.SourceSans) else createImageButtonWithText("ConfirmButton", UDim2.new(0, 128, 0, 44), UDim2.new(0.5, -138, 1, -59), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p34.ConfirmationText, Enum.Font.SourceSansBold)

	v113.Parent = u16
	v113.ScaleType = Slice
	v113.SliceCenter = rect
	v113.MouseButton1Click:connect(function() -- line: 416
		OnPromptEnded(true)
	end)

	if p34.CancelActive then
		local v114 = if not v21 then createImageButtonWithText("CancelButton", UDim2.new(0, 128, 0, 38), UDim2.new(0.5, 10, 1, -53), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p34.CancelText, Enum.Font.SourceSans) else createImageButtonWithText("CancelButton", UDim2.new(0, 128, 0, 44), UDim2.new(0.5, 10, 1, -59), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p34.CancelText, Enum.Font.SourceSans)

		v114.Parent = u16
		v114.ScaleType = Slice
		v114.SliceCenter = rect
		v114.MouseButton1Click:connect(function() -- line: 434
			OnPromptEnded(false)
		end)
		v114.NextSelectionLeft = v113
		v113.NextSelectionRight = v114
	end
end
function CreatePromptPhone(p35) -- line: 443
	-- upvalues: createTextLabel (copy), n1 (ref), u16 (ref), createFrame (copy), createScrollingTextLabel (copy), createImageButtonWithText (copy)
	local v116 = createTextLabel("WindowTitle", UDim2.new(1, 0, 0, n1), UDim2.new(0, 0, 0, 0), Enum.Font.SourceSansBold, 24, p35.WindowTitle)

	v116.Parent = u16
	v116.ZIndex = 9

	local v117 = createFrame("ColorStripe", UDim2.new(1, 0, 0, 2), nil, 0, p35.StripeColor)

	v117.Position = UDim2.new(0, 0, 0, n1)
	v117.ZIndex = 9
	v117.Parent = u16

	local v123

	if p35.Image then
		local uDim2_8 = UDim2.new(0, 120, 0, 120)
		local uDim2_9 = UDim2.new(0, 15, 0, n1 + 17)
		local p35Image = p35.Image
		local FetchImageFunction = p35.FetchImageFunction
		local ImageLabel = Instance.new("ImageLabel")

		ImageLabel.Name = "Image"
		ImageLabel.Size = uDim2_8
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.Position = uDim2_9
		ImageLabel.Image = p35Image

		if FetchImageFunction then
			FetchImageFunction(ImageLabel)
		end

		ImageLabel.ZIndex = 9
		ImageLabel.Parent = u16
		v123 = createScrollingTextLabel("MainText", UDim2.new(0, u16.AbsoluteSize.X - 175, 0, 120), UDim2.new(0, 155, 0, n1 + 17), Enum.Font.SourceSansBold, 20, p35.MainText, 8)
	else
		v123 = createScrollingTextLabel("MainText", UDim2.new(1, u16.AbsoluteSize.X - 40, 0, 120), UDim2.new(0, 20, 0, n1 + 17), Enum.Font.SourceSansBold, 20, p35.MainText, 8)
	end

	v123.Parent = u16

	local rect = Rect.new(8, 8, 56, 56)
	local Slice = Enum.ScaleType.Slice
	local v126 = if not p35.CancelActive then createImageButtonWithText("ConfirmButton", UDim2.new(0, 128, 0, 44), UDim2.new(0.5, -64, 1, -59), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p35.ConfirmationText, Enum.Font.SourceSans) else createImageButtonWithText("ConfirmButton", UDim2.new(0, 128, 0, 44), UDim2.new(0.5, -138, 1, -59), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p35.ConfirmationText, Enum.Font.SourceSansBold)

	v126.Parent = u16
	v126.ScaleType = Slice
	v126.SliceCenter = rect
	v126.MouseButton1Click:connect(function() -- line: 489
		OnPromptEnded(true)
	end)

	if p35.CancelActive then
		local v127 = createImageButtonWithText("CancelButton", UDim2.new(0, 128, 0, 44), UDim2.new(0.5, 10, 1, -59), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p35.CancelText, Enum.Font.SourceSans)

		v127.Parent = u16
		v127.ScaleType = Slice
		v127.SliceCenter = rect
		v127.MouseButton1Click:connect(function() -- line: 500
			OnPromptEnded(false)
		end)
	end
end
function CreatePromptFromOptions(p36) -- line: 506
	-- upvalues: u16 (ref), u18 (ref), v17 (copy), v20 (copy)
	u16:ClearAllChildren()

	if u18 or v17 then
		CreatePromptVRorConsole(p36)

		return
	end

	if v20 then
		CreatePromptPhone(p36)

		return
	end

	CreatePromptPCorTablet(p36)
end
function SetSelectedObject() -- line: 518
	-- upvalues: u16 (ref), GuiService (copy)
	local CancelButton = u16:FindFirstChild("CancelButton")

	if CancelButton then
		GuiService.SelectedCoreObject = CancelButton

		return
	end

	local ConfirmButton = u16:FindFirstChild("ConfirmButton")

	if ConfirmButton then
		GuiService.SelectedCoreObject = ConfirmButton
	end
end
function OnTweenInFinished() -- line: 530
	-- upvalues: u23 (ref), v17 (copy)
	if u23 or v17 then
		SetSelectedObject()
	end
end
function ConnectActiveEvents() -- line: 536
	-- upvalues: u18 (ref), u23 (ref), t3 (ref), UserInputService (copy), GuiService (copy), u22 (ref), u24 (ref), u25 (ref), u26 (ref)
	local function OnInputChanged(p37) -- line: 537
		-- upvalues: u18 (ref), u23 (ref)
		local UserInputType = p37.UserInputType
		local UserInputType2 = Enum.UserInputType

		if not u18 and valueInTable(UserInputType, {
			UserInputType2.Gamepad1,
			UserInputType2.Gamepad2,
			UserInputType2.Gamepad3,
			UserInputType2.Gamepad4
		}) then
			if p37.KeyCode ~= Enum.KeyCode.Thumbstick1 and p37.KeyCode ~= Enum.KeyCode.Thumbstick2 then
				u23 = true

				return
			end

			if math.abs(p37.Position.X) > 0.1 or math.abs(p37.Position.Z) > 0.1 or math.abs(p37.Position.Y) > 0.1 then
				u23 = true

				return
			end
		else
			u23 = false
		end
	end

	table.insert(t3, UserInputService.InputChanged:connect(OnInputChanged))
	table.insert(t3, UserInputService.InputBegan:connect(OnInputChanged))
	table.insert(t3, GuiService.Changed:connect(function(p38) -- line: 556
		-- upvalues: u22 (ref), GuiService (copy), u24 (ref), u25 (ref), u26 (ref)
		if u22 then
			if p38 == "CoreGuiNavigationEnabled" then
				if GuiService.CoreGuiNavigationEnabled ~= true then
					u24 = GuiService.CoreGuiNavigationEnabled
					GuiService.CoreGuiNavigationEnabled = true

					return
				end
			elseif p38 == "GuiNavigationEnabled" then
				if GuiService.GuiNavigationEnabled ~= false then
					u25 = GuiService.GuiNavigationEnabled
					GuiService.GuiNavigationEnabled = false

					return
				end
			elseif p38 == "AutoSelectGuiEnabled" and GuiService.AutoSelectGuiEnabled ~= false then
				u26 = GuiService.AutoSelectGuiEnabled
				GuiService.AutoSelectGuiEnabled = false
			end
		end
	end))
end
function DisconnectActiveEvents() -- line: 578
	-- upvalues: t3 (ref)
	for _, v in ipairs(t3) do
		v:Disconnect()
	end

	t3 = {}
end
function ShowPrompt() -- line: 585
	-- upvalues: u15 (ref), v17 (copy), UserInputService (copy), u18 (ref), u14 (ref), Dialog (copy), uDim2_3 (ref), EngineFeature (copy)
	u15.Visible = true

	if v17 then
		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
	end

	if u18 then
		if not u14 then
			u14 = Dialog.new()
		end

		u15.Position = uDim2_3
		u14:SetContent(u15)
		u14:Show(true)
		DisableControllerMovement()

		return
	end

	if EngineFeature then
		u15:TweenPositionInternal(uDim2_3, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.3, true, OnTweenInFinished)
	else
		u15:TweenPosition(uDim2_3, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.3, true, OnTweenInFinished)
	end

	DisableControllerMovement()
	EnableControllerInput()
end
function HidePrompt() -- line: 609
	-- upvalues: u22 (ref), GuiService (copy), u24 (ref), u25 (ref), u26 (ref), v17 (copy), UserInputService (copy), v8 (copy), u15 (ref), u16 (ref), u18 (ref), uDim2_2 (ref), u14 (ref), EngineFeature (copy)
	local function onClosed() -- line: 610
		-- upvalues: u22 (ref), GuiService (copy), u24 (ref), u25 (ref), u26 (ref), v17 (copy), UserInputService (copy), v8 (copy), u15 (ref), u16 (ref)
		u22 = false
		GuiService.CoreGuiNavigationEnabled = u24
		GuiService.GuiNavigationEnabled = u25
		GuiService.AutoSelectGuiEnabled = u26
		GuiService.SelectedCoreObject = nil

		if v17 then
			UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
		end

		if v8 then
			DisconnectActiveEvents()

			if u15 then
				u15:Destroy()
				u15 = nil
				u16 = nil

				return
			end
		else
			u15.Visible = false
		end
	end

	if u18 then
		u15.Position = uDim2_2

		if u14 then
			u14:Close()
		end

		u22 = false
		GuiService.CoreGuiNavigationEnabled = u24
		GuiService.GuiNavigationEnabled = u25
		GuiService.AutoSelectGuiEnabled = u26
		GuiService.SelectedCoreObject = nil

		if v17 then
			UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
		end

		if not v8 then
			u15.Visible = false

			return
		end

		DisconnectActiveEvents()

		if u15 then
			u15:Destroy()
			u15 = nil
			u16 = nil

			return
		end
	else
		if EngineFeature then
			u15:TweenPositionInternal(uDim2_2, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.3, true, onClosed)

			return
		end

		u15:TweenPosition(uDim2_2, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.3, true, onClosed)
	end
end
function DoCreatePrompt(p39) -- line: 641
	-- upvalues: PromptCompletedCallback (ref), t2 (copy), u29 (ref)
	PromptCompletedCallback = p39.PromptCompletedCallback
	AddDefaultsToPromptOptions(p39, t2)
	u29 = p39
	CreatePromptFromOptions(p39)
	ShowPrompt()
end
function OnPromptEnded(p40) -- line: 649
	-- upvalues: PromptCompletedCallback (ref), u29 (ref)
	if PromptCompletedCallback then
		if u29.CancelActive then
			spawn(function() -- line: 652
				-- upvalues: PromptCompletedCallback (ref), p40 (copy)
				PromptCompletedCallback(p40)
			end)
		else
			spawn(function() -- line: 654
				-- upvalues: PromptCompletedCallback (ref)
				PromptCompletedCallback(true)
			end)
		end
	end

	HidePrompt()
	EnableControllerMovement()
	DisableControllerInput()
end
function NoOpFunc() -- line: 664
end
function EnableControllerMovement() -- line: 666
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("doNothingThumbstick2PromptCreator")
	ContextActionService:UnbindCoreAction("doNothingAButtonPromptCreator")
end
function DisableControllerMovement() -- line: 671
	-- upvalues: ContextActionService (copy)
	ContextActionService:BindCoreAction("doNothingThumbstick2PromptCreator", NoOpFunc, false, Enum.KeyCode.Thumbstick2)
	ContextActionService:BindCoreAction("doNothingAButtonPromptCreator", NoOpFunc, false, Enum.KeyCode.ButtonA)
end
function EnableControllerInput() -- line: 676
	-- upvalues: ContextActionService (copy), u29 (ref), GuiService (copy)
	ContextActionService:BindCoreAction("CoreScriptPromptCreatorCancel", function(_, p42, _) -- line: 679
		-- upvalues: u29 (ref)
		if p42 ~= Enum.UserInputState.Begin then
			return
		end

		if u29.CancelActive then
			OnPromptEnded(false)
		end
	end, false, Enum.KeyCode.ButtonB)
	ContextActionService:BindCoreAction("CoreScriptPromptCreatorSelect", function(_, p45, _) -- line: 692
		-- upvalues: GuiService (copy)
		if p45 ~= Enum.UserInputState.Begin then
			return
		end

		if GuiService.SelectedCoreObject == nil then
			SetSelectedObject()
		end
	end, false, Enum.KeyCode.ButtonSelect)
end
function DisableControllerInput() -- line: 704
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("CoreScriptPromptCreatorCancel")
	ContextActionService:UnbindCoreAction("CoreScriptPromptCreatorSelect")
end
function valueInTable(p47, p48) -- line: 709
	for _, v in pairs(p48) do
		if v == p47 then
			return true
		end
	end

	return false
end
function SetupGamepadSelection() -- line: 718
	-- upvalues: u24 (ref), GuiService (copy), u25 (ref), u26 (ref)
	u24 = GuiService.CoreGuiNavigationEnabled
	u25 = GuiService.GuiNavigationEnabled
	u26 = GuiService.AutoSelectGuiEnabled
	GuiService.SelectedCoreObject = nil
	GuiService.CoreGuiNavigationEnabled = true
	GuiService.GuiNavigationEnabled = false
	GuiService.AutoSelectGuiEnabled = false
end

if not v8 then
	createPromptDialog()

	local function OnInputChanged(p49) -- line: 733
		-- upvalues: u18 (ref), u23 (ref)
		local UserInputType = p49.UserInputType
		local UserInputType3 = Enum.UserInputType

		if not u18 and valueInTable(UserInputType, {
			UserInputType3.Gamepad1,
			UserInputType3.Gamepad2,
			UserInputType3.Gamepad3,
			UserInputType3.Gamepad4
		}) then
			if p49.KeyCode ~= Enum.KeyCode.Thumbstick1 and p49.KeyCode ~= Enum.KeyCode.Thumbstick2 then
				u23 = true

				return
			end

			if math.abs(p49.Position.X) > 0.1 or math.abs(p49.Position.Z) > 0.1 or math.abs(p49.Position.Y) > 0.1 then
				u23 = true

				return
			end
		else
			u23 = false
		end
	end

	UserInputService.InputChanged:connect(OnInputChanged)
	UserInputService.InputBegan:connect(OnInputChanged)

	local function OnVREnabled(p50) -- line: 751
		-- upvalues: u14 (ref), Dialog (copy), u15 (ref), u18 (ref), RobloxGui (copy)
		if p50 then
			if not u14 then
				u14 = Dialog.new()
			end

			u14:SetContent(u15)
			u18 = true

			return
		end

		u18 = false

		if u14 then
			u14:SetContent(nil)
		end

		u15.Parent = RobloxGui
	end

	spawn(function() -- line: 767
		-- upvalues: UserInputService (copy), u14 (ref), Dialog (copy), u15 (ref), u18 (ref), RobloxGui (copy)
		if UserInputService.VREnabled then
			if not u14 then
				u14 = Dialog.new()
			end

			u14:SetContent(u15)
			u18 = true

			return
		end

		u18 = false

		if u14 then
			u14:SetContent(nil)
		end

		u15.Parent = RobloxGui
	end)
	UserInputService.Changed:connect(function(p51) -- line: 771
		-- upvalues: UserInputService (copy), u14 (ref), Dialog (copy), u15 (ref), u18 (ref), RobloxGui (copy)
		if p51 == "VREnabled" then
			if UserInputService.VREnabled then
				if not u14 then
					u14 = Dialog.new()
				end

				u14:SetContent(u15)
				u18 = true

				return
			end

			u18 = false

			if u14 then
				u14:SetContent(nil)
			end

			u15.Parent = RobloxGui
		end
	end)
	GuiService.Changed:connect(function(p52) -- line: 777
		-- upvalues: u22 (ref), GuiService (copy), u24 (ref), u25 (ref), u26 (ref)
		if u22 then
			if p52 == "CoreGuiNavigationEnabled" then
				if GuiService.CoreGuiNavigationEnabled ~= true then
					u24 = GuiService.CoreGuiNavigationEnabled
					GuiService.CoreGuiNavigationEnabled = true

					return
				end
			elseif p52 == "GuiNavigationEnabled" then
				if GuiService.GuiNavigationEnabled ~= false then
					u25 = GuiService.GuiNavigationEnabled
					GuiService.GuiNavigationEnabled = false

					return
				end
			elseif p52 == "AutoSelectGuiEnabled" and GuiService.AutoSelectGuiEnabled ~= false then
				u26 = GuiService.AutoSelectGuiEnabled
				GuiService.AutoSelectGuiEnabled = false
			end
		end
	end)
end

function t1.CreatePrompt(_, p54) -- line: 800
	-- upvalues: u22 (ref), v8 (copy), createPromptDialog (copy)
	if u22 then
		return false
	end

	u22 = true

	if v8 then
		createPromptDialog()
		ConnectActiveEvents()
	end

	SetupGamepadSelection()
	DoCreatePrompt(p54)

	return true
end
function t1.IsCurrentlyPrompting(_) -- line: 816
	-- upvalues: u22 (ref)
	return u22
end

return t1
