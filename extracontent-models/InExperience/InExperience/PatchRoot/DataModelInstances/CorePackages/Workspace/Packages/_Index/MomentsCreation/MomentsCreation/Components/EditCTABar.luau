local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Foundation = require(MomentsCreationParent.Foundation)
local Localization = require(MomentsCreationParent.Localization)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local Icon = Foundation.Icon
local Loading = Foundation.Loading
local FoundationText = Foundation.Text
local View = Foundation.View
local GradientBackdrop = MomentsCommon.Components.GradientBackdrop
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

require(MomentsCreation.Types.CreationFlowTypes)

return function(t1: {[any]: any}) -- line: 43
	-- upvalues: useDeviceInsets (copy), useTokens (copy), useLocalization (copy), React (copy), View (copy), Loading (copy), Foundation (copy), Icon (copy), FoundationText (copy), GradientBackdrop (copy)
	local v16 = useDeviceInsets()
	local v17 = useTokens()
	local t2 = {}

	for _, v20 in t1.tools do
		t2[v20.cta.localizationKey] = v20.cta.localizationKey
	end

	local v21 = useLocalization(t2)
	local v22, v23 = React.useBinding(UDim2.fromScale(1, 0))
	local v24 = React.useCallback(function(p1) -- line: 57
		-- upvalues: v23 (copy)
		v23(UDim2.new(0, 1.5 * p1.AbsoluteSize.X, 1, 0))
	end, {})
	local t3 = {}
	local isLoadingMap = t1.isLoadingMap

	for v27, v28 in t1.tools do
		local kind = v28.kind
		local v30 = isLoadingMap ~= nil and isLoadingMap[kind] == true

		t3["Tool_" .. kind] = React.createElement(View, {
			tag = "row align-x-right align-y-center gap-medium auto-xy padding-xsmall radius-medium",
			LayoutOrder = v28.cta.order or v27,
			onActivated = not v30 and function() -- line: 73
				-- upvalues: t1 (copy), kind (copy)
				t1.onToolSelected(kind)
			end or nil
		}, {
			Icon = if not v30 then React.createElement(Icon, {
				LayoutOrder = 2,
				name = v28.cta.icon,
				size = Foundation.Enums.IconSize.Large
			}) else React.createElement(Loading, {
				LayoutOrder = 2,
				size = Foundation.Enums.IconSize.Small
			}),
			Text = if not t1.showText then nil else React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy text-label-medium content-emphasis",
				Text = v21[v28.cta.localizationKey]
			})
		})
	end

	return React.createElement(View, {
		tag = "position-center-right anchor-center-right size-0-full auto-x",
		ZIndex = t1.zIndex
	}, {
		GradientBackdrop = React.createElement(GradientBackdrop, {
			rotation = 180,
			color3 = v17.Color.Common.Scrim.Color3,
			size = v22
		}),
		EditCTABar = React.createElement(View, {
			tag = "col align-x-right align-y-center gap-small position-center-right anchor-center-right size-0-full auto-x",
			onAbsoluteSizeChanged = v24,
			padding = {
				left = UDim.new(0, v17.Padding.Large),
				right = UDim.new(0, v16.right + v17.Padding.Large)
			}
		}, t3)
	})
end
