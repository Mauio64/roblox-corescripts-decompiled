local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local Foundation = require(ExpChatParent.Foundation)
local render = require(ExpChatParent.Dev.ReactTestingLibrary).render
local benchmark = require(ExpChatParent.Dev.JestBenchmark).benchmark
local BenchmarkUtils = require(ExpChatParent.Dev.BenchmarkUtils)
local benchFile = BenchmarkUtils.benchFile
local mountComponentTimes = BenchmarkUtils.mountComponentTimes
local scrollComponentTimes = BenchmarkUtils.scrollComponentTimes
local Config = require(ExpChat.Config)
local Helpers = ExpChat.ChatWindow.Helpers
local getMessageSettings = require(Helpers.getMessageSettings)
local getMessageText = require(Helpers.getMessageText)
local TranslatedTextMessageV2 = require(ExpChat.ChatWindow.UI.TranslatedTextMessageV2)
local t1 = {
	FontFace = Config.ChatWindowFont,
	TextColor3 = Config.ChatWindowTextColor3,
	TextSize = Config.ChatWindowTextSize,
	TextStrokeColor3 = Config.ChatWindowTextStrokeColor,
	TextStrokeTransparency = Config.ChatWindowTextStrokeTransparency,
	BackgroundColor3 = Config.ChatWindowBackgroundColor3,
	BackgroundTransparency = Config.ChatWindowBackgroundTransparency
}

local function createMessageElement(t2: {[any]: any}?) -- line: 34
	-- upvalues: getMessageSettings (copy), t1 (copy), React (copy), TranslatedTextMessageV2 (copy), getMessageText (copy)
	local t3 = {
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

	if t2 then
		for v27, v28 in t2 do
			t3[v27] = v28
		end
	end

	local t4 = {
		current = {
			userId = 0,
			messageId = "0",
			text = t3.text,
			translation = t3.translation,
			useTranslation = t3.useTranslation,
			prefixText = t3.prefixText,
			chatWindowMessageProperties = t3.chatWindowMessageProperties
		}
	}
	local v30 = getMessageSettings(t4.current, t1)

	return React.createElement(TranslatedTextMessageV2, {
		chatWindowSettings = t1,
		textTransparency = React.createBinding(0),
		onTextMessageLabelButtonActivated = function() -- line: 71
		end,
		isSpatialUIEnabled = t3.isSpatialUIEnabled,
		originalBodyText = React.createBinding(getMessageText(t4.current.useTranslation, v30.translation, v30.text)),
		originalPrefixText = React.createBinding(v30.prefixText or ""),
		shouldShowTranslationToggle = React.createBinding(false),
		bodyTextProperties = React.createBinding(v30.bodyTextProperties),
		prefixTextProperties = React.createBinding(v30.prefixTextProperties),
		layoutOrder = React.createBinding(0),
		visible = React.createBinding(true),
		isUserVerified = React.createBinding(t3.isUserVerified),
		message = t4,
		isTrustedConnection = React.createBinding(t3.isTrustedConnection),
		wasRewritten = React.createBinding(t3.wasRewritten),
		isRewriteWindowOpen = React.createBinding(t3.isRewriteWindowOpen),
		chatWindowTransparencyBindable = React.createBinding(0),
		arButtonPadding = React.createBinding(UDim.new(0, 0))
	})
end
local function wrapWithProviders(p1) -- line: 92
	-- upvalues: React (copy), Foundation (copy)
	return React.createElement(Foundation.FoundationProvider, {
		device = "Desktop",
		theme = "Dark"
	}, p1)
end

local v19 = createMessageElement()
local v20 = React.createElement(Foundation.FoundationProvider, {
	device = "Desktop",
	theme = "Dark"
}, v19)
local v21 = createMessageElement({
	useTranslation = true
})
local v22 = React.createElement(Foundation.FoundationProvider, {
	device = "Desktop",
	theme = "Dark"
}, v21)
local v23 = createMessageElement({
	isUserVerified = true
})
local v24 = React.createElement(Foundation.FoundationProvider, {
	device = "Desktop",
	theme = "Dark"
}, v23)

benchFile(script, function() -- line: 103
	-- upvalues: benchmark (copy), render (copy), v20 (copy), v22 (copy), v24 (copy), mountComponentTimes (copy), scrollComponentTimes (copy)
	benchmark("Render TranslatedTextMessage", function() -- line: 104
		-- upvalues: render (copy), v20 (copy)
		render(v20):unmount()
	end)
	benchmark("Render TranslatedTextMessage with translation", function() -- line: 109
		-- upvalues: render (copy), v22 (copy)
		render(v22):unmount()
	end)
	benchmark("Render TranslatedTextMessage (verified user)", function() -- line: 114
		-- upvalues: render (copy), v24 (copy)
		render(v24):unmount()
	end)
	mountComponentTimes(v20, "TranslatedTextMessage", 50)
	mountComponentTimes(v20, "TranslatedTextMessage", 100)
	scrollComponentTimes(v20, "TranslatedTextMessage", 50)
end)
