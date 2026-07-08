local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local getAllInstancesIsA = require(ParentParent.util.getAllInstancesIsA)

return {
	getData = function(p1) -- line: 17
		-- upvalues: getAllInstancesIsA (copy)
		local t1 = {}

		for _, v6 in getAllInstancesIsA(p1, "Animation") do
			local AnimationId = v6.AnimationId

			if AnimationId == "" then
				continue
			end

			local ok, result = pcall(function() -- line: 26
				-- upvalues: AnimationId (copy)
				return game:GetObjectsAllOrNone(AnimationId)
			end)

			if not ok or result == nil then
				return nil
			end

			for _, v11 in result do
				if v11:IsA("CurveAnimation") then
					table.insert(t1, v11)
				end
			end
		end

		return t1
	end
}
