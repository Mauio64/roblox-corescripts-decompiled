local TextChatService = game:GetService("TextChatService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Foundation = require(ExpChatParent.Foundation)
local UIBlox = require(ExpChatParent.UIBlox)
local Config = require(ExpChat.Config)
local FStringExpChatSummaryPrefixText = require(ExpChat.Flags.FStringExpChatSummaryPrefixText)
local FFlagExpChatPolishSummaryMessageUI = require(ExpChat.Flags.FFlagExpChatPolishSummaryMessageUI)

local function ceilToEven(n1: number) -- line: 15
	local v13 = math.ceil(n1)

	if v13 % 2 == 1 then
		v13 += 1
	end

	return (math.max(0, v13))
end
local function calculateSummaryTextSize(n2: number) -- line: 23
	return (math.max(0, n2 - 2))
end
local function getSummaryTextSizeFromConfiguration() -- line: 27
	-- upvalues: TextChatService (copy), Config (copy)
	local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

	if ChatWindowConfiguration then
		return (math.max(0, ChatWindowConfiguration.TextSize - 2))
	end

	return (math.max(0, Config.ChatWindowTextSize - 2))
end

return {
	getSummaryIconPrefix = function(n3: number?) -- line: 35
		-- upvalues: FFlagExpChatPolishSummaryMessageUI (copy), TextChatService (copy), Config (copy), Foundation (copy), FStringExpChatSummaryPrefixText (copy)
		if FFlagExpChatPolishSummaryMessageUI then
			local v17

			if n3 then
				v17 = math.max(0, n3 - 2)
			else
				local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

				v17 = if not ChatWindowConfiguration then math.max(0, Config.ChatWindowTextSize - 2) else math.max(0, ChatWindowConfiguration.TextSize - 2)
			end

			local v19 = math.ceil(v17 * 3 / 4)

			if v19 % 2 == 1 then
				v19 += 1
			end

			return `<font weight='600' size="{ math.max(0, v19) }" family='rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json'>{ Foundation.Enums.IconName.Nebula }</font>{ FStringExpChatSummaryPrefixText }`
		end

		return `<font weight='600' family='rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json'>{ Foundation.Enums.IconName.Nebula }</font>{ FStringExpChatSummaryPrefixText }`
	end,
	wrapInSummaryMutedStyle = function(s1: string, s2: string?, n4: number?) -- line: 46
		-- upvalues: FFlagExpChatPolishSummaryMessageUI (copy), UIBlox (copy), TextChatService (copy), Config (copy)
		if FFlagExpChatPolishSummaryMessageUI then
			local v23 = UIBlox.App.Style.Colors.LightGrey:ToHex()
			local v24

			if n4 then
				v24 = math.max(0, n4 - 2)
			else
				local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

				v24 = if not ChatWindowConfiguration then math.max(0, Config.ChatWindowTextSize - 2) else math.max(0, ChatWindowConfiguration.TextSize - 2)
			end

			return `<font color='#{ v23 }' weight='600' size="{ v24 }">{ s1 }</font>`
		end

		return `<font color='#{ s2 or "BCBEC8" }' size="{ Config.ChatWindowTextSize - 2 }">{ s1 }</font>`
	end
}
