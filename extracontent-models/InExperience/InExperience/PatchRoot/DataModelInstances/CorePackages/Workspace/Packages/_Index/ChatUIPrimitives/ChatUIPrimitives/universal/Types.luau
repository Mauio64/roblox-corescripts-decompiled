local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local t = require(parent.t)
local PlainTextTypes = require(script.Parent.ContentKinds.PlainText.PlainTextTypes)
local PresetTypes = require(script.Parent.ContentKinds.Preset.PresetTypes)
local EmojiTypes = require(script.Parent.ContentKinds.Emoji.EmojiTypes)
local SystemTypes = require(script.Parent.ContentKinds.System.SystemTypes)

local array = t.array(t.union(
	t.strictInterface({ plainText = PlainTextTypes.isValid }),
	t.strictInterface({ preset = PresetTypes.isValid }),
	t.strictInterface({ emoji = EmojiTypes.isValid }),
	t.strictInterface({ system = SystemTypes.isValid })
))

local function isValidMessageContent(list)
	local v, v2 = array(list)

	if not v then
		return false, v2
	end

	if #list > 1 then
		for _, item in list do
			if item.system ~= nil then
				return false, "a system content must be the message's only content"
			end
		end
	end

	return true
end

local array2 = t.array(t.union(
	t.strictInterface({ plainText = PlainTextTypes.isValidDraft }),
	t.strictInterface({ preset = PresetTypes.isValidDraft }),
	t.strictInterface({ emoji = EmojiTypes.isValidDraft })
))

local interface = t.interface({ userId = t.string, displayName = t.string })

local interface2 = t.interface({ contents = array2, repliesToIds = t.optional(t.array(t.string)) })

local interface3 = t.interface({
	id = t.string,
	sentAtUnixMilliseconds = t.number,
	author = t.optional(interface),
	contents = isValidMessageContent,
	repliesTo = t.optional(t.array(t.interface({
		id = t.string,
		preview = t.optional(t.interface({ author = t.optional(interface), fallbackText = t.string })),
		label = t.optional(t.string)
	})))
})

local strictInterface = t.strictInterface({
	state = t.literal("sending"),
	attemptedAtUnixMilliseconds = t.number,
	resolvedAtUnixMilliseconds = t.optional(t.number)
})

local strictInterface2 = t.strictInterface({
	state = t.literal("failed"),
	attemptedAtUnixMilliseconds = t.number,
	resolvedAtUnixMilliseconds = t.optional(t.number)
})

local strictInterface3 = t.strictInterface({
	kind = t.literal("draft"),
	draft = interface2,
	author = t.optional(interface)
})

local union = t.union(t.strictInterface({
	direction = t.literal("incoming"),
	stableId = t.string,
	payload = t.strictInterface({ kind = t.literal("message"), message = interface3 })
}), t.strictInterface({
	direction = t.literal("outgoing"),
	stableId = t.string,
	payload = strictInterface3,
	delivery = strictInterface
}), t.strictInterface({
	direction = t.literal("outgoing"),
	stableId = t.string,
	payload = strictInterface3,
	delivery = strictInterface2
}), t.strictInterface({
	direction = t.literal("outgoing"),
	stableId = t.string,
	payload = t.strictInterface({ kind = t.literal("message"), message = interface3 }),
	delivery = t.strictInterface({
		state = t.literal("acknowledged"),
		attemptedAtUnixMilliseconds = t.number,
		resolvedAtUnixMilliseconds = t.number
	})
}))

return {
	isValidMessageDraft = interface2,
	isValidMessage = interface3,
	isValidMessageEnvelope = function(data)
		local v, v2 = union(data)

		if not v then
			return false, v2
		end

		if data.direction == "incoming" and data.stableId ~= data.payload.message.id then
			return false, "incoming envelope stableId must equal message.id"
		end

		return true
	end
}
