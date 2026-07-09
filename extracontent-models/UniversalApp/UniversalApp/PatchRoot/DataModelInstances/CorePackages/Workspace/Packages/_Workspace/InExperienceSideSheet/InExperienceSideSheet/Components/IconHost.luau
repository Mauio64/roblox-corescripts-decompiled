local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent

require(InExperienceSideSheetParent.Chrome)

local React = require(InExperienceSideSheetParent.React)
local Foundation = require(InExperienceSideSheetParent.Foundation)
local Flags = Foundation.Utility.Flags
local useTokens = Foundation.Hooks.useTokens
local StatusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local StatusIndicator = Foundation.StatusIndicator
local View = Foundation.View
local useNotificationCount = require(InExperienceSideSheet.Hooks.useNotificationCount)

local function IconHost(t1: {[any]: any}) -- line: 25
	-- upvalues: useTokens (copy), useNotificationCount (copy), React (copy), View (copy), StatusIndicator (copy), Flags (copy), StatusIndicatorVariant (copy)
	local v13 = useTokens()
	local v14, v15 = useNotificationCount(t1.notification)

	return React.createElement(View, {
		tag = {
			["size-1000"] = true,
			["position-center-center anchor-center-center"] = t1.centerPosition
		}
	}, {
		IconContainer = React.createElement(View, {
			tag = "size-full align-x-center align-y-center",
			ZIndex = 1
		}, {
			Icon = React.createElement(t1.icon)
		}),
		NotificationBadge = if not v14 then nil else React.createElement(StatusIndicator, {
			ZIndex = 2,
			value = v15,
			variant = if not Flags.FoundationStatusIndicatorVariantExperiment then StatusIndicatorVariant.Emphasis else StatusIndicatorVariant.Contrast_Experiment,
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.new(0, v13.Gap.XXLarge, 0, v13.Gap.Small)
		})
	})
end

return IconHost
