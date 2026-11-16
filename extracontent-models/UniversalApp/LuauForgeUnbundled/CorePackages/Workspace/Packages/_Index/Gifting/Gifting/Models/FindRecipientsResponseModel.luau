local t = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/t")

local UserRelationship = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Enums/UserRelationship")
local GiftModelUtils = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/GiftModelUtils")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")

local interface = t.interface({ userId = t.number })

local function formatRecipientResult(data)
	local v5, v6 = interface(data)

	if not v5 then
		return nil, `recipient: {v6}`
	end

	local v7 = UserRelationship.fromValue(data.userRelationship)

	if v7 == nil then
		return nil, GiftModelUtils.invalidField("recipient.userRelationship", data.userRelationship)
	end

	return {
		userId = data.userId,
		username = data.username or "",
		displayName = data.displayName or "",
		thumbnailUrl = data.thumbnailUrl or "",
		userRelationship = v7
	}
end

return {
	format = function(p2)
		local formatList, v5 = GiftModelUtils.formatList("recipients", p2.recipients or {}, formatRecipientResult)

		if formatList == nil then
			return nil, v5
		end

		return { recipients = formatList, nextCursor = p2.nextCursor }
	end
}
