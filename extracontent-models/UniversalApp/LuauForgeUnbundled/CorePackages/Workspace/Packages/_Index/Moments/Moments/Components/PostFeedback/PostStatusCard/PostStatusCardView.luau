local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local button = Foundation.Button
local foundationProvider = Foundation.FoundationProvider
local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View

local colorMode = Foundation.Enums.ColorMode
local fillBehavior = Foundation.Enums.FillBehavior
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize

local momentMediaTile = MomentsCommon.Media.MomentMediaTile
local useTokens = Foundation.Hooks.useTokens

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")

local function renderMedia(media, small)
	if media.kind == "thumbnail" then
		local clone = table.clone(media.mediaItem)
		clone.cornerRadius = small
		return React.createElement(
			view,
			{
				LayoutOrder = 1,
				tag = "size-1200-1200",
				testId = "moments-post-status-card-thumbnail"
			},
			{
				Tile = React.createElement(momentMediaTile, {
					mediaItem = clone,
					isActive = false
				})
			}
		)
	else
		local v5 = media.kind == "momentsIcon"
		local createElement = React.createElement

		local createElement2 = React.createElement
		local v11 = if v5 then BuilderIcons.Icon.Moments else BuilderIcons.Icon.ArrowSpinClockwiseDashed
		return createElement(view, {
			LayoutOrder = 1,
			tag = "row align-x-center align-y-center size-1200-1200 radius-small bg-shift-200",
			testId = v5 and "moments-post-status-card-moments-icon" or "moments-post-status-card-unavailable"
		}, {
			Icon = createElement2(icon, { name = v11, size = iconSize.Large })
		})
	end
end

local function PostStatusCardView(props)
	local v5 = useTokens()

	local v6, v7 = React.useBinding(400)
	local v8 = React.useCallback(function(p2)
		v7(p2.AbsoluteSize.Y)
	end, {})
	local v9

	if props.shown == nil then
		v9 = UDim2.new()
	else
		v9 = React.joinBindings({ shown = props.shown, distance = v6 }):map(function(p2)
			return UDim2.fromOffset(0, (p2.shown - 1) * p2.distance)
		end)
	end

	local children = {}

	for k, action in props.actions do
		children[`Action{k}`] = React.createElement(button, {
			LayoutOrder = k,
			text = action.text,
			variant = action.variant,
			size = inputSize.Small,
			fillBehavior = fillBehavior.Fill,
			onActivated = action.onActivated,
			testId = `moments-post-status-card-action-{k}`
		})
	end

	local createElement = React.createElement
	local v11 = {
		tag = "position-top-center anchor-top-center size-full-0 auto-y",
		ZIndex = Constants.ZIndex.PostStatusCard
	}

	local createElement2 = React.createElement
	local v14 = {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = v9,
		[React.Change.AbsoluteSize] = v8
	}

	local createElement3 = React.createElement
	local v17 = {
		tag = "col align-x-center size-full-0 auto-y",
		padding = {
			top = UDim.new(0, props.topInset),
			left = UDim.new(0, props.leftInset + v5.Padding.XLarge),
			right = UDim.new(0, props.rightInset + v5.Padding.XLarge)
		}
	}

	local createElement4 = React.createElement
	local v20 = { colorMode = colorMode.Dark }

	local createElement5 = React.createElement
	local v23 = {
		tag = "row align-y-top gap-large size-full-0 auto-y padding-large radius-medium bg-surface-100",
		sizeConstraint = { MaxSize = Vector2.new(480, 1e999) },
		testId = "moments-post-status-card"
	}

	local v25 = if props.media ~= nil then renderMedia(props.media, v5.Radius.Small) else nil
	local createElement6 = React.createElement

	local v28 = {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-emphasis",
			Text = props.title
		}),
		Body = React.createElement(text, {
			LayoutOrder = 2,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
			Text = props.body
		}),
		Actions = 0
	}

	local v29 = if #props.actions > 0 then React.createElement(
		view,
		{ LayoutOrder = 3, tag = "row gap-small size-full-0 auto-y padding-top-medium" },
		children
	) else nil
	v28.Actions = v29
	return createElement(view, v11, {
		Slide = createElement2("Frame", v14, {
			Inset = createElement3(view, v17, {
				DarkScope = createElement4(foundationProvider, v20, {
					Card = createElement5(view, v23, {
						Media = v25,
						Content = createElement6(
							view,
							{ LayoutOrder = 2, tag = "col grow gap-xxsmall auto-y" },
							v28
						)
					})
				})
			})
		})
	})
end

return PostStatusCardView
