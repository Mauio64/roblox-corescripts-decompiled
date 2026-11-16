local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Text = Foundation.Text

local function DescriptionTextBlock(p)
	return React.createElement(Text, {
		Text = p.text,
		tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default",
		LayoutOrder = p.LayoutOrder
	})
end

return DescriptionTextBlock
