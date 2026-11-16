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

local success, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserShouldLocalizeGameChatBubble")
end)

local v = success and result

local success2, result2 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserFixBubbleChatText")
end)

local v2 = success2 and result2

local success3, result3 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserRoactBubbleChatBeta")
end)

local v3 = success3 and result3

local success4, result4 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserPreventOldBubbleChatOverlap")
end)

local v4 = success4 and result4

local function getMessageLength(p) -- 4 equivalent calls inferred from this helper
	return utf8.len(utf8.nfcnormalize(p))
end

local SourceSans = Enum.Font.SourceSans
local Size24 = Enum.FontSize.Size24
local v5 = 128 - getMessageLength("...") - 1 -- inferred equivalent call

local v6 = { WHITE = "dub", BLUE = "blu", GREEN = "gre", RED = "red" }

local bubbleChat = Instance.new("ScreenGui")
bubbleChat.Name = "BubbleChat"
bubbleChat.ResetOnSpawn = false
bubbleChat.Parent = PlayerGui

local function lerpLength(p, p2, p3) -- 2 equivalent calls inferred from this helper
	return p2 + (p3 - p2) * math.min(getMessageLength(p) / 75, 1) -- inferred equivalent call
end

local function createFifo()
	local fifo = {}
	fifo.data = {}

	local bindableEvent = Instance.new("BindableEvent")
	fifo.Emptied = bindableEvent.Event

	function fifo:Size()
		return #fifo.data
	end

	function fifo:Empty(): boolean
		return fifo:Size() <= 0
	end

	function fifo:PopFront()
		table.remove(fifo.data, 1)

		if fifo:Empty() then
			bindableEvent:Fire()
		end
	end

	function fifo:Front()
		return fifo.data[1]
	end

	function fifo:Get(p)
		return fifo.data[p]
	end

	function fifo:PushBack(p)
		table.insert(fifo.data, p)
	end

	function fifo:GetData()
		return fifo.data
	end

	return fifo
end

local function createCharacterChats() -- 1 equivalent call inferred from this helper
	return { ["Fifo"] = createFifo(), BillboardGui = nil }
end

local function createMap()
	local map = {}
	map.data = {}
	local v7 = 0

	function map:Size()
		return v7
	end

	function map:Erase(p)
		if map.data[p] then
			v7 -= 1
		end

		map.data[p] = nil
	end

	function map.Set(_, p, p2)
		map.data[p] = p2

		if p2 then
			v7 += 1
		end
	end

	function map:Get(p)
		if not p then
			return
		end

		if not map.data[p] then
			map.data[p] = createCharacterChats() -- inferred equivalent call
			local emptiedConnection = nil
			emptiedConnection = map.data[p].Fifo.Emptied:connect(function()
				emptiedConnection:disconnect()
				map:Erase(p)
			end)
		end

		return map.data[p]
	end

	function map:GetData()
		return map.data
	end

	return map
end

local function createChatLine(message, bubbleColor, isLocalPlayer)
	local chatLine = {}

	function chatLine:ComputeBubbleLifetime(p, p2)
		if p2 then
			return lerpLength(p, 8, 15) -- inferred equivalent call
		end

		return lerpLength(p, 12, 20) -- inferred equivalent call
	end

	chatLine.Origin = nil
	chatLine.RenderBubble = nil
	chatLine.Message = message
	chatLine.BubbleDieDelay = chatLine:ComputeBubbleLifetime(message, isLocalPlayer)
	chatLine.BubbleColor = bubbleColor
	chatLine.IsLocalPlayer = isLocalPlayer

	return chatLine
end

local function createPlayerChatLine(player, message, isLocalPlayer)
	local chatLine = createChatLine(message, "dub", isLocalPlayer)

	if player then
		chatLine.User = player.Name
		chatLine.Origin = player.Character
	end

	return chatLine
end

local function createGameChatLine(origin, message, isLocalPlayer, bubbleColor) -- 1 equivalent call inferred from this helper
	local chatLine = createChatLine(message, bubbleColor, isLocalPlayer)
	chatLine.Origin = origin

	return chatLine
end

function createChatBubbleMain(p, sliceCenter)
	local chatBubble = Instance.new("ImageLabel")
	chatBubble.Name = "ChatBubble"
	chatBubble.ScaleType = Enum.ScaleType.Slice
	chatBubble.SliceCenter = sliceCenter
	chatBubble.Image = "rbxasset://textures/" .. tostring(p) .. ".png"
	chatBubble.BackgroundTransparency = 1
	chatBubble.BorderSizePixel = 0
	chatBubble.Size = UDim2.new(1, 0, 1, 0)
	chatBubble.Position = UDim2.new(0, 0, 0, 0)

	return chatBubble
end

function createChatBubbleTail(position, size)
	local chatBubbleTail = Instance.new("ImageLabel")
	chatBubbleTail.Name = "ChatBubbleTail"
	chatBubbleTail.Image = "rbxasset://textures/ui/dialog_tail.png"
	chatBubbleTail.BackgroundTransparency = 1
	chatBubbleTail.BorderSizePixel = 0
	chatBubbleTail.Position = position
	chatBubbleTail.Size = size

	return chatBubbleTail
end

function createChatBubbleWithTail(p, p2, p3, p4)
	local chatBubbleMain = createChatBubbleMain(p, p4)

	local chatBubbleTail = createChatBubbleTail(p2, p3)
	chatBubbleTail.Parent = chatBubbleMain

	return chatBubbleMain
end

function createScaledChatBubbleWithTail(p, p2, p3, p4)
	local chatBubbleMain = createChatBubbleMain(p, p4)

	local chatBubbleTailFrame = Instance.new("Frame")
	chatBubbleTailFrame.Name = "ChatBubbleTailFrame"
	chatBubbleTailFrame.BackgroundTransparency = 1
	chatBubbleTailFrame.SizeConstraint = Enum.SizeConstraint.RelativeXX
	chatBubbleTailFrame.Position = UDim2.new(0.5, 0, 1, 0)
	chatBubbleTailFrame.Size = UDim2.new(p2, 0, p2, 0)
	chatBubbleTailFrame.Parent = chatBubbleMain

	local chatBubbleTail = createChatBubbleTail(p3, UDim2.new(1, 0, 0.5, 0))
	chatBubbleTail.Parent = chatBubbleTailFrame

	return chatBubbleMain
end

function createChatImposter(p, p2, p3)
	local dialogPlaceholder = Instance.new("ImageLabel")
	dialogPlaceholder.Name = "DialogPlaceholder"
	dialogPlaceholder.Image = "rbxasset://textures/" .. tostring(p) .. ".png"
	dialogPlaceholder.BackgroundTransparency = 1
	dialogPlaceholder.BorderSizePixel = 0
	dialogPlaceholder.Position = UDim2.new(0, 0, -1.25, 0)
	dialogPlaceholder.Size = UDim2.new(1, 0, 1, 0)

	local dotDotDot = Instance.new("ImageLabel")
	dotDotDot.Name = "DotDotDot"
	dotDotDot.Image = "rbxasset://textures/" .. tostring(p2) .. ".png"
	dotDotDot.BackgroundTransparency = 1
	dotDotDot.BorderSizePixel = 0
	dotDotDot.Position = UDim2.new(0.001, 0, p3, 0)
	dotDotDot.Size = UDim2.new(1, 0, 0.7, 0)
	dotDotDot.Parent = dialogPlaceholder

	return dialogPlaceholder
end

local v7 = {}
v7.ChatBubble = {}
v7.ChatBubbleWithTail = {}
v7.ScalingChatBubbleWithTail = {}
v7.CharacterSortedMsg = createMap()

local function initChatBubbleType(p, p2, _, p3, rect)
	v7.ChatBubble[p] = createChatBubbleMain(p2, rect)
	v7.ChatBubbleWithTail[p] = createChatBubbleWithTail(
		p2,
		UDim2.new(0.5, -14, 1, p3 and -1 or 0),
		UDim2.new(0, 30, 0, 14),
		rect
	)
	v7.ScalingChatBubbleWithTail[p] = createScaledChatBubbleWithTail(
		p2,
		0.5,
		UDim2.new(-0.5, 0, 0, p3 and -1 or 0),
		rect
	)
end

initChatBubbleType("dub", "ui/dialog_white", "ui/chatBubble_white_notify_bkg", false, Rect.new(5, 5, 15, 15))
initChatBubbleType("blu", "ui/dialog_blue", "ui/chatBubble_blue_notify_bkg", true, Rect.new(7, 7, 33, 33))
initChatBubbleType("red", "ui/dialog_red", "ui/chatBubble_red_notify_bkg", true, Rect.new(7, 7, 33, 33))
initChatBubbleType("gre", "ui/dialog_green", "ui/chatBubble_green_notify_bkg", true, Rect.new(7, 7, 33, 33))

function v7:SanitizeChatLine(value)
	if v5 < getMessageLength(value) then -- inferred equivalent call
		return (string.sub(value, 1, utf8.offset(value, v5 + getMessageLength("...") + 1) - 1)) -- inferred equivalent call
	end

	return value
end

local function createBillboardInstance(adornee)
	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Adornee = adornee
	billboardGui.Size = UDim2.new(0, 400, 0, 250)
	billboardGui.StudsOffset = Vector3.new(0, 1.5, 2)
	billboardGui.Parent = bubbleChat

	local billboardFrame = Instance.new("Frame")
	billboardFrame.Name = "BillboardFrame"
	billboardFrame.Size = UDim2.new(1, 0, 1, 0)
	billboardFrame.Position = UDim2.new(0, 0, -0.5, 0)
	billboardFrame.BackgroundTransparency = 1
	billboardFrame.Parent = billboardGui

	local childRemovedConnection = nil
	childRemovedConnection = billboardFrame.ChildRemoved:connect(function()
		if #billboardFrame:GetChildren() <= 1 then
			childRemovedConnection:disconnect()
			billboardGui:Destroy()
		end
	end)

	local createSmallTalkBubble = v7:CreateSmallTalkBubble("dub")
	createSmallTalkBubble.Parent = billboardFrame

	return billboardGui
end

function v7:CreateBillboardGuiHelper(instance, p)
	if instance and not v7.CharacterSortedMsg:Get(instance).BillboardGui then
		if p or not instance:IsA("BasePart") then
			if instance:IsA("Model") then
				local head = instance:FindFirstChild("Head")

				if head and head:IsA("BasePart") then
					local billboardInstance = createBillboardInstance(head)
					local get = v7.CharacterSortedMsg:Get(instance)
					get.BillboardGui = billboardInstance
				end
			end
		else
			local billboardInstance = createBillboardInstance(instance)
			local get = v7.CharacterSortedMsg:Get(instance)
			get.BillboardGui = billboardInstance
		end
	end
end

local function distanceToBubbleOrigin(model) -- 1 equivalent call inferred from this helper
	if model then
		return (model.Position - game.Workspace.CurrentCamera.CoordinateFrame.Position).magnitude
	end

	return 100000
end

local function isPartOfLocalPlayer(adornee) -- 2 equivalent calls inferred from this helper
	if adornee and Players.LocalPlayer.Character then
		return adornee:IsDescendantOf(Players.LocalPlayer.Character)
	end
end

function v7:SetBillboardLODNear(state)
	local partOfLocalPlayer = isPartOfLocalPlayer(state.Adornee) -- inferred equivalent call
	state.Size = UDim2.new(0, 400, 0, 250)
	state.StudsOffset = Vector3.new(0, partOfLocalPlayer and 1.5 or 2.5, partOfLocalPlayer and 2 or 0.1)
	state.Enabled = true
	local children = state.BillboardFrame:GetChildren()

	for i = 1, #children do
		children[i].Visible = true
	end

	state.BillboardFrame.SmallTalkBubble.Visible = false
end

function v7:SetBillboardLODDistant(state)
	local partOfLocalPlayer = isPartOfLocalPlayer(state.Adornee) -- inferred equivalent call
	state.Size = UDim2.new(4, 0, 3, 0)
	state.StudsOffset = Vector3.new(0, 3, partOfLocalPlayer and 2 or 0.1)
	state.Enabled = true
	local children = state.BillboardFrame:GetChildren()

	for i = 1, #children do
		children[i].Visible = false
	end

	state.BillboardFrame.SmallTalkBubble.Visible = true
end

function v7:SetBillboardLODVeryFar(p)
	p.Enabled = false
end

function v7:SetBillboardGuiLOD(p, model)
	if not model then
		return
	end

	if model:IsA("Model") then
		model = model:FindFirstChild("Head") or model.PrimaryPart
	end

	local v8 = distanceToBubbleOrigin(model) -- inferred equivalent call

	if v8 < 65 then
		v7:SetBillboardLODNear(p)
	elseif v8 >= 65 and v8 < 100 then
		v7:SetBillboardLODDistant(p)
	else
		v7:SetBillboardLODVeryFar(p)
	end
end

function v7:CameraCFrameChanged()
	for k, v8 in pairs(v7.CharacterSortedMsg:GetData()) do
		local billboardGui = v8.BillboardGui

		if billboardGui then
			v7:SetBillboardGuiLOD(billboardGui, k)
		end
	end
end

function v7:CreateBubbleText(text, autoLocalize)
	local bubbleText = Instance.new("TextLabel")
	bubbleText.Name = "BubbleText"
	bubbleText.BackgroundTransparency = 1

	if v2 then
		bubbleText.Size = UDim2.fromScale(1, 1)
	else
		bubbleText.Position = UDim2.new(0, 15, 0, 0)
		bubbleText.Size = UDim2.new(1, -30, 1, 0)
	end

	bubbleText.Font = SourceSans
	bubbleText.ClipsDescendants = true
	bubbleText.TextWrapped = true
	bubbleText.FontSize = Size24
	bubbleText.Text = text
	bubbleText.Visible = false
	bubbleText.AutoLocalize = autoLocalize

	if not v2 then
		return bubbleText
	end

	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingTop = UDim.new(0, 12)
	uiPadding.PaddingRight = UDim.new(0, 12)
	uiPadding.PaddingBottom = UDim.new(0, 12)
	uiPadding.PaddingLeft = UDim.new(0, 12)
	uiPadding.Parent = bubbleText

	return bubbleText
end

function v7.CreateSmallTalkBubble(_, p)
	local smallTalkBubble = v7.ScalingChatBubbleWithTail[p]:Clone()
	smallTalkBubble.Name = "SmallTalkBubble"
	smallTalkBubble.AnchorPoint = Vector2.new(0, 0.5)
	smallTalkBubble.Position = UDim2.new(0, 0, 0.5, 0)
	smallTalkBubble.Visible = false
	local bubbleText = v7:CreateBubbleText("...")
	bubbleText.TextScaled = true
	bubbleText.TextWrapped = false
	bubbleText.Visible = true
	bubbleText.Parent = smallTalkBubble

	return smallTalkBubble
end

function v7:UpdateChatLinesForOrigin(p, p2)
	local fifo = v7.CharacterSortedMsg:Get(p).Fifo
	local size = fifo:Size()
	local data = fifo:GetData()

	if #data <= 1 then
		return
	end

	for i = #data - 1, 1, -1 do
		local renderBubble = data[i].RenderBubble

		if not renderBubble then
			break
		end

		if size - i + 1 > 1 then
			local chatBubbleTail = renderBubble:FindFirstChild("ChatBubbleTail")

			if chatBubbleTail then
				chatBubbleTail:Destroy()
			end

			local bubbleText = renderBubble:FindFirstChild("BubbleText")

			if bubbleText then
				bubbleText.TextTransparency = 0.5
			end
		end

		renderBubble:TweenPosition(
			UDim2.new(
				renderBubble.Position.X.Scale,
				renderBubble.Position.X.Offset,
				1,
				p2 - renderBubble.Size.Y.Offset - 14
			),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Bounce,
			0.1,
			true
		)
		p2 = p2 - renderBubble.Size.Y.Offset - 14
	end
end

function v7:DestroyBubble(object, p)
	if not object or object:Empty() then
		return
	end

	local renderBubble = object:Front().RenderBubble

	if renderBubble then
		spawn(function()
			while object:Front().RenderBubble ~= p do
				wait()
			end

			renderBubble = object:Front().RenderBubble

			local bubbleText = renderBubble:FindFirstChild("BubbleText")
			local chatBubbleTail = renderBubble:FindFirstChild("ChatBubbleTail")

			while renderBubble and renderBubble.ImageTransparency < 1 do
				local v8 = wait()

				if not renderBubble then
					continue
				end

				local v9 = v8 * 1.5
				renderBubble.ImageTransparency += v9

				if bubbleText then
					bubbleText.TextTransparency += v9
				end

				if chatBubbleTail then
					chatBubbleTail.ImageTransparency += v9
				end
			end

			if renderBubble then
				renderBubble:Destroy()
				object:PopFront()
			end
		end)
	else
		object:PopFront()
	end
end

function v7:CreateChatLineRender(p, state, p2, p3, p4)
	if not p then
		return
	end

	if not v7.CharacterSortedMsg:Get(p).BillboardGui then
		v7:CreateBillboardGuiHelper(p, p2)
	end

	local billboardGui = v7.CharacterSortedMsg:Get(p).BillboardGui

	if billboardGui then
		local clone = v7.ChatBubbleWithTail[state.BubbleColor]:Clone()
		clone.Visible = false
		local bubbleText = v7:CreateBubbleText(state.Message, p4)

		bubbleText.Parent = clone
		clone.Parent = billboardGui.BillboardFrame

		state.RenderBubble = clone

		local textSize = TextService:GetTextSize(bubbleText.Text, 24, SourceSans, Vector2.new(400, 250))
		local v8 = textSize.Y / 24

		if v2 then
			local v9 = math.ceil(textSize.X + 24)
			local v10 = v8 * 34

			clone.Size = UDim2.fromOffset(0, 0)
			clone.Position = UDim2.fromScale(0.5, 1)

			clone:TweenSizeAndPosition(
				UDim2.fromOffset(v9, v10),
				UDim2.new(0.5, -v9 / 2, 1, -v10),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Elastic,
				0.1,
				true,
				function()
					bubbleText.Visible = true
				end
			)

			v7:SetBillboardGuiLOD(billboardGui, state.Origin)
			v7:UpdateChatLinesForOrigin(state.Origin, -v10)
		else
			local v9 = math.max((textSize.X + 30) / 400, 0.1)

			clone.Size = UDim2.new(0, 0, 0, 0)
			clone.Position = UDim2.new(0.5, 0, 1, 0)

			local v10 = v8 * 34

			clone:TweenSizeAndPosition(
				UDim2.new(v9, 0, 0, v10),
				UDim2.new((1 - v9) / 2, 0, 1, -v10),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Elastic,
				0.1,
				true,
				function()
					bubbleText.Visible = true
				end
			)

			v7:SetBillboardGuiLOD(billboardGui, state.Origin)
			v7:UpdateChatLinesForOrigin(state.Origin, -v10)
		end

		delay(state.BubbleDieDelay, function()
			v7:DestroyBubble(p3, clone)
		end)
	end
end

function v7:OnPlayerChatMessage(player, p, _)
	if not v7:BubbleChatEnabled() then
		return
	end

	local localPlayer = Players.LocalPlayer
	local v8

	if localPlayer == nil then
		v8 = false
	else
		v8 = player ~= localPlayer
	end

	local chatLine = createChatLine(v7:SanitizeChatLine(p), v6.WHITE, not v8)

	if player then
		chatLine.User = player.Name
		chatLine.Origin = player.Character
	end

	if player and chatLine.Origin then
		local fifo = v7.CharacterSortedMsg:Get(chatLine.Origin).Fifo
		fifo:PushBack(chatLine)

		v7:CreateChatLineRender(player.Character, chatLine, true, fifo, false)
	end
end

function v7:OnGameChatMessage(origin, p, p2)
	if v3 or v4 and Chat.BubbleChatEnabled then
		return
	end

	local localPlayer = Players.LocalPlayer
	local v8

	if localPlayer == nil then
		v8 = false
	else
		v8 = localPlayer.Character ~= origin
	end

	local v9

	if p2 == Enum.ChatColor.Blue then
		v9 = "blu"
	elseif p2 == Enum.ChatColor.Green then
		v9 = "gre"
	else
		v9 = if p2 == Enum.ChatColor.Red then "red" else "dub"
	end

	local gameChatLine = createGameChatLine(origin, v7:SanitizeChatLine(p), not v8, v9) -- inferred equivalent call

	v7.CharacterSortedMsg:Get(gameChatLine.Origin).Fifo:PushBack(gameChatLine)

	if v then
		v7:CreateChatLineRender(origin, gameChatLine, false, v7.CharacterSortedMsg:Get(gameChatLine.Origin).Fifo, true)
	else
		v7:CreateChatLineRender(origin, gameChatLine, false, v7.CharacterSortedMsg:Get(gameChatLine.Origin).Fifo, false)
	end
end

function v7:BubbleChatEnabled()
	if v3 or v4 and Chat.BubbleChatEnabled then
		return false
	end

	local clientChatModules = Chat:FindFirstChild("ClientChatModules")

	local chatSettings = clientChatModules and clientChatModules:FindFirstChild("ChatSettings")

	if chatSettings then
		local module = require(chatSettings)

		if module.BubbleChatEnabled ~= nil then
			return module.BubbleChatEnabled
		end
	end

	return Players.BubbleChat
end

function v7:ShowOwnFilteredMessage()
	local clientChatModules = Chat:FindFirstChild("ClientChatModules")

	local chatSettings = clientChatModules and clientChatModules:FindFirstChild("ChatSettings")

	if not chatSettings then
		return false
	end

	local module = require(chatSettings)
	return module.ShowUserOwnFilteredMessage
end

function findPlayer(p)
	for _, player in pairs(Players:GetPlayers()) do
		if player.Name == p then
			return player
		end
	end
end

Chat.Chatted:connect(function(p, p2, p3)
	v7:OnGameChatMessage(p, p2, p3)
end)
local cFrameChangedConnection

if game.Workspace.CurrentCamera then
	cFrameChangedConnection = game.Workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(function(_)
		v7:CameraCFrameChanged()
	end)
else
	cFrameChangedConnection = nil
end

game.Workspace.Changed:Connect(function(p)
	if p == "CurrentCamera" then
		if cFrameChangedConnection then
			cFrameChangedConnection:disconnect()
		end

		if game.Workspace.CurrentCamera then
			cFrameChangedConnection = game.Workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(function(_)
				v7:CameraCFrameChanged()
			end)
		end
	end
end)

local v8 = nil

function getAllowedMessageTypes()
	if v8 then
		return v8
	end

	local clientChatModules = Chat:FindFirstChild("ClientChatModules")

	if not clientChatModules then
		return { "Message", "Whisper" }
	end

	local chatSettings = clientChatModules:FindFirstChild("ChatSettings")

	if chatSettings then
		local module = require(chatSettings)

		if module.BubbleChatMessageTypes then
			v8 = module.BubbleChatMessageTypes
			return v8
		end
	end

	local chatConstants = clientChatModules:FindFirstChild("ChatConstants")

	if chatConstants then
		local module = require(chatConstants)
		v8 = { module.MessageTypeDefault, module.MessageTypeWhisper }
	end

	return v8
end

function checkAllowedMessageType(p): boolean
	local allowedMessageTypes = getAllowedMessageTypes()

	for i = 1, #allowedMessageTypes do
		if allowedMessageTypes[i] == p.MessageType then
			return true
		end
	end

	return false
end

local DefaultChatSystemChatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents")
local OnMessageDoneFiltering = DefaultChatSystemChatEvents:WaitForChild("OnMessageDoneFiltering")
DefaultChatSystemChatEvents:WaitForChild("OnNewMessage").OnClientEvent:connect(function(data, _)
	if not checkAllowedMessageType(data) then
		return
	end

	local player = findPlayer(data.FromSpeaker)

	if
		not player
		or (not data.IsFiltered or data.FromSpeaker == LocalPlayer.Name)
		and (data.FromSpeaker ~= LocalPlayer.Name or v7:ShowOwnFilteredMessage())
	then
		return
	end

	v7:OnPlayerChatMessage(player, data.Message, nil)
end)

OnMessageDoneFiltering.OnClientEvent:connect(function(p, _)
	if not checkAllowedMessageType(p) then
		return
	end

	local player = findPlayer(p.FromSpeaker)

	if not player or p.FromSpeaker == LocalPlayer.Name and not v7:ShowOwnFilteredMessage() then
		return
	end

	v7:OnPlayerChatMessage(player, p.Message, nil)
end)
