local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local ReactTestingLibrary = require(parent.Dev.ReactTestingLibrary)
local render = ReactTestingLibrary.render

local BenchmarkUtils = require(parent.Dev.BenchmarkUtils)
local benchFile = BenchmarkUtils.benchFile
local benchmarkWarm = BenchmarkUtils.benchmarkWarm
local benchmarkInstanceCount = BenchmarkUtils.benchmarkInstanceCount

local Config = require(ExpChat.Config)

local Helpers = ExpChat.ChatWindow.Helpers
local getMessageSettings = require(Helpers.getMessageSettings)
local getMessageText = require(Helpers.getMessageText)

local TranslatedTextMessageV2 = require(ExpChat.ChatWindow.UI.TranslatedTextMessageV2)

local chatWindowSettings = {
	FontFace = Config.ChatWindowFont,
	TextColor3 = Config.ChatWindowTextColor3,
	TextSize = Config.ChatWindowTextSize,
	TextStrokeColor3 = Config.ChatWindowTextStrokeColor,
	TextStrokeTransparency = Config.ChatWindowTextStrokeTransparency,
	BackgroundColor3 = Config.ChatWindowBackgroundColor3,
	BackgroundTransparency = Config.ChatWindowBackgroundTransparency
}

local function createMessageElement(items)
	local v = {
		text = "Sample text chat message text!",
		translation = "Exemple de texte de message de chat !",
		useTranslation = false,
		prefixText = "<font color=\"#FFA500\">PrefixText</font>",
		chatWindowMessageProperties = nil,
		isUserVerified = false,
		isSpatialUIEnabled = false,
		isTrustedConnection = false,
		wasRewritten = false,
		isRewriteWindowOpen = false
	}

	if items then
		for k, item in items do
			v[k] = item
		end
	end

	local message = {
		current = {
			text = v.text,
			translation = v.translation,
			useTranslation = v.useTranslation,
			prefixText = v.prefixText,
			userId = 0,
			messageId = "0",
			chatWindowMessageProperties = v.chatWindowMessageProperties
		}
	}

	local messageSettings = getMessageSettings(message.current, chatWindowSettings)

	return React.createElement(TranslatedTextMessageV2, {
		chatWindowSettings = chatWindowSettings,
		textTransparency = React.createBinding(0),
		onTextMessageLabelButtonActivated = function() end,
		isSpatialUIEnabled = v.isSpatialUIEnabled,
		originalBodyText = React.createBinding(getMessageText(
			message.current.useTranslation,
			messageSettings.translation,
			messageSettings.text
		)),
		originalPrefixText = React.createBinding(messageSettings.prefixText or ""),
		shouldShowTranslationToggle = React.createBinding(false),
		bodyTextProperties = React.createBinding(messageSettings.bodyTextProperties),
		prefixTextProperties = React.createBinding(messageSettings.prefixTextProperties),
		layoutOrder = React.createBinding(0),
		visible = React.createBinding(true),
		isUserVerified = React.createBinding(v.isUserVerified),
		message = message,
		isTrustedConnection = React.createBinding(v.isTrustedConnection),
		wasRewritten = React.createBinding(v.wasRewritten),
		isRewriteWindowOpen = React.createBinding(v.isRewriteWindowOpen),
		chatWindowTransparencyBindable = React.createBinding(0),
		arButtonPadding = React.createBinding(UDim.new(0, 0))
	})
end

local function messageList(p)
	local v = {}

	for i = 1, 50 do
		v[i] = createMessageElement(p)
	end

	return React.createElement(Foundation.FoundationProvider, {
		device = "Desktop",
		colorMode = "Dark"
	}, {
		List = React.createElement("Frame", { Size = UDim2.fromScale(1, 1) }, v)
	})
end

local v = messageList()
local v2 = messageList({ useTranslation = true })
local v3 = messageList({ isUserVerified = true })

benchFile(script, function()
	benchmarkWarm(`Render {50} TranslatedTextMessages`, function()
		render(v):unmount()
	end)

	benchmarkWarm(`Render {50} TranslatedTextMessages with translation`, function()
		render(v2):unmount()
	end)

	benchmarkWarm(`Render {50} TranslatedTextMessages (verified user)`, function()
		render(v3):unmount()
	end)

	benchmarkInstanceCount(`Mount {50} TranslatedTextMessages`, v)
end)
