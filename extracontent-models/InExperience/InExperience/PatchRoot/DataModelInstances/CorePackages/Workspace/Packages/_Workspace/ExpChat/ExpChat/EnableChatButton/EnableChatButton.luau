local TextChatService = game:GetService("TextChatService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local useCursor = UIBlox.App.SelectionCursor.useCursor

local Localization = require(ExpChat.Localization)
local Config = require(ExpChat.Config)
local useInterpolatedClientSettings = require(ExpChat.ClientSettings.useInterpolatedClientSettings)

local engineFeature = game:GetEngineFeature("EnableChatButtonTelemetryEnabled")

local FFlagExpChatNewInputBar = require(ExpChat.Flags.FFlagExpChatNewInputBar)

local function setTransparency(p, transparencyValue) -- 3 equivalent calls inferred from this helper
	return transparencyValue:map(function(p2: number)
		return p + p2 * (1 - p)
	end)
end

local function EnableChatButton(props)
	local selectionImageObject = useCursor()

	local isSpatialUIEnabled = props.isSpatialUIEnabled
	local chatWindowSettings = props.chatWindowSettings

	local backgroundTransparency = useInterpolatedClientSettings(chatWindowSettings).BackgroundTransparency
	local backgroundColor3 = useInterpolatedClientSettings(chatWindowSettings).BackgroundColor3

	React.useEffect(function()
		if engineFeature and props.visible then
			TextChatService:SendEnableChatButtonShown()
		end
	end, { props.visible })

	local createElement = React.createElement
	local v = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = backgroundColor3,
		BackgroundTransparency = FFlagExpChatNewInputBar and 1 or setTransparency( -- inferred equivalent call
			backgroundTransparency,
			props.transparencyValue
		),
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromScale(1, 0),
		Visible = props.visible,
		ZIndex = 2,
		[React.Event.MouseEnter] = props.onHovered,
		[React.Event.MouseLeave] = props.onUnhovered
	}

	local createElement2 = React.createElement
	local paddingLeft

	if not FFlagExpChatNewInputBar then
		paddingLeft = UDim.new(0, 8)
	end

	local paddingRight

	if not FFlagExpChatNewInputBar then
		paddingRight = UDim.new(0, 8)
	end

	local children = {
		UIPadding = createElement2("UIPadding", {
			PaddingLeft = paddingLeft,
			PaddingRight = paddingRight,
			PaddingTop = props.addTopPadding and UDim.new(0, 8) or UDim.new(0, 0),
			PaddingBottom = UDim.new(0, 1)
		}),
		EnableChatButton = 0
	}

	local createElement3 = React.createElement
	local v2 = {
		["AutomaticSize"] = Enum.AutomaticSize.XY,
		BackgroundColor3 = Config.EnableChatButtonBackgroundColor,
		BackgroundTransparency = setTransparency(Config.EnableChatButtonBackgroundTransparency, props.transparencyValue), -- inferred equivalent call
		Size = UDim2.fromScale(1, 0),
		FontFace = Config.EnableChatButtonFontFace,
		Selectable = true,
		SelectionImageObject = selectionImageObject,
		Text = (props.EnableChatButtonText == nil or props.EnableChatButtonText == "") and "Unlock chat" or props.EnableChatButtonText,
		TextColor3 = Config.ChatInputBarTextColor3
	}
	local textSize

	if isSpatialUIEnabled then
		textSize = Config.ChatInputBarSpatialPanelTextSize
	else
		textSize = Config.ChatInputBarTextSize
	end

	v2.TextSize = textSize

	v2.TextTransparency = setTransparency(0, props.transparencyValue) -- inferred equivalent call
	v2.TextWrapped = true
	v2.TextXAlignment = Enum.TextXAlignment.Center
	v2.TextYAlignment = Enum.TextYAlignment.Center
	v2.ZIndex = 2
	v2[React.Event.Activated] = function()
		if engineFeature then
			TextChatService:SendEnableChatButtonClicked()
		end

		props.onActivated()
	end

	children.EnableChatButton = createElement3("TextButton", v2, {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10)
		})
	})
	return createElement("Frame", v, children)
end

return Localization.connect(function()
	return { EnableChatButtonText = "CoreScripts.TextChat.EnableChatButton.Label.UnlockChat" }
end)(EnableChatButton)
