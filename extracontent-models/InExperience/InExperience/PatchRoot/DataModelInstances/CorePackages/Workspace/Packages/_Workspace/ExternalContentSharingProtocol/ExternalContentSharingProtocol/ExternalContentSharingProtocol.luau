local parent = script.Parent.Parent

local MessageBus = require(parent.MessageBus)
local messageBus = MessageBus.MessageBus
local t = require(parent.t)
require(script.Parent.ExternalContentSharingProtocolTypes)
require(parent.MessageBus)

local strictInterface = t.strictInterface({ text = t.string, context = t.optional(t.string) })

local strictInterface2 = t.strictInterface({ url = t.string, context = t.optional(t.string) })

local strictInterface3 = t.strictInterface({
	context = t.optional(t.string),
	image = t.string,
	shareSheetTitle = t.optional(t.string),
	url = t.optional(t.string)
})

local strictInterface4 = t.strictInterface({
	context = t.optional(t.string),
	shareSheetTitle = t.optional(t.string),
	url = t.optional(t.string),
	video = t.string
})

local strictInterface5 = t.strictInterface({ text = t.string, context = t.optional(t.string) })

local ExternalContentSharingProtocol = {
	EXTERNAL_CONTENT_SHARING_SHARE_TEXT_DESCRIPTOR = {
		mid = messageBus.getMessageId("ExternalContentSharing", "shareText"),
		validateParams = strictInterface
	},
	EXTERNAL_CONTENT_SHARING_SHARE_URL_DESCRIPTOR = {
		mid = messageBus.getMessageId("ExternalContentSharing", "shareUrl"),
		validateParams = strictInterface2
	},
	EXTERNAL_CONTENT_SHARING_SHARE_IMAGE_DESCRIPTOR = {
		mid = messageBus.getMessageId("ExternalContentSharing", "shareImage"),
		validateParams = strictInterface3
	},
	EXTERNAL_CONTENT_SHARING_SHARE_VIDEO_DESCRIPTOR = {
		mid = messageBus.getMessageId("ExternalContentSharing", "shareVideo"),
		validateParams = strictInterface4
	},
	EXTERNAL_CONTENT_SHARING_SET_CLIPBOARD_TEXT_DESCRIPTOR = {
		mid = messageBus.getMessageId("ExternalContentSharing", "setClipboardText"),
		validateParams = strictInterface5
	}
}

ExternalContentSharingProtocol.__index = ExternalContentSharingProtocol

function ExternalContentSharingProtocol.new(p)
	return (setmetatable({
		messageBus = p or messageBus
	}, ExternalContentSharingProtocol))
end

function ExternalContentSharingProtocol.shareText(p, p2)
	p.messageBus.publish(p.EXTERNAL_CONTENT_SHARING_SHARE_TEXT_DESCRIPTOR, p2)
end

function ExternalContentSharingProtocol.shareUrl(p, p2)
	p.messageBus.publish(p.EXTERNAL_CONTENT_SHARING_SHARE_URL_DESCRIPTOR, p2)
end

function ExternalContentSharingProtocol.shareImage(p, p2)
	p.messageBus.publish(p.EXTERNAL_CONTENT_SHARING_SHARE_IMAGE_DESCRIPTOR, p2)
end

function ExternalContentSharingProtocol.shareVideo(p, p2)
	p.messageBus.publish(p.EXTERNAL_CONTENT_SHARING_SHARE_VIDEO_DESCRIPTOR, p2)
end

function ExternalContentSharingProtocol.setClipboardText(p, p2)
	p.messageBus.publish(p.EXTERNAL_CONTENT_SHARING_SET_CLIPBOARD_TEXT_DESCRIPTOR, p2)
end

ExternalContentSharingProtocol.default = ExternalContentSharingProtocol.new()

return ExternalContentSharingProtocol
