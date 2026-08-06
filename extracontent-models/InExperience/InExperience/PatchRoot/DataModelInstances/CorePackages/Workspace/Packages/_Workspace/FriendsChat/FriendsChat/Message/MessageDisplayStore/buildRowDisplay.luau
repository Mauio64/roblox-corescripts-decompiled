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

local function ceilToEven(n1: number) -- line: 82
	local v20 = math.ceil(n1)

	if v20 % 2 == 1 then
		v20 += 1
	end

	return (math.max(0, v20))
end
local function getSystemIconAttributes(n2: number?) -- line: 94
	if n2 == nil then
		return {
			weight = "600"
		}
	end

	local v22 = math.ceil(n2 * 3 / 4)

	if v22 % 2 == 1 then
		v22 += 1
	end

	local v23 = math.max(0, v22)

	return {
		weight = "600",
		size = tostring(v23)
	}
end
local function hashContent(s1: string) -- line: 115
	return (string.gsub(s1, "[^%s]", "#"))
end
local function isNameLoading(t1: {[any]: any}) -- line: 119
	return t1.name == nil or t1.name == ""
end
local function makeSystemRow(t2: {[any]: any}) -- line: 126
	-- upvalues: escapeRichText (copy), formatInlineIcon (copy), getSystemIconAttributes (copy)
	local v27 = escapeRichText(t2.content)
	local v28 = if t2.icon == nil then v27 else `{ formatInlineIcon(t2.icon, (getSystemIconAttributes(t2.systemTextSize))) } { v27 }`

	return {
		displayStyle = "system",
		content = v28,
		skeletonWidth = t2.skeletonWidth or "none"
	}
end
local function buildReplyHeader(t3: {[any]: any}, t4: {[any]: any}, t5: {[any]: any}) -- line: 138
	-- upvalues: makeSystemRow (copy), getReplyLabelDescriptor (copy), IconName (copy)
	local localize = t5.localize
	local systemTextSize = t5.systemTextSize
	local localUserId = t4.localUserId
	local v35 = localUserId ~= nil and localUserId == t3.senderUserId
	local v36 = localUserId ~= nil and localUserId == t3.repliedToUserId
	local v37 = t3.senderUserId == t3.repliedToUserId
	local v38 = t4.namesByUserId or {}
	local v39 = v38[t3.senderUserId] or {}
	local v40 = v38[t3.repliedToUserId] or {}

	if (v39.name == nil or v39.name == "") and not v35 or (v40.name == nil or v40.name == "") and not v36 then
		return (makeSystemRow({
			content = "",
			skeletonWidth = "full"
		}))
	end

	local v41 = getReplyLabelDescriptor({
		senderIsLocalUser = v35,
		senderRepliedToSelf = v37,
		senderRepliedToLocalUser = v36,
		isGroup = t4.isGroup == true,
		senderName = v39.name or "",
		repliedToName = v40.name or ""
	})
	local v42 = not localize and "" or localize(v41)

	return (makeSystemRow({
		content = v42,
		icon = IconName.ArrowCurlToLeft,
		systemTextSize = systemTextSize
	}))
end
local function buildHiddenUser(t6: {[any]: any}, t7: {[any]: any}) -- line: 179
	-- upvalues: makeSystemRow (copy), IconName (copy)
	if t6.name == nil or t6.name == "" then
		return (makeSystemRow({
			content = "",
			skeletonWidth = "full"
		}))
	end

	local localize = t7.localize
	local v46 = not localize and "" or localize({
		"Feature.Chat.Message.CannotBeDisplayedThirdPerson",
		displayName = t6.name
	})

	return (makeSystemRow({
		content = v46,
		icon = IconName.LockClosed,
		systemTextSize = t7.systemTextSize
	}))
end
local function buildUserText(t8: {[any]: any}, t9: {[any]: any}) -- line: 194
	-- upvalues: escapeRichText (copy), computeNameColor (copy), color3 (copy)
	local v50

	if t8.moderated then
		local body = t8.body

		v50 = string.gsub(body, "[^%s]", "#")
	else
		v50 = escapeRichText(t8.body)
	end

	local name = t9.name

	if name == nil or name == "" then
		return {
			skeletonWidth = "prefix",
			displayStyle = "user",
			content = `: { v50 }`
		}
	end

	local username = t9.username
	local v53 = if username == nil or username == "" then color3 else computeNameColor(username)

	return {
		skeletonWidth = "none",
		displayStyle = "user",
		content = string.format("<font color=\"#%s\">%s</font>: %s", v53:ToHex(), escapeRichText(name), v50)
	}
end
local function buildRowDisplay(p1, t10: {[any]: any}, t11: {[any]: any}) -- line: 227
	-- upvalues: IconName (copy), makeSystemRow (copy), buildHiddenUser (copy), buildReplyHeader (copy), buildUserText (copy)
	local localize = t11.localize
	local systemTextSize = t11.systemTextSize
	local v59 = t10.namesByUserId or {}

	if p1.kind == "systemMessage" then
		local v60 = if p1.variant ~= "party" then IconName.CircleI else IconName.TwoPeopleSpeechBubble

		return (makeSystemRow({
			content = p1.body,
			icon = v60,
			systemTextSize = systemTextSize
		}))
	end

	if p1.kind == "moderationNotice" then
		local v61 = not localize and "" or localize("Feature.Chat.Message.MessageContentModerated")

		return (makeSystemRow({
			content = v61,
			icon = IconName.TriangleExclamation,
			systemTextSize = systemTextSize
		}))
	end

	if p1.kind == "hiddenUser" then
		return (buildHiddenUser(v59[p1.senderUserId] or {}, t11))
	end

	if p1.kind == "replyHeader" then
		return (buildReplyHeader(p1, t10, t11))
	end

	return (buildUserText(p1, v59[p1.senderUserId] or {}))
end

return buildRowDisplay
