local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local chevronLargeUp = BuilderIcons.Icon.ChevronLargeUp
local chevronLargeDown = BuilderIcons.Icon.ChevronLargeDown

local iconButton = Foundation.IconButton
local view = Foundation.View

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local usePreferredInput = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/usePreferredInput")
local useTokens = Foundation.Hooks.useTokens

local fFlagLuaSupportMicroGamepadPreferredInput = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagLuaSupportMicroGamepadPreferredInput

local formFactor = MomentsCommon.Enums.FormFactor

local function NavigationBar(props)
	local v5 = useDeviceInsets()
	local v6 = useFormFactor()
	local v7 = usePreferredInput()
	local v8 = useTokens()

	local FFlagMomentsAlignFeedNavArrowsWithHeader = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsAlignFeedNavArrowsWithHeader")

	local v9 = if FFlagMomentsAlignFeedNavArrowsWithHeader then require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/AppComposition").useCompositionLayout() else nil

	if v6 == formFactor.MobileLandscape then
		return nil
	end

	local v10 = v7 == Enum.PreferredInput.Gamepad
		or fFlagLuaSupportMicroGamepadPreferredInput and v7 == Enum.PreferredInput.MicroGamepad

	if v7 ~= Enum.PreferredInput.KeyboardAndMouse and not v10 or not props.active then
		return nil
	end

	local v11 = math.max(v5.right, v8.Padding.XLarge)

	if FFlagMomentsAlignFeedNavArrowsWithHeader then
		local resolveFeedRightChromeInset = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/resolveFeedRightChromeInset")

		local v12 = if v9 ~= nil then v9.margin else nil
		v11 = resolveFeedRightChromeInset(v5, v12, v8.Padding.XLarge)
	end

	return React.createElement(view, {
		padding = { right = UDim.new(0, v11) },
		tag = "size-full",
		ZIndex = props.zIndex
	}, {
		NavControls = React.createElement(
			view,
			{
				tag = "col align-x-center align-y-center position-center-right anchor-center-right auto-xy radius-circle clip bg-over-media-0"
			},
			{
				PreviousButton = React.createElement(iconButton, {
					icon = chevronLargeUp,
					isCircular = true,
					isDisabled = props.currentIndex == 1,
					LayoutOrder = 1,
					onActivated = props.onScrollToPrevious,
					size = Foundation.Enums.IconSize.Medium
				}),
				NextButton = React.createElement(iconButton, {
					icon = chevronLargeDown,
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
