local Gifting = script:FindFirstAncestor("Gifting")
local parent = Gifting.Parent

local t = require(parent.t)

local UserRelationship = require(Gifting.Enums.UserRelationship)
local GiftModelUtils = require(Gifting.Models.GiftModelUtils)
require(Gifting.Types)

local interface = t.interface({ userId = t.number })

local function formatRecipientResult(data)
	local v, v2 = interface(data)

	if not v then
		return nil, `recipient: {v2}`
	end

	local userRelationship = UserRelationship.fromValue(data.userRelationship)

	if userRelationship == nil then
		return nil, GiftModelUtils.invalidField("recipient.userRelationship", data.userRelationship)
	end

	return {
		userId = data.userId,
		username = data.username or "",
		displayName = data.displayName or "",
		thumbnailUrl = data.thumbnailUrl or "",
		userRelationship = userRelationship
	}
end

return {
	format = function(self)
		local formatList, v = GiftModelUtils.formatList("recipients", self.recipients or {}, formatRecipientResult)

		if formatList == nil then
			return nil, v
		end

		return { recipients = formatList, nextCursor = self.nextCursor }
	end
}
