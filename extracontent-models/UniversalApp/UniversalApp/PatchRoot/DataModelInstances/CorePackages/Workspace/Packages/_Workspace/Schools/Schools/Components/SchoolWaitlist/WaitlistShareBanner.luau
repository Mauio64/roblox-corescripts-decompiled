local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local React = require(SchoolsParent.React)
local Foundation = require(SchoolsParent.Foundation)
local Button = Foundation.Button
local FoundationImage = Foundation.Image
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useLocalization = require(SchoolsParent.Localization).Hooks.useLocalization
local TextKeys = require(Schools.Common.TextKeys)
local Constants = require(Schools.Common.Constants)

local function WaitlistShareBanner(t1: {[any]: any}) -- line: 29
	-- upvalues: useLocalization (copy), TextKeys (copy), React (copy), View (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), InputSize (copy), Constants (copy), FoundationImage (copy)
	local v16 = useLocalization({
		title = t1.titleKey,
		body = t1.bodyKey,
		shareAction = TextKeys.ShareBannerAction
	})
	local v17 = t1.hasMedia and t1.mediaImage ~= nil

	return React.createElement(View, {
		tag = "row size-full-0 auto-y stroke-standard stroke-default radius-medium clip bg-surface-100",
		LayoutOrder = t1.LayoutOrder
	}, {
		Content = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col align-x-left grow gap-xsmall size-0-0 auto-y padding-large"
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-label-large text-wrap text-align-x-left content-emphasis",
				Text = v16.title
			}),
			Body = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
				Text = v16.body
			}),
			CTA = React.createElement(View, {
				LayoutOrder = 3,
				tag = "row align-x-left size-full-0 auto-y padding-top-medium"
			}, {
				ShareButton = React.createElement(Button, {
					text = v16.shareAction,
					variant = ButtonVariant.Emphasis,
					size = InputSize.Small,
					onActivated = t1.onShare
				})
			})
		}),
		Media = if not v17 then nil else React.createElement(View, {
			LayoutOrder = 2,
			tag = "align-x-center align-y-center",
			Size = UDim2.new(0, Constants.Waitlist.MEDIA_WIDTH, 0, Constants.Waitlist.MEDIA_HEIGHT)
		}, {
			MediaImage = React.createElement(FoundationImage, {
				BackgroundTransparency = 1,
				Image = t1.mediaImage,
				Size = UDim2.fromScale(1, 1),
				ScaleType = Enum.ScaleType.Fit
			})
		})
	})
end

return WaitlistShareBanner
