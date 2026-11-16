local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local getAllInstancesIsA = require(parent.util.getAllInstancesIsA)

local getFFlagUGCValidateCurveAnimSingleRoot = require(parent.flags.getFFlagUGCValidateCurveAnimSingleRoot)

return {
	getData = function(p, p2)
		local result = {}

		for _, v in getAllInstancesIsA(p, "Animation") do
			local animationId = v.AnimationId

			if animationId == "" then
				continue
			end

			local v2 = p2 and p2.preloadedCurveAnimations[animationId]

			if v2 then
				table.insert(result, v2)
			else
				local success, result2 = pcall(function()
					return game:GetObjectsAllOrNone(animationId)
				end)

				if not success or result2 == nil then
					return nil
				end

				if getFFlagUGCValidateCurveAnimSingleRoot() then
					if #result2 ~= 1 or not result2[1]:IsA("CurveAnimation") then
						return nil
					end

					table.insert(result, result2[1])
				else
					for _, curveAnimation in result2 do
						if curveAnimation:IsA("CurveAnimation") then
							table.insert(result, curveAnimation)
						end
					end
				end
			end
		end

		return result
	end
}
