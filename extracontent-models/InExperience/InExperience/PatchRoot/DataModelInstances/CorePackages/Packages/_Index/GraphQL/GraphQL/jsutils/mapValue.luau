require(script.Parent.ObjMap)

return {
	mapValue = function(items, callback)
		local result = {}

		for k, item in pairs(items) do
			result[k] = callback(item, k)
		end

		return result
	end
}
