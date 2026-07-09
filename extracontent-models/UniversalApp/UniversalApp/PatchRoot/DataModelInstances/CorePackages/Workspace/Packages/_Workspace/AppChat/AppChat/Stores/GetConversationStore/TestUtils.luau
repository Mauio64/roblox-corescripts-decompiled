return {
	seedConversationStore = function(p1, t1: {[any]: any}?, p2) -- line: 2
		p1.clear()

		for _, v in pairs(t1 or {}) do
			p1.upsertConversation(v)
		end

		if p2 ~= nil then
			p1.setListStatus(p2)
		end
	end
}
