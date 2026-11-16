local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local ArgCheck = require(parent.ArgCheck)
local EnumMessageTypes = require(AppChat.Components.ChatConversation.EnumMessageTypes)

local formatMessages = require(script.Parent.formatMessages)
local separateRobloxUrlsFromText = require(script.Parent.RobloxUrlUtils.separateRobloxUrlsFromText)

local FFlagAppChatPlusReferralAssetCard = require(AppChat.Flags.FFlagAppChatPlusReferralAssetCard)

return function(data, p)
	ArgCheck.isType(data, "table", "filterForLinks.text")
	ArgCheck.isType(p, "table", "filterForLinks.whitelistedDomains")

	if data.messageType == EnumMessageTypes.System then
		return { data }
	end

	if data.messageType == EnumMessageTypes.Link and not (data.gameLink and data.gameLink.universeId) then
		return { Cryo.Dictionary.join(data, { messageType = Cryo.None }) }
	end

	if
		data.content
		and not data.moderated
		and (data.content:lower():match("%/games[^%d]*(%d+)/?") or data.content:match("%/share%?.*code=([%w%-]+)") or FFlagAppChatPlusReferralAssetCard and data.content:match("%/plus%-referral%?.*code=([%w%-]+)"))
	then
		return formatMessages(separateRobloxUrlsFromText(data.content), data)
	end

	return { data }
end
