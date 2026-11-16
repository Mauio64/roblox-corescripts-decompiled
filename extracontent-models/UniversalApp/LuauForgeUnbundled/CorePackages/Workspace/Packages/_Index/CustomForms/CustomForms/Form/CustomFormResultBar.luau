local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/Localization").Hooks.useLocalization
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/ReactOtter")

local v5 = { dampingRatio = 1, frequency = 2.5 }

local function CustomFormResultBar(props)
	local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion
	local v6 = Foundation.Hooks.useTokens()
	local v7 = useLocalization({
		caption = {
			"Feature.CustomForms.Label.Percent",
			number = props.percentage
		}
	})

	local v8, v9 = ReactOtter.useAnimatedBinding(0)
	local isSelected = props.isSelected == true

	React.useEffect(function()
		local v11 = if reducedMotion then ReactOtter.instant(props.percentage) else ReactOtter.spring(props.percentage, v5)
		v9(v11)
	end, { props.percentage, reducedMotion })

	local createElement = React.createElement
	local view = Foundation.View
	local v10 = {
		LayoutOrder = props.layoutOrder,
		tag = {
			["size-full-0 auto-y stroke-standard radius-medium clip"] = true,
			["stroke-emphasis"] = isSelected,
			["stroke-default"] = not isSelected
		},
		testId = props.testId
	}
	local v11 = {
		Fill = React.createElement(Foundation.View, {
			Size = v8:map(function(p2)
				return UDim2.fromScale(math.clamp(p2 / 100, 0, 1), 1)
			end),
			ZIndex = 1,
			tag = {
				["radius-medium"] = true,
				["bg-shift-300"] = isSelected,
				["bg-shift-200"] = not isSelected
			},
			testId = `{props.testId}--bar`
		}),
		Content = 0
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v13 = {
		Label = React.createElement(Foundation.Text, {
			Text = props.label,
			LayoutOrder = 1,
			tag = {
				["fill auto-y text-body-large text-wrap text-align-x-left content-emphasis"] = true
			}
		}),
		Check = 0,
		Caption = 0
	}
	local v14

	if isSelected and props.viewerUserId then
		v14 = React.createElement(Foundation.AvatarIcon, {
			userId = props.viewerUserId,
			size = Foundation.Enums.AvatarIconSize.Medium,
			backgroundStyle = v6.Color.Shift.Shift_400,
			LayoutOrder = 2,
			testId = `{props.testId}--selected`
		})
	elseif isSelected then
		v14 = React.createElement(Foundation.Icon, {
			name = Foundation.Enums.IconName.CircleCheck,
			size = Foundation.Enums.IconSize.Small,
			LayoutOrder = 2,
			testId = `{props.testId}--selected`
		})
	end

	v13.Check = v14

	v13.Caption = React.createElement(Foundation.Text, {
		Text = v7.caption,
		LayoutOrder = 3,
		testId = `{props.testId}--caption`,
		tag = {
			["auto-xy text-body-large text-align-x-right"] = true,
			["content-emphasis"] = isSelected,
			["content-default"] = not isSelected
		}
	})
	v11.Content = createElement2(
		view2,
		{
			ZIndex = 2,
			tag = "row align-y-center gap-small size-full-0 auto-y padding-x-medium padding-y-medium"
		},
		v13
	)
	return createElement(view, v10, v11)
end

return React.memo(CustomFormResultBar)
