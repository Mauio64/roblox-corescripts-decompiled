local Parent = script:FindFirstAncestor("FriendsChat").Parent
local Foundation = require(Parent.Foundation)
local ChatUIPrimitives = require(Parent.ChatUIPrimitives)
local computeNameColor = ChatUIPrimitives.Utils.computeNameColor
local formatInlineIcon = ChatUIPrimitives.Utils.formatInlineIcon
local escapeRichText = ChatUIPrimitives.Utils.escapeRichText
local getReplyLabelDescriptor = require(Parent.AppChat.getReplyLabelDescriptor)

require(script.Parent.classifyMessage)

local IconName = Foundation.Enums.IconName
local color3 = Color3.fromRGB(255, 255, 255)
local t1 = {
	weight = "600"
}

local function hashContent(s1: string) -- line: 90
	return (string.gsub(s1, "[^%s]", "#"))
end
local function isNameLoading(t2: {[any]: any}) -- line: 94
	return t2.name == nil or t2.name == ""
end
local function makeSystemRow(t3: {[any]: any}) -- line: 101
	-- upvalues: escapeRichText (copy), formatInlineIcon (copy), t1 (copy)
	local v21 = escapeRichText(t3.content)
	local v22 = if t3.icon == nil then v21 else `{ formatInlineIcon(t3.icon, t1) } { v21 }`

	return {
		displayStyle = "system",
		content = v22,
		skeletonWidth = t3.skeletonWidth or "none"
	}
end
local function buildReplyHeader(t4: {[any]: any}, t5: {[any]: any}, p1: ((...any) -> ...any)) -- line: 113
	-- upvalues: makeSystemRow (copy), getReplyLabelDescriptor (copy), IconName (copy)
	local localUserId = t5.localUserId
	local v27 = localUserId ~= nil and localUserId == t4.senderUserId
	local v28 = localUserId ~= nil and localUserId == t4.repliedToUserId
	local v29 = t4.senderUserId == t4.repliedToUserId
	local v30 = t5.namesByUserId or {}
	local v31 = v30[t4.senderUserId] or {}
	local v32 = v30[t4.repliedToUserId] or {}

	if (v31.name == nil or v31.name == "") and not v27 or (v32.name == nil or v32.name == "") and not v28 then
		return (makeSystemRow({
			content = "",
			skeletonWidth = "full"
		}))
	end

	local v33 = getReplyLabelDescriptor({
		senderIsLocalUser = v27,
		senderRepliedToSelf = v29,
		senderRepliedToLocalUser = v28,
		isGroup = t5.isGroup == true,
		senderName = v31.name or "",
		repliedToName = v32.name or ""
	})

	return (makeSystemRow({
		content = p1(v33),
		icon = IconName.ArrowCurlToLeft
	}))
end
local function buildHiddenUser(t6: {[any]: any}) -- line: 150
	-- upvalues: makeSystemRow (copy), IconName (copy)
	if t6.name == nil or t6.name == "" then
		return (makeSystemRow({
			content = "",
			skeletonWidth = "full"
		}))
	end

	return (makeSystemRow({
		content = `{ t6.name } sent a message that can't be displayed`,
		icon = IconName.LockClosed
	}))
end
local function buildUserText(t7: {[any]: any}, t8: {[any]: any}) -- line: 160
	-- upvalues: escapeRichText (copy), computeNameColor (copy), color3 (copy)
	local v38

	if t7.moderated then
		local body = t7.body

		v38 = string.gsub(body, "[^%s]", "#")
	else
		v38 = escapeRichText(t7.body)
	end

	local name = t8.name

	if name == nil or name == "" then
		return {
			skeletonWidth = "prefix",
			displayStyle = "user",
			content = `: { v38 }`
		}
	end

	local username = t8.username
	local v41 = if username == nil or username == "" then color3 else computeNameColor(username)

	return {
		skeletonWidth = "none",
		displayStyle = "user",
		content = string.format("<font color=\"#%s\">%s</font>: %s", v41:ToHex(), escapeRichText(name), v38)
	}
end
local function buildRowDisplay(p2, t9: {[any]: any}, p3: ((...any) -> ...any)) -- line: 193
	-- upvalues: IconName (copy), makeSystemRow (copy), buildHiddenUser (copy), buildReplyHeader (copy), buildUserText (copy)
	local v45 = t9.namesByUserId or {}

	if p2.kind == "systemMessage" then
		local v46 = if p2.variant ~= "party" then IconName.CircleI else IconName.TwoPeopleSpeechBubble

		return (makeSystemRow({
			content = p2.body,
			icon = v46
		}))
	end

	if p2.kind == "moderationNotice" then
		return (makeSystemRow({
			content = p3("Feature.Chat.Message.MessageContentModerated"),
			icon = IconName.TriangleExclamation
		}))
	end

	if p2.kind == "hiddenUser" then
		return (buildHiddenUser(v45[p2.senderUserId] or {}))
	end

	if p2.kind == "replyHeader" then
		return (buildReplyHeader(p2, t9, p3))
	end

	return (buildUserText(p2, v45[p2.senderUserId] or {}))
end

return buildRowDisplay
