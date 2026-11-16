local parent = script:FindFirstAncestor("AppBlox").Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Button = Foundation.Button
local BannerBadge = require(script.Parent.BannerBadge)
local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image

local v = {
	isContained = true,
	width = UDim.new(1, 0),
	tags = { container = "col auto-y" }
}

local function Banner(p)
	local joined = Cryo.Dictionary.join(v, p)
	local tag = "col auto-y"

	if joined.isContained then
		tag ..= " radius-medium padding-large stroke-standard stroke-default bg-shift-100"
	end

	local v2 = joined.badges and #joined.badges > 0
	local v3 = joined.buttons

	if v3 then
		if #joined.buttons < 2 then
			v3 = not (joined.image or joined.body or v2 or joined.onDismiss)
		else
			v3 = false
		end
	end

	local v4 = React.useMemo(function()
		local children = {}

		if joined.buttons and #joined.buttons > 0 then
			for k, button in joined.buttons do
				children["banner-button-" .. k] = React.createElement(Button, Cryo.Dictionary.join({
					LayoutOrder = k + 1,
					size = Foundation.Enums.InputSize.Small,
					testId = "--banner-button-" .. k
				}, button))
			end
		end

		return children
	end, { joined.buttons })

	local v5 = React.useMemo(function()
		local children = {}

		if joined.badges then
			for i, badge in ipairs(joined.badges) do
				children["banner-badge-" .. i] = React.createElement(BannerBadge, Cryo.Dictionary.join({
					testId = "--banner-badge-" .. i,
					LayoutOrder = i + 1
				}, badge))
			end
		end

		return children
	end, { joined.badges })

	local dismiss = React.useMemo(function()
		if joined.onDismiss then
			return (React.createElement(IconButton, {
				testId = v2 and "--banner-badges-dismiss" or "--banner-dismiss",
				LayoutOrder = v2 and 1 or 3,
				icon = Foundation.Enums.IconName.XSmall,
				isCircular = true,
				variant = Foundation.Enums.ButtonVariant.Utility,
				onActivated = joined.onDismiss
			}))
		end

		return nil
	end, { joined.onDismiss, v2 })

	local createElement = React.createElement
	local v6 = {
		LayoutOrder = joined.LayoutOrder,
		Size = UDim2.new(joined.width.Scale, joined.width.Offset, 0, 0),
		testId = "--banner",
		tag = tag
	}
	local badgesRow

	if v2 then
		local createElement2 = React.createElement

		local v7 = {
			Badges = React.createElement(
				View,
				{ LayoutOrder = 1, testId = "--banner-badges", tag = "row auto-xy gap-small fill" },
				v5
			),
			Dismiss = 0
		}
		local dismiss2

		if dismiss then
			dismiss2 = React.createElement(View, { tag = "auto-xy", LayoutOrder = 2 }, {
				Dismiss = dismiss
			})
		end

		v7.Dismiss = dismiss2
		badgesRow = createElement2(
			View,
			{
				tag = "row auto-y size-full-0 flex-between gap-large align-y-center padding-bottom-large",
				LayoutOrder = 2
			},
			v7
		)
	end

	local createElement2 = React.createElement
	local icon

	if joined.icon and not joined.image then
		icon = React.createElement(Icon, {
			testId = "--banner-icon",
			LayoutOrder = 1,
			size = Foundation.Enums.IconSize.Large,
			name = joined.icon,
			variant = joined.iconVariant,
			style = joined.iconStyle
		})
	end

	local image

	if joined.image then
		image = React.createElement(View, { tag = "auto-xy flex-none bg-shift-100 radius-medium" }, {
			Image = React.createElement(Image, {
				Image = joined.image,
				testId = "--banner-image",
				tag = "size-1800",
				ScaleType = Enum.ScaleType.Fit
			})
		})
	end

	local createElement3 = React.createElement

	local v7 = {
		Title = React.createElement(Text, {
			Text = joined.title,
			testId = "--banner-title",
			tag = "auto-xy text-title-medium content-emphasis fill text-wrap text-align-x-left",
			LayoutOrder = 1
		}),
		InlineButton = 0,
		Subcontent = 0
	}
	local inlineButton

	if v3 and joined.buttons and joined.buttons[1] then
		inlineButton = React.createElement(
			Button,
			Cryo.Dictionary.join(
				{ tag = "auto-xy shrink", LayoutOrder = 2, testId = "--banner-button-inline" },
				joined.buttons[1]
			)
		)
	end

	v7.InlineButton = inlineButton
	local subcontent

	if not v3 then
		local createElement4 = React.createElement
		local body

		if joined.body then
			body = React.createElement(Text, {
				testId = "--banner-body",
				Text = joined.body,
				tag = "auto-xy text-body-medium content-default text-wrap text-align-x-left",
				LayoutOrder = 1,
				RichText = true
			})
		end

		subcontent = createElement4(View, { tag = "auto-xy col gap-large shrink", LayoutOrder = 2 }, {
			Body = body,
			Buttons = React.createElement(
				View,
				{
					tag = "row auto-xy grow gap-small wrap",
					LayoutOrder = 2,
					testId = "--banner-buttons"
				},
				v4
			)
		})
	end

	v7.Subcontent = subcontent
	local v8 = {
		Icon = icon,
		Image = image,
		Content = createElement3(View, {
			LayoutOrder = 2,
			tag = {
				["auto-xy gap-small align-x-left fill"] = true,
				["col flex-fill"] = not v3,
				["row align-y-center flex-between"] = v3
			}
		}, v7),
		Dismiss = 0
	}

	if v2 then
		dismiss = nil
	end

	v8.Dismiss = dismiss
	return createElement(View, v6, {
		BadgesRow = badgesRow,
		ContentRow = createElement2(View, {
			tag = { ["row auto-y size-full-0 gap-large"] = true, ["align-y-center"] = v3 },
			LayoutOrder = 3
		}, v8)
	})
end

return React.memo(Banner)
