local TextChatService = game:GetService("TextChatService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local useCursor = require(ExpChatParent.UIBlox).App.SelectionCursor.useCursor
local Localization = require(ExpChat.Localization)
local Config = require(ExpChat.Config)
local useInterpolatedClientSettings = require(ExpChat.ClientSettings.useInterpolatedClientSettings)
local EngineFeature = game:GetEngineFeature("EnableChatButtonTelemetryEnabled")
local FFlagExpChatNewInputBar = require(ExpChat.Flags.FFlagExpChatNewInputBar)

local function setTransparency(p1, p2) -- line: 36
	return p2:map(function(n1: number) -- line: 37
		-- upvalues: p1 (copy)
		return p1 + n1 * (1 - p1)
	end)
end
local function EnableChatButton(t1: {[any]: any}) -- line: 42
	-- upvalues: useCursor (copy), useInterpolatedClientSettings (copy), React (copy), EngineFeature (copy), TextChatService (copy), FFlagExpChatNewInputBar (copy), Config (copy)
	local v16 = useCursor()
	local isSpatialUIEnabled = t1.isSpatialUIEnabled
	local chatWindowSettings = t1.chatWindowSettings
	local BackgroundTransparency = useInterpolatedClientSettings(chatWindowSettings).BackgroundTransparency
	local BackgroundColor3 = useInterpolatedClientSettings(chatWindowSettings).BackgroundColor3

	React.useEffect(function() -- line: 55
		-- upvalues: EngineFeature (copy), t1 (copy), TextChatService (copy)
		if EngineFeature and t1.visible then
			TextChatService:SendEnableChatButtonShown()
		end
	end, { t1.visible })

	local createElement = React.createElement
	local t2 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = BackgroundColor3,
		BackgroundTransparency = if not FFlagExpChatNewInputBar then t1.transparencyValue:map(function(n2: number) -- line: 37
			-- upvalues: BackgroundTransparency (copy)
			return BackgroundTransparency + n2 * (1 - BackgroundTransparency)
		end) else 1,
		BorderSizePixel = 0,
		LayoutOrder = t1.LayoutOrder,
		Size = UDim2.fromScale(1, 0),
		Visible = t1.visible,
		ZIndex = 2,
		[React.Event.MouseEnter] = t1.onHovered,
		[React.Event.MouseLeave] = t1.onUnhovered
	}
	local t3 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = if not FFlagExpChatNewInputBar then UDim.new(0, 8) else nil,
			PaddingRight = if not FFlagExpChatNewInputBar then UDim.new(0, 8) else nil,
			PaddingTop = t1.addTopPadding and UDim.new(0, 8) or UDim.new(0, 0),
			PaddingBottom = UDim.new(0, 1)
		})
	}
	local createElement2 = React.createElement
	local t4 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Config.EnableChatButtonBackgroundColor
	}
	local EnableChatButtonBackgroundTransparency = Config.EnableChatButtonBackgroundTransparency

	t4.BackgroundTransparency = t1.transparencyValue:map(function(n3: number) -- line: 37
		-- upvalues: EnableChatButtonBackgroundTransparency (copy)
		return EnableChatButtonBackgroundTransparency + n3 * (1 - EnableChatButtonBackgroundTransparency)
	end)
	t4.Size = UDim2.fromScale(1, 0)
	t4.FontFace = Config.EnableChatButtonFontFace
	t4.Selectable = true
	t4.SelectionImageObject = v16
	t4.Text = (t1.EnableChatButtonText == nil or t1.EnableChatButtonText == "") and "Unlock chat" or t1.EnableChatButtonText
	t4.TextColor3 = Config.ChatInputBarTextColor3
	t4.TextSize = if not isSpatialUIEnabled then Config.ChatInputBarTextSize else Config.ChatInputBarSpatialPanelTextSize

	local n4 = 0

	t4.TextTransparency = t1.transparencyValue:map(function(n5: number) -- line: 37
		-- upvalues: n4 (copy)
		return n4 + n5 * (1 - n4)
	end)
	t4.TextWrapped = true
	t4.TextXAlignment = Enum.TextXAlignment.Center
	t4.TextYAlignment = Enum.TextYAlignment.Center
	t4.ZIndex = 2
	t4[React.Event.Activated] = function() -- line: 104
		-- upvalues: EngineFeature (copy), TextChatService (copy), t1 (copy)
		if EngineFeature then
			TextChatService:SendEnableChatButtonClicked()
		end

		t1.onActivated()
	end
	t3.EnableChatButton = createElement2("TextButton", t4, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10)
		})
	})

	return createElement("Frame", t2, t3)
end

return Localization.connect(function() -- line: 124
	return {
		EnableChatButtonText = "CoreScripts.TextChat.EnableChatButton.Label.UnlockChat"
	}
end)(EnableChatButton)
