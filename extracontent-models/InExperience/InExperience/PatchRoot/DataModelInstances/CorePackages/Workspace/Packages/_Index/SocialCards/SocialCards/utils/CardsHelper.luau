local SocialCards = script:FindFirstAncestor("SocialCards")
local parent = SocialCards.Parent

local RoactUtils = require(parent.RoactUtils)

local FFlagEnableCallCard = require(SocialCards.Flags.FFlagEnableCallCard)
local createLazyComponent = RoactUtils.Components.createLazyComponent

local cardComponent = {
	scheduled_group_up = createLazyComponent(function()
		local Components = require(SocialCards.Components)
		return Components.ScheduledSquadCard
	end),
	group_up = createLazyComponent(function()
		local Components = require(SocialCards.Components)
		return Components.SquadCard.SquadCard
	end)
}

if FFlagEnableCallCard then
	cardComponent.call = createLazyComponent(function()
		return require(SocialCards.Components.CallCard)
	end)
end

return { CardComponent = cardComponent }
