local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")

local button = Foundation.Button
local BannerBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/Banner/BannerBadge")
local icon = Foundation.Icon
local iconButton = Foundation.IconButton
local view = Foundation.View
local text = Foundation.Text
local image = Foundation.Image

local v5 = {
	isContained = true,
	width = UDim.new(1, 0),
	tags = { container = "col auto-y" }
}

local function Banner(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = "col auto-y"

	if joined.isContained then
		v6 ..= " radius-medium padding-large stroke-standard stroke-default bg-shift-100"
	end

	local v7 = joined.badges and #joined.badges > 0
	local v8 = joined.buttons

	if v8 then
		v8 = #joined.buttons < 2 and not (joined.image or joined.body or v7 or joined.onDismiss)
	end

	local v9 = React.useMemo(function()
		local children = {}

		if joined.buttons and #joined.buttons > 0 then
			for k, button2 in joined.buttons do
				children["banner-button-" .. k] = React.createElement(button, Cryo.Dictionary.join({
					LayoutOrder = k + 1,
					size = Foundation.Enums.InputSize.Small,
					testId = "--banner-button-" .. k
				}, button2))
			end
		end

		return children
	end, { joined.buttons })

	local v10 = React.useMemo(function()
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

	local v11 = React.useMemo(function()
		if joined.onDismiss then
			return React.createElement(iconButton, {
				testId = v7 and "--banner-badges-dismiss" or "--banner-dismiss",
				LayoutOrder = v7 and 1 or 3,
				icon = Foundation.Enums.IconName.XSmall,
				isCircular = true,
				variant = Foundation.Enums.ButtonVariant.Utility,
				onActivated = joined.onDismiss
			})
		end

		return nil
	end, { joined.onDismiss, v7 })

	local createElement = React.createElement
	local v13 = {
		LayoutOrder = joined.LayoutOrder,
		Size = UDim2.new(joined.width.Scale, joined.width.Offset, 0, 0),
		testId = "--banner",
		tag = v6
	}
	local v15

	if v7 then
		local createElement2 = React.createElement

		local v18 = {
			Badges = React.createElement(
				view,
				{
					LayoutOrder = 1,
					testId = "--banner-badges",
					tag = "row auto-xy gap-small fill"
				},
				v10
			),
			Dismiss = 0
		}

		local v19 = if v11 then React.createElement(view, {
			tag = "auto-xy",
			LayoutOrder = 2
		}, {
			Dismiss = v11
		}) else nil
		v18.Dismiss = v19
		v15 = createElement2(
			view,
			{
				tag = "row auto-y size-full-0 flex-between gap-large align-y-center padding-bottom-large",
				LayoutOrder = 2
			},
			v18
		)
	end

	local createElement2 = React.createElement

	local v19 = if joined.icon and not joined.image then React.createElement(icon, {
		testId = "--banner-icon",
		LayoutOrder = 1,
		size = Foundation.Enums.IconSize.Large,
		name = joined.icon,
		variant = joined.iconVariant,
		style = joined.iconStyle
	}) else nil

	local v20 = if joined.image then React.createElement(
		view,
		{ tag = "auto-xy flex-none bg-shift-100 radius-medium" },
		{
			Image = React.createElement(image, {
				Image = joined.image,
				testId = "--banner-image",
				tag = "size-1800",
				ScaleType = Enum.ScaleType.Fit
			})
		}
	) else nil

	local createElement3 = React.createElement

	local v23 = {
		Title = React.createElement(text, {
			Text = joined.title,
			testId = "--banner-title",
			tag = "auto-xy text-title-medium content-emphasis fill text-wrap text-align-x-left",
			LayoutOrder = 1
		}),
		InlineButton = 0,
		Subcontent = 0
	}

	local v24 = if v8 and joined.buttons and joined.buttons[1] then React.createElement(
		button,
		Cryo.Dictionary.join(
			{
				tag = "auto-xy shrink",
				LayoutOrder = 2,
				testId = "--banner-button-inline"
			},
			joined.buttons[1]
		)
	) else nil
	v23.InlineButton = v24
	local v25

	if not v8 then
		local createElement4 = React.createElement

		local v29 = if joined.body then React.createElement(text, {
			testId = "--banner-body",
			Text = joined.body,
			tag = "auto-xy text-body-medium content-default text-wrap text-align-x-left",
			LayoutOrder = 1,
			RichText = true
		}) else nil
		v25 = createElement4(view, {
			tag = "auto-xy col gap-large shrink",
			LayoutOrder = 2
		}, {
			Body = v29,
			Buttons = React.createElement(
				view,
				{
					tag = "row auto-xy grow gap-small wrap",
					LayoutOrder = 2,
					testId = "--banner-buttons"
				},
				v9
			)
		})
	end

	v23.Subcontent = v25
	local v18 = {
		Icon = v19,
		Image = v20,
		Content = createElement3(view, {
			LayoutOrder = 2,
			tag = {
				["auto-xy gap-small align-x-left fill"] = true,
				["col flex-fill"] = not v8,
				["row align-y-center flex-between"] = v8
			}
		}, v23),
		Dismiss = 0
	}

	if v7 then
		v11 = nil
	end

	v18.Dismiss = v11
	return createElement(view, v13, {
		BadgesRow = v15,
		ContentRow = createElement2(view, {
			tag = {
				["row auto-y size-full-0 gap-large"] = true,
				["align-y-center"] = v8
			},
			LayoutOrder = 3
		}, v18)
	})
end

return React.memo(Banner)
