local PromptCreator = {}

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local TextService = game:GetService("TextService")
local GuiService = game:GetService("GuiService")

local defineFastFlag = game:DefineFastFlag("PromptCreatorTransientDialog", false)

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Modules = RobloxGui:WaitForChild("Modules")
local TenFootInterface = require(Modules:WaitForChild("TenFootInterface"))
local vr = Modules:WaitForChild("VR")
local Dialog = require(vr:WaitForChild("Dialog"))

local v = nil
local parent = nil
local parent2 = nil

function getViewportSize()
	while not game.Workspace.CurrentCamera do
		game.Workspace.Changed:Wait()
	end

	assert(game.Workspace.CurrentCamera, "")

	while
		game.Workspace.CurrentCamera.ViewportSize == Vector2.new(0, 0)
		or game.Workspace.CurrentCamera.ViewportSize == Vector2.new(1, 1)
	do
		game.Workspace.CurrentCamera.Changed:Wait()
	end

	return game.Workspace.CurrentCamera.ViewportSize
end

local isEnabled = TenFootInterface:IsEnabled()
local flag = false
local v2

if UserInputService.TouchEnabled == true then
	v2 = UserInputService.MouseEnabled == false
else
	v2 = false
end

local v3 = v2 and getViewportSize().Y <= 370
local v4 = v2 and not v3
local flag2 = false

local v5 = false
local coreGuiNavigationEnabled = false
local guiNavigationEnabled = false
local autoSelectGuiEnabled = false

local v6 = {
	WindowTitle = "Confirm",
	MainText = "Is this okay?",
	ConfirmationText = "Confirm",
	CancelText = "Cancel",
	CancelActive = true,
	StripeColor = Color3.new(0.01, 0.72, 0.34),
	Image = nil,
	ImageConsoleVR = nil,
	PromptCompletedCallback = nil
}

local promptCompletedCallback = nil
local v7 = nil

local connections = {}

local udim = UDim2.new(0, 438, 0, 300)
local udim2 = UDim2.new(0.5, -219, 0, -300)
local udim3 = UDim2.new(0.5, -219, 0.5, -150)

if isEnabled or flag then
	udim = UDim2.new(1, 0, 0, 690)
	udim2 = UDim2.new(0, 0, 0, -690)
	udim3 = UDim2.new(0, 0, 0.5, -345)
elseif v3 then
	udim = UDim2.new(0.9, 0, 0.9, 0)
	udim2 = UDim2.new(0.05, 0, -0.9, 0)
	udim3 = UDim2.new(0.05, 0, 0.05, 0)
elseif v4 then
	udim = UDim2.new(0, 400, 0, 305)
	udim2 = UDim2.new(0.5, -200, 0, -305)
	udim3 = UDim2.new(0.5, -200, 0.5, -152)
end

local v8 = v3 and 44 or 52
local v9 = (isEnabled or flag) and 42 or 24

local function createFrame(name, size, p, backgroundTransparency, p2)
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Size = size
	frame.Position = p or UDim2.new(0, 0, 0, 0)
	frame.BackgroundTransparency = backgroundTransparency
	frame.BackgroundColor3 = p2 or Color3.new()
	frame.BorderSizePixel = 0
	frame.ZIndex = 8

	return frame
end

local function createTextLabel(name, p, position, font, textSize, text)
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = name
	textLabel.Size = p or UDim2.new(0, 0, 0, 0)
	textLabel.Position = position
	textLabel.BackgroundTransparency = 1
	textLabel.Font = font
	textLabel.TextSize = textSize
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.Text = text
	textLabel.ZIndex = 8

	return textLabel
end

local function createScrollingTextLabel(name, size, position, sourceSansBold, textSize2, mainText, scrollBarThickness)
	local textLabel = createTextLabel(name, size, position, sourceSansBold, textSize2, mainText)
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextYAlignment = Enum.TextYAlignment.Top
	textLabel.TextWrapped = true

	if not (TextService:GetTextSize(mainText, textSize2, sourceSansBold, Vector2.new(size.X.Offset, 10000)).Y > size.Y.Offset) then
		return textLabel
	end

	local vector2 = Vector2.new(size.X.Offset - (scrollBarThickness + 20), 10000)
	local textSize = TextService:GetTextSize(mainText, textSize2, sourceSansBold, vector2)

	local scrollingTextParent = Instance.new("Frame")
	scrollingTextParent.Name = "ScrollingTextParent"
	scrollingTextParent.BackgroundTransparency = 1
	scrollingTextParent.BackgroundColor3 = Color3.new(1, 1, 1)
	scrollingTextParent.BorderSizePixel = 0
	scrollingTextParent.Position = position
	scrollingTextParent.Size = size - UDim2.new(0, scrollBarThickness * 2, 0, 0)

	local scrollingFrame = Instance.new("ScrollingFrame")
	scrollingFrame.Selectable = true
	scrollingFrame.Name = "ScrollingFrame"
	scrollingFrame.BackgroundTransparency = 1
	scrollingFrame.BackgroundColor3 = Color3.new(1, 1, 1)
	scrollingFrame.BorderSizePixel = 0
	scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
	scrollingFrame.Size = size
	scrollingFrame.CanvasSize = UDim2.new(0, vector2.X - scrollBarThickness * 2, 0, textSize.Y)
	scrollingFrame.ScrollBarThickness = scrollBarThickness
	scrollingFrame.SelectionImageObject = Instance.new("ImageLabel")
	scrollingFrame.SelectionImageObject.Name = "EmptySelectionImage"
	scrollingFrame.SelectionImageObject.BackgroundTransparency = 1
	scrollingFrame.SelectionImageObject.Image = ""
	scrollingFrame.Active = false

	scrollingFrame.SelectionGained:connect(function()
		scrollingTextParent.BackgroundTransparency = 0.15
	end)

	scrollingFrame.SelectionLost:connect(function()
		scrollingTextParent.BackgroundTransparency = 1
	end)

	textLabel.Position = UDim2.new(0, 10, 0, 0)
	textLabel.Size = UDim2.new(0, vector2.X, 0, textSize.Y)
	textLabel.Parent = scrollingFrame

	scrollingFrame.Parent = scrollingTextParent

	return scrollingTextParent
end

local function createImageLabel(name, size, position, image, callback) -- 3 equivalent calls inferred from this helper
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = name
	imageLabel.Size = size
	imageLabel.BackgroundTransparency = 1
	imageLabel.Position = position
	imageLabel.Image = image

	if callback then
		callback(imageLabel)
	end

	return imageLabel
end

local function createImageButtonWithText(name, size, position, image, image2, text, font)
	local imageButton = Instance.new("ImageButton")
	imageButton.Name = name
	imageButton.Size = size
	imageButton.Position = position
	imageButton.Image = image
	imageButton.BackgroundTransparency = 1
	imageButton.AutoButtonColor = false
	imageButton.ZIndex = 8
	imageButton.Modal = true
	imageButton.Selectable = true
	imageButton.SelectionImageObject = Instance.new("ImageLabel")
	imageButton.SelectionImageObject.Name = "EmptySelectionImage"
	imageButton.SelectionImageObject.BackgroundTransparency = 1
	imageButton.SelectionImageObject.Image = ""

	local textLabel = createTextLabel(name .. "Text", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), font, v9, text)
	textLabel.ZIndex = 9
	textLabel.Parent = imageButton

	imageButton.MouseEnter:connect(function()
		imageButton.Image = image2
	end)
	imageButton.MouseLeave:connect(function()
		imageButton.Image = image
	end)
	imageButton.MouseButton1Click:connect(function()
		imageButton.Image = image
	end)
	imageButton.SelectionGained:connect(function()
		imageButton.Image = image2
	end)
	imageButton.SelectionLost:connect(function()
		imageButton.Image = image
	end)

	return imageButton
end

local function createPromptDialog()
	parent = createFrame("PromptDialog", udim, udim2, 1, nil)
	parent.Visible = false
	parent.Active = true
	parent.Parent = RobloxGui

	parent2 = createFrame("ContainerFrame", UDim2.new(1, 0, 1, 0), nil, 0.36, Color3.new(0, 0, 0))
	parent2.ZIndex = 8
	parent2.Parent = parent
end

local function destroyPromptDialog() -- 1 equivalent call inferred from this helper
	if parent then
		parent:Destroy()
		parent = nil
		parent2 = nil
	end
end

function AddDefaultsToPromptOptions(p, items)
	for k, item in pairs(items) do
		if p[k] == nil then
			p[k] = item
		end
	end
end

function CreatePromptVRorConsole(data)
	local v10

	if data.ImageConsoleVR then
		local imageLabel = createImageLabel( -- inferred equivalent call
			"Image",
			UDim2.new(0, 600, 0, 600),
			UDim2.new(0, 100, 0, 45),
			data.ImageConsoleVR,
			data.FetchImageFunctionConsoleVR
		)
		imageLabel.ZIndex = 9
		imageLabel.Parent = parent2
		v10 = 800
	else
		v10 = 90
	end

	local textLabel = createTextLabel(
		"WindowTitle",
		UDim2.new(0, 800, 0, 60),
		UDim2.new(0, v10, 0, 60),
		Enum.Font.SourceSansBold,
		48,
		data.WindowTitle
	)
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextYAlignment = Enum.TextYAlignment.Center
	textLabel.Parent = parent2
	textLabel.ZIndex = 9

	local frame = createFrame("ColorStripe", UDim2.new(0, 832, 0, 4), UDim2.new(0, v10, 0, 120), 0, data.StripeColor)
	frame.ZIndex = 9
	frame.Parent = parent2

	local scrollingTextLabel = createScrollingTextLabel(
		"MainText",
		UDim2.new(0, 800, 0, 450),
		UDim2.new(0, v10, 0, 152),
		Enum.Font.SourceSansBold,
		44,
		data.MainText,
		16
	)
	scrollingTextLabel.Parent = parent2

	local rect = Rect.new(8, 8, 56, 56)
	local slice = Enum.ScaleType.Slice

	local imageButtonWithText = createImageButtonWithText(
		"ConfirmButton",
		UDim2.new(0, 320, 0, 80),
		UDim2.new(0, v10, 1, -125),
		"rbxasset://textures/ui/VR/button.png",
		"rbxasset://textures/ui/VR/buttonSelected.png",
		data.ConfirmationText,
		Enum.Font.SourceSans
	)

	imageButtonWithText.Parent = parent2
	imageButtonWithText.ScaleType = slice
	imageButtonWithText.SliceCenter = rect

	imageButtonWithText.MouseButton1Click:connect(function()
		OnPromptEnded(true)
	end)

	if data.CancelActive then
		local imageButtonWithText2 = createImageButtonWithText(
			"CancelButton",
			UDim2.new(0, 320, 0, 80),
			UDim2.new(0, v10 + 340, 1, -125),
			"rbxasset://textures/ui/VR/button.png",
			"rbxasset://textures/ui/VR/buttonSelected.png",
			data.CancelText,
			Enum.Font.SourceSans
		)

		imageButtonWithText2.Parent = parent2
		imageButtonWithText2.ScaleType = slice
		imageButtonWithText2.SliceCenter = rect

		imageButtonWithText2.MouseButton1Click:connect(function()
			OnPromptEnded(false)
		end)
	end
end

function CreatePromptPCorTablet(data)
	local textLabel = createTextLabel(
		"WindowTitle",
		UDim2.new(1, 0, 0, v8),
		UDim2.new(0, 0, 0, 0),
		Enum.Font.SourceSansBold,
		24,
		data.WindowTitle
	)
	textLabel.Parent = parent2
	textLabel.ZIndex = 9

	local frame = createFrame("ColorStripe", UDim2.new(1, 0, 0, 2), nil, 0, data.StripeColor)
	frame.Position = UDim2.new(0, 0, 0, v8)
	frame.ZIndex = 9
	frame.Parent = parent2
	local v10

	if data.Image then
		local imageLabel = createImageLabel( -- inferred equivalent call
			"Image",
			UDim2.new(0, 150, 0, 150),
			UDim2.new(0, 15, 0, v8 + 17),
			data.Image,
			data.FetchImageFunction
		)
		imageLabel.ZIndex = 9
		imageLabel.Parent = parent2

		if v4 then
			v10 = createScrollingTextLabel(
				"MainText",
				UDim2.new(0, 195, 0, 150),
				UDim2.new(0, 185, 0, v8 + 17),
				Enum.Font.SourceSansBold,
				22,
				data.MainText,
				8
			)
		else
			v10 = createScrollingTextLabel(
				"MainText",
				UDim2.new(0, 233, 0, 150),
				UDim2.new(0, 185, 0, v8 + 17),
				Enum.Font.SourceSansBold,
				22,
				data.MainText,
				8
			)
		end
	elseif v4 then
		v10 = createScrollingTextLabel(
			"MainText",
			UDim2.new(0, 360, 0, 150),
			UDim2.new(0, 20, 0, v8 + 17),
			Enum.Font.SourceSansBold,
			22,
			data.MainText,
			8
		)
	else
		v10 = createScrollingTextLabel(
			"MainText",
			UDim2.new(0, 398, 0, 150),
			UDim2.new(0, 20, 0, v8 + 17),
			Enum.Font.SourceSansBold,
			22,
			data.MainText,
			8
		)
	end

	v10.Parent = parent2

	local rect = Rect.new(8, 8, 56, 56)
	local slice = Enum.ScaleType.Slice
	local nextSelectionLeft

	if v4 then
		if data.CancelActive then
			nextSelectionLeft = createImageButtonWithText(
				"ConfirmButton",
				UDim2.new(0, 128, 0, 44),
				UDim2.new(0.5, -138, 1, -59),
				"rbxasset://textures/ui/VR/button.png",
				"rbxasset://textures/ui/VR/buttonSelected.png",
				data.ConfirmationText,
				Enum.Font.SourceSansBold
			)
		else
			nextSelectionLeft = createImageButtonWithText(
				"ConfirmButton",
				UDim2.new(0, 128, 0, 44),
				UDim2.new(0.5, -64, 1, -59),
				"rbxasset://textures/ui/VR/button.png",
				"rbxasset://textures/ui/VR/buttonSelected.png",
				data.ConfirmationText,
				Enum.Font.SourceSans
			)
		end
	elseif data.CancelActive then
		nextSelectionLeft = createImageButtonWithText(
			"ConfirmButton",
			UDim2.new(0, 128, 0, 38),
			UDim2.new(0.5, -138, 1, -53),
			"rbxasset://textures/ui/VR/button.png",
			"rbxasset://textures/ui/VR/buttonSelected.png",
			data.ConfirmationText,
			Enum.Font.SourceSansBold
		)
	else
		nextSelectionLeft = createImageButtonWithText(
			"ConfirmButton",
			UDim2.new(0, 128, 0, 38),
			UDim2.new(0.5, -64, 1, -53),
			"rbxasset://textures/ui/VR/button.png",
			"rbxasset://textures/ui/VR/buttonSelected.png",
			data.ConfirmationText,
			Enum.Font.SourceSans
		)
	end

	nextSelectionLeft.Parent = parent2
	nextSelectionLeft.ScaleType = slice
	nextSelectionLeft.SliceCenter = rect

	nextSelectionLeft.MouseButton1Click:connect(function()
		OnPromptEnded(true)
	end)

	if data.CancelActive then
		local nextSelectionRight

		if v4 then
			nextSelectionRight = createImageButtonWithText(
				"CancelButton",
				UDim2.new(0, 128, 0, 44),
				UDim2.new(0.5, 10, 1, -59),
				"rbxasset://textures/ui/VR/button.png",
				"rbxasset://textures/ui/VR/buttonSelected.png",
				data.CancelText,
				Enum.Font.SourceSans
			)
		else
			nextSelectionRight = createImageButtonWithText(
				"CancelButton",
				UDim2.new(0, 128, 0, 38),
				UDim2.new(0.5, 10, 1, -53),
				"rbxasset://textures/ui/VR/button.png",
				"rbxasset://textures/ui/VR/buttonSelected.png",
				data.CancelText,
				Enum.Font.SourceSans
			)
		end

		nextSelectionRight.Parent = parent2
		nextSelectionRight.ScaleType = slice
		nextSelectionRight.SliceCenter = rect

		nextSelectionRight.MouseButton1Click:connect(function()
			OnPromptEnded(false)
		end)

		nextSelectionRight.NextSelectionLeft = nextSelectionLeft
		nextSelectionLeft.NextSelectionRight = nextSelectionRight
	end
end

function CreatePromptPhone(data)
	local textLabel = createTextLabel(
		"WindowTitle",
		UDim2.new(1, 0, 0, v8),
		UDim2.new(0, 0, 0, 0),
		Enum.Font.SourceSansBold,
		24,
		data.WindowTitle
	)
	textLabel.Parent = parent2
	textLabel.ZIndex = 9

	local frame = createFrame("ColorStripe", UDim2.new(1, 0, 0, 2), nil, 0, data.StripeColor)
	frame.Position = UDim2.new(0, 0, 0, v8)
	frame.ZIndex = 9
	frame.Parent = parent2
	local v10

	if data.Image then
		local imageLabel = createImageLabel( -- inferred equivalent call
			"Image",
			UDim2.new(0, 120, 0, 120),
			UDim2.new(0, 15, 0, v8 + 17),
			data.Image,
			data.FetchImageFunction
		)
		imageLabel.ZIndex = 9
		imageLabel.Parent = parent2

		v10 = createScrollingTextLabel(
			"MainText",
			UDim2.new(0, parent2.AbsoluteSize.X - 175, 0, 120),
			UDim2.new(0, 155, 0, v8 + 17),
			Enum.Font.SourceSansBold,
			20,
			data.MainText,
			8
		)
	else
		v10 = createScrollingTextLabel(
			"MainText",
			UDim2.new(1, parent2.AbsoluteSize.X - 40, 0, 120),
			UDim2.new(0, 20, 0, v8 + 17),
			Enum.Font.SourceSansBold,
			20,
			data.MainText,
			8
		)
	end

	v10.Parent = parent2

	local rect = Rect.new(8, 8, 56, 56)
	local slice = Enum.ScaleType.Slice
	local v11

	if data.CancelActive then
		v11 = createImageButtonWithText(
			"ConfirmButton",
			UDim2.new(0, 128, 0, 44),
			UDim2.new(0.5, -138, 1, -59),
			"rbxasset://textures/ui/VR/button.png",
			"rbxasset://textures/ui/VR/buttonSelected.png",
			data.ConfirmationText,
			Enum.Font.SourceSansBold
		)
	else
		v11 = createImageButtonWithText(
			"ConfirmButton",
			UDim2.new(0, 128, 0, 44),
			UDim2.new(0.5, -64, 1, -59),
			"rbxasset://textures/ui/VR/button.png",
			"rbxasset://textures/ui/VR/buttonSelected.png",
			data.ConfirmationText,
			Enum.Font.SourceSans
		)
	end

	v11.Parent = parent2
	v11.ScaleType = slice
	v11.SliceCenter = rect

	v11.MouseButton1Click:connect(function()
		OnPromptEnded(true)
	end)

	if data.CancelActive then
		local imageButtonWithText = createImageButtonWithText(
			"CancelButton",
			UDim2.new(0, 128, 0, 44),
			UDim2.new(0.5, 10, 1, -59),
			"rbxasset://textures/ui/VR/button.png",
			"rbxasset://textures/ui/VR/buttonSelected.png",
			data.CancelText,
			Enum.Font.SourceSans
		)
		imageButtonWithText.Parent = parent2
		imageButtonWithText.ScaleType = slice
		imageButtonWithText.SliceCenter = rect

		imageButtonWithText.MouseButton1Click:connect(function()
			OnPromptEnded(false)
		end)
	end
end

function CreatePromptFromOptions(p)
	parent2:ClearAllChildren()

	if flag or isEnabled then
		CreatePromptVRorConsole(p)
	elseif v3 then
		CreatePromptPhone(p)
	else
		CreatePromptPCorTablet(p)
	end
end

function SetSelectedObject()
	local cancelButton = parent2:FindFirstChild("CancelButton")

	if cancelButton then
		GuiService.SelectedCoreObject = cancelButton
		return
	end

	local confirmButton = parent2:FindFirstChild("ConfirmButton")

	if confirmButton then
		GuiService.SelectedCoreObject = confirmButton
	end
end

function OnTweenInFinished()
	if v5 or isEnabled then
		SetSelectedObject()
	end
end

function ConnectActiveEvents()
	local function OnInputChanged(data)
		local userInputType = data.UserInputType
		local userInputType2 = Enum.UserInputType

		if
			flag
			or not valueInTable(userInputType, {
				userInputType2.Gamepad1,
				userInputType2.Gamepad2,
				userInputType2.Gamepad3,
				userInputType2.Gamepad4
			})
		then
			v5 = false
		elseif data.KeyCode ~= Enum.KeyCode.Thumbstick1 and data.KeyCode ~= Enum.KeyCode.Thumbstick2 then
			v5 = true
		elseif
			math.abs(data.Position.X) > 0.1
			or math.abs(data.Position.Z) > 0.1
			or math.abs(data.Position.Y) > 0.1
		then
			v5 = true
		end
	end

	table.insert(connections, UserInputService.InputChanged:connect(OnInputChanged))
	table.insert(connections, UserInputService.InputBegan:connect(OnInputChanged))

	table.insert(connections, GuiService.Changed:connect(function(p)
		if flag2 then
			if p == "CoreGuiNavigationEnabled" then
				if GuiService.CoreGuiNavigationEnabled ~= true then
					coreGuiNavigationEnabled = GuiService.CoreGuiNavigationEnabled
					GuiService.CoreGuiNavigationEnabled = true
				end
			elseif p == "GuiNavigationEnabled" then
				if GuiService.GuiNavigationEnabled ~= false then
					guiNavigationEnabled = GuiService.GuiNavigationEnabled
					GuiService.GuiNavigationEnabled = false
				end
			elseif p == "AutoSelectGuiEnabled" and GuiService.AutoSelectGuiEnabled ~= false then
				autoSelectGuiEnabled = GuiService.AutoSelectGuiEnabled
				GuiService.AutoSelectGuiEnabled = false
			end
		end
	end))
end

function DisconnectActiveEvents()
	for _, connection in ipairs(connections) do
		connection:Disconnect()
	end

	connections = {}
end

function ShowPrompt()
	parent.Visible = true

	if isEnabled then
		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
	end

	if flag then
		if not v then
			v = Dialog.new()
		end

		parent.Position = udim3
		v:SetContent(parent)
		v:Show(true)
		DisableControllerMovement()
	else
		parent:TweenPositionInternal(
			udim3,
			Enum.EasingDirection.InOut,
			Enum.EasingStyle.Quad,
			0.3,
			true,
			OnTweenInFinished
		)
		DisableControllerMovement()
		EnableControllerInput()
	end
end

function HidePrompt()
	local function onClosed() -- 1 equivalent call inferred from this helper
		flag2 = false
		GuiService.CoreGuiNavigationEnabled = coreGuiNavigationEnabled
		GuiService.GuiNavigationEnabled = guiNavigationEnabled
		GuiService.AutoSelectGuiEnabled = autoSelectGuiEnabled
		GuiService.SelectedCoreObject = nil

		if isEnabled then
			UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
		end

		if defineFastFlag then
			DisconnectActiveEvents()
			destroyPromptDialog() -- inferred equivalent call
		else
			parent.Visible = false
		end
	end

	if flag then
		parent.Position = udim2

		if v then
			v:Close()
		end

		onClosed() -- inferred equivalent call
	else
		parent:TweenPositionInternal(udim2, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.3, true, onClosed)
	end
end

function DoCreatePrompt(p)
	promptCompletedCallback = p.PromptCompletedCallback
	AddDefaultsToPromptOptions(p, v6)
	v7 = p
	CreatePromptFromOptions(p)
	ShowPrompt()
end

function OnPromptEnded(p)
	if promptCompletedCallback then
		if v7.CancelActive then
			spawn(function()
				promptCompletedCallback(p)
			end)
		else
			spawn(function()
				promptCompletedCallback(true)
			end)
		end
	end

	HidePrompt()
	EnableControllerMovement()
	DisableControllerInput()
end

function NoOpFunc() end

function EnableControllerMovement()
	ContextActionService:UnbindCoreAction("doNothingThumbstick2PromptCreator")
	ContextActionService:UnbindCoreAction("doNothingAButtonPromptCreator")
end

function DisableControllerMovement()
	ContextActionService:BindCoreAction("doNothingThumbstick2PromptCreator", NoOpFunc, false, Enum.KeyCode.Thumbstick2)
	ContextActionService:BindCoreAction("doNothingAButtonPromptCreator", NoOpFunc, false, Enum.KeyCode.ButtonA)
end

function EnableControllerInput()
	ContextActionService:BindCoreAction("CoreScriptPromptCreatorCancel", function(_, p, _)
		if p ~= Enum.UserInputState.Begin then
			return
		end

		if v7.CancelActive then
			OnPromptEnded(false)
		end
	end, false, Enum.KeyCode.ButtonB)

	ContextActionService:BindCoreAction("CoreScriptPromptCreatorSelect", function(_, p, _)
		if p ~= Enum.UserInputState.Begin then
			return
		end

		if GuiService.SelectedCoreObject == nil then
			SetSelectedObject()
		end
	end, false, Enum.KeyCode.ButtonSelect)
end

function DisableControllerInput()
	ContextActionService:UnbindCoreAction("CoreScriptPromptCreatorCancel")
	ContextActionService:UnbindCoreAction("CoreScriptPromptCreatorSelect")
end

function valueInTable(p, items): boolean
	for _, item in pairs(items) do
		if item == p then
			return true
		end
	end

	return false
end

function SetupGamepadSelection()
	coreGuiNavigationEnabled = GuiService.CoreGuiNavigationEnabled
	guiNavigationEnabled = GuiService.GuiNavigationEnabled
	autoSelectGuiEnabled = GuiService.AutoSelectGuiEnabled

	GuiService.SelectedCoreObject = nil
	GuiService.CoreGuiNavigationEnabled = true
	GuiService.GuiNavigationEnabled = false
	GuiService.AutoSelectGuiEnabled = false
end

if not defineFastFlag then
	createPromptDialog()

	local function OnInputChanged(data)
		local userInputType = data.UserInputType
		local userInputType2 = Enum.UserInputType

		if
			flag
			or not valueInTable(userInputType, {
				userInputType2.Gamepad1,
				userInputType2.Gamepad2,
				userInputType2.Gamepad3,
				userInputType2.Gamepad4
			})
		then
			v5 = false
		elseif data.KeyCode ~= Enum.KeyCode.Thumbstick1 and data.KeyCode ~= Enum.KeyCode.Thumbstick2 then
			v5 = true
		elseif
			math.abs(data.Position.X) > 0.1
			or math.abs(data.Position.Z) > 0.1
			or math.abs(data.Position.Y) > 0.1
		then
			v5 = true
		end
	end
	UserInputService.InputChanged:connect(OnInputChanged)
	UserInputService.InputBegan:connect(OnInputChanged)

	local function OnVREnabled(vrEnabled) -- 2 equivalent calls inferred from this helper
		if vrEnabled then
			if not v then
				v = Dialog.new()
			end

			v:SetContent(parent)
			flag = true
		else
			flag = false

			if v then
				v:SetContent(nil)
			end

			parent.Parent = RobloxGui
		end
	end

	spawn(function()
		OnVREnabled(UserInputService.VREnabled) -- inferred equivalent call
	end)

	UserInputService.Changed:connect(function(p)
		if p == "VREnabled" then
			OnVREnabled(UserInputService.VREnabled) -- inferred equivalent call
		end
	end)

	GuiService.Changed:connect(function(p)
		if flag2 then
			if p == "CoreGuiNavigationEnabled" then
				if GuiService.CoreGuiNavigationEnabled ~= true then
					coreGuiNavigationEnabled = GuiService.CoreGuiNavigationEnabled
					GuiService.CoreGuiNavigationEnabled = true
				end
			elseif p == "GuiNavigationEnabled" then
				if GuiService.GuiNavigationEnabled ~= false then
					guiNavigationEnabled = GuiService.GuiNavigationEnabled
					GuiService.GuiNavigationEnabled = false
				end
			elseif p == "AutoSelectGuiEnabled" and GuiService.AutoSelectGuiEnabled ~= false then
				autoSelectGuiEnabled = GuiService.AutoSelectGuiEnabled
				GuiService.AutoSelectGuiEnabled = false
			end
		end
	end)
end

function PromptCreator.CreatePrompt(_, p): boolean
	if flag2 then
		return false
	end

	flag2 = true

	if defineFastFlag then
		createPromptDialog()
		ConnectActiveEvents()
	end

	SetupGamepadSelection()
	DoCreatePrompt(p)
	return true
end

function PromptCreator.IsCurrentlyPrompting(_)
	return flag2
end

return PromptCreator
