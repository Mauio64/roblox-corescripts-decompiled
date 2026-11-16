local v = {}
local BackHandlerRegistry = {}

function BackHandlerRegistry.register(callback)
	table.insert(v, callback)

	return function()
		local index = table.find(v, callback)

		if index then
			table.remove(v, index)
		end
	end
end

function BackHandlerRegistry.consume(): boolean
	local v2 = v[#v]

	if not v2 then
		return false
	end

	v2()
	return true
end

return BackHandlerRegistry
