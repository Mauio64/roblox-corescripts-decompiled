require(script.Parent.Types)
local MessageEnvelopeModel = {}

function MessageEnvelopeModel.incoming(message)
	return {
		direction = "incoming",
		stableId = message.id,
		payload = { kind = "message", message = message }
	}
end

function MessageEnvelopeModel.sending(stableId: string, draft, author, attemptedAtUnixMilliseconds: number)
	return {
		direction = "outgoing",
		stableId = stableId,
		payload = { kind = "draft", draft = draft, author = author },
		delivery = { state = "sending", attemptedAtUnixMilliseconds = attemptedAtUnixMilliseconds }
	}
end

function MessageEnvelopeModel.acknowledged(p, message, resolvedAtUnixMilliseconds: number)
	return {
		direction = "outgoing",
		stableId = p.stableId,
		payload = { kind = "message", message = message },
		delivery = {
			state = "acknowledged",
			attemptedAtUnixMilliseconds = p.delivery.attemptedAtUnixMilliseconds,
			resolvedAtUnixMilliseconds = resolvedAtUnixMilliseconds
		}
	}
end

function MessageEnvelopeModel.failed(data, resolvedAtUnixMilliseconds: number)
	return {
		direction = "outgoing",
		stableId = data.stableId,
		payload = data.payload,
		delivery = {
			state = "failed",
			attemptedAtUnixMilliseconds = data.delivery.attemptedAtUnixMilliseconds,
			resolvedAtUnixMilliseconds = resolvedAtUnixMilliseconds
		}
	}
end

return MessageEnvelopeModel
