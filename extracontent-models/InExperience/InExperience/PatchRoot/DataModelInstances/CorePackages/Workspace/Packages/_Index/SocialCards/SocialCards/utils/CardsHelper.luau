local SocialCards = script:FindFirstAncestor("SocialCards")
local SocialCardsParent = SocialCards.Parent
local createLazyComponent = require(SocialCardsParent.RoactUtils).Components.createLazyComponent

return {
	CardComponent = {
		scheduled_group_up = createLazyComponent(function() -- line: 9
			-- upvalues: SocialCards (copy)
			return require(SocialCards.Components).ScheduledSquadCard
		end),
		group_up = createLazyComponent(function() -- line: 12
			-- upvalues: SocialCards (copy)
			return require(SocialCards.Components).SquadCard.SquadCard
		end)
	}
}
