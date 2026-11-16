local parent = script:FindFirstAncestor("ShareSheet").Parent

local Foundation = require(parent.Foundation)
local Motion = require(parent.Motion)
local React = require(parent.React)
local UserTile = require(parent.UserTile)

local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant
local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens
local userTile = UserTile.UserTile
local LayoutMode = UserTile.LayoutMode

local function AnimatedIcon(p)
	local v = useTokens()
	local reducedMotion = usePreferences().reducedMotion
	local v2 = React.useMemo(function()
		return {
			compressed = Motion.createState({ scale = 0.75 }, {
				default = Motion.transition({ duration = 0 })
			}),
			rest = Motion.createState({ scale = 1 }, {
				default = Motion.transition({
					duration = reducedMotion and 0 or v.Time.Time_300,
					easingStyle = v.Ease.ExpressiveOut
				})
			})
		}
	end, { reducedMotion, v })
	local v3, v4 = Motion.useMotion(v2.rest)

	React.useEffect(function()
		if not p.shouldAnimate then
			return
		end

		v4(v2.compressed, {
			onAnimationComplete = function(p2)
				if p2 == true then
					v4(v2.rest)
				end
			end
		})
	end, { v4, p.shouldAnimate, v2 })

	return React.createElement(View, { scale = v3.scale, tag = "auto-xy" }, {
		Icon = React.createElement(Icon, { name = p.icon, size = IconSize.Large })
	})
end

local function ShareSheetItemView(props)
	local v = useTokens()

	local createElement = React.createElement
	local v2 = {
		tag = "col align-x-center gap-small size-1700-0 auto-y",
		LayoutOrder = props.LayoutOrder,
		testId = "share-sheet-item-view"
	}
	local content

	if props.primaryUserId then
		local createElement2 = React.createElement
		local v3 = {
			tag = "size-full-1700",
			LayoutOrder = 1,
			testId = props.secondUserId and "share-sheet-item-avatar-pile" or "share-sheet-item-avatar"
		}
		local v4 = {
			Tile = React.createElement(userTile, {
				userId = props.primaryUserId,
				facePileSecondUserId = props.secondUserId,
				layoutMode = LayoutMode.compact,
				userPresenceType = props.userPresence,
				onActivated = props.onActivated,
				selectable = true
			}),
			SelectionIndicator = 0
		}
		local selectionIndicator

		if props.isSelected then
			selectionIndicator = React.createElement(Icon, {
				name = IconName.CircleCheck,
				size = IconSize.Small,
				variant = IconVariant.Filled,
				style = v.Color.System.Contrast,
				Position = UDim2.fromScale(0.8536, 0.1464),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ZIndex = 4,
				testId = "share-sheet-item-selection-indicator"
			})
		end

		v4.SelectionIndicator = selectionIndicator
		content = createElement2(View, v3, v4)
	else
		content = React.createElement(View, {
			tag = "align-x-center align-y-center size-full-1700 radius-circle bg-shift-300",
			LayoutOrder = 1,
			testId = "share-sheet-item",
			onActivated = props.onActivated,
			selection = { Selectable = true }
		}, {
			IconContent = React.createElement(AnimatedIcon, {
				icon = props.icon,
				shouldAnimate = props.shouldAnimate
			})
		})
	end

	return createElement(View, v2, {
		Content = content,
		Label = React.createElement(Text, {
			tag = "size-full-0 auto-y text-body-small text-align-x-center content-default",
			Text = props.label,
			TextTruncate = Enum.TextTruncate.AtEnd,
			LayoutOrder = 2
		})
	})
end

return ShareSheetItemView
