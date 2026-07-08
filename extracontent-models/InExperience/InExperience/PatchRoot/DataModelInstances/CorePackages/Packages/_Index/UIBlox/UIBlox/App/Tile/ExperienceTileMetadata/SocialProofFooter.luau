local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent
local React = require(ParentParent2.React)
local StatGroup = require(ParentParent.Indicator.StatGroup)
local FooterFrame = require(scriptParent.FooterFrame)

local function SocialProofFooter(p1) -- line: 19
	-- upvalues: React (copy), FooterFrame (copy), StatGroup (copy)
	return React.createElement(FooterFrame, p1, {
		Stats = React.createElement(StatGroup, {
			ratingText = p1.ratingText,
			playingText = p1.playingText
		})
	})
end

return SocialProofFooter
