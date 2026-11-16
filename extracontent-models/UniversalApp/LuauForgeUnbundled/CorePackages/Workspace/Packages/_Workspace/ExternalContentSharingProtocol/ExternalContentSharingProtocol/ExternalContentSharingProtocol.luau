local messageBus = require("@game/CorePackages/Workspace/Packages/_Workspace/ExternalContentSharingProtocol/MessageBus").MessageBus
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/ExternalContentSharingProtocol/t")
require("@game/CorePackages/Workspace/Packages/_Workspace/ExternalContentSharingProtocol/ExternalContentSharingProtocol/ExternalContentSharingProtocolTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/ExternalContentSharingProtocol/MessageBus")

local strictInterface = t.strictInterface({
	text = t.string,
	context = t.optional(t.string)
})

local strictInterface2 = t.strictInterface({
	url = t.string,
	context = t.optional(t.string)
})

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

local strictInterface5 = t.strictInterface({
	text = t.string,
	context = t.optional(t.string)
})

local v5 = {
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

v5.__index = v5

function v5.new(p2)
	return (setmetatable({
		messageBus = p2 or messageBus
	}, v5))
end

function v5:shareText(p3)
	self.messageBus.publish(self.EXTERNAL_CONTENT_SHARING_SHARE_TEXT_DESCRIPTOR, p3)
end

function v5.shareUrl(p2, p3)
	p2.messageBus.publish(p2.EXTERNAL_CONTENT_SHARING_SHARE_URL_DESCRIPTOR, p3)
end

function v5.shareImage(p2, p3)
	p2.messageBus.publish(p2.EXTERNAL_CONTENT_SHARING_SHARE_IMAGE_DESCRIPTOR, p3)
end

function v5.shareVideo(p2, p3)
	p2.messageBus.publish(p2.EXTERNAL_CONTENT_SHARING_SHARE_VIDEO_DESCRIPTOR, p3)
end

function v5:setClipboardText(p3)
	self.messageBus.publish(self.EXTERNAL_CONTENT_SHARING_SET_CLIPBOARD_TEXT_DESCRIPTOR, p3)
end

v5.default = v5.new()

return v5
