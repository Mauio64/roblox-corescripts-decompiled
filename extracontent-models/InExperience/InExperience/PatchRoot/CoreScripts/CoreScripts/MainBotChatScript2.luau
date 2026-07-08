local t1 = {
	[Enum.DialogPurpose.Quest] = {
		"rbxasset://textures/ui/dialog_purpose_quest.png",
		Vector2.new(10, 34)
	},
	[Enum.DialogPurpose.Help] = {
		"rbxasset://textures/ui/dialog_purpose_help.png",
		Vector2.new(20, 35)
	},
	[Enum.DialogPurpose.Shop] = {
		"rbxasset://textures/ui/dialog_purpose_shop.png",
		Vector2.new(22, 43)
	}
}
local n1 = 24
local Size24 = Enum.FontSize.Size24
local vector2 = Vector2.new(80, 90)
local n2 = 350
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local u11 = false
local u12 = false
local LocalPlayer = Players.LocalPlayer

while LocalPlayer == nil do
	Players.PlayerAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local Character = LocalPlayer.Character

if not Character or Character.Parent == nil then
	Character = LocalPlayer.CharacterAdded:Wait()
end

LocalPlayer.CharacterAdded:Connect(function(character) -- line: 48
	-- upvalues: Character (ref)
	Character = character
end)

function setUsingGamepad(p1, _) -- line: 52
	-- upvalues: u11 (ref)
	if p1.UserInputType == Enum.UserInputType.Gamepad1 or (p1.UserInputType == Enum.UserInputType.Gamepad2 or p1.UserInputType == Enum.UserInputType.Gamepad3 or p1.UserInputType == Enum.UserInputType.Gamepad4) then
		u11 = true

		return
	end

	u11 = false
end

game:GetService("UserInputService").InputBegan:Connect(setUsingGamepad)
game:GetService("UserInputService").InputChanged:Connect(setUsingGamepad)

local Frame = nil
local t2 = {}
local u17 = nil
local t3 = {}
local u19 = nil
local u20 = nil
local t4 = {}
local u22 = nil
local CoreGui = game:GetService("CoreGui")

game:GetService("CorePackages")

local RobloxGui = CoreGui.RobloxGui
local SetDialogInUse = game:GetService("RobloxReplicatedStorage"):WaitForChild("SetDialogInUse", 1e999)
local BillboardGui = nil
local Frame2 = nil
local t5 = {}
local t6 = {}
local TouchControlFrame = nil
local u31 = false
local v32 = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
local Utility = require(RobloxGui.Modules.Settings.Utility)
local GameTranslator = require(RobloxGui.Modules.GameTranslator)
local v35 = Utility:IsSmallTouchScreen()

if v32 then
	Size24 = Enum.FontSize.Size36
	n1 = 36
	n2 = 500
elseif v35 then
	Size24 = Enum.FontSize.Size14
	n1 = 14
	n2 = 250
end

local u36 = if not RobloxGui:FindFirstChild("ControlFrame") then RobloxGui else RobloxGui.ControlFrame
local TouchEnabled = game:GetService("UserInputService").TouchEnabled

local function isDialogMultiplePlayers(p3) -- line: 118
	local ok, result = pcall(function() -- line: 119
		-- upvalues: p3 (copy)
		return p3.BehaviorType == Enum.DialogBehaviorType.MultiplePlayers
	end)

	return not not ok and (result or false)
end

function currentTone() -- line: 123
	-- upvalues: u19 (ref)
	if u19 then
		return u19.Tone
	end

	return Enum.DialogTone.Neutral
end
function createChatNotificationGui() -- line: 132
	-- upvalues: BillboardGui (ref), vector2 (copy), UserInputService (copy)
	BillboardGui = Instance.new("BillboardGui")
	BillboardGui.Name = "ChatNotificationGui"
	BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
	BillboardGui.Size = UDim2.new(vector2.X / 31.5, 0, vector2.Y / 31.5, 0)
	BillboardGui.SizeOffset = Vector2.new(0, 0)
	BillboardGui.StudsOffset = Vector3.new(0, 3.700000047683716, 0)
	BillboardGui.Enabled = true
	BillboardGui.RobloxLocked = true
	BillboardGui.Active = true

	local ImageButton = Instance.new("ImageButton")

	ImageButton.Name = "Background"
	ImageButton.Active = false
	ImageButton.BackgroundTransparency = 1
	ImageButton.Position = UDim2.new(0, 0, 0, 0)
	ImageButton.Size = UDim2.new(1, 0, 1, 0)
	ImageButton.Image = ""
	ImageButton.Parent = BillboardGui

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Name = "Icon"
	ImageLabel.Position = UDim2.new(0, 0, 0, 0)
	ImageLabel.Size = UDim2.new(1, 0, 1, 0)
	ImageLabel.Image = ""
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Parent = ImageButton

	local ImageLabel2 = Instance.new("ImageLabel")

	ImageLabel2.Name = "ActivationButton"
	ImageLabel2.Position = UDim2.new(-0.3, 0, -0.4, 0)
	ImageLabel2.Size = UDim2.new(0.8, 0, 0.8 * (vector2.X / vector2.Y), 0)
	ImageLabel2.Image = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonX)
	ImageLabel2.BackgroundTransparency = 1
	ImageLabel2.Visible = false
	ImageLabel2.Parent = ImageButton
end
function getChatColor(p4) -- line: 170
	if p4 == Enum.DialogTone.Neutral then
		return Enum.ChatColor.Blue
	end

	if p4 == Enum.DialogTone.Friendly then
		return Enum.ChatColor.Green
	end

	if p4 == Enum.DialogTone.Enemy then
		return Enum.ChatColor.Red
	end
end
function styleChoices() -- line: 180
	-- upvalues: t2 (copy), u17 (ref)
	for _, v in pairs(t2) do
		v.BackgroundTransparency = 1
	end

	u17.BackgroundTransparency = 1
end
function styleMainFrame(p5) -- line: 187
	-- upvalues: Frame (ref)
	if p5 == Enum.DialogTone.Neutral then
		Frame.Style = Enum.FrameStyle.ChatBlue
	elseif p5 == Enum.DialogTone.Friendly then
		Frame.Style = Enum.FrameStyle.ChatGreen
	elseif p5 == Enum.DialogTone.Enemy then
		Frame.Style = Enum.FrameStyle.ChatRed
	end

	styleChoices()
end
function setChatNotificationTone(p6, p7, p8) -- line: 198
	-- upvalues: t1 (copy), vector2 (copy)
	if p8 == Enum.DialogTone.Neutral then
		p6.Background.Image = "rbxasset://textures/ui/chatBubble_blue_notify_bkg.png"
	elseif p8 == Enum.DialogTone.Friendly then
		p6.Background.Image = "rbxasset://textures/ui/chatBubble_green_notify_bkg.png"
	elseif p8 == Enum.DialogTone.Enemy then
		p6.Background.Image = "rbxasset://textures/ui/chatBubble_red_notify_bkg.png"
	end

	local v59, v60 = unpack(t1[p7])
	local v61 = v60 / vector2

	p6.Background.Icon.Size = UDim2.new(v61.X, 0, v61.Y, 0)
	p6.Background.Icon.Position = UDim2.new(0.5 - v61.X / 2, 0, 0.4 - v61.Y / 2, 0)
	p6.Background.Icon.Image = v59
end
function createMessageDialog() -- line: 214
	-- upvalues: Frame2 (ref)
	Frame2 = Instance.new("Frame")
	Frame2.Name = "DialogScriptMessage"
	Frame2.Style = Enum.FrameStyle.Custom
	Frame2.BackgroundTransparency = 0.5
	Frame2.BackgroundColor3 = Color3.new(0.12156862745098039, 0.12156862745098039, 0.12156862745098039)
	Frame2.Visible = false
	Frame2.RobloxLocked = true

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = "Text"
	TextLabel.Position = UDim2.new(0, 0, 0, -1)
	TextLabel.Size = UDim2.new(1, 0, 1, 0)
	TextLabel.FontSize = Enum.FontSize.Size14
	TextLabel.BackgroundTransparency = 1
	TextLabel.TextColor3 = Color3.new(1, 1, 1)
	TextLabel.Parent = Frame2
end
function showMessage(p9, p10) -- line: 233
	-- upvalues: Frame2 (ref)
	Frame2.Text.Text = p9
	Frame2.Size = UDim2.new(0, p10, 0, 40)
	Frame2.Position = UDim2.new(0.5, -p10 / 2, 0.5, -40)
	Frame2.Visible = true
	wait(2)
	Frame2.Visible = false
end
function variableDelay(p11) -- line: 242
	local v66 = math.min(string.len(p11), 100)

	wait(v66 / 75 * 1.5 + 0.75)
end
function resetColor(p12) -- line: 247
	p12.BackgroundTransparency = 1
end
function wanderDialog() -- line: 251
	-- upvalues: Frame (ref)
	Frame.Visible = false
	endDialog()
	showMessage("Chat ended because you walked away", 350)
end
function timeoutDialog() -- line: 257
	-- upvalues: Frame (ref)
	Frame.Visible = false
	endDialog()
	showMessage("Chat ended because you didn't reply", 350)
end
function normalEndDialog() -- line: 263
	endDialog()
end
function endDialog() -- line: 267
	-- upvalues: u22 (ref), t4 (copy), u19 (ref), SetDialogInUse (copy), t5 (copy), ContextActionService (copy), u20 (ref), TouchControlFrame (ref), u31 (ref), u36 (ref), GuiService (copy), Frame (ref)
	if u22 then
		t4[u22] = false
		u22 = nil
	end

	local v68 = u19

	u19 = nil

	if v68 and v68.InUse then
		delay(5, function() -- line: 277
			-- upvalues: SetDialogInUse (copy), v68 (copy)
			SetDialogInUse:FireServer(v68, false)
			v68.InUse = false
		end)
	end

	for k, v in pairs(t5) do
		if k and v then
			v.Enabled = not k.InUse
		end
	end

	ContextActionService:UnbindCoreAction("Nothing")
	u20 = nil

	if TouchControlFrame then
		TouchControlFrame.Visible = true
	end

	if u31 then
		u36.BottomLeftControl.Visible = false
	end

	if GuiService.SelectedCoreObject and GuiService.SelectedCoreObject.Parent == Frame then
		GuiService.SelectedCoreObject = nil
	end
end
function sanitizeMessage(p13) -- line: 306
	if string.len(p13) == 0 then
		return "..."
	end

	return p13
end

local function chatFunc(p14, ...) -- line: 314
	local ok, result = pcall(function() -- line: 119
		-- upvalues: p14 (copy)
		return p14.BehaviorType == Enum.DialogBehaviorType.MultiplePlayers
	end)

	if not not ok and (result or false) then
		game:GetService("Chat"):ChatLocal(...)

		return
	end

	game:GetService("Chat"):Chat(...)
end

function selectChoice(p15) -- line: 322
	-- upvalues: u19 (ref), Character (ref), Frame (ref), u17 (ref), chatFunc (copy), t3 (ref), LocalPlayer (ref), u20 (ref)
	if not u19 then
		return
	end

	renewKillswitch(u19)

	if not Character:FindFirstAncestorOfClass("Workspace") then
		return
	end

	Frame.Visible = false

	if p15 == u17 then
		chatFunc(u19, Character, u17.UserPrompt.Text, getChatColor(currentTone()))
		normalEndDialog()

		return
	end

	local v76 = t3[p15]

	chatFunc(u19, Character, sanitizeMessage(v76.UserDialog), getChatColor(currentTone()))
	wait(1)

	if not u19 then
		return
	end

	u19:SignalDialogChoiceSelected(LocalPlayer, v76)
	chatFunc(u19, u20, sanitizeMessage(v76.ResponseDialog), getChatColor(currentTone()))
	variableDelay(v76.ResponseDialog)
	presentDialogChoices(u20, v76:GetChildren(), v76)
end
function newChoice() -- line: 357
	-- upvalues: Size24 (ref), UserInputService (copy)
	local Frame3 = Instance.new("Frame")

	Frame3.Visible = false

	local TextButton = Instance.new("TextButton")

	TextButton.BackgroundColor3 = Color3.new(0.8901960784313725, 0.8901960784313725, 0.8901960784313725)
	TextButton.BackgroundTransparency = 1
	TextButton.AutoButtonColor = false
	TextButton.BorderSizePixel = 0
	TextButton.Text = ""
	TextButton.MouseEnter:connect(function() -- line: 367
		-- upvalues: TextButton (copy)
		TextButton.BackgroundTransparency = 0
	end)
	TextButton.MouseLeave:connect(function() -- line: 370
		-- upvalues: TextButton (copy)
		TextButton.BackgroundTransparency = 1
	end)
	TextButton.SelectionImageObject = Frame3
	TextButton.Activated:connect(function() -- line: 374
		-- upvalues: TextButton (copy)
		selectChoice(TextButton)
	end)
	TextButton.RobloxLocked = true

	local TextLabel = Instance.new("TextLabel")

	TextLabel.AutoLocalize = false
	TextLabel.Name = "UserPrompt"
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = Enum.Font.SourceSans
	TextLabel.FontSize = Size24
	TextLabel.Position = UDim2.new(0, 40, 0, 0)
	TextLabel.Size = UDim2.new(1, -72, 1, 0)
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.TextYAlignment = Enum.TextYAlignment.Center
	TextLabel.TextWrap = true
	TextLabel.Parent = TextButton

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Name = "RBXchatDialogSelectionButton"
	ImageLabel.Position = UDim2.new(0, 0, 0.5, -16.5)
	ImageLabel.Size = UDim2.new(0, 33, 0, 33)
	ImageLabel.Image = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonA)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Visible = false
	ImageLabel.Parent = TextButton

	return TextButton
end
function initialize(p16) -- line: 404
	-- upvalues: t2 (copy), u17 (ref), n1 (ref), Frame (ref), n2 (ref)
	t2[1] = newChoice()
	t2[2] = newChoice()
	t2[3] = newChoice()
	t2[4] = newChoice()
	u17 = newChoice()
	u17.UserPrompt.Text = "Goodbye!"
	u17.Size = UDim2.new(1, 28, 0, n1 + 12)
	Frame = Instance.new("Frame")
	Frame.Name = "UserDialogArea"
	Frame.Size = UDim2.new(0, n2, 0, 200)
	Frame.Style = Enum.FrameStyle.ChatBlue
	Frame.Visible = false

	for _, v in pairs(t2) do
		v.RobloxLocked = true
		v.Parent = Frame
	end

	u17.RobloxLocked = true
	u17.Parent = Frame
	Frame.RobloxLocked = true
	Frame.Parent = p16
end
function presentDialogChoices(p17, p18, p19) -- line: 432
	-- upvalues: u19 (ref), u20 (ref), t3 (ref), t2 (copy), n1 (ref), GameTranslator (copy), u17 (ref), Frame (ref), n2 (ref), v35 (copy), LocalPlayer (ref), TouchControlFrame (ref), TouchEnabled (copy), u36 (ref), u31 (ref), u11 (ref)
	if not u19 then
		return
	end

	u20 = p17

	local t7 = {}

	for _, v in pairs(p18) do
		if v:IsA("DialogChoice") then
			table.insert(t7, v)
		end
	end

	table.sort(t7, function(p20, p21) -- line: 444
		return p20.Name < p21.Name
	end)

	if #t7 == 0 then
		normalEndDialog()

		return
	end

	local n3 = 1
	local n4 = 0

	t3 = {}

	for _, v in pairs(t2) do
		v.Visible = false
	end

	for _, v in pairs(t7) do
		if n3 <= #t2 then
			t2[n3].Size = UDim2.new(1, 28, 0, n1 * 3)
			GameTranslator:TranslateAndRegister(t2[n3].UserPrompt, v, v.UserDialog)

			local v96 = math.ceil(t2[n3].UserPrompt.TextBounds.Y / n1) * n1 + 12

			t2[n3].Position = UDim2.new(0, -11, 0, n4 + -8)
			t2[n3].Size = UDim2.new(1, 28, 0, v96)
			t2[n3].Visible = true
			t3[t2[n3]] = v
			n4 = n4 + v96 + 1
			n3 += 1
		end
	end

	u17.Size = UDim2.new(1, 28, 0, n1 * 3)
	u17.UserPrompt.Text = if p19.GoodbyeDialog ~= "" then p19.GoodbyeDialog else "Goodbye!"

	local v97 = math.ceil(u17.UserPrompt.TextBounds.Y / n1) * n1 + 12

	u17.Size = UDim2.new(1, 28, 0, v97)
	u17.Position = UDim2.new(0, -11, 0, n4 + -8)
	u17.Visible = true

	if not p19.GoodbyeChoiceActive then
		u17.Visible = false
		Frame.Size = UDim2.new(0, n2, 0, n4 + 34 + -16)
	else
		Frame.Size = UDim2.new(0, n2, 0, n4 + u17.AbsoluteSize.Y + 34 + -16)
	end

	Frame.Position = UDim2.new(0, 20, 1, -Frame.Size.Y.Offset - 20)

	if v35 then
		local TouchGui = LocalPlayer.PlayerGui:FindFirstChild("TouchGui")

		if TouchGui then
			TouchControlFrame = TouchGui:FindFirstChild("TouchControlFrame")

			if TouchControlFrame then
				TouchControlFrame.Visible = false
			end
		end

		Frame.Position = UDim2.new(0, 10, 1, -Frame.Size.Y.Offset)
	elseif not TouchEnabled and not u36.BottomLeftControl.Visible then
		u36.BottomLeftControl.Visible = true
		u31 = true
	end

	styleMainFrame(currentTone())
	Frame.Visible = true

	if u11 then
		game:GetService("GuiService").SelectedCoreObject = t2[1]
	end
end
function doDialog(p22) -- line: 516
	-- upvalues: u19 (ref), ContextActionService (copy), SetDialogInUse (copy), chatFunc (copy)
	if p22.InitialPrompt == "" then
		warn("Can't start a dialog with an empty InitialPrompt")

		return
	end

	local ok, result = pcall(function() -- line: 119
		-- upvalues: p22 (copy)
		return p22.BehaviorType == Enum.DialogBehaviorType.MultiplePlayers
	end)
	local v102 = not not ok and (result or false)

	if p22.InUse and not v102 then
		return
	end

	u19 = p22
	p22.InUse = true
	ContextActionService:BindCoreAction("Nothing", function() -- line: 530
	end, false, Enum.UserInputType.Gamepad1, Enum.UserInputType.Gamepad2, Enum.UserInputType.Gamepad3, Enum.UserInputType.Gamepad4)
	SetDialogInUse:FireServer(p22, true)
	chatFunc(p22, p22.Parent, p22.InitialPrompt, getChatColor(p22.Tone))
	variableDelay(p22.InitialPrompt)
	presentDialogChoices(p22.Parent, p22:GetChildren(), p22)
end
function renewKillswitch(p23) -- line: 541
	-- upvalues: u22 (ref), t4 (copy), SetDialogInUse (copy)
	if u22 then
		t4[u22] = false
		u22 = nil
	end

	u22 = coroutine.create(function(p24) -- line: 547
		-- upvalues: t4 (copy), SetDialogInUse (copy), p23 (copy)
		wait(15)

		if p24 ~= nil then
			if t4[p24] == nil then
				SetDialogInUse:FireServer(p23, false)
				p23.InUse = false
			end

			t4[p24] = nil
		end
	end)
	coroutine.resume(u22, u22)
end
function checkForLeaveArea() -- line: 560
	-- upvalues: u19 (ref), LocalPlayer (ref)
	while u19 do
		if u19.Parent and LocalPlayer:DistanceFromCharacter(u19.Parent.Position) >= u19.ConversationDistance then
			wanderDialog()
		end

		wait(1)
	end
end
function startDialog(p25) -- line: 569
	-- upvalues: RbxAnalyticsService (copy), LocalPlayer (ref), t5 (copy)
	if p25.Parent and p25.Parent:IsA("BasePart") then
		RbxAnalyticsService:TrackEvent("Dialogue", "Old Dialogue", "Conversation Initiated")

		if LocalPlayer:DistanceFromCharacter(p25.Parent.Position) >= p25.ConversationDistance then
			showMessage("You are too far away to chat!", 300)

			return
		end

		for k, v in pairs(t5) do
			if k and v then
				v.Enabled = false
			end
		end

		renewKillswitch(p25)
		delay(1, checkForLeaveArea)
		doDialog(p25)
	end
end
function removeDialog(p26) -- line: 591
	-- upvalues: t5 (copy), t6 (copy)
	if t5[p26] then
		t5[p26]:Destroy()
		t5[p26] = nil
	end

	if t6[p26] then
		t6[p26]:disconnect()
		t6[p26] = nil
	end
end
function addDialog(p27) -- line: 602
	-- upvalues: u12 (ref), RbxAnalyticsService (copy), BillboardGui (ref), CoreGui (copy), t5 (copy), t6 (copy), u19 (ref)
	if p27.Parent then
		if p27.Parent:IsA("BasePart") and p27:IsDescendantOf(game.Workspace) then
			u12 = true
			RbxAnalyticsService:TrackEvent("Dialogue", "Old Dialogue", "Used In Place", nil, game.PlaceId)

			local v109 = BillboardGui:clone()

			v109.Adornee = p27.Parent
			v109.RobloxLocked = true

			local v110 = not p27.InUse

			if not v110 then
				local ok, result = pcall(function() -- line: 119
					-- upvalues: p27 (copy)
					return p27.BehaviorType == Enum.DialogBehaviorType.MultiplePlayers
				end)

				v110 = not not ok and (result or false)
			end

			v109.Enabled = v110
			v109.Parent = CoreGui
			v109.Background.MouseButton1Click:connect(function() -- line: 614
				-- upvalues: p27 (copy)
				startDialog(p27)
			end)
			setChatNotificationTone(v109, p27.Purpose, p27.Tone)

			if game:GetEngineFeature("ClosestVisibleDialogAPI") then
				p27:SetGuiObject(v109)
			end

			t5[p27] = v109
			t6[p27] = p27.Changed:connect(function(p28) -- line: 624
				-- upvalues: p27 (copy), v109 (copy), u19 (ref)
				if p28 == "Parent" and p27.Parent then
					removeDialog(p27)
					addDialog(p27)

					return
				end

				if p28 == "InUse" then
					local v129 = p27
					local ok, result = pcall(function() -- line: 119
						-- upvalues: v129 (copy)
						return v129.BehaviorType == Enum.DialogBehaviorType.MultiplePlayers
					end)

					if not ok or not result and not false then
						v109.Enabled = u19 == nil and not p27.InUse
					else
						v109.Enabled = u19 ~= p27
					end

					if not p27.InUse then
						local v132 = p27
						local ok2, result2 = pcall(function() -- line: 119
							-- upvalues: v132 (copy)
							return v132.BehaviorType == Enum.DialogBehaviorType.MultiplePlayers
						end)

						if (not ok2 or not result2 and not false) and p27 == u19 then
							timeoutDialog()

							return
						end
					end
				elseif p28 == "Tone" or p28 == "Purpose" then
					setChatNotificationTone(v109, p27.Purpose, p27.Tone)
				end
			end)

			return
		end

		t6[p27] = p27.Changed:connect(function(p29) -- line: 644
			-- upvalues: p27 (copy)
			if p29 == "Parent" and p27.Parent then
				removeDialog(p27)
				addDialog(p27)
			end
		end)
	end
end
function onLoad() -- line: 655
	-- upvalues: Frame2 (ref), u36 (ref), TouchEnabled (copy), v35 (copy)
	createChatNotificationGui()
	createMessageDialog()
	Frame2.RobloxLocked = true
	Frame2.Parent = u36
	u36:WaitForChild("BottomLeftControl")

	local Frame4 = Instance.new("Frame")

	Frame4.Name = "DialogFrame"
	Frame4.Position = UDim2.new(0, 0, 0, 0)
	Frame4.Size = UDim2.new(0, 0, 0, 0)
	Frame4.BackgroundTransparency = 1
	Frame4.RobloxLocked = true
	game:GetService("GuiService"):AddSelectionParent("RBXDialogGroup", Frame4)

	if TouchEnabled and not v35 then
		Frame4.Position = UDim2.new(0, 20, 0.5, 0)
		Frame4.Size = UDim2.new(0.25, 0, 0.1, 0)
		Frame4.Parent = u36
	elseif v35 then
		Frame4.Position = UDim2.new(0, 0, 0.9, -10)
		Frame4.Size = UDim2.new(0.25, 0, 0.1, 0)
		Frame4.Parent = u36
	else
		Frame4.Parent = u36.BottomLeftControl
	end

	initialize(Frame4)
	game:GetService("CollectionService").ItemAdded:Connect(function(p30) -- line: 686
		if p30:IsA("Dialog") then
			addDialog(p30)
		end
	end)
	game:GetService("CollectionService").ItemRemoved:Connect(function(p31) -- line: 691
		if p31:IsA("Dialog") then
			removeDialog(p31)
		end
	end)

	for _, v in pairs(game:GetService("CollectionService"):GetCollection("Dialog")) do
		if v:IsA("Dialog") then
			addDialog(v)
		end
	end
end
function getLocalHumanoidRootPart() -- line: 703
	-- upvalues: LocalPlayer (ref)
	if LocalPlayer.Character then
		return LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	end
end
function dialogIsValid(p32) -- line: 709
	return p32 and (p32.Parent and p32.Parent:IsA("BasePart"))
end

local u40 = nil
local GetClosestDialogToPosition = GuiService.GetClosestDialogToPosition

game:GetService("RunService").Heartbeat:Connect(function() -- line: 716
	-- upvalues: GetClosestDialogToPosition (copy), GuiService (copy), u19 (ref), LocalPlayer (ref), u11 (ref), u40 (ref), t5 (copy), ContextActionService (copy)
	local u117 = nil
	local v118 = getLocalHumanoidRootPart()

	if v118 then
		local Position = v118.Position

		u117 = GetClosestDialogToPosition(GuiService, Position)
	end

	if getLocalHumanoidRootPart() and dialogIsValid(u117) and u19 == nil then
		local TriggerDistance = u117.TriggerDistance
		local TriggerOffset = u117.TriggerOffset
		local v122 = LocalPlayer:DistanceFromCharacter(u117.Parent.Position + TriggerOffset)

		if TriggerDistance ~= 0 and v122 < u117.ConversationDistance and v122 < TriggerDistance then
			startDialog(u117)
		end
	end

	if u11 == true then
		if v118 and game:GetEngineFeature("ClosestVisibleDialogAPI") then
			local Position = v118.Position

			u117 = GuiService.GetClosestVisibleDialogToPosition(GuiService, Position)
		end

		if u117 ~= u40 then
			if t5[u40] then
				t5[u40].Background.ActivationButton.Visible = false
			end

			u40 = u117
			ContextActionService:UnbindCoreAction("StartDialogAction")

			if u117 ~= nil then
				ContextActionService:BindCoreAction("StartDialogAction", function(_, p34, _) -- line: 755
					-- upvalues: u117 (ref)
					if p34 == Enum.UserInputState.Begin and (u117 and u117.Parent) then
						startDialog(u117)
					end
				end, false, Enum.KeyCode.ButtonX)

				if t5[u117] then
					t5[u117].Background.ActivationButton.Visible = true
				end
			end
		end
	end
end)

local SelectedCoreObject = nil

GuiService.Changed:connect(function(p36) -- line: 772
	-- upvalues: SelectedCoreObject (ref), GuiService (copy)
	if p36 == "SelectedCoreObject" then
		if SelectedCoreObject and SelectedCoreObject:FindFirstChild("RBXchatDialogSelectionButton") then
			SelectedCoreObject:FindFirstChild("RBXchatDialogSelectionButton").Visible = false
			SelectedCoreObject.BackgroundTransparency = 1
		end

		SelectedCoreObject = GuiService.SelectedCoreObject

		if SelectedCoreObject and SelectedCoreObject:FindFirstChild("RBXchatDialogSelectionButton") then
			SelectedCoreObject:FindFirstChild("RBXchatDialogSelectionButton").Visible = true
			SelectedCoreObject.BackgroundTransparency = 0
		end
	end
end)
onLoad()
