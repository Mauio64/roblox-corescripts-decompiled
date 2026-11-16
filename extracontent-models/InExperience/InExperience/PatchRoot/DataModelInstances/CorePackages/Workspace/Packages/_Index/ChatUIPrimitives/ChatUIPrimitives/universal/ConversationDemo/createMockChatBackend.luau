local HttpService = game:GetService("HttpService")

local Signals = require(script:FindFirstAncestor("ChatUIPrimitives").Parent.Signals)
local PlainTextContentModel = require(script.Parent.Parent.ContentKinds.PlainText.PlainTextContentModel)
local PresetContentModel = require(script.Parent.Parent.ContentKinds.Preset.PresetContentModel)
local EmojiContentModel = require(script.Parent.Parent.ContentKinds.Emoji.EmojiContentModel)
local MessageEnvelopeModel = require(script.Parent.Parent.MessageEnvelopeModel)
local MessageModel = require(script.Parent.Parent.MessageModel)
require(script.Parent.Parent.Types)

local frozen = table.freeze({
	{ userId = "1", displayName = "Roblox" },
	{ userId = "156", displayName = "Builderman" }
})

local function incomingPlainText(text: string) -- 12 equivalent calls inferred from this helper
	return { kind = "plainText", text = text }
end

local function incomingPreset(presetId: string, displayText: string) -- 2 equivalent calls inferred from this helper
	return { kind = "preset", presetId = presetId, displayText = displayText }
end

local function incomingEmoji(emojiId: string, unicode: string) -- 1 equivalent call inferred from this helper
	return { kind = "emoji", emojiId = emojiId, unicode = unicode }
end

local frozen2 = table.freeze({
	"Switching to Bright blue, red team is stacked",
	"Who just bloxxed me off the tower??",
	"12 KOs and still top of the leaderboard, come get me",
	"gg! Sending you a friend request",
	"Where is everyone? The map is empty",
	"/regen the bridge is gone again",
	"Anyone on yellow want to team up?",
	"Got bloxxed by my own rocket lol",
	"Meet at the middle tower, bring a sword",
	"Friend request sent, let's run it back",
	"Changing teams, green has nobody",
	"Who keeps blowing up the house? /regen"
})

local frozen3 = table.freeze({
	incomingPlainText(frozen2[1]), -- inferred equivalent call
	incomingPlainText(frozen2[2]), -- inferred equivalent call
	incomingPlainText(frozen2[3]), -- inferred equivalent call
	incomingPlainText(frozen2[4]), -- inferred equivalent call
	incomingPlainText(frozen2[5]), -- inferred equivalent call
	incomingPlainText(frozen2[6]), -- inferred equivalent call
	incomingPlainText(frozen2[7]), -- inferred equivalent call
	incomingPlainText(frozen2[8]), -- inferred equivalent call
	incomingPlainText(frozen2[9]), -- inferred equivalent call
	incomingPlainText(frozen2[10]), -- inferred equivalent call
	incomingPlainText(frozen2[11]), -- inferred equivalent call
	incomingPlainText(frozen2[12]), -- inferred equivalent call
	incomingPreset("hello", "Hello"), -- inferred equivalent call
	incomingPreset("gg", "gg"), -- inferred equivalent call
	incomingEmoji("party-popper", "🎉") -- inferred equivalent call
})

local function acceptedSendOf(p)
	local content = p.contents[1]

	if content == nil then
		return nil
	end

	local draft = PlainTextContentModel.getDraft(content)

	if draft == nil then
		local draft2 = PresetContentModel.getDraft(content)

		if draft2 == nil then
			local draft3 = EmojiContentModel.getDraft(content)

			if draft3 == nil or (draft3.emojiId == "" or draft3.unicode == "") then
				return nil
			end

			return { kind = "emoji", emojiId = draft3.emojiId, unicode = draft3.unicode }
		elseif draft2.presetId == "" or draft2.displayText == "" then
			return nil
		else
			return { kind = "preset", presetId = draft2.presetId, displayText = draft2.displayText }
		end
	elseif draft.text == "" then
		return nil
	else
		return { kind = "plainText", text = draft.text }
	end
end

return {
	create = function(userId: string, data)
		local v = { userId = userId, displayName = "You" }

		local random = Random.new()
		local function nextInteger(p: number, p2: number) -- 1 equivalent call inferred from this helper
			local random2

			if data then
				random2 = data.random
			end

			if random2 then
				return random2:NextInteger(p, p2)
			end

			return random:NextInteger(p, p2)
		end

		local function pick(frozen4) -- 3 equivalent calls inferred from this helper
			return frozen4[nextInteger(1, #frozen4)] -- inferred equivalent call
		end

		local signal, v2 = Signals.createSignal({})
		local v3 = {}

		local timestamp = 0
		local function nowMs() -- 2 equivalent calls inferred from this helper
			local getNowMs

			if data then
				getNowMs = data.getNowMs
			end

			if getNowMs then
				return getNowMs()
			end

			return DateTime.now().UnixTimestampMillis
		end

		local function appendEnvelope(p) -- 2 equivalent calls inferred from this helper
			local clone = table.clone(signal(false))
			table.insert(clone, p)
			v2(clone)
		end

		local function nextTimestamp() -- 4 equivalent calls inferred from this helper
			timestamp = math.max(nowMs(), timestamp + 1) -- inferred equivalent call
			return timestamp
		end

		local function messageFromText(p: string, author, sentAtUnixMilliseconds: number?)
			local fromPlainText = MessageModel.fromPlainText

			if not sentAtUnixMilliseconds then
				sentAtUnixMilliseconds = nextTimestamp() -- inferred equivalent call
			end

			return fromPlainText(p, {
				sentAtUnixMilliseconds = sentAtUnixMilliseconds,
				author = author
			})
		end

		local function messageFromAcceptedSend(data2, author, sentAtUnixMilliseconds: number?)
			if not sentAtUnixMilliseconds then
				sentAtUnixMilliseconds = nextTimestamp() -- inferred equivalent call
			end

			local v4 = { sentAtUnixMilliseconds = sentAtUnixMilliseconds, author = author }

			if data2.kind == "preset" then
				return MessageModel.fromPreset(data2.presetId, data2.displayText, v4)
			end

			if data2.kind == "emoji" then
				return MessageModel.fromEmoji(data2.emojiId, data2.unicode, v4)
			end

			return MessageModel.fromPlainText(data2.text, v4)
		end

		local function appendMessage(p) -- 2 equivalent calls inferred from this helper
			appendEnvelope(MessageEnvelopeModel.incoming(p)) -- inferred equivalent call
		end

		local author = pick(frozen) -- inferred equivalent call
		appendMessage(MessageModel.fromPlainText("Welcome to Crossroads! Type /regen if someone wrecks the map.", { -- inferred equivalent call
			sentAtUnixMilliseconds = nextTimestamp(), -- inferred equivalent call
			author = author
		}))

		local function replaceEnvelope(guid: string, fn)
			local v4 = signal(false)
			local clone = table.clone(v4)

			for k, v5 in v4 do
				if v5.stableId == guid then
					clone[k] = fn(v5)
					v2(clone)
					break
				end
			end
		end

		local function pushIncoming() -- 2 equivalent calls inferred from this helper
			appendMessage(messageFromAcceptedSend(pick(frozen3), pick(frozen))) -- inferred equivalent call
		end

		return {
			getMessageEnvelopes = signal,
			sendMessageDraft = function(p)
				local v4 = acceptedSendOf(p)

				if v4 == nil then
					return
				end

				local guid = HttpService:GenerateGUID(false)
				local timestamp2 = nextTimestamp() -- inferred equivalent call
				local deliveryOutcome

				if data then
					deliveryOutcome = data.deliveryOutcome
				else
					deliveryOutcome = nil
				end

				local deliveryDelaySeconds

				if data then
					deliveryDelaySeconds = data.deliveryDelaySeconds
				end

				appendEnvelope(MessageEnvelopeModel.sending(guid, p, v, timestamp2)) -- inferred equivalent call

				local thread = nil
				local function resolveDelivery()
					v3[thread] = nil
					replaceEnvelope(guid, function(data2)
						if
							data2.direction ~= "outgoing"
							or data2.payload.kind ~= "draft"
							or data2.delivery.state ~= "sending"
						then
							return data2
						end

						local v5 = math.max(nowMs(), data2.delivery.attemptedAtUnixMilliseconds) -- inferred equivalent call

						if deliveryOutcome == "fail" then
							return MessageEnvelopeModel.failed(data2, v5)
						end

						return MessageEnvelopeModel.acknowledged(data2, messageFromAcceptedSend(v4, v, timestamp2), v5)
					end)
				end

				if deliveryDelaySeconds == nil then
					thread = task.defer(resolveDelivery)
				else
					thread = task.delay(deliveryDelaySeconds, resolveDelivery)
				end

				v3[thread] = true
			end,
			startIncomingTraffic = function()
				local flag = false
				local thread = nil
				local function scheduleNext()
					thread = task.delay(2, function()
						thread = nil

						if flag then
							return
						end

						pushIncoming() -- inferred equivalent call
						scheduleNext()
					end)
				end

				thread = task.delay(2, function()
					thread = nil

					if flag then
						return
					end

					pushIncoming() -- inferred equivalent call
					scheduleNext()
				end)

				return function()
					flag = true

					if thread ~= nil then
						task.cancel(thread)
						thread = nil
					end
				end
			end,
			destroy = function()
				for k in v3 do
					task.cancel(k)
				end

				table.clear(v3)
			end
		}
	end,
	incomingIntervalSeconds = 2,
	senderPool = frozen,
	welcomeText = "Welcome to Crossroads! Type /regen if someone wrecks the map.",
	incomingLines = frozen2,
	incomingContents = frozen3
}
