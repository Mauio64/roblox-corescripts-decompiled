local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local BuilderIcons = require(MomentsParent.BuilderIcons)
local Foundation = require(MomentsParent.Foundation)
local MomentsCommon = require(MomentsParent.MomentsCommon)
local React = require(MomentsParent.React)
local ChevronLargeUp = BuilderIcons.Icon.ChevronLargeUp
local ChevronLargeDown = BuilderIcons.Icon.ChevronLargeDown
local IconButton = Foundation.IconButton
local View = Foundation.View
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local usePreferredInput = require(Moments.Hooks.usePreferredInput)
local useTokens = Foundation.Hooks.useTokens
local FormFactor = MomentsCommon.Enums.FormFactor

local function NavigationBar(t1: {[any]: any}) -- line: 38
	-- upvalues: useDeviceInsets (copy), useFormFactor (copy), usePreferredInput (copy), useTokens (copy), FormFactor (copy), React (copy), View (copy), IconButton (copy), ChevronLargeUp (copy), Foundation (copy), ChevronLargeDown (copy)
	local v18 = useDeviceInsets()
	local v19 = useFormFactor()
	local v20 = usePreferredInput()
	local v21 = useTokens()

	if v19 == FormFactor.MobileLandscape then
		return nil
	end

	if v20 ~= Enum.PreferredInput.KeyboardAndMouse and v20 ~= Enum.PreferredInput.Gamepad then
		return nil
	end

	if not t1.active then
		return nil
	end

	return React.createElement(View, {
		tag = "size-full",
		padding = {
			right = UDim.new(0, (math.max(v18.right, v21.Padding.XLarge)))
		},
		ZIndex = t1.zIndex
	}, {
		NavControls = React.createElement(View, {
			tag = "col align-x-center align-y-center position-center-right anchor-center-right auto-xy radius-circle clip bg-over-media-0"
		}, {
			PreviousButton = React.createElement(IconButton, {
				isCircular = true,
				LayoutOrder = 1,
				icon = ChevronLargeUp,
				isDisabled = t1.currentIndex == 1,
				onActivated = t1.onScrollToPrevious,
				size = Foundation.Enums.IconSize.Medium
			}),
			NextButton = React.createElement(IconButton, {
				isCircular = true,
				LayoutOrder = 2,
				icon = ChevronLargeDown,
				isDisabled = t1.currentIndex == t1.numItems,
				onActivated = t1.onScrollToNext,
				size = Foundation.Enums.IconSize.Medium
			})
		})
	})
end

return NavigationBar
