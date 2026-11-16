local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent

local React = require(parent.React)

local MobileGameJoinCard = require(GameJoinCard.Components.MobileGameJoinCard.MobileGameJoinCard)
local useInExperienceGameJoinCardViewModel = require(script.Parent.useInExperienceGameJoinCardViewModel)
require(script.Parent.Types)

local function InExperienceGameJoinCard(p)
	local v = useInExperienceGameJoinCardViewModel(p)
	return React.createElement(MobileGameJoinCard, v)
end

return InExperienceGameJoinCard
