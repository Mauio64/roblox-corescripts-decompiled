local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Foundation = require(MomentsCreationParent.Foundation)
local Localization = require(MomentsCreationParent.Localization)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local GradientBackdrop = MomentsCommon.Components.GradientBackdrop
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

require(MomentsCreation.Types.CreationFlowTypes)

return function(t1: {[any]: any}) -- line: 41
	-- upvalues: useDeviceInsets (copy), useTokens (copy), useLocalization (copy), React (copy), View (copy), Icon (copy), Foundation (copy), FoundationText (copy), GradientBackdrop (copy)
	local v15 = useDeviceInsets()
	local v16 = useTokens()
	local t2 = {}

	for _, v19 in t1.tools do
		t2[v19.cta.localizationKey] = v19.cta.localizationKey
	end

	local v20 = useLocalization(t2)
	local v21, v22 = React.useBinding(UDim2.fromScale(1, 0))
	local v23 = React.useCallback(function(p1) -- line: 55
		-- upvalues: v22 (copy)
		v22(UDim2.new(0, 1.5 * p1.AbsoluteSize.X, 1, 0))
	end, {})
	local t3 = {}

	for v25, v26 in t1.tools do
		local kind = v26.kind

		t3["Tool_" .. kind] = React.createElement(View, {
			tag = "row align-x-right align-y-center gap-medium auto-xy padding-xsmall radius-medium",
			LayoutOrder = v26.cta.order or v25,
			onActivated = function() -- line: 65
				-- upvalues: t1 (copy), kind (copy)
				t1.onToolSelected(kind)
			end
		}, {
			Icon = React.createElement(Icon, {
				LayoutOrder = 2,
				name = v26.cta.icon,
				size = Foundation.Enums.IconSize.Large
			}),
			Text = if not t1.showText then nil else React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy text-label-medium content-emphasis",
				Text = v20[v26.cta.localizationKey]
			})
		})
	end

	return React.createElement(View, {
		tag = "position-center-right anchor-center-right size-0-full auto-x",
		ZIndex = t1.zIndex
	}, {
		GradientBackdrop = React.createElement(GradientBackdrop, {
			rotation = 180,
			color3 = v16.Color.Common.Scrim.Color3,
			size = v21
		}),
		EditCTABar = React.createElement(View, {
			tag = "col align-x-right align-y-center gap-small position-center-right anchor-center-right size-0-full auto-x",
			onAbsoluteSizeChanged = v23,
			padding = {
				left = UDim.new(0, v16.Padding.Large),
				right = UDim.new(0, v15.right + v16.Padding.Large)
			}
		}, t3)
	})
end
