local t1 = {}
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local TextService = game:GetService("TextService")
local GuiService = game:GetService("GuiService")
local v7 = game:DefineFastFlag("PromptCreatorTransientDialog", false)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Modules = RobloxGui:WaitForChild("Modules")
local TenFootInterface = require(Modules:WaitForChild("TenFootInterface"))
local VR = Modules:WaitForChild("VR")
local Dialog = require(VR:WaitForChild("Dialog"))
local u13 = nil
local u14 = nil
local u15 = nil

function getViewportSize() -- line: 32
	while not game.Workspace.CurrentCamera do
		game.Workspace.Changed:Wait()
	end

	assert(game.Workspace.CurrentCamera, "")

	while game.Workspace.CurrentCamera.ViewportSize == Vector2.new(0, 0) or game.Workspace.CurrentCamera.ViewportSize == Vector2.new(1, 1) do
		game.Workspace.CurrentCamera.Changed:Wait()
	end

	return game.Workspace.CurrentCamera.ViewportSize
end

local v16 = TenFootInterface:IsEnabled()
local u17 = false
local v18 = UserInputService.TouchEnabled == true and UserInputService.MouseEnabled == false
local v19 = v18 and getViewportSize().Y <= 370
local v20 = v18 and not v19
local u21 = false
local u22 = false
local u23 = false
local u24 = false
local u25 = false
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
local u28 = nil
local t3 = {}
local uDim2 = UDim2.new(0, 438, 0, 300)
local uDim2_2 = UDim2.new(0.5, -219, 0, -300)
local uDim2_3 = UDim2.new(0.5, -219, 0.5, -150)
local n1 = 52
local n2 = 24

if v16 or u17 then
	uDim2 = UDim2.new(1, 0, 0, 690)
	uDim2_2 = UDim2.new(0, 0, 0, -690)
	uDim2_3 = UDim2.new(0, 0, 0.5, -345)
elseif v19 then
	uDim2 = UDim2.new(0.9, 0, 0.9, 0)
	uDim2_2 = UDim2.new(0.05, 0, -0.9, 0)
	uDim2_3 = UDim2.new(0.05, 0, 0.05, 0)
elseif v20 then
	uDim2 = UDim2.new(0, 400, 0, 305)
	uDim2_2 = UDim2.new(0.5, -200, 0, -305)
	uDim2_3 = UDim2.new(0.5, -200, 0.5, -152)
end

if v19 then
	n1 = 44
end

if v16 or u17 then
	n2 = 42
end

local function createFrame(p1, p2, p3, p4, p5) -- line: 125
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
local function createTextLabel(p6, p7, p8, p9, p10, p11) -- line: 138
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
local function createScrollingTextLabel(p12, p13, p14, p15, p16, p17, p18) -- line: 153
	-- upvalues: createTextLabel (copy), TextService (copy)
	local v64 = createTextLabel(p12, p13, p14, p15, p16, p17)

	v64.TextXAlignment = Enum.TextXAlignment.Left
	v64.TextYAlignment = Enum.TextYAlignment.Top
	v64.TextWrapped = true

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
		ScrollingFrame.SelectionGained:connect(function() -- line: 189
			-- upvalues: Frame (copy)
			Frame.BackgroundTransparency = 0.15
		end)
		ScrollingFrame.SelectionLost:connect(function() -- line: 193
			-- upvalues: Frame (copy)
			Frame.BackgroundTransparency = 1
		end)
		v64.Position = UDim2.new(0, 10, 0, 0)
		v64.Size = UDim2.new(0, vector2.X, 0, TextSize.Y)
		v64.Parent = ScrollingFrame
		ScrollingFrame.Parent = Frame

		return Frame
	end

	return v64
end
local function createImageLabel(p19, p20, p21, p22, p23) -- line: 210
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
local function createImageButtonWithText(p24, p25, p26, p27, p28, p29, p30) -- line: 225
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

	local v83 = createTextLabel(p24 .. "Text", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), p30, n2, p29)

	v83.ZIndex = 9
	v83.Parent = ImageButton
	ImageButton.MouseEnter:connect(function() -- line: 245
		-- upvalues: ImageButton (copy), p28 (copy)
		ImageButton.Image = p28
	end)
	ImageButton.MouseLeave:connect(function() -- line: 248
		-- upvalues: ImageButton (copy), p27 (copy)
		ImageButton.Image = p27
	end)
	ImageButton.MouseButton1Click:connect(function() -- line: 251
		-- upvalues: ImageButton (copy), p27 (copy)
		ImageButton.Image = p27
	end)
	ImageButton.SelectionGained:connect(function() -- line: 254
		-- upvalues: ImageButton (copy), p28 (copy)
		ImageButton.Image = p28
	end)
	ImageButton.SelectionLost:connect(function() -- line: 257
		-- upvalues: ImageButton (copy), p27 (copy)
		ImageButton.Image = p27
	end)

	return ImageButton
end
local function createPromptDialog() -- line: 265
	-- upvalues: u14 (ref), createFrame (copy), uDim2 (ref), uDim2_2 (ref), RobloxGui (copy), u15 (ref)
	u14 = createFrame("PromptDialog", uDim2, uDim2_2, 1, nil)
	u14.Visible = false
	u14.Active = true
	u14.Parent = RobloxGui
	u15 = createFrame("ContainerFrame", UDim2.new(1, 0, 1, 0), nil, 0.36, Color3.new(0, 0, 0))
	u15.ZIndex = 8
	u15.Parent = u14
end
local function destroyPromptDialog() -- line: 276
	-- upvalues: u14 (ref), u15 (ref)
	if u14 then
		u14:Destroy()
		u14 = nil
		u15 = nil
	end
end

function AddDefaultsToPromptOptions(p31, p32) -- line: 284
	for k, v in pairs(p32) do
		if p31[k] == nil then
			p31[k] = v
		end
	end
end
function CreatePromptVRorConsole(p33) -- line: 293
	-- upvalues: u15 (ref), createTextLabel (copy), createFrame (copy), createScrollingTextLabel (copy), createImageButtonWithText (copy)
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
		ImageLabel.Parent = u15
		n3 = 800
	end

	local v95 = createTextLabel("WindowTitle", UDim2.new(0, 800, 0, 60), UDim2.new(0, n3, 0, 60), Enum.Font.SourceSansBold, 48, p33.WindowTitle)

	v95.TextXAlignment = Enum.TextXAlignment.Left
	v95.TextYAlignment = Enum.TextYAlignment.Center
	v95.Parent = u15
	v95.ZIndex = 9

	local v96 = createFrame("ColorStripe", UDim2.new(0, 832, 0, 4), UDim2.new(0, n3, 0, 120), 0, p33.StripeColor)

	v96.ZIndex = 9
	v96.Parent = u15
	createScrollingTextLabel("MainText", UDim2.new(0, 800, 0, 450), UDim2.new(0, n3, 0, 152), Enum.Font.SourceSansBold, 44, p33.MainText, 16).Parent = u15

	local rect = Rect.new(8, 8, 56, 56)
	local Slice = Enum.ScaleType.Slice
	local v99 = createImageButtonWithText("ConfirmButton", UDim2.new(0, 320, 0, 80), UDim2.new(0, n3, 1, -125), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p33.ConfirmationText, Enum.Font.SourceSans)

	v99.Parent = u15
	v99.ScaleType = Slice
	v99.SliceCenter = rect
	v99.MouseButton1Click:connect(function() -- line: 330
		OnPromptEnded(true)
	end)

	if p33.CancelActive then
		local v100 = createImageButtonWithText("CancelButton", UDim2.new(0, 320, 0, 80), UDim2.new(0, n3 + 340, 1, -125), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p33.CancelText, Enum.Font.SourceSans)

		v100.Parent = u15
		v100.ScaleType = Slice
		v100.SliceCenter = rect
		v100.MouseButton1Click:connect(function() -- line: 342
			OnPromptEnded(false)
		end)
	end
end
function CreatePromptPCorTablet(p34) -- line: 348
	-- upvalues: createTextLabel (copy), n1 (ref), u15 (ref), createFrame (copy), v20 (copy), createScrollingTextLabel (copy), createImageButtonWithText (copy)
	local v102 = createTextLabel("WindowTitle", UDim2.new(1, 0, 0, n1), UDim2.new(0, 0, 0, 0), Enum.Font.SourceSansBold, 24, p34.WindowTitle)

	v102.Parent = u15
	v102.ZIndex = 9

	local v103 = createFrame("ColorStripe", UDim2.new(1, 0, 0, 2), nil, 0, p34.StripeColor)

	v103.Position = UDim2.new(0, 0, 0, n1)
	v103.ZIndex = 9
	v103.Parent = u15

	local v109

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
		ImageLabel.Parent = u15
		v109 = if not v20 then createScrollingTextLabel("MainText", UDim2.new(0, 233, 0, 150), UDim2.new(0, 185, 0, n1 + 17), Enum.Font.SourceSansBold, 22, p34.MainText, 8) else createScrollingTextLabel("MainText", UDim2.new(0, 195, 0, 150), UDim2.new(0, 185, 0, n1 + 17), Enum.Font.SourceSansBold, 22, p34.MainText, 8)
	else
		v109 = if not v20 then createScrollingTextLabel("MainText", UDim2.new(0, 398, 0, 150), UDim2.new(0, 20, 0, n1 + 17), Enum.Font.SourceSansBold, 22, p34.MainText, 8) else createScrollingTextLabel("MainText", UDim2.new(0, 360, 0, 150), UDim2.new(0, 20, 0, n1 + 17), Enum.Font.SourceSansBold, 22, p34.MainText, 8)
	end

	v109.Parent = u15

	local rect = Rect.new(8, 8, 56, 56)
	local Slice = Enum.ScaleType.Slice
	local v112 = if not v20 then if not p34.CancelActive then createImageButtonWithText("ConfirmButton", UDim2.new(0, 128, 0, 38), UDim2.new(0.5, -64, 1, -53), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p34.ConfirmationText, Enum.Font.SourceSans) else createImageButtonWithText("ConfirmButton", UDim2.new(0, 128, 0, 38), UDim2.new(0.5, -138, 1, -53), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p34.ConfirmationText, Enum.Font.SourceSansBold) else if not p34.CancelActive then createImageButtonWithText("ConfirmButton", UDim2.new(0, 128, 0, 44), UDim2.new(0.5, -64, 1, -59), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p34.ConfirmationText, Enum.Font.SourceSans) else createImageButtonWithText("ConfirmButton", UDim2.new(0, 128, 0, 44), UDim2.new(0.5, -138, 1, -59), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p34.ConfirmationText, Enum.Font.SourceSansBold)

	v112.Parent = u15
	v112.ScaleType = Slice
	v112.SliceCenter = rect
	v112.MouseButton1Click:connect(function() -- line: 414
		OnPromptEnded(true)
	end)

	if p34.CancelActive then
		local v113 = if not v20 then createImageButtonWithText("CancelButton", UDim2.new(0, 128, 0, 38), UDim2.new(0.5, 10, 1, -53), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p34.CancelText, Enum.Font.SourceSans) else createImageButtonWithText("CancelButton", UDim2.new(0, 128, 0, 44), UDim2.new(0.5, 10, 1, -59), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p34.CancelText, Enum.Font.SourceSans)

		v113.Parent = u15
		v113.ScaleType = Slice
		v113.SliceCenter = rect
		v113.MouseButton1Click:connect(function() -- line: 432
			OnPromptEnded(false)
		end)
		v113.NextSelectionLeft = v112
		v112.NextSelectionRight = v113
	end
end
function CreatePromptPhone(p35) -- line: 441
	-- upvalues: createTextLabel (copy), n1 (ref), u15 (ref), createFrame (copy), createScrollingTextLabel (copy), createImageButtonWithText (copy)
	local v115 = createTextLabel("WindowTitle", UDim2.new(1, 0, 0, n1), UDim2.new(0, 0, 0, 0), Enum.Font.SourceSansBold, 24, p35.WindowTitle)

	v115.Parent = u15
	v115.ZIndex = 9

	local v116 = createFrame("ColorStripe", UDim2.new(1, 0, 0, 2), nil, 0, p35.StripeColor)

	v116.Position = UDim2.new(0, 0, 0, n1)
	v116.ZIndex = 9
	v116.Parent = u15

	local v122

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
		ImageLabel.Parent = u15
		v122 = createScrollingTextLabel("MainText", UDim2.new(0, u15.AbsoluteSize.X - 175, 0, 120), UDim2.new(0, 155, 0, n1 + 17), Enum.Font.SourceSansBold, 20, p35.MainText, 8)
	else
		v122 = createScrollingTextLabel("MainText", UDim2.new(1, u15.AbsoluteSize.X - 40, 0, 120), UDim2.new(0, 20, 0, n1 + 17), Enum.Font.SourceSansBold, 20, p35.MainText, 8)
	end

	v122.Parent = u15

	local rect = Rect.new(8, 8, 56, 56)
	local Slice = Enum.ScaleType.Slice
	local v125 = if not p35.CancelActive then createImageButtonWithText("ConfirmButton", UDim2.new(0, 128, 0, 44), UDim2.new(0.5, -64, 1, -59), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p35.ConfirmationText, Enum.Font.SourceSans) else createImageButtonWithText("ConfirmButton", UDim2.new(0, 128, 0, 44), UDim2.new(0.5, -138, 1, -59), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p35.ConfirmationText, Enum.Font.SourceSansBold)

	v125.Parent = u15
	v125.ScaleType = Slice
	v125.SliceCenter = rect
	v125.MouseButton1Click:connect(function() -- line: 487
		OnPromptEnded(true)
	end)

	if p35.CancelActive then
		local v126 = createImageButtonWithText("CancelButton", UDim2.new(0, 128, 0, 44), UDim2.new(0.5, 10, 1, -59), "rbxasset://textures/ui/VR/button.png", "rbxasset://textures/ui/VR/buttonSelected.png", p35.CancelText, Enum.Font.SourceSans)

		v126.Parent = u15
		v126.ScaleType = Slice
		v126.SliceCenter = rect
		v126.MouseButton1Click:connect(function() -- line: 498
			OnPromptEnded(false)
		end)
	end
end
function CreatePromptFromOptions(p36) -- line: 504
	-- upvalues: u15 (ref), u17 (ref), v16 (copy), v19 (copy)
	u15:ClearAllChildren()

	if u17 or v16 then
		CreatePromptVRorConsole(p36)

		return
	end

	if v19 then
		CreatePromptPhone(p36)

		return
	end

	CreatePromptPCorTablet(p36)
end
function SetSelectedObject() -- line: 516
	-- upvalues: u15 (ref), GuiService (copy)
	local CancelButton = u15:FindFirstChild("CancelButton")

	if CancelButton then
		GuiService.SelectedCoreObject = CancelButton

		return
	end

	local ConfirmButton = u15:FindFirstChild("ConfirmButton")

	if ConfirmButton then
		GuiService.SelectedCoreObject = ConfirmButton
	end
end
function OnTweenInFinished() -- line: 528
	-- upvalues: u22 (ref), v16 (copy)
	if u22 or v16 then
		SetSelectedObject()
	end
end
function ConnectActiveEvents() -- line: 534
	-- upvalues: u17 (ref), u22 (ref), t3 (ref), UserInputService (copy), GuiService (copy), u21 (ref), u23 (ref), u24 (ref), u25 (ref)
	local function OnInputChanged(p37) -- line: 535
		-- upvalues: u17 (ref), u22 (ref)
		local UserInputType = p37.UserInputType
		local UserInputType2 = Enum.UserInputType

		if not u17 and valueInTable(UserInputType, {
			UserInputType2.Gamepad1,
			UserInputType2.Gamepad2,
			UserInputType2.Gamepad3,
			UserInputType2.Gamepad4
		}) then
			if p37.KeyCode ~= Enum.KeyCode.Thumbstick1 and p37.KeyCode ~= Enum.KeyCode.Thumbstick2 then
				u22 = true

				return
			end

			if math.abs(p37.Position.X) > 0.1 or math.abs(p37.Position.Z) > 0.1 or math.abs(p37.Position.Y) > 0.1 then
				u22 = true

				return
			end
		else
			u22 = false
		end
	end

	table.insert(t3, UserInputService.InputChanged:connect(OnInputChanged))
	table.insert(t3, UserInputService.InputBegan:connect(OnInputChanged))
	table.insert(t3, GuiService.Changed:connect(function(p38) -- line: 554
		-- upvalues: u21 (ref), GuiService (copy), u23 (ref), u24 (ref), u25 (ref)
		if u21 then
			if p38 == "CoreGuiNavigationEnabled" then
				if GuiService.CoreGuiNavigationEnabled ~= true then
					u23 = GuiService.CoreGuiNavigationEnabled
					GuiService.CoreGuiNavigationEnabled = true

					return
				end
			elseif p38 == "GuiNavigationEnabled" then
				if GuiService.GuiNavigationEnabled ~= false then
					u24 = GuiService.GuiNavigationEnabled
					GuiService.GuiNavigationEnabled = false

					return
				end
			elseif p38 == "AutoSelectGuiEnabled" and GuiService.AutoSelectGuiEnabled ~= false then
				u25 = GuiService.AutoSelectGuiEnabled
				GuiService.AutoSelectGuiEnabled = false
			end
		end
	end))
end
function DisconnectActiveEvents() -- line: 576
	-- upvalues: t3 (ref)
	for _, v in ipairs(t3) do
		v:Disconnect()
	end

	t3 = {}
end
function ShowPrompt() -- line: 583
	-- upvalues: u14 (ref), v16 (copy), UserInputService (copy), u17 (ref), u13 (ref), Dialog (copy), uDim2_3 (ref)
	u14.Visible = true

	if v16 then
		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
	end

	if u17 then
		if not u13 then
			u13 = Dialog.new()
		end

		u14.Position = uDim2_3
		u13:SetContent(u14)
		u13:Show(true)
		DisableControllerMovement()

		return
	end

	u14:TweenPositionInternal(uDim2_3, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.3, true, OnTweenInFinished)
	DisableControllerMovement()
	EnableControllerInput()
end
function HidePrompt() -- line: 603
	-- upvalues: u21 (ref), GuiService (copy), u23 (ref), u24 (ref), u25 (ref), v16 (copy), UserInputService (copy), v7 (copy), u14 (ref), u15 (ref), u17 (ref), uDim2_2 (ref), u13 (ref)
	local function onClosed() -- line: 604
		-- upvalues: u21 (ref), GuiService (copy), u23 (ref), u24 (ref), u25 (ref), v16 (copy), UserInputService (copy), v7 (copy), u14 (ref), u15 (ref)
		u21 = false
		GuiService.CoreGuiNavigationEnabled = u23
		GuiService.GuiNavigationEnabled = u24
		GuiService.AutoSelectGuiEnabled = u25
		GuiService.SelectedCoreObject = nil

		if v16 then
			UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
		end

		if v7 then
			DisconnectActiveEvents()

			if u14 then
				u14:Destroy()
				u14 = nil
				u15 = nil

				return
			end
		else
			u14.Visible = false
		end
	end

	if u17 then
		u14.Position = uDim2_2

		if u13 then
			u13:Close()
		end

		u21 = false
		GuiService.CoreGuiNavigationEnabled = u23
		GuiService.GuiNavigationEnabled = u24
		GuiService.AutoSelectGuiEnabled = u25
		GuiService.SelectedCoreObject = nil

		if v16 then
			UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
		end

		if not v7 then
			u14.Visible = false

			return
		end

		DisconnectActiveEvents()

		if u14 then
			u14:Destroy()
			u14 = nil
			u15 = nil

			return
		end
	else
		u14:TweenPositionInternal(uDim2_2, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.3, true, onClosed)
	end
end
function DoCreatePrompt(p39) -- line: 631
	-- upvalues: PromptCompletedCallback (ref), t2 (copy), u28 (ref)
	PromptCompletedCallback = p39.PromptCompletedCallback
	AddDefaultsToPromptOptions(p39, t2)
	u28 = p39
	CreatePromptFromOptions(p39)
	ShowPrompt()
end
function OnPromptEnded(p40) -- line: 639
	-- upvalues: PromptCompletedCallback (ref), u28 (ref)
	if PromptCompletedCallback then
		if u28.CancelActive then
			spawn(function() -- line: 642
				-- upvalues: PromptCompletedCallback (ref), p40 (copy)
				PromptCompletedCallback(p40)
			end)
		else
			spawn(function() -- line: 644
				-- upvalues: PromptCompletedCallback (ref)
				PromptCompletedCallback(true)
			end)
		end
	end

	HidePrompt()
	EnableControllerMovement()
	DisableControllerInput()
end
function NoOpFunc() -- line: 654
end
function EnableControllerMovement() -- line: 656
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("doNothingThumbstick2PromptCreator")
	ContextActionService:UnbindCoreAction("doNothingAButtonPromptCreator")
end
function DisableControllerMovement() -- line: 661
	-- upvalues: ContextActionService (copy)
	ContextActionService:BindCoreAction("doNothingThumbstick2PromptCreator", NoOpFunc, false, Enum.KeyCode.Thumbstick2)
	ContextActionService:BindCoreAction("doNothingAButtonPromptCreator", NoOpFunc, false, Enum.KeyCode.ButtonA)
end
function EnableControllerInput() -- line: 666
	-- upvalues: ContextActionService (copy), u28 (ref), GuiService (copy)
	ContextActionService:BindCoreAction("CoreScriptPromptCreatorCancel", function(_, p42, _) -- line: 669
		-- upvalues: u28 (ref)
		if p42 ~= Enum.UserInputState.Begin then
			return
		end

		if u28.CancelActive then
			OnPromptEnded(false)
		end
	end, false, Enum.KeyCode.ButtonB)
	ContextActionService:BindCoreAction("CoreScriptPromptCreatorSelect", function(_, p45, _) -- line: 682
		-- upvalues: GuiService (copy)
		if p45 ~= Enum.UserInputState.Begin then
			return
		end

		if GuiService.SelectedCoreObject == nil then
			SetSelectedObject()
		end
	end, false, Enum.KeyCode.ButtonSelect)
end
function DisableControllerInput() -- line: 694
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("CoreScriptPromptCreatorCancel")
	ContextActionService:UnbindCoreAction("CoreScriptPromptCreatorSelect")
end
function valueInTable(p47, p48) -- line: 699
	for _, v in pairs(p48) do
		if v == p47 then
			return true
		end
	end

	return false
end
function SetupGamepadSelection() -- line: 708
	-- upvalues: u23 (ref), GuiService (copy), u24 (ref), u25 (ref)
	u23 = GuiService.CoreGuiNavigationEnabled
	u24 = GuiService.GuiNavigationEnabled
	u25 = GuiService.AutoSelectGuiEnabled
	GuiService.SelectedCoreObject = nil
	GuiService.CoreGuiNavigationEnabled = true
	GuiService.GuiNavigationEnabled = false
	GuiService.AutoSelectGuiEnabled = false
end

if not v7 then
	createPromptDialog()

	local function OnInputChanged(p49) -- line: 723
		-- upvalues: u17 (ref), u22 (ref)
		local UserInputType = p49.UserInputType
		local UserInputType3 = Enum.UserInputType

		if not u17 and valueInTable(UserInputType, {
			UserInputType3.Gamepad1,
			UserInputType3.Gamepad2,
			UserInputType3.Gamepad3,
			UserInputType3.Gamepad4
		}) then
			if p49.KeyCode ~= Enum.KeyCode.Thumbstick1 and p49.KeyCode ~= Enum.KeyCode.Thumbstick2 then
				u22 = true

				return
			end

			if math.abs(p49.Position.X) > 0.1 or math.abs(p49.Position.Z) > 0.1 or math.abs(p49.Position.Y) > 0.1 then
				u22 = true

				return
			end
		else
			u22 = false
		end
	end

	UserInputService.InputChanged:connect(OnInputChanged)
	UserInputService.InputBegan:connect(OnInputChanged)

	local function OnVREnabled(p50) -- line: 741
		-- upvalues: u13 (ref), Dialog (copy), u14 (ref), u17 (ref), RobloxGui (copy)
		if p50 then
			if not u13 then
				u13 = Dialog.new()
			end

			u13:SetContent(u14)
			u17 = true

			return
		end

		u17 = false

		if u13 then
			u13:SetContent(nil)
		end

		u14.Parent = RobloxGui
	end

	spawn(function() -- line: 757
		-- upvalues: UserInputService (copy), u13 (ref), Dialog (copy), u14 (ref), u17 (ref), RobloxGui (copy)
		if UserInputService.VREnabled then
			if not u13 then
				u13 = Dialog.new()
			end

			u13:SetContent(u14)
			u17 = true

			return
		end

		u17 = false

		if u13 then
			u13:SetContent(nil)
		end

		u14.Parent = RobloxGui
	end)
	UserInputService.Changed:connect(function(p51) -- line: 761
		-- upvalues: UserInputService (copy), u13 (ref), Dialog (copy), u14 (ref), u17 (ref), RobloxGui (copy)
		if p51 == "VREnabled" then
			if UserInputService.VREnabled then
				if not u13 then
					u13 = Dialog.new()
				end

				u13:SetContent(u14)
				u17 = true

				return
			end

			u17 = false

			if u13 then
				u13:SetContent(nil)
			end

			u14.Parent = RobloxGui
		end
	end)
	GuiService.Changed:connect(function(p52) -- line: 767
		-- upvalues: u21 (ref), GuiService (copy), u23 (ref), u24 (ref), u25 (ref)
		if u21 then
			if p52 == "CoreGuiNavigationEnabled" then
				if GuiService.CoreGuiNavigationEnabled ~= true then
					u23 = GuiService.CoreGuiNavigationEnabled
					GuiService.CoreGuiNavigationEnabled = true

					return
				end
			elseif p52 == "GuiNavigationEnabled" then
				if GuiService.GuiNavigationEnabled ~= false then
					u24 = GuiService.GuiNavigationEnabled
					GuiService.GuiNavigationEnabled = false

					return
				end
			elseif p52 == "AutoSelectGuiEnabled" and GuiService.AutoSelectGuiEnabled ~= false then
				u25 = GuiService.AutoSelectGuiEnabled
				GuiService.AutoSelectGuiEnabled = false
			end
		end
	end)
end

function t1.CreatePrompt(_, p54) -- line: 790
	-- upvalues: u21 (ref), v7 (copy), createPromptDialog (copy)
	if u21 then
		return false
	end

	u21 = true

	if v7 then
		createPromptDialog()
		ConnectActiveEvents()
	end

	SetupGamepadSelection()
	DoCreatePrompt(p54)

	return true
end
function t1.IsCurrentlyPrompting(_) -- line: 806
	-- upvalues: u21 (ref)
	return u21
end

return t1
