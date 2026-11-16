require(script.Parent.ObjMap)

return {
	toObjMap = function(items)
		local objMap = {}

		for k, item in pairs(items) do
			objMap[k] = item
		end

		return objMap
	end
}
