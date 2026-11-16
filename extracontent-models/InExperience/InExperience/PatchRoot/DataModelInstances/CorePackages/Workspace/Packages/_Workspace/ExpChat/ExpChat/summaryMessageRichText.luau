local TextChatService = game:GetService("TextChatService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Foundation = require(parent.Foundation)
local UIBlox = require(parent.UIBlox)

local Config = require(ExpChat.Config)
local FStringExpChatSummaryPrefixText = require(ExpChat.Flags.FStringExpChatSummaryPrefixText)
local FFlagExpChatPolishSummaryMessageUI = require(ExpChat.Flags.FFlagExpChatPolishSummaryMessageUI)

local function ceilToEven(p: number) -- 1 equivalent call inferred from this helper
	local v = math.ceil(p)

	if v % 2 == 1 then
		v += 1
	end

	return (math.max(0, v))
end

local function calculateSummaryTextSize(p: number) -- 4 equivalent calls inferred from this helper
	return (math.max(0, p - 2))
end

local function getSummaryTextSizeFromConfiguration() -- 2 equivalent calls inferred from this helper
	local chatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

	if chatWindowConfiguration then
		return calculateSummaryTextSize(chatWindowConfiguration.TextSize) -- inferred equivalent call
	end

	return calculateSummaryTextSize(Config.ChatWindowTextSize) -- inferred equivalent call
end

local SummaryMessageRichText = {}

function SummaryMessageRichText.getSummaryIconPrefix(p: number?)
	if not FFlagExpChatPolishSummaryMessageUI then
		return `<font weight='600' family='rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json'>{Foundation.Enums.IconName.Nebula}</font>{FStringExpChatSummaryPrefixText}`
	end

	local v

	if p then
		v = calculateSummaryTextSize(p) -- inferred equivalent call
	else
		v = getSummaryTextSizeFromConfiguration() -- inferred equivalent call
	end

	return `<font weight='600' size="{ceilToEven(v * 3 / 4)}" family='rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json'>{Foundation.Enums.IconName.Nebula}</font>{FStringExpChatSummaryPrefixText}` -- inferred equivalent call
end

function SummaryMessageRichText.wrapInSummaryMutedStyle(p: string, value: string?, p2: number?)
	if not FFlagExpChatPolishSummaryMessageUI then
		return `<font color='#{value or "BCBEC8"}' size="{Config.ChatWindowTextSize - 2}">{p}</font>`
	end

	local hex = UIBlox.App.Style.Colors.LightGrey:ToHex()
	local v

	if p2 then
		v = calculateSummaryTextSize(p2) -- inferred equivalent call
	else
		v = getSummaryTextSizeFromConfiguration() -- inferred equivalent call
	end

	return `<font color='#{hex}' weight='600' size="{v}">{p}</font>`
end

return SummaryMessageRichText
