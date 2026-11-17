local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local getAllInstancesIsA = require(parent.util.getAllInstancesIsA)

local getFFlagUGCValidateCurveAnimSingleRoot = require(parent.flags.getFFlagUGCValidateCurveAnimSingleRoot)

return {
	getData = function(p, p2)
		local result = {}
		local result2 = {}

		for _, v in getAllInstancesIsA(p, "Animation") do
			local animationId = v.AnimationId

			if animationId == "" then
				continue
			end

			local v2 = p2 and p2.preloadedCurveAnimations[animationId]

			if v2 then
				table.insert(result, v2)
				table.insert(result2, v)
			else
				local success, result3 = pcall(function()
					return game:GetObjectsAllOrNone(animationId)
				end)

				if not success or result3 == nil then
					return nil
				end

				if getFFlagUGCValidateCurveAnimSingleRoot() then
					if #result3 ~= 1 or not result3[1]:IsA("CurveAnimation") then
						return nil
					end

					table.insert(result, result3[1])
					table.insert(result2, v)
				else
					for _, curveAnimation in result3 do
						if not curveAnimation:IsA("CurveAnimation") then
							continue
						end

						table.insert(result, curveAnimation)
						table.insert(result2, v)
					end
				end
			end
		end

		return result, result2
	end
}
