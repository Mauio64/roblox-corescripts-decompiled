local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local BuilderIcons = require(parent.BuilderIcons)

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local ChevronLargeUp = BuilderIcons.Icon.ChevronLargeUp
local ChevronLargeDown = BuilderIcons.Icon.ChevronLargeDown

local IconButton = Foundation.IconButton
local View = Foundation.View

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local usePreferredInput = require(Moments.Hooks.usePreferredInput)
local useTokens = Foundation.Hooks.useTokens

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput

local FormFactor = MomentsCommon.Enums.FormFactor

local function NavigationBar(props)
	local v = useDeviceInsets()
	local v2 = useFormFactor()
	local v3 = usePreferredInput()
	local v4 = useTokens()

	local FFlagMomentsAlignFeedNavArrowsWithHeader = require(Moments.Flags.FFlagMomentsAlignFeedNavArrowsWithHeader)
	local v5

	if FFlagMomentsAlignFeedNavArrowsWithHeader then
		local AppComposition = require(parent.AppComposition)
		v5 = AppComposition.useCompositionLayout()
	end

	if v2 == FormFactor.MobileLandscape then
		return nil
	end

	local v6 = v3 == Enum.PreferredInput.Gamepad
		or FFlagLuaSupportMicroGamepadPreferredInput and v3 == Enum.PreferredInput.MicroGamepad

	if v3 ~= Enum.PreferredInput.KeyboardAndMouse and not v6 or not props.active then
		return nil
	end

	local v7 = math.max(v.right, v4.Padding.XLarge)

	if FFlagMomentsAlignFeedNavArrowsWithHeader then
		local resolveFeedRightChromeInset = require(script.Parent.resolveFeedRightChromeInset)
		local v8

		if v5 ~= nil then
			v8 = v5.margin
		end

		v7 = resolveFeedRightChromeInset(v, v8, v4.Padding.XLarge)
	end

	return React.createElement(View, {
		padding = { right = UDim.new(0, v7) },
		tag = "size-full",
		ZIndex = props.zIndex
	}, {
		NavControls = React.createElement(
			View,
			{
				tag = "col align-x-center align-y-center position-center-right anchor-center-right auto-xy radius-circle clip bg-over-media-0"
			},
			{
				PreviousButton = React.createElement(IconButton, {
					icon = ChevronLargeUp,
					isCircular = true,
					isDisabled = props.currentIndex == 1,
					LayoutOrder = 1,
					onActivated = props.onScrollToPrevious,
					size = Foundation.Enums.IconSize.Medium
				}),
				NextButton = React.createElement(IconButton, {
					icon = ChevronLargeDown,
					isCircular = true,
					isDisabled = props.currentIndex == props.numItems,
					LayoutOrder = 2,
					onActivated = props.onScrollToNext,
					size = Foundation.Enums.IconSize.Medium
				})
			}
		)
	})
end

return NavigationBar
