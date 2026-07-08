return function(p1, p2) -- line: 1
	local v3 = string.gsub(p2 or "0", "%p", {
		["."] = "_"
	})

	p1.reportCounter(string.format("ExpChatV%sCount", v3))
end
