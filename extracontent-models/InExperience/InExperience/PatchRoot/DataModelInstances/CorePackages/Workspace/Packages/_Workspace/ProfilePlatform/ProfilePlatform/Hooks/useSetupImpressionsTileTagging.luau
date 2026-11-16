local parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(parent.React)

local Impressions = require(parent.Impressions)
local ImpressionsTagUtility = Impressions.ImpressionsTagUtility

local function useSetupImpressionsTileTagging(p, p2: string, p3: number)
	React.useEffect(function()
		ImpressionsTagUtility.AddTag(p, p2, p3)
		return function()
			ImpressionsTagUtility.RemoveTag(p, p2, p3)
		end
	end, { p, p2, p3 })
end
return useSetupImpressionsTileTagging
