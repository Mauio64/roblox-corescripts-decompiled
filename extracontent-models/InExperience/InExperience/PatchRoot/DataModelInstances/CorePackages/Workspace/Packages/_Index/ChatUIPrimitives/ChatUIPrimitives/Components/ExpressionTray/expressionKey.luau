local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
require(ChatUIPrimitives.UniversalMessage.Types)

return {
	expressionKey = function(data)
		if data.kind == "preset" then
			return "preset:" .. data.presetId
		end

		if data.kind == "emoji" then
			return "emoji:" .. data.emojiId
		end

		if data.kind == "asset" then
			return "asset:" .. data.assetId
		end

		return "plain-text"
	end
}
