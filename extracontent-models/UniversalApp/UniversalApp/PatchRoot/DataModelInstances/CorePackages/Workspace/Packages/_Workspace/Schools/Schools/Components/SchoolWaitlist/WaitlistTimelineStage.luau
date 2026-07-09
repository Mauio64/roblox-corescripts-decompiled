local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local React = require(SchoolsParent.React)
local BuilderIcons = require(SchoolsParent.BuilderIcons)
local Foundation = require(SchoolsParent.Foundation)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(SchoolsParent.Localization).Hooks.useLocalization
local Constants = require(Schools.Common.Constants)

require(script.Parent.waitlistVariants)

local t1 = {
	Verified = BuilderIcons.Icon.CircleCheck,
	Pending = BuilderIcons.Icon.Clock,
	Badge = BuilderIcons.Icon.PersonGraduate,
	Classmates = BuilderIcons.Icon.ThreePeople,
	Trends = BuilderIcons.Icon.Flame
}

local function WaitlistTimelineStage(t2: {[any]: any}) -- line: 35
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), View (copy), Icon (copy), t1 (copy), IconSize (copy), FoundationText (copy), Constants (copy)
	local v16 = useTokens()
	local stage = t2.stage
	local v18 = useLocalization({
		title = if not stage.usesCount then stage.titleKey else {
			stage.titleKey,
			count = t2.remainingCount
		},
		body = stage.bodyKey
	})
	local Emphasis = v16.Color.Stroke.Emphasis
	local v20 = React.createElement(View, {
		tag = "row flex-y-fill gap-medium size-full-0 auto-y padding-x-medium",
		LayoutOrder = t2.LayoutOrder,
		sizeConstraint = {
			MinSize = Vector2.new(0, v16.Size.Size_1500)
		}
	}, {
		Indicator = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col align-x-center gap-xsmall",
			Size = UDim2.new(0, v16.Size.Size_600, 0, 0)
		}, {
			TopConnector = React.createElement(View, {
				LayoutOrder = 1,
				tag = "grow",
				Size = UDim2.new(0, v16.Size.Size_50, 0, 0),
				backgroundStyle = if not t2.isFirst then Emphasis else nil
			}),
			IconWrapper = React.createElement(Icon, {
				LayoutOrder = 2,
				name = t1[stage.icon],
				size = IconSize.Medium,
				style = v16.Color.Content.Emphasis
			}),
			BottomConnector = React.createElement(View, {
				LayoutOrder = 3,
				tag = "grow",
				Size = UDim2.new(0, v16.Size.Size_50, 0, 0),
				backgroundStyle = if not t2.isLast then Emphasis else nil
			})
		}),
		Content = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col align-x-left align-y-center grow gap-xxsmall size-0-0 auto-y padding-y-small"
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
				Text = v18.title
			}),
			Body = if stage.bodyKey == nil then nil else React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
				Text = v18.body
			})
		})
	})

	if stage.dimmed then
		return React.createElement("CanvasGroup", {
			BackgroundTransparency = 1,
			LayoutOrder = t2.LayoutOrder,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			GroupTransparency = Constants.Waitlist.DIMMED_GROUP_TRANSPARENCY
		}, {
			Row = v20
		})
	end

	return v20
end

return WaitlistTimelineStage
