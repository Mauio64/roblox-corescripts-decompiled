local parent = script:FindFirstAncestor("CustomForms").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local ReactOtter = require(parent.ReactOtter)

local v = { dampingRatio = 1, frequency = 2.5 }

local function CustomFormResultBar(props)
	local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion
	local v2 = Foundation.Hooks.useTokens()
	local v3 = useLocalization({
		caption = {
			"Feature.CustomForms.Label.Percent",
			number = props.percentage
		}
	})

	local v4, v5 = ReactOtter.useAnimatedBinding(0)
	local isSelected = props.isSelected == true

	React.useEffect(function()
		local v6

		if reducedMotion then
			v6 = ReactOtter.instant(props.percentage)
		else
			v6 = ReactOtter.spring(props.percentage, v)
		end

		v5(v6)
	end, { props.percentage, reducedMotion })

	local createElement = React.createElement
	local view = Foundation.View
	local v6 = {
		LayoutOrder = props.layoutOrder,
		tag = {
			["size-full-0 auto-y stroke-standard radius-medium clip"] = true,
			["stroke-emphasis"] = isSelected,
			["stroke-default"] = not isSelected
		},
		testId = props.testId
	}
	local v7 = {
		Fill = React.createElement(Foundation.View, {
			Size = v4:map(function(p: number)
				return UDim2.fromScale(math.clamp(p / 100, 0, 1), 1)
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

	local v8 = {
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
	local check

	if isSelected and props.viewerUserId then
		check = React.createElement(Foundation.AvatarIcon, {
			userId = props.viewerUserId,
			size = Foundation.Enums.AvatarIconSize.Medium,
			backgroundStyle = v2.Color.Shift.Shift_400,
			LayoutOrder = 2,
			testId = `{props.testId}--selected`
		})
	elseif isSelected then
		check = React.createElement(Foundation.Icon, {
			name = Foundation.Enums.IconName.CircleCheck,
			size = Foundation.Enums.IconSize.Small,
			LayoutOrder = 2,
			testId = `{props.testId}--selected`
		})
	end

	v8.Check = check

	v8.Caption = React.createElement(Foundation.Text, {
		Text = v3.caption,
		LayoutOrder = 3,
		testId = `{props.testId}--caption`,
		tag = {
			["auto-xy text-body-large text-align-x-right"] = true,
			["content-emphasis"] = isSelected,
			["content-default"] = not isSelected
		}
	})
	v7.Content = createElement2(
		view2,
		{
			ZIndex = 2,
			tag = "row align-y-center gap-small size-full-0 auto-y padding-x-medium padding-y-medium"
		},
		v8
	)
	return createElement(view, v6, v7)
end

return React.memo(CustomFormResultBar)
