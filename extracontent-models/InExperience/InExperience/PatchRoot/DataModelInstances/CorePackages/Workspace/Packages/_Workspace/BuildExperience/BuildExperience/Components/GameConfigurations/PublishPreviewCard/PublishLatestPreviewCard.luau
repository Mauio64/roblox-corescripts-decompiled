local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

require(BuildExperience.Chat.chatTypes)
local PublishExperienceTitle = require(script.Parent.PublishExperienceTitle)

local View = Foundation.View

local function PublishLatestPreviewCard(props)
	local testId = props.testId or "publish-latest-preview-card"

	return React.createElement(
		View,
		{
			LayoutOrder = props.layoutOrder,
			tag = "col size-full-0 auto-y padding-top-xxsmall",
			testId = testId
		},
		{
			Card = React.createElement(
				View,
				{
					LayoutOrder = 1,
					tag = "col size-full-0 auto-y stroke-standard stroke-default radius-large clip"
				},
				{
					Content = React.createElement(
						View,
						{ LayoutOrder = 1, tag = "col size-full-0 auto-y padding-large" },
						{
							Title = React.createElement(PublishExperienceTitle, {
								target = props.target,
								isCreatorVerified = props.isCreatorVerified,
								layoutOrder = 1,
								testId = `{testId}-title`
							})
						}
					)
				}
			)
		}
	)
end

return PublishLatestPreviewCard
