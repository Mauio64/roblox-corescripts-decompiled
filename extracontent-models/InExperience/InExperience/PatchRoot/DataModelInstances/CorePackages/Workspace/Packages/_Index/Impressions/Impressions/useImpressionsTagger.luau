local parent = script:FindFirstAncestor("Impressions").Parent

local React = require(parent.React)

local ImpressionsTagUtility = require(script.Parent.ImpressionsTagUtility)

return function(p, p2: string, p3: number?)
	React.useEffect(function()
		ImpressionsTagUtility.AddTag(p, p2, p3)

		return function()
			ImpressionsTagUtility.RemoveTag(p, p2, p3)
		end
	end, { p, p2, p3 })
end
