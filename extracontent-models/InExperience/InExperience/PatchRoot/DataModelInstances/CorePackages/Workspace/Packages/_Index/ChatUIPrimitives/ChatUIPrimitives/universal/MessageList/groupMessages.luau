local unpackContent = require(script.Parent.Parent.ContentKinds.unpackContent)
local SystemContentModel = require(script.Parent.Parent.ContentKinds.System.SystemContentModel)
require(script.Parent.projectMessageEnvelope)
local getReplyPreview = require(script.Parent.Reply.getReplyPreview)

local isSystemMessage = SystemContentModel.isSystemMessage

local function sameSender(p, p2): boolean -- 1 equivalent call inferred from this helper
	local author = p.author
	local author2 = p2.author

	return author ~= nil and author2 ~= nil and author.userId == author2.userId
end

local function getGroupBreakReason(p, p2, p3, p4: number, p5: number?, p6: number?): nil | string
	if
		p6 ~= nil
		and p2 ~= nil
		and not isSystemMessage(p3)
		and p6 <= p3.sentAtUnixMilliseconds - p2.sentAtUnixMilliseconds
	then
		return "time"
	end

	if isSystemMessage(p) or isSystemMessage(p3) then
		return "system"
	end

	if not sameSender(p, p3) then -- inferred equivalent call
		return "sender"
	end

	if getReplyPreview.getReplyText(p3) ~= nil then
		return "reply"
	end

	return if not (p5 == nil or not (p5 <= p4)) then "count" else nil
end

local function hasRenderableContent(item): boolean -- 1 equivalent call inferred from this helper
	local contents = item.contents

	if type(contents) ~= "table" then
		return false
	end

	for _, content in contents do
		if unpackContent(content) ~= nil then
			return true
		end
	end

	return false
end

local function orderedMessages(items)
	local result = {}

	for _, item in items do
		if type(item) ~= "table" then
			continue
		end

		local v
		v = hasRenderableContent(item) -- inferred equivalent call

		if v then
			table.insert(result, item)
		end
	end

	table.sort(result, function(a, b): boolean
		if a.sentAtUnixMilliseconds == b.sentAtUnixMilliseconds then
			return a.id < b.id
		end

		return a.sentAtUnixMilliseconds < b.sentAtUnixMilliseconds
	end)

	return result
end

local function indexPrevious(items) -- 2 equivalent calls inferred from this helper
	local result = {}

	if items == nil then
		return result
	end

	for _, item in items do
		result[item.id] = item
	end

	return result
end

local function messageRow(p, message, isFirst: boolean, isLast: boolean)
	local v = p[message.id]

	if
		v == nil
		or v.kind ~= "message"
		or v.message ~= message
		or v.groupPosition.isFirst ~= isFirst
		or v.groupPosition.isLast ~= isLast
	then
		return {
			kind = "message",
			id = message.id,
			message = message,
			groupPosition = { isFirst = isFirst, isLast = isLast }
		}
	end

	return v
end

local function systemRow(p, message) -- 1 equivalent call inferred from this helper
	local v = p[message.id]

	if v == nil or v.kind ~= "system" or v.message ~= message then
		return { kind = "system", id = message.id, message = message }
	end

	return v
end

local function appendRows(list, p, message, isFirst: boolean, isLast: boolean) -- 2 equivalent calls inferred from this helper
	if not isSystemMessage(message) then
		table.insert(list, messageRow(p, message, isFirst, isLast))
		return
	end

	table.insert(list, systemRow(p, message)) -- inferred equivalent call
end

local function timestampRow(p, p2, p3)
	local formatted = `timestamp:{p2.id}`
	local sentAtUnixMilliseconds

	if p3 ~= nil then
		sentAtUnixMilliseconds = p3.sentAtUnixMilliseconds
	end

	local v = p[formatted]

	if
		v == nil
		or v.kind ~= "timestamp"
		or v.displayUnixMilliseconds ~= p2.sentAtUnixMilliseconds
		or v.referenceUnixMilliseconds ~= sentAtUnixMilliseconds
	then
		return {
			kind = "timestamp",
			id = formatted,
			displayUnixMilliseconds = p2.sentAtUnixMilliseconds,
			referenceUnixMilliseconds = sentAtUnixMilliseconds
		}
	end

	return v
end

local function finish(list, list2) -- 1 equivalent call inferred from this helper
	if list == nil or #list ~= #list2 then
		return list2
	end

	for k, item in list2 do
		if list[k] ~= item then
			return list2
		end
	end

	return list
end

local GroupMessages = {}

function GroupMessages.groupMessages(p, p2: number?, p3: number?, list, p4)
	local v = p4 == nil or p4.shouldInsertTimestampRows ~= false
	local v2 = orderedMessages(p)
	local result = indexPrevious(list) -- inferred equivalent call
	local v3 = {}
	local v4 = 1

	local function appendGroup(p5: number)
		local v5 = p5 - v4 + 1

		for i = 0, v5 - 1 do
			appendRows(v3, result, v2[v4 + i], i == 0, i == v5 - 1) -- inferred equivalent call
		end
	end

	local function appendTimestamp(p5, p6) -- 1 equivalent call inferred from this helper
		table.insert(v3, timestampRow(result, p5, p6))
	end

	local v5

	if #v2 > 0 and not isSystemMessage(v2[1]) then
		v5 = v2[1]
	end

	for i = 2, #v2 do
		local v6 = v2[i]
		local v7 = i - v4

		local groupBreakReason = getGroupBreakReason(v2[i - 1], v5, v6, v7, p2, p3)

		if groupBreakReason ~= nil then
			appendGroup(i - 1)

			if groupBreakReason == "time" and v then
				appendTimestamp(v6, v5) -- inferred equivalent call
			end

			v4 = i
		end

		if not isSystemMessage(v6) then
			v5 = v6
		end
	end

	if #v2 > 0 then
		appendGroup(#v2)
	end

	if list == nil or #list ~= #v3 then
		list = v3
	else
		for k, v6 in v3 do
			if list[k] ~= v6 then
				list = v3
				break
			end
		end
	end

	return list
end

function GroupMessages.ungroupedRows(p, p2)
	local v = orderedMessages(p)
	local result = indexPrevious(p2) -- inferred equivalent call
	local v2 = {}

	for _, v3 in v do
		appendRows(v2, result, v3, true, true) -- inferred equivalent call
	end

	return finish(p2, v2) -- inferred equivalent call
end

return GroupMessages
