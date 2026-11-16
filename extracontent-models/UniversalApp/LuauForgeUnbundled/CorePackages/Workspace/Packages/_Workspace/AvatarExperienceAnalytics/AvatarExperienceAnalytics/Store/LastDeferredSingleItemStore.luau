local snapshot = nil

return {
	setSnapshot = function(p2)
		snapshot = p2
	end,
	getSnapshot = function()
		return snapshot
	end,
	clearSnapshot = function()
		snapshot = nil
	end
}
