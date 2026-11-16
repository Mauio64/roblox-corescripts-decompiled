local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent.Parent

local React = require(parent3.React)

local StatGroup = require(parent2.Indicator.StatGroup)
local FooterFrame = require(parent.FooterFrame)

local function SocialProofFooter(p)
	return React.createElement(FooterFrame, p, {
		Stats = React.createElement(StatGroup, {
			ratingText = p.ratingText,
			playingText = p.playingText
		})
	})
end

return SocialProofFooter
