local u1 = false

return {
	setEnabled = function(b1: boolean) -- line: 6
		-- upvalues: u1 (ref)
		u1 = b1
	end,
	isEnabled = function() -- line: 10
		-- upvalues: u1 (ref)
		return u1
	end,
	log = function(s1: string, s2: string?) -- line: 14
		-- upvalues: u1 (ref)
		if not u1 then
			return
		end

		if s2 then
			print(`[ChatTextArea] { s1 } | { s2 }`)

			return
		end

		print(`[ChatTextArea] { s1 }`)
	end
}
