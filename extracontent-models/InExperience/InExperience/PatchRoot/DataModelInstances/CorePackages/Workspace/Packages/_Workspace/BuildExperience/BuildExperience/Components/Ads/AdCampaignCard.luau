local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local useAdCampaignCardViewModel = require(script.Parent.useAdCampaignCardViewModel)

local Button = Foundation.Button
local Text = Foundation.Text
local View = Foundation.View
local InputSize = Foundation.Enums.InputSize

local function AdCampaignCard(p)
	local v = useAdCampaignCardViewModel(p)

	return React.createElement(
		View,
		{
			LayoutOrder = p.LayoutOrder,
			tag = "col gap-large size-full-0 auto-y padding-large stroke-standard stroke-default radius-large",
			testId = "AdCampaignCard"
		},
		{
			Content = React.createElement(View, {
				LayoutOrder = 1,
				tag = "col gap-xxsmall size-full-0 auto-y"
			}, {
				Title = React.createElement(Text, {
					LayoutOrder = 1,
					Text = v.title,
					tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
				}),
				Description = React.createElement(Text, {
					LayoutOrder = 2,
					Text = v.description,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis"
				})
			}),
			Action = React.createElement(Button, {
				LayoutOrder = 2,
				text = v.actionText,
				size = InputSize.Small,
				variant = v.buttonVariant,
				width = UDim.new(1, 0),
				isLoading = v.isLoading,
				onActivated = v.onActivated,
				testId = "AdCampaignCard.Primary"
			})
		}
	)
end

return AdCampaignCard
