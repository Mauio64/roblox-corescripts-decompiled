local parent = script:FindFirstAncestor("AvatarWorkshop").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local Image = Foundation.Image
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local v = utf8.char(57344)

local function ItemCard(props)
	local v2 = useLocalization({ detailsText = "Feature.Avatar.Label.DetailsButton" })
	local text

	if props.username and props.hasVerifiedBadge then
		text = `{props.username}{v}`
	else
		text = props.username
	end

	local aspectRatio = props.vertical and 0.8 or 1

	local v3 = props.title ~= nil or text ~= nil or props.price ~= nil

	local createElement = React.createElement
	local view = Foundation.View
	local v4 = { tag = "size-full", LayoutOrder = props.LayoutOrder }

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v5 = {
		tag = "col gap-small size-full-0 auto-y",
		onActivated = props.onActivated,
		stateLayer = { affordance = StateLayerAffordance.None }
	}

	local createElement3 = React.createElement
	local v6 = {
		tag = {
			["size-full radius-medium clip bg-shift-200"] = true,
			["stroke-system-contrast"] = props.isSelected
		},
		aspectRatio = {
			AspectRatio = aspectRatio,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		},
		ScaleType = Enum.ScaleType.Crop,
		LayoutOrder = 1,
		Image = props.image
	}
	local detailsOverlay

	if props.showDetails then
		detailsOverlay = React.createElement(Foundation.View, { tag = "size-full padding-xxsmall" }, {
			DetailsButton = React.createElement(Foundation.Button, {
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.fromScale(0.5, 1),
				fillBehavior = FillBehavior.Fill,
				size = InputSize.XSmall,
				text = v2.detailsText,
				variant = ButtonVariant.OverMedia,
				onActivated = props.onDetailsActivated or function() end
			})
		})
	end

	local v7 = {
		Thumbnail = createElement3(Image, v6, { DetailsOverlay = detailsOverlay }),
		Content = 0
	}
	local content

	if v3 then
		local createElement4 = React.createElement
		local view3 = Foundation.View
		local title

		if props.title ~= nil then
			title = React.createElement(Foundation.Text, {
				tag = "size-full-0 auto-y text-title-small text-align-x-left text-truncate-end content-emphasis",
				Text = props.title,
				LayoutOrder = 1
			})
		end

		local username

		if text ~= nil then
			username = React.createElement(Foundation.Text, {
				tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end",
				Text = text,
				LayoutOrder = 2
			})
		end

		local price

		if props.price ~= nil then
			price = React.createElement(
				Foundation.View,
				{ tag = "row align-y-center gap-xxsmall size-full-0 auto-y", LayoutOrder = 3 },
				{
					Icon = React.createElement(Foundation.Icon, {
						tag = "content-emphasis",
						name = "robux",
						size = IconSize.Small,
						LayoutOrder = 1
					}),
					Amount = React.createElement(Foundation.Text, {
						tag = "auto-xy padding-x-xsmall text-body-medium text-align-x-left content-emphasis",
						Text = tostring(props.price),
						LayoutOrder = 2
					})
				}
			)
		end

		content = createElement4(view3, {
			tag = "col gap-xsmall size-full-0 auto-y",
			LayoutOrder = 2
		}, {
			Title = title,
			Username = username,
			Price = price
		})
	end

	v7.Content = content
	return createElement(view, v4, { Card = createElement2(view2, v5, v7) })
end

return ItemCard
