local u1 = false
local ok, result = pcall(function() -- line: 41
	return UserSettings():IsUserFeatureEnabled("UserFixOverlappingRtlChatMessages2")
end)

if ok then
	u1 = result
end

local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.ChildAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local ParentParent = script.Parent.Parent
local ChatSettings = require(ParentParent:WaitForChild("ChatSettings"))
local ChatConstants = require(ParentParent:WaitForChild("ChatConstants"))
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.GetStringTextBounds(_, p2, p3, p4, p5) -- line: 66
	-- upvalues: TextService (copy)
	local v17 = p5 or Vector2.new(10000, 10000)

	return TextService:GetTextSize(p2, p4, p3, v17)
end
function t2.GetMessageHeight(p6, p7, p8, p9) -- line: 72
	-- upvalues: u1 (ref)
	local v22 = p9 or p8.AbsoluteSize.X
	local StringTextBounds = p6:GetStringTextBounds(if not u1 then p7.Text else p7.ContentText, p7.Font, p7.TextSize, Vector2.new(v22, 1000))

	if StringTextBounds.Y ~= math.floor(StringTextBounds.Y) then
		return StringTextBounds.Y + 1
	end

	return StringTextBounds.Y
end
function t2.GetNumberOfSpaces(p10, p11, p12, p13) -- line: 84
	local StringTextBounds = p10:GetStringTextBounds(p11, p12, p13)
	local StringTextBounds2 = p10:GetStringTextBounds(" ", p12, p13)

	return (math.ceil(StringTextBounds.X / StringTextBounds2.X))
end
function t2.CreateLeadingSpaces(_, p15) -- line: 90
	-- upvalues: u1 (ref)
	if u1 then
		return "<font dir=\"ltr\">" .. string.rep(" ", p15) .. "</font>"
	end

	return string.rep(" ", p15)
end
function t2.SanitizeForRichText(_, p17) -- line: 98
	-- upvalues: u1 (ref)
	if u1 then
		return string.gsub(p17, "%p", {
			["<"] = "&lt;",
			[">"] = "&gt;",
			["&"] = "&amp;"
		})
	end

	return p17
end
function t2.CreateBaseMessage(p18, p19, p20, p21, p22) -- line: 110
	-- upvalues: u1 (ref)
	local FromObjectPool = p18:GetFromObjectPool("Frame")

	FromObjectPool.Selectable = false
	FromObjectPool.Size = UDim2.new(1, 0, 0, 18)
	FromObjectPool.Visible = true
	FromObjectPool.BackgroundTransparency = 1

	local FromObjectPool2 = p18:GetFromObjectPool("TextLabel")

	FromObjectPool2.Selectable = false
	FromObjectPool2.Size = UDim2.new(1, -14, 1, 0)
	FromObjectPool2.Position = UDim2.new(0, 8, 0, 0)
	FromObjectPool2.BackgroundTransparency = 1
	FromObjectPool2.Font = p20
	FromObjectPool2.TextSize = p21
	FromObjectPool2.TextXAlignment = Enum.TextXAlignment.Left
	FromObjectPool2.TextYAlignment = Enum.TextYAlignment.Top
	FromObjectPool2.TextTransparency = 0
	FromObjectPool2.TextStrokeTransparency = 0.75
	FromObjectPool2.TextColor3 = p22
	FromObjectPool2.TextWrapped = true
	FromObjectPool2.ClipsDescendants = true
	FromObjectPool2.Text = p19
	FromObjectPool2.Visible = true
	FromObjectPool2.RichText = not not u1
	FromObjectPool2.Parent = FromObjectPool

	return FromObjectPool, FromObjectPool2
end
function t2.AddNameButtonToBaseMessage(p23, p24, p25, p26, p27) -- line: 141
	local StringTextBounds = p23:GetStringTextBounds(p26, p24.Font, p24.TextSize)
	local FromObjectPool = p23:GetFromObjectPool("TextButton")

	FromObjectPool.Selectable = false
	FromObjectPool.Size = UDim2.new(0, StringTextBounds.X, 0, StringTextBounds.Y)
	FromObjectPool.Position = UDim2.new(0, 0, 0, 0)
	FromObjectPool.BackgroundTransparency = 1
	FromObjectPool.Font = p24.Font
	FromObjectPool.TextSize = p24.TextSize
	FromObjectPool.TextXAlignment = p24.TextXAlignment
	FromObjectPool.TextYAlignment = p24.TextYAlignment
	FromObjectPool.TextTransparency = p24.TextTransparency
	FromObjectPool.TextStrokeTransparency = p24.TextStrokeTransparency
	FromObjectPool.TextColor3 = p25
	FromObjectPool.Text = p26
	FromObjectPool.Visible = true
	FromObjectPool.Parent = p24

	local v48 = FromObjectPool.MouseButton1Click:connect(function() -- line: 159
		-- upvalues: p23 (copy), FromObjectPool (copy), p27 (copy)
		p23:NameButtonClicked(FromObjectPool, p27)
	end)
	local u49 = nil

	u49 = FromObjectPool.Changed:connect(function(p28) -- line: 164
		-- upvalues: v48 (copy), u49 (ref)
		if p28 == "Parent" then
			v48:Disconnect()
			u49:Disconnect()
		end
	end)

	return FromObjectPool
end
function t2.AddTranslationButtonToBaseMessage(p29, p30) -- line: 174
	local v52 = math.floor(p30.TextSize * 0.9)
	local vector2 = Vector2.new(v52, v52)
	local FromObjectPool = p29:GetFromObjectPool("ImageButton")

	FromObjectPool.Selectable = false
	FromObjectPool.Size = UDim2.new(0, vector2.X, 0, vector2.Y)
	FromObjectPool.Position = UDim2.new(0, 0, 0, 0)
	FromObjectPool.BackgroundTransparency = 1
	FromObjectPool.Visible = false
	FromObjectPool.Parent = p30
	FromObjectPool.Image = "rbxasset://textures/translateIcon.png"
	FromObjectPool.HoverImage = "rbxasset://textures/translateIconDark.png"
	FromObjectPool.PressedImage = "rbxasset://textures/translateIconDark.png"

	return FromObjectPool
end
function t2.AddChannelButtonToBaseMessage(p31, p32, p33, p34, p35) -- line: 191
	local StringTextBounds = p31:GetStringTextBounds(p34, p32.Font, p32.TextSize)
	local FromObjectPool = p31:GetFromObjectPool("TextButton")

	FromObjectPool.Selectable = false
	FromObjectPool.Size = UDim2.new(0, StringTextBounds.X, 0, StringTextBounds.Y)
	FromObjectPool.Position = UDim2.new(0, 0, 0, 0)
	FromObjectPool.BackgroundTransparency = 1
	FromObjectPool.Font = p32.Font
	FromObjectPool.TextSize = p32.TextSize
	FromObjectPool.TextXAlignment = p32.TextXAlignment
	FromObjectPool.TextYAlignment = p32.TextYAlignment
	FromObjectPool.TextTransparency = p32.TextTransparency
	FromObjectPool.TextStrokeTransparency = p32.TextStrokeTransparency
	FromObjectPool.TextColor3 = p33
	FromObjectPool.Text = p34
	FromObjectPool.Visible = true
	FromObjectPool.Parent = p32

	local v62 = FromObjectPool.MouseButton1Click:connect(function() -- line: 209
		-- upvalues: p31 (copy), FromObjectPool (copy), p35 (copy)
		p31:ChannelButtonClicked(FromObjectPool, p35)
	end)
	local u63 = nil

	u63 = FromObjectPool.Changed:connect(function(p36) -- line: 214
		-- upvalues: v62 (copy), u63 (ref)
		if p36 == "Parent" then
			v62:Disconnect()
			u63:Disconnect()
		end
	end)

	return FromObjectPool
end
function t2.AddTagLabelToBaseMessage(p37, p38, p39, p40) -- line: 224
	local StringTextBounds = p37:GetStringTextBounds(p40, p38.Font, p38.TextSize)
	local FromObjectPool = p37:GetFromObjectPool("TextLabel")

	FromObjectPool.Selectable = false
	FromObjectPool.Size = UDim2.new(0, StringTextBounds.X, 0, StringTextBounds.Y)
	FromObjectPool.Position = UDim2.new(0, 0, 0, 0)
	FromObjectPool.BackgroundTransparency = 1
	FromObjectPool.Font = p38.Font
	FromObjectPool.TextSize = p38.TextSize
	FromObjectPool.TextXAlignment = p38.TextXAlignment
	FromObjectPool.TextYAlignment = p38.TextYAlignment
	FromObjectPool.TextTransparency = p38.TextTransparency
	FromObjectPool.TextStrokeTransparency = p38.TextStrokeTransparency
	FromObjectPool.TextColor3 = p39
	FromObjectPool.Text = p40
	FromObjectPool.Visible = true
	FromObjectPool.Parent = p38

	return FromObjectPool
end
function GetWhisperChannelPrefix() -- line: 245
	-- upvalues: ChatConstants (copy)
	if ChatConstants.WhisperChannelPrefix then
		return ChatConstants.WhisperChannelPrefix
	end

	return "To "
end
function t2.NameButtonClicked(p41, _, p43) -- line: 252
	-- upvalues: ChatSettings (copy), Players (copy), LocalPlayer (ref)
	if not p41.ChatWindow then
		return
	end

	if ChatSettings.ClickOnPlayerNameToWhisper then
		local p43_2 = Players:FindFirstChild(p43)

		if p43_2 and p43_2 ~= LocalPlayer then
			local v74 = GetWhisperChannelPrefix() .. p43

			if p41.ChatWindow:GetChannel(v74) then
				p41.ChatBar:ResetCustomState()

				if v74 ~= p41.ChatWindow:GetTargetMessageChannel() then
					p41.ChatWindow:SwitchCurrentChannel(v74)
				end

				local v75 = "/w " .. p43

				p41.ChatBar:SetText(v75)
				p41.ChatBar:CaptureFocus()

				return
			end

			if not p41.ChatBar:IsInCustomState() then
				local v76 = "/w " .. p43

				p41.ChatBar:SetText(v76)
				p41.ChatBar:CaptureFocus()
			end
		end
	end
end
function t2.ChannelButtonClicked(p44, _, p46) -- line: 282
	-- upvalues: ChatSettings (copy)
	if not p44.ChatWindow then
		return
	end

	if ChatSettings.ClickOnChannelNameToSetMainChannel and p44.ChatWindow:GetChannel(p46) then
		p44.ChatBar:ResetCustomState()

		if p46 ~= p44.ChatWindow:GetTargetMessageChannel() then
			p44.ChatWindow:SwitchCurrentChannel(p46)
		end

		p44.ChatBar:ResetText()
		p44.ChatBar:CaptureFocus()
	end
end
function t2.RegisterChatWindow(p47, p48) -- line: 300
	p47.ChatWindow = p48
	p47.ChatBar = p48:GetChatBar()
end
function t2.GetFromObjectPool(p49, p50) -- line: 305
	if p49.ObjectPool == nil then
		return Instance.new(p50)
	end

	return p49.ObjectPool:GetInstance(p50)
end
function t2.RegisterObjectPool(p51, p52) -- line: 312
	p51.ObjectPool = p52
end
function t2.CreateFadeFunctions(_, p54) -- line: 332
	local t3 = {}

	for k, v in pairs(p54) do
		t3[k] = {}

		for k2, v2 in pairs(v) do
			t3[k][k2] = {
				NormalizedExptValue = 1,
				Target = v2.FadedIn,
				Current = k[k2]
			}
		end
	end

	local function FadeInFunction(p55, p56) -- line: 345
		-- upvalues: t3 (copy), p54 (copy)
		for k, v in pairs(t3) do
			for k3, v3 in pairs(v) do
				v3.Target = p54[k][k3].FadedIn
				v3.NormalizedExptValue = p56:NormalizedDefaultExptValueInSeconds(p55)
			end
		end
	end
	local function FadeOutFunction(p57, p58) -- line: 354
		-- upvalues: t3 (copy), p54 (copy)
		for k, v in pairs(t3) do
			for k4, v4 in pairs(v) do
				v4.Target = p54[k][k4].FadedOut
				v4.NormalizedExptValue = p58:NormalizedDefaultExptValueInSeconds(p57)
			end
		end
	end
	local function AnimGuiObjects() -- line: 363
		-- upvalues: t3 (copy)
		for k, v in pairs(t3) do
			for k5, v5 in pairs(v) do
				k[k5] = v5.Current
			end
		end
	end
	local function UpdateAnimFunction(p59, p60) -- line: 371
		-- upvalues: t3 (copy), AnimGuiObjects (copy)
		for _, v in pairs(t3) do
			for _, v6 in pairs(v) do
				v6.Current = p60:Expt(v6.Current, v6.Target, v6.NormalizedExptValue, p59)
			end
		end

		AnimGuiObjects()
	end

	return FadeInFunction, FadeOutFunction, UpdateAnimFunction
end
function t2.NewBindableEvent(_, p62) -- line: 389
	local BindableEvent = Instance.new("BindableEvent")

	BindableEvent.Name = p62

	return BindableEvent
end
function t2.RegisterGuiRoot(_) -- line: 396
end
function t1.new() -- line: 401
	-- upvalues: t2 (copy)
	local self = setmetatable({}, t2)

	self.ObjectPool = nil
	self.ChatWindow = nil
	self.DEFAULT_MESSAGE_CREATOR = "UnknownMessage"
	self.MESSAGE_CREATOR_MODULES_VERSION = 1
	self.KEY_MESSAGE_TYPE = "MessageType"
	self.KEY_CREATOR_FUNCTION = "MessageCreatorFunc"
	self.KEY_BASE_FRAME = "BaseFrame"
	self.KEY_BASE_MESSAGE = "BaseMessage"
	self.KEY_UPDATE_TEXT_FUNC = "UpdateTextFunction"
	self.KEY_GET_HEIGHT = "GetHeightFunction"
	self.KEY_FADE_IN = "FadeInFunction"
	self.KEY_FADE_OUT = "FadeOutFunction"
	self.KEY_UPDATE_ANIMATION = "UpdateAnimFunction"

	return self
end

return t1.new()
