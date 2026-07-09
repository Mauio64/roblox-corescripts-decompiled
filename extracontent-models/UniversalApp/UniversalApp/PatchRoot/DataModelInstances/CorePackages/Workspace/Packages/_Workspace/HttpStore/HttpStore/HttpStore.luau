local ParentParent = script.Parent.Parent
local Signals = require(ParentParent.Signals)

require(ParentParent.InternalHttpStore)

local createHttpStore = require(script.Parent.createHttpStore)
local u4 = nil
local v5, v6 = Signals.createSignal(nil)
local u7 = v5
local u8 = v6

return {
	_create = function(p1) -- line: 24
		-- upvalues: u4 (ref), createHttpStore (copy), u8 (ref)
		u4 = createHttpStore(p1)
		u8(u4)

		return u4
	end,
	_dispose = function() -- line: 30
		-- upvalues: u7 (ref), u8 (ref)
		local v10 = u7()

		if v10 ~= nil then
			v10.cancelAll()
		end

		u8(nil)
	end,
	get = function(p2) -- line: 38
		-- upvalues: u7 (ref)
		return u7(p2)
	end
}
