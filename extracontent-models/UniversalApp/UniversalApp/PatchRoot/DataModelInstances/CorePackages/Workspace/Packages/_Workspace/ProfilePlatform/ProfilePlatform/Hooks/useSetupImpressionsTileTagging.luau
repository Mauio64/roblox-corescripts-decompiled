local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(Parent.React)
local ImpressionsTagUtility = require(Parent.Impressions).ImpressionsTagUtility

local function useSetupImpressionsTileTagging(p1, s1: string, n1: number) -- line: 8
	-- upvalues: React (copy), ImpressionsTagUtility (copy)
	React.useEffect(function() -- line: 9
		-- upvalues: ImpressionsTagUtility (copy), p1 (copy), s1 (copy), n1 (copy)
		ImpressionsTagUtility.AddTag(p1, s1, n1)

		return function() -- line: 11
			-- upvalues: ImpressionsTagUtility (copy), p1 (copy), s1 (copy), n1 (copy)
			ImpressionsTagUtility.RemoveTag(p1, s1, n1)
		end
	end, {
		p1,
		s1,
		n1
	})
end

return useSetupImpressionsTileTagging
