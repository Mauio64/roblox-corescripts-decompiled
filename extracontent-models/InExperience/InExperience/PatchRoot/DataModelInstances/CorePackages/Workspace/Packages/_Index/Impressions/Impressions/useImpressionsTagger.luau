local Parent = script:FindFirstAncestor("Impressions").Parent
local React = require(Parent.React)
local ImpressionsTagUtility = require(script.Parent.ImpressionsTagUtility)

return function(p1, s1: string, n1: number?) -- line: 8
	-- upvalues: React (copy), ImpressionsTagUtility (copy)
	React.useEffect(function() -- line: 9
		-- upvalues: ImpressionsTagUtility (copy), p1 (copy), s1 (copy), n1 (copy)
		ImpressionsTagUtility.AddTag(p1, s1, n1)

		return function() -- line: 12
			-- upvalues: ImpressionsTagUtility (copy), p1 (copy), s1 (copy), n1 (copy)
			ImpressionsTagUtility.RemoveTag(p1, s1, n1)
		end
	end, {
		p1,
		s1,
		n1
	})
end
