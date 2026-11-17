local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createSduiFriendRecommendationsStore = require(script.Parent.createSduiFriendRecommendationsStore)

local SharedFlags = require(parent.SharedFlags)
local FFlagPymkCarouselExtendProps = SharedFlags.FFlagPymkCarouselExtendProps

local computed = Signals.createComputed(createSduiFriendRecommendationsStore)

if FFlagPymkCarouselExtendProps then
	return nil
end

return function()
	return computed(false)
end
