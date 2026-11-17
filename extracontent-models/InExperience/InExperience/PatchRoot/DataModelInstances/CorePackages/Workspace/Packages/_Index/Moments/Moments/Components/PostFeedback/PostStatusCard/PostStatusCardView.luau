local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Button = Foundation.Button
local FoundationProvider = Foundation.FoundationProvider
local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View

local ColorMode = Foundation.Enums.ColorMode
local FillBehavior = Foundation.Enums.FillBehavior
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize

local MomentMediaTile = MomentsCommon.Media.MomentMediaTile
local useTokens = Foundation.Hooks.useTokens

local Constants = require(Moments.Constants)

local function renderMedia(media, small: number)
	if media.kind == "thumbnail" then
		local clone = table.clone(media.mediaItem)
		clone.cornerRadius = small
		return React.createElement(
			View,
			{
				LayoutOrder = 1,
				tag = "size-1200-1200",
				testId = "moments-post-status-card-thumbnail"
			},
			{
				Tile = React.createElement(MomentMediaTile, { mediaItem = clone, isActive = false })
			}
		)
	else
		local v = media.kind == "momentsIcon"
		local createElement = React.createElement

		local createElement2 = React.createElement
		local name

		if v then
			name = BuilderIcons.Icon.Moments
		else
			name = BuilderIcons.Icon.ArrowSpinClockwiseDashed
		end

		return createElement(View, {
			LayoutOrder = 1,
			tag = "row align-x-center align-y-center size-1200-1200 radius-small bg-shift-200",
			testId = v and "moments-post-status-card-moments-icon" or "moments-post-status-card-unavailable"
		}, {
			Icon = createElement2(Icon, { name = name, size = IconSize.Large })
		})
	end
end

local function PostStatusCardView(props)
	local v = useTokens()

	local distance, v2 = React.useBinding(400)
	local v3 = React.useCallback(function(p)
		v2(p.AbsoluteSize.Y)
	end, {})
	local position

	if props.shown == nil then
		position = UDim2.new()
	else
		position = React.joinBindings({ shown = props.shown, distance = distance }):map(function(p)
			return UDim2.fromOffset(0, (p.shown - 1) * p.distance)
		end)
	end

	local children = {}

	for k, action in props.actions do
		children[`Action{k}`] = React.createElement(Button, {
			LayoutOrder = k,
			text = action.text,
			variant = action.variant,
			size = InputSize.Small,
			fillBehavior = FillBehavior.Fill,
			onActivated = action.onActivated,
			testId = `moments-post-status-card-action-{k}`
		})
	end

	local createElement = React.createElement
	local v4 = {
		tag = "position-top-center anchor-top-center size-full-0 auto-y",
		ZIndex = Constants.ZIndex.PostStatusCard
	}

	local createElement2 = React.createElement
	local v5 = {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = position,
		[React.Change.AbsoluteSize] = v3
	}

	local createElement3 = React.createElement
	local v6 = {
		tag = "col align-x-center size-full-0 auto-y",
		padding = {
			top = UDim.new(0, props.topInset),
			left = UDim.new(0, props.leftInset + v.Padding.XLarge),
			right = UDim.new(0, props.rightInset + v.Padding.XLarge)
		}
	}

	local createElement4 = React.createElement
	local v7 = { colorMode = ColorMode.Dark }

	local createElement5 = React.createElement
	local v8 = {
		tag = "row align-y-top gap-large size-full-0 auto-y padding-large radius-medium bg-surface-100",
		sizeConstraint = { MaxSize = Vector2.new(480, 1e999) },
		testId = "moments-post-status-card"
	}
	local media

	if props.media ~= nil then
		media = renderMedia(props.media, v.Radius.Small)
	end

	local createElement6 = React.createElement

	local v9 = {
		Title = React.createElement(Text, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-emphasis",
			Text = props.title
		}),
		Body = React.createElement(Text, {
			LayoutOrder = 2,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
			Text = props.body
		}),
		Actions = 0
	}
	local actions

	if #props.actions > 0 then
		actions = React.createElement(
			View,
			{ LayoutOrder = 3, tag = "row gap-small size-full-0 auto-y padding-top-medium" },
			children
		)
	end

	v9.Actions = actions
	return createElement(View, v4, {
		Slide = createElement2("Frame", v5, {
			Inset = createElement3(View, v6, {
				DarkScope = createElement4(FoundationProvider, v7, {
					Card = createElement5(View, v8, {
						Media = media,
						Content = createElement6(View, {
							LayoutOrder = 2,
							tag = "col grow gap-xxsmall auto-y"
						}, v9)
					})
				})
			})
		})
	})
end

return PostStatusCardView
