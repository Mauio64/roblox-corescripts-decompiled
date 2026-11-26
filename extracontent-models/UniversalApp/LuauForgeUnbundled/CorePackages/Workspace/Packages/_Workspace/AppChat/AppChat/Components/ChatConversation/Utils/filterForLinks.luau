local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ArgCheck")
local EnumMessageTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/EnumMessageTypes")

local formatMessages = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/formatMessages")
local separateRobloxUrlsFromText = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/RobloxUrlUtils/separateRobloxUrlsFromText")

local FFlagAppChatPlusReferralAssetCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPlusReferralAssetCard")

return function(data, p2)
	ArgCheck.isType(data, "table", "filterForLinks.text")
	ArgCheck.isType(p2, "table", "filterForLinks.whitelistedDomains")

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
