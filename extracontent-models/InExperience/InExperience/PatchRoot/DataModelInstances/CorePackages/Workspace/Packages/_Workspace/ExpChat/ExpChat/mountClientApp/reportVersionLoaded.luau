return function(p, value)
	local v = string.gsub(value or "0", "%p", { ["."] = "_" })
	p.reportCounter(string.format("ExpChatV%sCount", v))
end
