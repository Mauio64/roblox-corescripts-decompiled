local v5 = false

return {
	setEnabled = function(p2)
		v5 = p2
	end,
	isEnabled = function()
		return v5
	end,
	log = function(p2, p3)
		if not v5 then
			return
		end

		if p3 then
			print(`[ChatTextArea] {p2} | {p3}`)
		else
			print(`[ChatTextArea] {p2}`)
		end
	end
}
