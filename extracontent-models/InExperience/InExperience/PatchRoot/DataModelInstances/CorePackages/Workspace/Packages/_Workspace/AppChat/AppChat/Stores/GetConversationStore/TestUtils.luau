return {
	seedConversationStore = function(data, options, p)
		data.clear()

		for _, v in pairs(options or {}) do
			data.upsertConversation(v)
		end

		if p ~= nil then
			data.setListStatus(p)
		end
	end
}
