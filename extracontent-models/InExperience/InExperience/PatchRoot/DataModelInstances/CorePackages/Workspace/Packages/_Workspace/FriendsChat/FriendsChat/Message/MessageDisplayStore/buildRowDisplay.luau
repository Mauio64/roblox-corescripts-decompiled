local parent = script:FindFirstAncestor("FriendsChat").Parent

local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local computeNameColor = ChatUIPrimitives.Utils.computeNameColor
local formatInlineIcon = ChatUIPrimitives.Utils.formatInlineIcon
local escapeRichText = ChatUIPrimitives.Utils.escapeRichText

local NameInfo = require(script.Parent.NameInfo)
require(script.Parent.classifyMessage)
local rowCopy = require(script.Parent.rowCopy)
require(script.Parent.Parent.Parent.Utils.useLocalize)

local color = Color3.fromRGB(255, 255, 255)

local function ceilToEven(p: number)
	local v = math.ceil(p)

	if v % 2 == 1 then
		v += 1
	end

	return (math.max(0, v))
end

local function getSystemIconAttributes(systemTextSize: number?)
	if systemTextSize == nil then
		return { weight = "600" }
	end

	local v = math.ceil(systemTextSize * 3 / 4)

	if v % 2 == 1 then
		v += 1
	end

	return { weight = "600", size = tostring((math.max(0, v))) }
end

local function makeSystemRow(data)
	local content = escapeRichText(data.content)

	if data.icon ~= nil then
		content = `{formatInlineIcon(data.icon, getSystemIconAttributes(data.systemTextSize))} {content}`
	end

	return {
		content = content,
		skeletonWidth = data.skeletonWidth or "none",
		displayStyle = "system"
	}
end

local function buildReplyHeader(data, data2, p)
	local replyLabelText = rowCopy.replyLabelText({
		senderUserId = data.senderUserId,
		repliedToUserId = data.repliedToUserId,
		localUserId = data2.localUserId,
		isGroup = data2.isGroup == true,
		namesByUserId = data2.namesByUserId or {},
		localize = p.localize
	})

	if replyLabelText == nil then
		return makeSystemRow({ content = "", skeletonWidth = "full" })
	end

	local systemTextSize = p.systemTextSize
	return makeSystemRow({
		content = replyLabelText,
		icon = rowCopy.REPLY_ICON,
		systemTextSize = systemTextSize
	})
end

local function buildHiddenUser(p, p2)
	if NameInfo.isNameLoading(p) then
		return makeSystemRow({ content = "", skeletonWidth = "full" })
	end

	local localize = p2.localize
	return makeSystemRow({
		content = rowCopy.hiddenNoticeText(p.name, localize),
		icon = rowCopy.HIDDEN_ICON,
		systemTextSize = p2.systemTextSize
	})
end

local function buildUserText(data, p)
	local v

	if data.moderated then
		v = rowCopy.maskedBody(data)
	else
		v = escapeRichText(data.body)
	end

	if NameInfo.isNameLoading(p) then
		return { content = `: {v}`, skeletonWidth = "prefix", displayStyle = "user" }
	end

	local username = p.username
	local v2

	if username == nil or username == "" then
		v2 = color
	else
		v2 = computeNameColor(username)
	end

	return {
		content = string.format("<font color=\"#%s\">%s</font>: %s", v2:ToHex(), escapeRichText(p.name), v),
		skeletonWidth = "none",
		displayStyle = "user"
	}
end

local function buildRowDisplay(data, p, p2)
	local localize = p2.localize
	local systemTextSize = p2.systemTextSize
	local namesByUserId = p.namesByUserId or {}

	if data.kind == "systemMessage" then
		return makeSystemRow({
			content = data.body,
			icon = rowCopy.systemIcon(data.variant),
			systemTextSize = systemTextSize
		})
	end

	if data.kind == "moderationNotice" then
		return makeSystemRow({
			content = rowCopy.moderatedNoticeText(localize),
			icon = rowCopy.MODERATED_ICON,
			systemTextSize = systemTextSize
		})
	end

	if data.kind == "hiddenUser" then
		return buildHiddenUser(namesByUserId[data.senderUserId] or {}, p2)
	end

	if data.kind == "replyHeader" then
		return buildReplyHeader(data, p, p2)
	end

	return buildUserText(data, namesByUserId[data.senderUserId] or {})
end

return buildRowDisplay
