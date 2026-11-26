local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local foundationProvider = Foundation.FoundationProvider
local text = Foundation.Text
local view = Foundation.View

local colorMode = Foundation.Enums.ColorMode

local function PostStatusBadgeView(p2)
	return React.createElement(
		view,
		{
			tag = "position-top-left anchor-top-left auto-xy padding-small",
			ZIndex = p2.ZIndex,
			testId = "moments-post-status-badge"
		},
		{
			DarkScope = React.createElement(foundationProvider, {
				colorMode = colorMode.Dark
			}, {
				Pill = React.createElement(
					view,
					{
						tag = "row align-y-center size-0-600 auto-x padding-x-small radius-circle bg-over-media-300"
					},
					{
						Label = React.createElement(text, {
							tag = "auto-xy text-caption-medium content-emphasis",
							Text = p2.label
						})
					}
				)
			})
		}
	)
end

return PostStatusBadgeView
