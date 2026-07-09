require(script.Parent.Stores.createPhotoboothStore)

local u1 = nil

return {
	setStore = function(p1) -- line: 13
		-- upvalues: u1 (ref)
		u1 = p1
	end,
	getStore = function() -- line: 17
		-- upvalues: u1 (ref)
		return u1
	end,
	clearStore = function() -- line: 21
		-- upvalues: u1 (ref)
		u1 = nil
	end
}
