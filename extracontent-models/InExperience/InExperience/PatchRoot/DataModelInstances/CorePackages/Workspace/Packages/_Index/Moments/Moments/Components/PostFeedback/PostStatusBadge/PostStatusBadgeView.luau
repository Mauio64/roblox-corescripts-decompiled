local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local FoundationProvider = Foundation.FoundationProvider
local Text = Foundation.Text
local View = Foundation.View

local ColorMode = Foundation.Enums.ColorMode

local function PostStatusBadgeView(p)
	return React.createElement(
		View,
		{
			tag = "position-top-left anchor-top-left auto-xy padding-small",
			ZIndex = p.ZIndex,
			testId = "moments-post-status-badge"
		},
		{
			DarkScope = React.createElement(FoundationProvider, { colorMode = ColorMode.Dark }, {
				Pill = React.createElement(
					View,
					{
						tag = "row align-y-center size-0-600 auto-x padding-x-small radius-circle bg-over-media-300"
					},
					{
						Label = React.createElement(Text, {
							tag = "auto-xy text-caption-medium content-emphasis",
							Text = p.label
						})
					}
				)
			})
		}
	)
end

return PostStatusBadgeView
