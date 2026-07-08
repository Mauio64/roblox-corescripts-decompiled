local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Chat = game:GetService("Chat")
local TextService = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer

while LocalPlayer == nil do
	Players.ChildAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ok, result = pcall(function() -- line: 24
	return UserSettings():IsUserFeatureEnabled("UserShouldLocalizeGameChatBubble")
end)
local v9 = ok and result
local ok2, result2 = pcall(function() -- line: 30
	return UserSettings():IsUserFeatureEnabled("UserFixBubbleChatText")
end)
local u12 = ok2 and result2
local ok3, result3 = pcall(function() -- line: 37
	return UserSettings():IsUserFeatureEnabled("UserRoactBubbleChatBeta")
end)
local u15 = ok3 and result3
local ok4, result4 = pcall(function() -- line: 44
	return UserSettings():IsUserFeatureEnabled("UserPreventOldBubbleChatOverlap")
end)
local u18 = ok4 and result4

local function getMessageLength(p1) -- line: 50
	return utf8.len(utf8.nfcnormalize(p1))
end

local SourceSans = Enum.Font.SourceSans
local Size24 = Enum.FontSize.Size24
local v22 = 128 - utf8.len(utf8.nfcnormalize("...")) - 1
local t1 = {
	WHITE = "dub",
	BLUE = "blu",
	GREEN = "gre",
	RED = "red"
}
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "BubbleChat"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local function lerpLength(p2, p3, p4) -- line: 93
	return p3 + (p4 - p3) * math.min(utf8.len(utf8.nfcnormalize(p2)) / 75, 1)
end
local function createFifo() -- line: 97
	local t2 = {
		data = {}
	}
	local BindableEvent = Instance.new("BindableEvent")

	t2.Emptied = BindableEvent.Event

	function t2.Size(_) -- line: 104
		-- upvalues: t2 (copy)
		return #t2.data
	end
	function t2.Empty(_) -- line: 108
		-- upvalues: t2 (copy)
		return t2:Size() <= 0
	end
	function t2.PopFront(_) -- line: 112
		-- upvalues: t2 (copy), BindableEvent (copy)
		table.remove(t2.data, 1)

		if t2:Empty() then
			BindableEvent:Fire()
		end
	end
	function t2.Front(_) -- line: 117
		-- upvalues: t2 (copy)
		return t2.data[1]
	end
	function t2.Get(_, p10) -- line: 121
		-- upvalues: t2 (copy)
		return t2.data[p10]
	end
	function t2.PushBack(_, p12) -- line: 125
		-- upvalues: t2 (copy)
		table.insert(t2.data, p12)
	end
	function t2.GetData(_) -- line: 129
		-- upvalues: t2 (copy)
		return t2.data
	end

	return t2
end
local function createCharacterChats() -- line: 136
	-- upvalues: createFifo (copy)
	return {
		Fifo = createFifo(),
		BillboardGui = nil
	}
end
local function createMap() -- line: 145
	-- upvalues: createFifo (copy)
	local t3 = {
		data = {}
	}
	local n1 = 0

	function t3.Size(_) -- line: 150
		-- upvalues: n1 (ref)
		return n1
	end
	function t3.Erase(_, p16) -- line: 154
		-- upvalues: t3 (copy), n1 (ref)
		if t3.data[p16] then
			n1 -= 1
		end

		t3.data[p16] = nil
	end
	function t3.Set(_, p18, p19) -- line: 159
		-- upvalues: t3 (copy), n1 (ref)
		t3.data[p18] = p19

		if p19 then
			n1 += 1
		end
	end
	function t3.Get(_, p21) -- line: 164
		-- upvalues: t3 (copy), createFifo (copy)
		if not p21 then
			return
		end

		if not t3.data[p21] then
			t3.data[p21] = {
				Fifo = createFifo(),
				BillboardGui = nil
			}

			local u227 = nil

			u227 = t3.data[p21].Fifo.Emptied:connect(function() -- line: 169
				-- upvalues: u227 (ref), t3 (copy), p21 (copy)
				u227:disconnect()
				t3:Erase(p21)
			end)
		end

		return t3.data[p21]
	end
	function t3.GetData(_) -- line: 177
		-- upvalues: t3 (copy)
		return t3.data
	end

	return t3
end
local function createChatLine(p23, p24, p25) -- line: 184
	local t4 = {
		ComputeBubbleLifetime = function(_, p27, p28) -- line: 187
			if p28 then
				return 8 + 7 * math.min(utf8.len(utf8.nfcnormalize(p27)) / 75, 1)
			end

			return 12 + 8 * math.min(utf8.len(utf8.nfcnormalize(p27)) / 75, 1)
		end,
		Origin = nil,
		RenderBubble = nil,
		Message = p23
	}

	t4.BubbleDieDelay = t4:ComputeBubbleLifetime(p23, p25)
	t4.BubbleColor = p24
	t4.IsLocalPlayer = p25

	return t4
end
local function createPlayerChatLine(p29, p30, p31) -- line: 205
	-- upvalues: createChatLine (copy)
	local v56 = createChatLine(p30, "dub", p31)

	if p29 then
		v56.User = p29.Name
		v56.Origin = p29.Character
	end

	return v56
end
local function createGameChatLine(p32, p33, p34, p35) -- line: 216
	-- upvalues: createChatLine (copy)
	local v61 = createChatLine(p33, p35, p34)

	v61.Origin = p32

	return v61
end

function createChatBubbleMain(p36, p37) -- line: 223
	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Name = "ChatBubble"
	ImageLabel.ScaleType = Enum.ScaleType.Slice
	ImageLabel.SliceCenter = p37
	ImageLabel.Image = "rbxasset://textures/" .. tostring(p36) .. ".png"
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.BorderSizePixel = 0
	ImageLabel.Size = UDim2.new(1, 0, 1, 0)
	ImageLabel.Position = UDim2.new(0, 0, 0, 0)

	return ImageLabel
end
function createChatBubbleTail(p38, p39) -- line: 237
	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Name = "ChatBubbleTail"
	ImageLabel.Image = "rbxasset://textures/ui/dialog_tail.png"
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.BorderSizePixel = 0
	ImageLabel.Position = p38
	ImageLabel.Size = p39

	return ImageLabel
end
function createChatBubbleWithTail(p40, p41, p42, p43) -- line: 249
	local v72 = createChatBubbleMain(p40, p43)

	createChatBubbleTail(p41, p42).Parent = v72

	return v72
end
function createScaledChatBubbleWithTail(p44, p45, p46, p47) -- line: 258
	local v77 = createChatBubbleMain(p44, p47)
	local Frame = Instance.new("Frame")

	Frame.Name = "ChatBubbleTailFrame"
	Frame.BackgroundTransparency = 1
	Frame.SizeConstraint = Enum.SizeConstraint.RelativeXX
	Frame.Position = UDim2.new(0.5, 0, 1, 0)
	Frame.Size = UDim2.new(p45, 0, p45, 0)
	Frame.Parent = v77
	createChatBubbleTail(p46, UDim2.new(1, 0, 0.5, 0)).Parent = Frame

	return v77
end
function createChatImposter(p48, p49, p50) -- line: 275
	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Name = "DialogPlaceholder"
	ImageLabel.Image = "rbxasset://textures/" .. tostring(p48) .. ".png"
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.BorderSizePixel = 0
	ImageLabel.Position = UDim2.new(0, 0, -1.25, 0)
	ImageLabel.Size = UDim2.new(1, 0, 1, 0)

	local ImageLabel2 = Instance.new("ImageLabel")

	ImageLabel2.Name = "DotDotDot"
	ImageLabel2.Image = "rbxasset://textures/" .. tostring(p49) .. ".png"
	ImageLabel2.BackgroundTransparency = 1
	ImageLabel2.BorderSizePixel = 0
	ImageLabel2.Position = UDim2.new(0.001, 0, p50, 0)
	ImageLabel2.Size = UDim2.new(1, 0, 0.7, 0)
	ImageLabel2.Parent = ImageLabel

	return ImageLabel
end

local t5 = {
	ChatBubble = {},
	ChatBubbleWithTail = {},
	ScalingChatBubbleWithTail = {},
	CharacterSortedMsg = createMap()
}

local function initChatBubbleType(p51, p52, _, p54, p55) -- line: 304
	-- upvalues: t5 (copy)
	t5.ChatBubble[p51] = createChatBubbleMain(p52, p55)
	t5.ChatBubbleWithTail[p51] = createChatBubbleWithTail(p52, UDim2.new(0.5, -14, 1, not p54 and 0 or -1), UDim2.new(0, 30, 0, 14), p55)
	t5.ScalingChatBubbleWithTail[p51] = createScaledChatBubbleWithTail(p52, 0.5, UDim2.new(-0.5, 0, 0, not p54 and 0 or -1), p55)
end

initChatBubbleType("dub", "ui/dialog_white", "ui/chatBubble_white_notify_bkg", false, Rect.new(5, 5, 15, 15))
initChatBubbleType("blu", "ui/dialog_blue", "ui/chatBubble_blue_notify_bkg", true, Rect.new(7, 7, 33, 33))
initChatBubbleType("red", "ui/dialog_red", "ui/chatBubble_red_notify_bkg", true, Rect.new(7, 7, 33, 33))
initChatBubbleType("gre", "ui/dialog_green", "ui/chatBubble_green_notify_bkg", true, Rect.new(7, 7, 33, 33))

function t5.SanitizeChatLine(_, p57) -- line: 315
	-- upvalues: v22 (copy)
	if utf8.len(utf8.nfcnormalize(p57)) > v22 then
		return (string.sub(p57, 1, utf8.offset(p57, v22 + utf8.len(utf8.nfcnormalize("...")) + 1) - 1))
	end

	return p57
end

local function createBillboardInstance(p58) -- line: 324
	-- upvalues: ScreenGui (copy), t5 (copy)
	local BillboardGui = Instance.new("BillboardGui")

	BillboardGui.Adornee = p58
	BillboardGui.Size = UDim2.new(0, 400, 0, 250)
	BillboardGui.StudsOffset = Vector3.new(0, 1.5, 2)
	BillboardGui.Parent = ScreenGui

	local Frame = Instance.new("Frame")

	Frame.Name = "BillboardFrame"
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.Position = UDim2.new(0, 0, -0.5, 0)
	Frame.BackgroundTransparency = 1
	Frame.Parent = BillboardGui

	local u94 = nil

	u94 = Frame.ChildRemoved:connect(function() -- line: 339
		-- upvalues: Frame (copy), u94 (ref), BillboardGui (copy)
		if #Frame:GetChildren() <= 1 then
			u94:disconnect()
			BillboardGui:Destroy()
		end
	end)
	t5:CreateSmallTalkBubble("dub").Parent = Frame

	return BillboardGui
end

function t5.CreateBillboardGuiHelper(_, p60, p61) -- line: 351
	-- upvalues: t5 (copy), createBillboardInstance (copy)
	if p60 and not t5.CharacterSortedMsg:Get(p60).BillboardGui then
		if not p61 and p60:IsA("BasePart") then
			local v98 = createBillboardInstance(p60)

			t5.CharacterSortedMsg:Get(p60).BillboardGui = v98

			return
		end

		if p60:IsA("Model") then
			local Head = p60:FindFirstChild("Head")

			if Head and Head:IsA("BasePart") then
				local v100 = createBillboardInstance(Head)

				t5.CharacterSortedMsg:Get(p60).BillboardGui = v100
			end
		end
	end
end

local function distanceToBubbleOrigin(p62) -- line: 373
	if not p62 then
		return 100000
	end

	return (p62.Position - game.Workspace.CurrentCamera.CoordinateFrame.Position).magnitude
end
local function isPartOfLocalPlayer(p63) -- line: 379
	-- upvalues: Players (copy)
	if p63 and Players.LocalPlayer.Character then
		return p63:IsDescendantOf(Players.LocalPlayer.Character)
	end
end

function t5.SetBillboardLODNear(_, p65) -- line: 385
	-- upvalues: Players (copy)
	local p65Adornee = p65.Adornee
	local v106 = if not p65Adornee or not Players.LocalPlayer.Character then nil else p65Adornee:IsDescendantOf(Players.LocalPlayer.Character)

	p65.Size = UDim2.new(0, 400, 0, 250)
	p65.StudsOffset = Vector3.new(0, not v106 and 2.5 or 1.5, not v106 and 0.1 or 2)
	p65.Enabled = true

	local children = p65.BillboardFrame:GetChildren()

	for i = 1, #children do
		children[i].Visible = true
	end

	p65.BillboardFrame.SmallTalkBubble.Visible = false
end
function t5.SetBillboardLODDistant(_, p67) -- line: 397
	-- upvalues: Players (copy)
	local p67Adornee = p67.Adornee
	local v112 = if not p67Adornee or not Players.LocalPlayer.Character then nil else p67Adornee:IsDescendantOf(Players.LocalPlayer.Character)

	p67.Size = UDim2.new(4, 0, 3, 0)
	p67.StudsOffset = Vector3.new(0, 3, not v112 and 0.1 or 2)
	p67.Enabled = true

	local children = p67.BillboardFrame:GetChildren()

	for i = 1, #children do
		children[i].Visible = false
	end

	p67.BillboardFrame.SmallTalkBubble.Visible = true
end
function t5.SetBillboardLODVeryFar(_, p69) -- line: 409
	p69.Enabled = false
end
function t5.SetBillboardGuiLOD(_, p71, p72) -- line: 413
	-- upvalues: t5 (copy)
	if not p72 then
		return
	end

	if p72:IsA("Model") then
		p72 = p72:FindFirstChild("Head") or p72.PrimaryPart
	end

	local v120 = if p72 then (p72.Position - game.Workspace.CurrentCamera.CoordinateFrame.Position).magnitude else 100000

	if v120 < 65 then
		t5:SetBillboardLODNear(p71)

		return
	end

	if v120 >= 65 and v120 < 100 then
		t5:SetBillboardLODDistant(p71)

		return
	end

	t5:SetBillboardLODVeryFar(p71)
end
function t5.CameraCFrameChanged(_) -- line: 433
	-- upvalues: t5 (copy)
	for k, v in pairs(t5.CharacterSortedMsg:GetData()) do
		local BillboardGui = v.BillboardGui

		if BillboardGui then
			t5:SetBillboardGuiLOD(BillboardGui, k)
		end
	end
end
function t5.CreateBubbleText(_, p75, p76) -- line: 440
	-- upvalues: u12 (ref), SourceSans (copy), Size24 (copy)
	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = "BubbleText"
	TextLabel.BackgroundTransparency = 1

	if u12 then
		TextLabel.Size = UDim2.fromScale(1, 1)
	else
		TextLabel.Position = UDim2.new(0, 15, 0, 0)
		TextLabel.Size = UDim2.new(1, -30, 1, 0)
	end

	TextLabel.Font = SourceSans
	TextLabel.ClipsDescendants = true
	TextLabel.TextWrapped = true
	TextLabel.FontSize = Size24
	TextLabel.Text = p75
	TextLabel.Visible = false
	TextLabel.AutoLocalize = p76

	if u12 then
		local UIPadding = Instance.new("UIPadding")

		UIPadding.PaddingTop = UDim.new(0, 12)
		UIPadding.PaddingRight = UDim.new(0, 12)
		UIPadding.PaddingBottom = UDim.new(0, 12)
		UIPadding.PaddingLeft = UDim.new(0, 12)
		UIPadding.Parent = TextLabel
	end

	return TextLabel
end
function t5.CreateSmallTalkBubble(_, p78) -- line: 472
	-- upvalues: t5 (copy)
	local clone = t5.ScalingChatBubbleWithTail[p78]:Clone()

	clone.Name = "SmallTalkBubble"
	clone.AnchorPoint = Vector2.new(0, 0.5)
	clone.Position = UDim2.new(0, 0, 0.5, 0)
	clone.Visible = false

	local v133 = t5:CreateBubbleText("...")

	v133.TextScaled = true
	v133.TextWrapped = false
	v133.Visible = true
	v133.Parent = clone

	return clone
end
function t5.UpdateChatLinesForOrigin(_, p80, p81) -- line: 487
	-- upvalues: t5 (copy)
	local Fifo = t5.CharacterSortedMsg:Get(p80).Fifo
	local v138 = Fifo:Size()
	local Data = Fifo:GetData()

	if #Data <= 1 then
		return
	end

	for i = #Data - 1, 1, -1 do
		local RenderBubble = Data[i].RenderBubble

		if not RenderBubble then
			return
		end

		if v138 - i + 1 > 1 then
			local ChatBubbleTail = RenderBubble:FindFirstChild("ChatBubbleTail")

			if ChatBubbleTail then
				ChatBubbleTail:Destroy()
			end

			local BubbleText = RenderBubble:FindFirstChild("BubbleText")

			if BubbleText then
				BubbleText.TextTransparency = 0.5
			end
		end

		RenderBubble:TweenPosition(UDim2.new(RenderBubble.Position.X.Scale, RenderBubble.Position.X.Offset, 1, p81 - RenderBubble.Size.Y.Offset - 14), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
		p81 = p81 - RenderBubble.Size.Y.Offset - 14
	end
end
function t5.DestroyBubble(_, p83, p84) -- line: 513
	if not p83 then
		return
	end

	if p83:Empty() then
		return
	end

	local RenderBubble = p83:Front().RenderBubble

	if not RenderBubble then
		p83:PopFront()

		return
	end

	spawn(function() -- line: 523
		-- upvalues: p83 (copy), p84 (copy), RenderBubble (ref)
		while p83:Front().RenderBubble ~= p84 do
			wait()
		end

		RenderBubble = p83:Front().RenderBubble

		local BubbleText = RenderBubble:FindFirstChild("BubbleText")
		local ChatBubbleTail = RenderBubble:FindFirstChild("ChatBubbleTail")

		while RenderBubble and RenderBubble.ImageTransparency < 1 do
			local elapsed = wait()

			if RenderBubble then
				local v235 = elapsed * 1.5

				RenderBubble.ImageTransparency = RenderBubble.ImageTransparency + v235

				if BubbleText then
					BubbleText.TextTransparency = BubbleText.TextTransparency + v235
				end

				if ChatBubbleTail then
					ChatBubbleTail.ImageTransparency = ChatBubbleTail.ImageTransparency + v235
				end
			end
		end

		if RenderBubble then
			RenderBubble:Destroy()
			p83:PopFront()
		end
	end)
end
function t5.CreateChatLineRender(_, p86, p87, p88, p89, p90) -- line: 551
	-- upvalues: t5 (copy), TextService (copy), SourceSans (copy), u12 (ref)
	if not p86 then
		return
	end

	if not t5.CharacterSortedMsg:Get(p86).BillboardGui then
		t5:CreateBillboardGuiHelper(p86, p88)
	end

	local BillboardGui = t5.CharacterSortedMsg:Get(p86).BillboardGui

	if BillboardGui then
		local clone = t5.ChatBubbleWithTail[p87.BubbleColor]:Clone()

		clone.Visible = false

		local v156 = t5:CreateBubbleText(p87.Message, p90)

		v156.Parent = clone
		clone.Parent = BillboardGui.BillboardFrame
		p87.RenderBubble = clone

		local TextSize = TextService:GetTextSize(v156.Text, 24, SourceSans, Vector2.new(400, 250))
		local v158 = TextSize.Y / 24

		if u12 then
			local v159 = math.ceil(TextSize.X + 24)
			local v160 = v158 * 34

			clone.Size = UDim2.fromOffset(0, 0)
			clone.Position = UDim2.fromScale(0.5, 1)
			clone:TweenSizeAndPosition(UDim2.fromOffset(v159, v160), UDim2.new(0.5, -v159 / 2, 1, -v160), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.1, true, function() -- line: 590
				-- upvalues: v156 (copy)
				v156.Visible = true
			end)
			t5:SetBillboardGuiLOD(BillboardGui, p87.Origin)
			t5:UpdateChatLinesForOrigin(p87.Origin, -v160)
		else
			local v161 = math.max((TextSize.X + 30) / 400, 0.1)

			clone.Size = UDim2.new(0, 0, 0, 0)
			clone.Position = UDim2.new(0.5, 0, 1, 0)

			local v162 = v158 * 34

			clone:TweenSizeAndPosition(UDim2.new(v161, 0, 0, v162), UDim2.new((1 - v161) / 2, 0, 1, -v162), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.1, true, function() -- line: 610
				-- upvalues: v156 (copy)
				v156.Visible = true
			end)
			t5:SetBillboardGuiLOD(BillboardGui, p87.Origin)
			t5:UpdateChatLinesForOrigin(p87.Origin, -v162)
		end

		delay(p87.BubbleDieDelay, function() -- line: 617
			-- upvalues: t5 (copy), p89 (copy), clone (copy)
			t5:DestroyBubble(p89, clone)
		end)
	end
end
function t5.OnPlayerChatMessage(_, p92, p93, _) -- line: 623
	-- upvalues: t5 (copy), Players (copy), createChatLine (copy), t1 (copy)
	if not t5:BubbleChatEnabled() then
		return
	end

	local LocalPlayer2 = Players.LocalPlayer
	local v168 = LocalPlayer2 ~= nil and p92 ~= LocalPlayer2
	local v169 = t5:SanitizeChatLine(p93)
	local v170 = createChatLine(v169, t1.WHITE, not v168)

	if p92 then
		v170.User = p92.Name
		v170.Origin = p92.Character
	end

	if p92 and v170.Origin then
		local Fifo = t5.CharacterSortedMsg:Get(v170.Origin).Fifo

		Fifo:PushBack(v170)
		t5:CreateChatLineRender(p92.Character, v170, true, Fifo, false)
	end
end
function t5.OnGameChatMessage(_, p96, p97, p98) -- line: 642
	-- upvalues: u15 (ref), u18 (ref), Chat (copy), Players (copy), t5 (copy), createChatLine (copy), v9 (copy)
	if u15 or u18 and Chat.BubbleChatEnabled then
		return
	end

	local LocalPlayer3 = Players.LocalPlayer
	local v177 = LocalPlayer3 ~= nil and p96 ~= LocalPlayer3.Character
	local s1 = "dub"

	if p98 == Enum.ChatColor.Blue then
		s1 = "blu"
	elseif p98 == Enum.ChatColor.Green then
		s1 = "gre"
	elseif p98 == Enum.ChatColor.Red then
		s1 = "red"
	end

	local v179 = t5:SanitizeChatLine(p97)
	local v180 = createChatLine(v179, s1, not v177)

	v180.Origin = p96
	t5.CharacterSortedMsg:Get(v180.Origin).Fifo:PushBack(v180)

	if v9 then
		t5:CreateChatLineRender(p96, v180, false, t5.CharacterSortedMsg:Get(v180.Origin).Fifo, true)

		return
	end

	t5:CreateChatLineRender(p96, v180, false, t5.CharacterSortedMsg:Get(v180.Origin).Fifo, false)
end
function t5.BubbleChatEnabled(_) -- line: 668
	-- upvalues: u15 (ref), u18 (ref), Chat (copy), Players (copy)
	if u15 or u18 and Chat.BubbleChatEnabled then
		return false
	end

	local ClientChatModules = Chat:FindFirstChild("ClientChatModules")

	if ClientChatModules then
		local ChatSettings = ClientChatModules:FindFirstChild("ChatSettings")

		if ChatSettings then
			local lib = require(ChatSettings)

			if lib.BubbleChatEnabled ~= nil then
				return lib.BubbleChatEnabled
			end
		end
	end

	return Players.BubbleChat
end
function t5.ShowOwnFilteredMessage(_) -- line: 685
	-- upvalues: Chat (copy)
	local ClientChatModules = Chat:FindFirstChild("ClientChatModules")

	if ClientChatModules then
		local ChatSettings = ClientChatModules:FindFirstChild("ChatSettings")

		if ChatSettings then
			return require(ChatSettings).ShowUserOwnFilteredMessage
		end
	end

	return false
end
function findPlayer(p101) -- line: 697
	-- upvalues: Players (copy)
	for _, player in pairs(Players:GetPlayers()) do
		if p101 == player.Name then
			return player
		end
	end
end

Chat.Chatted:connect(function(p102, p103, p104) -- line: 705
	-- upvalues: t5 (copy)
	t5:OnGameChatMessage(p102, p103, p104)
end)

local connection = nil

if game.Workspace.CurrentCamera then
	connection = game.Workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(function(_) -- line: 709
		-- upvalues: t5 (copy)
		t5:CameraCFrameChanged()
	end)
end

game.Workspace.Changed:Connect(function(property) -- line: 712
	-- upvalues: connection (ref), t5 (copy)
	if property == "CurrentCamera" then
		if connection then
			connection:disconnect()
		end

		if game.Workspace.CurrentCamera then
			connection = game.Workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(function(_) -- line: 716
				-- upvalues: t5 (copy)
				t5:CameraCFrameChanged()
			end)
		end
	end
end)

local BubbleChatMessageTypes = nil

function getAllowedMessageTypes() -- line: 724
	-- upvalues: BubbleChatMessageTypes (ref), Chat (copy)
	if BubbleChatMessageTypes then
		return BubbleChatMessageTypes
	end

	local ClientChatModules = Chat:FindFirstChild("ClientChatModules")

	if ClientChatModules then
		local ChatSettings = ClientChatModules:FindFirstChild("ChatSettings")

		if ChatSettings then
			local lib = require(ChatSettings)

			if lib.BubbleChatMessageTypes then
				BubbleChatMessageTypes = lib.BubbleChatMessageTypes

				return BubbleChatMessageTypes
			end
		end

		local ChatConstants = ClientChatModules:FindFirstChild("ChatConstants")

		if ChatConstants then
			local lib = require(ChatConstants)

			BubbleChatMessageTypes = {
				lib.MessageTypeDefault,
				lib.MessageTypeWhisper
			}
		end

		return BubbleChatMessageTypes
	end

	return {
		"Message",
		"Whisper"
	}
end
function checkAllowedMessageType(p107) -- line: 748
	local v202 = getAllowedMessageTypes()

	for i = 1, #v202 do
		if v202[i] == p107.MessageType then
			return true
		end
	end

	return false
end

local DefaultChatSystemChatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents")
local OnMessageDoneFiltering = DefaultChatSystemChatEvents:WaitForChild("OnMessageDoneFiltering")

DefaultChatSystemChatEvents:WaitForChild("OnNewMessage").OnClientEvent:connect(function(p108, _) -- line: 762
	-- upvalues: LocalPlayer (ref), t5 (copy)
	if not checkAllowedMessageType(p108) then
		return
	end

	local v206 = findPlayer(p108.FromSpeaker)

	if not v206 then
		return
	end

	if (not p108.IsFiltered or p108.FromSpeaker == LocalPlayer.Name) and (p108.FromSpeaker ~= LocalPlayer.Name or t5:ShowOwnFilteredMessage()) then
		return
	end

	t5:OnPlayerChatMessage(v206, p108.Message, nil)
end)
OnMessageDoneFiltering.OnClientEvent:connect(function(p110, _) -- line: 781
	-- upvalues: LocalPlayer (ref), t5 (copy)
	if not checkAllowedMessageType(p110) then
		return
	end

	local v209 = findPlayer(p110.FromSpeaker)

	if not v209 then
		return
	end

	if p110.FromSpeaker == LocalPlayer.Name and not t5:ShowOwnFilteredMessage() then
		return
	end

	t5:OnPlayerChatMessage(v209, p110.Message, nil)
end)
