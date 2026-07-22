local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)

require(BuildExperience.Chat.chatTypes)

local PublishExperienceTitle = require(script.Parent.PublishExperienceTitle)
local View = Foundation.View

local function PublishLatestPreviewCard(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), View (copy), PublishExperienceTitle (copy)
	local v9 = t1.testId or "publish-latest-preview-card"

	return React.createElement(View, {
		tag = "col size-full-0 auto-y padding-top-xxsmall",
		LayoutOrder = t1.layoutOrder,
		testId = v9
	}, {
		Card = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col size-full-0 auto-y stroke-standard stroke-default radius-large clip"
		}, {
			Content = React.createElement(View, {
				LayoutOrder = 1,
				tag = "col size-full-0 auto-y padding-large"
			}, {
				Title = React.createElement(PublishExperienceTitle, {
					layoutOrder = 1,
					target = t1.target,
					isCreatorVerified = t1.isCreatorVerified,
					testId = `{ v9 }-title`
				})
			})
		})
	})
end

return PublishLatestPreviewCard
