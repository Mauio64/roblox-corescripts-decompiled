local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local FFlagEnableBuildExperienceScrollPerformanceTracking = require(BuildExperience.Flags.FFlagEnableBuildExperienceScrollPerformanceTracking)
local v6 = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else require(BuildExperience.Telemetry.useScrollPerformanceTracker)
local IconButton = Foundation.IconButton
local Divider = Foundation.Divider
local ScrollView = Foundation.ScrollView
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local function OverflowMenuPageShell(t1: {[any]: any}) -- line: 35
	-- upvalues: React (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy), v6 (copy), View (copy), IconButton (copy), IconName (copy), InputSize (copy), ButtonVariant (copy), FoundationText (copy), ScrollView (copy), Divider (copy)
	local v17 = t1.testId or "overflow-menu-page"
	local v18 = React.useRef(nil)

	if FFlagEnableBuildExperienceScrollPerformanceTracking then
		v6(t1.scrollPerformanceIntervalName, v18)
	end

	return React.createElement(View, {
		tag = "col align-x-center size-full bg-surface-0",
		LayoutOrder = t1.layoutOrder,
		testId = v17
	}, {
		Header = React.createElement(View, {
			LayoutOrder = 1,
			tag = "composition-content-header row align-y-center gap-small size-full-0 auto-y padding-y-small",
			testId = `{ v17 }-header`
		}, {
			Close = React.createElement(IconButton, {
				LayoutOrder = 1,
				isCircular = true,
				icon = t1.closeIcon or IconName.X,
				onActivated = t1.onClose,
				size = InputSize.Medium,
				testId = `{ v17 }-close`,
				variant = ButtonVariant.Utility
			}),
			Title = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "fill text-heading-medium text-align-x-left text-truncate-end content-emphasis",
				Text = t1.title
			}),
			Trailing = if t1.headerTrailing == nil then nil else React.createElement(View, {
				LayoutOrder = 3,
				tag = "auto-xy",
				testId = `{ v17 }-header-trailing`
			}, {
				Content = t1.headerTrailing
			})
		}),
		Body = React.createElement(ScrollView, {
			LayoutOrder = 2,
			tag = "fill size-full-0 bg-surface-0",
			scrollingFrameRef = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else v18,
			testId = `{ v17 }-scroll-view`,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, {
			ContentBody = React.createElement(View, {
				tag = "composition-content-body col size-full-0 auto-y",
				testId = `{ v17 }-content-body`
			}, {
				Content = t1.content
			})
		}),
		FooterDivider = if t1.footer == nil then nil else React.createElement(Divider, {
			LayoutOrder = 3
		}),
		Footer = if t1.footer == nil then nil else React.createElement(View, {
			LayoutOrder = 4,
			tag = "composition-content-body size-full-0 auto-y",
			testId = `{ v17 }-footer-body`
		}, {
			Footer = t1.footer
		})
	})
end

return OverflowMenuPageShell
