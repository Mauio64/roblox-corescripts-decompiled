local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local React = require(SchoolsParent.React)
local Foundation = require(SchoolsParent.Foundation)
local ScrollView = Foundation.ScrollView
local FoundationText = Foundation.Text
local View = Foundation.View
local useLocalization = require(SchoolsParent.Localization).Hooks.useLocalization

require(Schools.Common.Enums)

local waitlistVariants = require(script.Parent.waitlistVariants)
local WaitlistTimeline = require(script.Parent.WaitlistTimeline)
local WaitlistShareBanner = require(script.Parent.WaitlistShareBanner)

local function SchoolWaitlist(t1: {[any]: any}) -- line: 36
	-- upvalues: waitlistVariants (copy), useLocalization (copy), React (copy), ScrollView (copy), Foundation (copy), View (copy), FoundationText (copy), WaitlistTimeline (copy), WaitlistShareBanner (copy)
	local v14 = waitlistVariants.byVariant[t1.variant]
	local v15 = useLocalization({
		body = v14.bodyKey
	})

	return React.createElement(ScrollView, {
		Size = UDim2.fromScale(1, 1),
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(1, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			scrollBarVisibility = Foundation.Enums.Visibility.Auto
		}
	}, {
		Inner = React.createElement(View, {
			tag = "col gap-large size-full-0 auto-y padding-bottom-xlarge"
		}, {
			Header = React.createElement(View, {
				LayoutOrder = 1,
				tag = "col align-x-left gap-xxsmall size-full-0 auto-y"
			}, {
				Heading = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left content-default",
					Text = t1.schoolName
				}),
				Body = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
					Text = v15.body
				})
			}),
			Timeline = React.createElement(WaitlistTimeline, {
				LayoutOrder = 2,
				stages = v14.stages,
				remainingCount = t1.remainingCount
			}),
			ShareBanner = React.createElement(WaitlistShareBanner, {
				LayoutOrder = 3,
				titleKey = v14.shareTitleKey,
				bodyKey = v14.shareBodyKey,
				hasMedia = v14.hasShareMedia,
				mediaImage = t1.shareMedia,
				onShare = t1.onShare
			})
		})
	})
end

return SchoolWaitlist
