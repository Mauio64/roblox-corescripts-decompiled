local v = {
	[Enum.DialogPurpose.Quest] = { "rbxasset://textures/ui/dialog_purpose_quest.png", Vector2.new(10, 34) },
	[Enum.DialogPurpose.Help] = { "rbxasset://textures/ui/dialog_purpose_help.png", Vector2.new(20, 35) },
	[Enum.DialogPurpose.Shop] = { "rbxasset://textures/ui/dialog_purpose_shop.png", Vector2.new(22, 43) }
}

local fontSize = Enum.FontSize.Size24

local vector2 = Vector2.new(80, 90)

local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local LocalPlayer = Players.LocalPlayer
local flag = false
local v2 = 24
local v3 = 350
local v4 = false

while LocalPlayer == nil do
	Players.PlayerAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local v5 = LocalPlayer.Character

if not v5 or v5.Parent == nil then
	v5 = LocalPlayer.CharacterAdded:Wait()
end

LocalPlayer.CharacterAdded:Connect(function(character)
	v5 = character
end)

function setUsingGamepad(p, _)
	if
		p.UserInputType == Enum.UserInputType.Gamepad1
		or p.UserInputType == Enum.UserInputType.Gamepad2
		or p.UserInputType == Enum.UserInputType.Gamepad3
		or p.UserInputType == Enum.UserInputType.Gamepad4
	then
		flag = true
	else
		flag = false
	end
end

local UserInputService2 = game:GetService("UserInputService")
UserInputService2.InputBegan:Connect(setUsingGamepad)
local UserInputService3 = game:GetService("UserInputService")
UserInputService3.InputChanged:Connect(setUsingGamepad)

local userDialogArea = nil
local v6 = {}
local v7 = nil
local v8 = {}
local v9 = nil
local v10 = nil

local v11 = {}
local thread = nil

local CoreGui = game:GetService("CoreGui")
game:GetService("CorePackages")
local parent2 = CoreGui.RobloxGui
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local SetDialogInUse = RobloxReplicatedStorage:WaitForChild("SetDialogInUse", 1e999)

local chatNotificationGui = nil
local dialogScriptMessage = nil
local v12 = {}
local v13 = {}
local touchControlFrame = nil
local flag2 = false

local TenFootInterface = require(parent2.Modules.TenFootInterface)
local isEnabled = TenFootInterface:IsEnabled()
local Utility = require(parent2.Modules.Settings.Utility)
local GameTranslator = require(parent2.Modules.GameTranslator)
local isSmallTouchScreen = Utility:IsSmallTouchScreen()

if isEnabled then
	fontSize = Enum.FontSize.Size36
	v2 = 36
	v3 = 500
elseif isSmallTouchScreen then
	fontSize = Enum.FontSize.Size14
	v2 = 14
	v3 = 250
end

if parent2:FindFirstChild("ControlFrame") then
	parent2 = parent2.ControlFrame
end

local UserInputService4 = game:GetService("UserInputService")
local TouchEnabled = UserInputService4.TouchEnabled

local function isDialogMultiplePlayers(p) -- 3 equivalent calls inferred from this helper
	local success, result = pcall(function(): boolean
		return p.BehaviorType == Enum.DialogBehaviorType.MultiplePlayers
	end)
	return success and result or false
end

function currentTone()
	return if v9 then v9.Tone else Enum.DialogTone.Neutral
end

function createChatNotificationGui()
	chatNotificationGui = Instance.new("BillboardGui")
	chatNotificationGui.Name = "ChatNotificationGui"
	chatNotificationGui.ExtentsOffset = Vector3.new(0, 1, 0)
	chatNotificationGui.Size = UDim2.new(vector2.X / 31.5, 0, vector2.Y / 31.5, 0)
	chatNotificationGui.SizeOffset = Vector2.new(0, 0)
	chatNotificationGui.StudsOffset = Vector3.new(0, 3.7, 0)
	chatNotificationGui.Enabled = true
	chatNotificationGui.RobloxLocked = true
	chatNotificationGui.Active = true

	local background = Instance.new("ImageButton")
	background.Name = "Background"
	background.Active = false
	background.BackgroundTransparency = 1
	background.Position = UDim2.new(0, 0, 0, 0)
	background.Size = UDim2.new(1, 0, 1, 0)
	background.Image = ""
	background.Parent = chatNotificationGui

	local icon = Instance.new("ImageLabel")
	icon.Name = "Icon"
	icon.Position = UDim2.new(0, 0, 0, 0)
	icon.Size = UDim2.new(1, 0, 1, 0)
	icon.Image = ""
	icon.BackgroundTransparency = 1
	icon.Parent = background

	local activationButton = Instance.new("ImageLabel")
	activationButton.Name = "ActivationButton"
	activationButton.Position = UDim2.new(-0.3, 0, -0.4, 0)
	activationButton.Size = UDim2.new(0.8, 0, 0.8 * (vector2.X / vector2.Y), 0)
	activationButton.Image = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonX)
	activationButton.BackgroundTransparency = 1
	activationButton.Visible = false
	activationButton.Parent = background
end

function getChatColor(p)
	if p == Enum.DialogTone.Neutral then
		return Enum.ChatColor.Blue
	end

	if p == Enum.DialogTone.Friendly then
		return Enum.ChatColor.Green
	end

	if p == Enum.DialogTone.Enemy then
		return Enum.ChatColor.Red
	end
end

function styleChoices()
	for _, v14 in pairs(v6) do
		v14.BackgroundTransparency = 1
	end

	v7.BackgroundTransparency = 1
end

function styleMainFrame(p)
	if p == Enum.DialogTone.Neutral then
		userDialogArea.Style = Enum.FrameStyle.ChatBlue
	elseif p == Enum.DialogTone.Friendly then
		userDialogArea.Style = Enum.FrameStyle.ChatGreen
	elseif p == Enum.DialogTone.Enemy then
		userDialogArea.Style = Enum.FrameStyle.ChatRed
	end

	styleChoices()
end
function setChatNotificationTone(p, p2, p3)
	if p3 == Enum.DialogTone.Neutral then
		p.Background.Image = "rbxasset://textures/ui/chatBubble_blue_notify_bkg.png"
	elseif p3 == Enum.DialogTone.Friendly then
		p.Background.Image = "rbxasset://textures/ui/chatBubble_green_notify_bkg.png"
	elseif p3 == Enum.DialogTone.Enemy then
		p.Background.Image = "rbxasset://textures/ui/chatBubble_red_notify_bkg.png"
	end

	local image, v14 = unpack(v[p2])
	local v15 = v14 / vector2
	p.Background.Icon.Size = UDim2.new(v15.X, 0, v15.Y, 0)
	p.Background.Icon.Position = UDim2.new(0.5 - v15.X / 2, 0, 0.4 - v15.Y / 2, 0)
	p.Background.Icon.Image = image
end

function createMessageDialog()
	dialogScriptMessage = Instance.new("Frame")
	dialogScriptMessage.Name = "DialogScriptMessage"
	dialogScriptMessage.Style = Enum.FrameStyle.Custom
	dialogScriptMessage.BackgroundTransparency = 0.5
	dialogScriptMessage.BackgroundColor3 = Color3.new(31 / 255, 31 / 255, 31 / 255)
	dialogScriptMessage.Visible = false
	dialogScriptMessage.RobloxLocked = true

	local text = Instance.new("TextLabel")
	text.Name = "Text"
	text.Position = UDim2.new(0, 0, 0, -1)
	text.Size = UDim2.new(1, 0, 1, 0)
	text.FontSize = Enum.FontSize.Size14
	text.BackgroundTransparency = 1
	text.TextColor3 = Color3.new(1, 1, 1)
	text.Parent = dialogScriptMessage
end

function showMessage(text, p)
	dialogScriptMessage.Text.Text = text
	dialogScriptMessage.Size = UDim2.new(0, p, 0, 40)
	dialogScriptMessage.Position = UDim2.new(0.5, -p / 2, 0.5, -40)
	dialogScriptMessage.Visible = true
	wait(2)
	dialogScriptMessage.Visible = false
end

function variableDelay(value)
	local v14 = math.min(string.len(value), 100)
	wait(v14 / 75 * 1.5 + 0.75)
end

function resetColor(p)
	p.BackgroundTransparency = 1
end

function wanderDialog()
	userDialogArea.Visible = false
	endDialog()
	showMessage("Chat ended because you walked away", 350)
end

function timeoutDialog()
	userDialogArea.Visible = false
	endDialog()
	showMessage("Chat ended because you didn't reply", 350)
end

function normalEndDialog()
	endDialog()
end

function endDialog()
	if thread then
		v11[thread] = false
		thread = nil
	end

	local v14 = v9
	v9 = nil

	if v14 and v14.InUse then
		delay(5, function()
			SetDialogInUse:FireServer(v14, false)
			v14.InUse = false
		end)
	end

	for k, v15 in pairs(v12) do
		if k and v15 then
			v15.Enabled = not k.InUse
		end
	end

	ContextActionService:UnbindCoreAction("Nothing")
	v10 = nil

	if touchControlFrame then
		touchControlFrame.Visible = true
	end

	if flag2 then
		parent2.BottomLeftControl.Visible = false
	end

	if GuiService.SelectedCoreObject and GuiService.SelectedCoreObject.Parent == userDialogArea then
		GuiService.SelectedCoreObject = nil
	end
end

function sanitizeMessage(value)
	return if string.len(value) == 0 then "..." else value
end

local function chatFunc(p, ...)
	if isDialogMultiplePlayers(p) then -- inferred equivalent call
		local Chat = game:GetService("Chat")
		Chat:ChatLocal(...)
	else
		local Chat = game:GetService("Chat")
		Chat:Chat(...)
	end
end

function selectChoice(p)
	if not v9 then
		return
	end

	renewKillswitch(v9)

	if not v5:FindFirstAncestorOfClass("Workspace") then
		return
	end

	userDialogArea.Visible = false

	if p == v7 then
		chatFunc(v9, v5, v7.UserPrompt.Text, getChatColor(currentTone()))

		normalEndDialog()
	else
		local v14 = v8[p]

		chatFunc(v9, v5, sanitizeMessage(v14.UserDialog), getChatColor(currentTone()))
		wait(1)

		if not v9 then
			return
		end

		v9:SignalDialogChoiceSelected(LocalPlayer, v14)
		chatFunc(v9, v10, sanitizeMessage(v14.ResponseDialog), getChatColor(currentTone()))

		variableDelay(v14.ResponseDialog)
		presentDialogChoices(v10, v14:GetChildren(), v14)
	end
end

function newChoice()
	local frame = Instance.new("Frame")
	frame.Visible = false

	local textButton = Instance.new("TextButton")
	textButton.BackgroundColor3 = Color3.new(227 / 255, 227 / 255, 227 / 255)
	textButton.BackgroundTransparency = 1
	textButton.AutoButtonColor = false
	textButton.BorderSizePixel = 0
	textButton.Text = ""
	textButton.MouseEnter:connect(function()
		textButton.BackgroundTransparency = 0
	end)
	textButton.MouseLeave:connect(function()
		textButton.BackgroundTransparency = 1
	end)
	textButton.SelectionImageObject = frame
	textButton.Activated:connect(function()
		selectChoice(textButton)
	end)
	textButton.RobloxLocked = true

	local userPrompt = Instance.new("TextLabel")

	userPrompt.AutoLocalize = false
	userPrompt.Name = "UserPrompt"
	userPrompt.BackgroundTransparency = 1
	userPrompt.Font = Enum.Font.SourceSans
	userPrompt.FontSize = fontSize
	userPrompt.Position = UDim2.new(0, 40, 0, 0)
	userPrompt.Size = UDim2.new(1, -72, 1, 0)
	userPrompt.TextXAlignment = Enum.TextXAlignment.Left
	userPrompt.TextYAlignment = Enum.TextYAlignment.Center
	userPrompt.TextWrap = true
	userPrompt.Parent = textButton

	local rbXchatDialogSelectionButton = Instance.new("ImageLabel")
	rbXchatDialogSelectionButton.Name = "RBXchatDialogSelectionButton"
	rbXchatDialogSelectionButton.Position = UDim2.new(0, 0, 0.5, -16.5)
	rbXchatDialogSelectionButton.Size = UDim2.new(0, 33, 0, 33)
	rbXchatDialogSelectionButton.Image = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonA)
	rbXchatDialogSelectionButton.BackgroundTransparency = 1
	rbXchatDialogSelectionButton.Visible = false
	rbXchatDialogSelectionButton.Parent = textButton

	return textButton
end

function initialize(parent)
	v6[1] = newChoice()
	v6[2] = newChoice()
	v6[3] = newChoice()
	v6[4] = newChoice()

	v7 = newChoice()
	v7.UserPrompt.Text = "Goodbye!"
	v7.Size = UDim2.new(1, 28, 0, v2 + 12)

	userDialogArea = Instance.new("Frame")
	userDialogArea.Name = "UserDialogArea"
	userDialogArea.Size = UDim2.new(0, v3, 0, 200)
	userDialogArea.Style = Enum.FrameStyle.ChatBlue
	userDialogArea.Visible = false

	for _, v14 in pairs(v6) do
		v14.RobloxLocked = true
		v14.Parent = userDialogArea
	end

	v7.RobloxLocked = true
	v7.Parent = userDialogArea

	userDialogArea.RobloxLocked = true
	userDialogArea.Parent = parent
end

function presentDialogChoices(p, items, p2)
	if not v9 then
		return
	end

	v10 = p
	local dialogChoices = {}

	for _, dialogChoice in pairs(items) do
		if dialogChoice:IsA("DialogChoice") then
			table.insert(dialogChoices, dialogChoice)
		end
	end

	table.sort(dialogChoices, function(a, b): boolean
		return a.Name < b.Name
	end)

	if #dialogChoices == 0 then
		normalEndDialog()
		return
	end

	local v14 = 1
	local v15 = 0
	v8 = {}

	for _, v16 in pairs(v6) do
		v16.Visible = false
	end

	for _, v16 in pairs(dialogChoices) do
		if not (v14 <= #v6) then
			continue
		end

		v6[v14].Size = UDim2.new(1, 28, 0, v2 * 3)
		GameTranslator:TranslateAndRegister(v6[v14].UserPrompt, v16, v16.UserDialog)
		local v17 = math.ceil(v6[v14].UserPrompt.TextBounds.Y / v2) * v2 + 12

		v6[v14].Position = UDim2.new(0, -11, 0, v15 + -8)
		v6[v14].Size = UDim2.new(1, 28, 0, v17)
		v6[v14].Visible = true

		v8[v6[v14]] = v16

		v15 = v15 + v17 + 1
		v14 += 1
	end

	v7.Size = UDim2.new(1, 28, 0, v2 * 3)
	v7.UserPrompt.Text = p2.GoodbyeDialog == "" and "Goodbye!" or p2.GoodbyeDialog
	local v16 = math.ceil(v7.UserPrompt.TextBounds.Y / v2) * v2 + 12
	v7.Size = UDim2.new(1, 28, 0, v16)
	v7.Position = UDim2.new(0, -11, 0, v15 + -8)
	v7.Visible = true

	if p2.GoodbyeChoiceActive then
		userDialogArea.Size = UDim2.new(0, v3, 0, v15 + v7.AbsoluteSize.Y + 34 + -16)
	else
		v7.Visible = false
		userDialogArea.Size = UDim2.new(0, v3, 0, v15 + 34 + -16)
	end

	userDialogArea.Position = UDim2.new(0, 20, 1, -userDialogArea.Size.Y.Offset - 20)

	if isSmallTouchScreen then
		local touchGui = LocalPlayer.PlayerGui:FindFirstChild("TouchGui")

		if touchGui then
			touchControlFrame = touchGui:FindFirstChild("TouchControlFrame")

			if touchControlFrame then
				touchControlFrame.Visible = false
			end
		end

		userDialogArea.Position = UDim2.new(0, 10, 1, -userDialogArea.Size.Y.Offset)
	elseif not (TouchEnabled or parent2.BottomLeftControl.Visible) then
		parent2.BottomLeftControl.Visible = true
		flag2 = true
	end

	styleMainFrame(currentTone())
	userDialogArea.Visible = true

	if flag then
		local GuiService2 = game:GetService("GuiService")
		GuiService2.SelectedCoreObject = v6[1]
	end
end

function doDialog(instance)
	if instance.InitialPrompt == "" then
		warn("Can't start a dialog with an empty InitialPrompt")
		return
	end

	local success, result = pcall(function(): boolean
		return instance.BehaviorType == Enum.DialogBehaviorType.MultiplePlayers
	end)

	if instance.InUse and not (success and result) then
		return
	end

	v9 = instance
	instance.InUse = true

	ContextActionService:BindCoreAction(
		"Nothing",
		function() end,
		false,
		Enum.UserInputType.Gamepad1,
		Enum.UserInputType.Gamepad2,
		Enum.UserInputType.Gamepad3,
		Enum.UserInputType.Gamepad4
	)

	SetDialogInUse:FireServer(instance, true)

	chatFunc(instance, instance.Parent, instance.InitialPrompt, getChatColor(instance.Tone))
	variableDelay(instance.InitialPrompt)

	presentDialogChoices(instance.Parent, instance:GetChildren(), instance)
end

function renewKillswitch(p)
	if thread then
		v11[thread] = false
		thread = nil
	end

	thread = coroutine.create(function(p2)
		wait(15)

		if p2 ~= nil then
			if v11[p2] == nil then
				SetDialogInUse:FireServer(p, false)
				p.InUse = false
			end

			v11[p2] = nil
		end
	end)
	coroutine.resume(thread, thread)
end

function checkForLeaveArea()
	while v9 do
		if v9.Parent and LocalPlayer:DistanceFromCharacter(v9.Parent.Position) >= v9.ConversationDistance then
			wanderDialog()
		end

		wait(1)
	end
end

function startDialog(p)
	if p.Parent and p.Parent:IsA("BasePart") then
		RbxAnalyticsService:TrackEvent("Dialogue", "Old Dialogue", "Conversation Initiated")

		if LocalPlayer:DistanceFromCharacter(p.Parent.Position) >= p.ConversationDistance then
			showMessage("You are too far away to chat!", 300)
			return
		end

		for k, v14 in pairs(v12) do
			if k and v14 then
				v14.Enabled = false
			end
		end

		renewKillswitch(p)

		delay(1, checkForLeaveArea)
		doDialog(p)
	end
end

function removeDialog(p)
	if v12[p] then
		v12[p]:Destroy()
		v12[p] = nil
	end

	if v13[p] then
		v13[p]:disconnect()
		v13[p] = nil
	end
end

function addDialog(instance)
	if instance.Parent then
		if instance.Parent:IsA("BasePart") and instance:IsDescendantOf(game.Workspace) then
			v4 = true
			RbxAnalyticsService:TrackEvent("Dialogue", "Old Dialogue", "Used In Place", nil, game.PlaceId)

			local clone = chatNotificationGui:clone()
			clone.Adornee = instance.Parent
			clone.RobloxLocked = true
			clone.Enabled = not instance.InUse or isDialogMultiplePlayers(instance) -- inferred equivalent call
			clone.Parent = CoreGui

			clone.Background.MouseButton1Click:connect(function()
				startDialog(instance)
			end)
			setChatNotificationTone(clone, instance.Purpose, instance.Tone)

			if game:GetEngineFeature("ClosestVisibleDialogAPI") then
				instance:SetGuiObject(clone)
			end

			v12[instance] = clone

			v13[instance] = instance.Changed:connect(function(p)
				if p == "Parent" and instance.Parent then
					removeDialog(instance)
					addDialog(instance)
				elseif p == "InUse" then
					if isDialogMultiplePlayers(instance) then -- inferred equivalent call
						clone.Enabled = v9 ~= instance
					else
						clone.Enabled = v9 == nil and not instance.InUse
					end

					if not instance.InUse then
						local v14 = instance
						local success, result = pcall(function(): boolean
							return v14.BehaviorType == Enum.DialogBehaviorType.MultiplePlayers
						end)

						if not (success and result) and instance == v9 then
							timeoutDialog()
						end
					end
				elseif p == "Tone" or p == "Purpose" then
					setChatNotificationTone(clone, instance.Purpose, instance.Tone)
				end
			end)
		else
			v13[instance] = instance.Changed:connect(function(p)
				if p == "Parent" and instance.Parent then
					removeDialog(instance)
					addDialog(instance)
				end
			end)
		end
	end
end

function onLoad()
	createChatNotificationGui()

	createMessageDialog()
	dialogScriptMessage.RobloxLocked = true
	dialogScriptMessage.Parent = parent2

	parent2:WaitForChild("BottomLeftControl")

	local dialogFrame = Instance.new("Frame")
	dialogFrame.Name = "DialogFrame"
	dialogFrame.Position = UDim2.new(0, 0, 0, 0)
	dialogFrame.Size = UDim2.new(0, 0, 0, 0)
	dialogFrame.BackgroundTransparency = 1
	dialogFrame.RobloxLocked = true

	local GuiService2 = game:GetService("GuiService")
	GuiService2:AddSelectionParent("RBXDialogGroup", dialogFrame)

	if TouchEnabled and not isSmallTouchScreen then
		dialogFrame.Position = UDim2.new(0, 20, 0.5, 0)
		dialogFrame.Size = UDim2.new(0.25, 0, 0.1, 0)
		dialogFrame.Parent = parent2
	elseif isSmallTouchScreen then
		dialogFrame.Position = UDim2.new(0, 0, 0.9, -10)
		dialogFrame.Size = UDim2.new(0.25, 0, 0.1, 0)
		dialogFrame.Parent = parent2
	else
		dialogFrame.Parent = parent2.BottomLeftControl
	end

	initialize(dialogFrame)

	local CollectionService = game:GetService("CollectionService")
	CollectionService.ItemAdded:Connect(function(dialog)
		if dialog:IsA("Dialog") then
			addDialog(dialog)
		end
	end)
	local CollectionService2 = game:GetService("CollectionService")
	CollectionService2.ItemRemoved:Connect(function(dialog)
		if dialog:IsA("Dialog") then
			removeDialog(dialog)
		end
	end)
	local CollectionService3 = game:GetService("CollectionService")

	for _, dialog in pairs(CollectionService3:GetCollection("Dialog")) do
		if dialog:IsA("Dialog") then
			addDialog(dialog)
		end
	end
end

function getLocalHumanoidRootPart()
	if LocalPlayer.Character then
		return LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	end
end

function dialogIsValid(p)
	return p and p.Parent and p.Parent:IsA("BasePart")
end

local v14 = nil
local GetClosestDialogToPosition = GuiService.GetClosestDialogToPosition

local RunService = game:GetService("RunService")
RunService.Heartbeat:Connect(function()
	local localHumanoidRootPart = getLocalHumanoidRootPart()
	local v15

	if localHumanoidRootPart then
		v15 = GetClosestDialogToPosition(GuiService, localHumanoidRootPart.Position)
	else
		v15 = nil
	end

	if getLocalHumanoidRootPart() and dialogIsValid(v15) and v9 == nil then
		local triggerDistance = v15.TriggerDistance
		local triggerOffset = v15.TriggerOffset

		local distanceFromCharacter = LocalPlayer:DistanceFromCharacter(v15.Parent.Position + triggerOffset)

		if
			triggerDistance ~= 0
			and distanceFromCharacter < v15.ConversationDistance
			and distanceFromCharacter < triggerDistance
		then
			startDialog(v15)
		end
	end

	if flag == true then
		if localHumanoidRootPart and game:GetEngineFeature("ClosestVisibleDialogAPI") then
			local position = localHumanoidRootPart.Position
			v15 = GuiService.GetClosestVisibleDialogToPosition(GuiService, position)
		end

		if v15 ~= v14 then
			if v12[v14] then
				v12[v14].Background.ActivationButton.Visible = false
			end

			v14 = v15
			ContextActionService:UnbindCoreAction("StartDialogAction")

			if v15 ~= nil then
				ContextActionService:BindCoreAction("StartDialogAction", function(_, p, _)
					if p == Enum.UserInputState.Begin and v15 and v15.Parent then
						startDialog(v15)
					end
				end, false, Enum.KeyCode.ButtonX)

				if v12[v15] then
					v12[v15].Background.ActivationButton.Visible = true
				end
			end
		end
	end
end)

local selectedCoreObject = nil

GuiService.Changed:connect(function(p)
	if p == "SelectedCoreObject" then
		if selectedCoreObject and selectedCoreObject:FindFirstChild("RBXchatDialogSelectionButton") then
			local rbXchatDialogSelectionButton = selectedCoreObject:FindFirstChild("RBXchatDialogSelectionButton")
			rbXchatDialogSelectionButton.Visible = false
			selectedCoreObject.BackgroundTransparency = 1
		end

		selectedCoreObject = GuiService.SelectedCoreObject

		if selectedCoreObject and selectedCoreObject:FindFirstChild("RBXchatDialogSelectionButton") then
			local rbXchatDialogSelectionButton = selectedCoreObject:FindFirstChild("RBXchatDialogSelectionButton")
			rbXchatDialogSelectionButton.Visible = true
			selectedCoreObject.BackgroundTransparency = 0
		end
	end
end)

onLoad()
