local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local PublishExperienceTitle = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/PublishPreviewCard/PublishExperienceTitle")

local view = Foundation.View

local function PublishLatestPreviewCard(props)
	local testId = props.testId or "publish-latest-preview-card"

	return React.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "col size-full-0 auto-y padding-top-xxsmall",
			testId = testId
		},
		{
			Card = React.createElement(
				view,
				{
					LayoutOrder = 1,
					tag = "col size-full-0 auto-y stroke-standard stroke-default radius-large clip"
				},
				{
					Content = React.createElement(
						view,
						{
							LayoutOrder = 1,
							tag = "col size-full-0 auto-y padding-large"
						},
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
