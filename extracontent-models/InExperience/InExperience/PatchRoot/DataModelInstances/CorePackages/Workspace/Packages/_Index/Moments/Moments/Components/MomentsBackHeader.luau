local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)
local MomentsCommon = require(MomentsParent.MomentsCommon)
local React = require(MomentsParent.React)
local FoundationProvider = Foundation.FoundationProvider
local IconButton = Foundation.IconButton
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local Theme = Foundation.Enums.Theme
local GradientBackdrop = MomentsCommon.Components.GradientBackdrop
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local Constants = require(Moments.Constants)

local function MomentsBackHeader(t1: {[any]: any}) -- line: 41
	-- upvalues: useTokens (copy), useDeviceInsets (copy), React (copy), View (copy), Constants (copy), GradientBackdrop (copy), FoundationProvider (copy), Theme (copy), IconButton (copy), IconName (copy), ButtonVariant (copy), InputSize (copy)
	local v19 = useTokens()
	local v20 = useDeviceInsets()

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder,
		ZIndex = Constants.DisplayOrder.FeedTopBar
	}, {
		GradientScrim = React.createElement(GradientBackdrop, {
			startingTransparency = 0.4,
			endingTransparency = 1,
			rotation = 90,
			zIndex = 1,
			color3 = Color3.new(0, 0, 0),
			position = UDim2.fromScale(0, 0),
			size = UDim2.new(1, 0, 0, v20.top + v19.Size.Size_2000 + v19.Size.Size_1600)
		}),
		HeaderContent = React.createElement(View, {
			tag = "size-full-0 auto-y",
			ZIndex = 2,
			padding = {
				left = UDim.new(0, v20.left),
				right = UDim.new(0, v20.right),
				top = UDim.new(0, v20.top)
			}
		}, {
			OverMediaTheme = React.createElement(FoundationProvider, {
				theme = Theme.Light
			}, {
				HeaderRow = React.createElement(View, {
					tag = "row align-x-left align-y-center size-full-0 auto-y padding-x-large padding-top-medium"
				}, {
					BackButton = React.createElement(IconButton, {
						isCircular = true,
						Selectable = true,
						testId = "--moments-back-header-back",
						icon = IconName.ChevronLargeLeft,
						onActivated = t1.onBack,
						variant = ButtonVariant.OverMedia,
						size = InputSize.Medium
					})
				})
			})
		})
	})
end

return MomentsBackHeader
