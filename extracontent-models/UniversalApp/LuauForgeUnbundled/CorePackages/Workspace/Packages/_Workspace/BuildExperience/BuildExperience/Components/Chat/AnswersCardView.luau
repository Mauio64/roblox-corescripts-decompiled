local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")

local function AnswersCardView(props)
	local children = {}

	for k, row in props.rows do
		local children2 = {}

		for k2, answer in row.answers do
			local formatted = `Answer{k2}`
			local createElement = React.createElement
			local view = Foundation.View

			local v6 = {
				Title = React.createElement(Foundation.Text, {
					LayoutOrder = 1,
					Text = answer.title,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis"
				}),
				Description = 0
			}

			local v7 = if answer.description ~= nil then React.createElement(Foundation.Text, {
				LayoutOrder = 2,
				Text = answer.description,
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
			}) else nil
			v6.Description = v7
			children2[formatted] = createElement(
				view,
				{ LayoutOrder = k2, tag = "col gap-xsmall size-full-0 auto-y" },
				v6
			)
		end

		children[`Answer{k}`] = React.createElement(
			Foundation.View,
			{ LayoutOrder = k, tag = "col size-full-0 auto-y" },
			{
				Divider = React.createElement(Foundation.Divider, { LayoutOrder = 1 }),
				Content = React.createElement(
					Foundation.View,
					{
						LayoutOrder = 2,
						tag = "col gap-xsmall size-full-0 auto-y padding-large"
					},
					{
						Question = React.createElement(Foundation.Text, {
							LayoutOrder = 1,
							Text = row.question,
							tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted"
						}),
						Answers = React.createElement(
							Foundation.View,
							{
								LayoutOrder = 2,
								tag = "col gap-small size-full-0 auto-y"
							},
							children2
						)
					}
				)
			}
		)
	end

	return React.createElement(
		Foundation.View,
		{
			LayoutOrder = props.LayoutOrder,
			Size = props.Size,
			tag = "stroke-standard stroke-default radius-large",
			testId = "AnswersCard"
		},
		{
			Content = React.createElement(
				Foundation.View,
				{
					onAbsoluteSizeChanged = props.onContentSizeChanged,
					tag = "col size-full-0 auto-y",
					testId = "AnswersCard.Content"
				},
				{
					Header = React.createElement(Foundation.Text, {
						LayoutOrder = 1,
						Text = props.headerText,
						tag = "size-full-0 auto-y padding-large text-title-small text-align-x-left content-emphasis"
					}),
					Answers = React.createElement(
						Foundation.View,
						{ LayoutOrder = 2, tag = "col size-full-0 auto-y" },
						children
					)
				}
			)
		}
	)
end

return AnswersCardView
