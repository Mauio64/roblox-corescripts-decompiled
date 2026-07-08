local ParentParent = script.Parent.Parent
local MessageBus = require(ParentParent.MessageBus).MessageBus
local t = require(ParentParent.t)

require(script.Parent.ExternalContentSharingProtocolTypes)
require(ParentParent.MessageBus)

local v4 = t.strictInterface({
	text = t.string,
	context = t.optional(t.string)
})
local v5 = t.strictInterface({
	url = t.string,
	context = t.optional(t.string)
})
local v6 = t.strictInterface({
	context = t.optional(t.string),
	image = t.string,
	shareSheetTitle = t.optional(t.string),
	url = t.optional(t.string)
})
local v7 = t.strictInterface({
	context = t.optional(t.string),
	shareSheetTitle = t.optional(t.string),
	url = t.optional(t.string),
	video = t.string
})
local v8 = t.strictInterface({
	text = t.string,
	context = t.optional(t.string)
})
local t1 = {
	EXTERNAL_CONTENT_SHARING_SHARE_TEXT_DESCRIPTOR = {
		mid = MessageBus.getMessageId("ExternalContentSharing", "shareText"),
		validateParams = v4
	},
	EXTERNAL_CONTENT_SHARING_SHARE_URL_DESCRIPTOR = {
		mid = MessageBus.getMessageId("ExternalContentSharing", "shareUrl"),
		validateParams = v5
	},
	EXTERNAL_CONTENT_SHARING_SHARE_IMAGE_DESCRIPTOR = {
		mid = MessageBus.getMessageId("ExternalContentSharing", "shareImage"),
		validateParams = v6
	},
	EXTERNAL_CONTENT_SHARING_SHARE_VIDEO_DESCRIPTOR = {
		mid = MessageBus.getMessageId("ExternalContentSharing", "shareVideo"),
		validateParams = v7
	},
	EXTERNAL_CONTENT_SHARING_SET_CLIPBOARD_TEXT_DESCRIPTOR = {
		mid = MessageBus.getMessageId("ExternalContentSharing", "setClipboardText"),
		validateParams = v8
	}
}

t1.__index = t1

function t1.new(p1) -- line: 82
	-- upvalues: MessageBus (copy), t1 (copy)
	return (setmetatable({
		messageBus = p1 or MessageBus
	}, t1))
end
function t1.shareText(p2, p3) -- line: 90
	p2.messageBus.publish(p2.EXTERNAL_CONTENT_SHARING_SHARE_TEXT_DESCRIPTOR, p3)
end
function t1.shareUrl(p4, p5) -- line: 94
	p4.messageBus.publish(p4.EXTERNAL_CONTENT_SHARING_SHARE_URL_DESCRIPTOR, p5)
end
function t1.shareImage(p6, p7) -- line: 101
	p6.messageBus.publish(p6.EXTERNAL_CONTENT_SHARING_SHARE_IMAGE_DESCRIPTOR, p7)
end
function t1.shareVideo(p8, p9) -- line: 105
	p8.messageBus.publish(p8.EXTERNAL_CONTENT_SHARING_SHARE_VIDEO_DESCRIPTOR, p9)
end
function t1.setClipboardText(p10, p11) -- line: 109
	p10.messageBus.publish(p10.EXTERNAL_CONTENT_SHARING_SET_CLIPBOARD_TEXT_DESCRIPTOR, p11)
end

t1.default = t1.new()

return t1
