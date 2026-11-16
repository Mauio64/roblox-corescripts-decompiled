local parent = script.Parent.Parent
require(parent.Signals)

local function onDisposed(callback, callback2)
	local function source(_, flag: boolean?): number
		if flag then
			callback2()
		end

		return 0
	end

	callback(source)
end

return onDisposed
