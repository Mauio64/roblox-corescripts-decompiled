local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local Motion = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Motion")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local UserTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/UserTile")

local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local iconVariant = Foundation.Enums.IconVariant
local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens
local userTile = UserTile.UserTile
local layoutMode = UserTile.LayoutMode

local function AnimatedIcon(p2)
	local v5 = useTokens()
	local reducedMotion = usePreferences().reducedMotion
	local v6 = React.useMemo(function()
		return {
			compressed = Motion.createState({ scale = 0.75 }, {
				default = Motion.transition({ duration = 0 })
			}),
			rest = Motion.createState({ scale = 1 }, {
				default = Motion.transition({
					duration = reducedMotion and 0 or v5.Time.Time_300,
					easingStyle = v5.Ease.ExpressiveOut
				})
			})
		}
	end, { reducedMotion, v5 })
	local v7, v8 = Motion.useMotion(v6.rest)

	React.useEffect(function()
		if not p2.shouldAnimate then
			return
		end

		v8(v6.compressed, {
			onAnimationComplete = function(p3)
				if p3 == true then
					v8(v6.rest)
				end
			end
		})
	end, { v8, p2.shouldAnimate, v6 })

	return React.createElement(view, { scale = v7.scale, tag = "auto-xy" }, {
		Icon = React.createElement(icon, { name = p2.icon, size = iconSize.Large })
	})
end

local function ShareSheetItemView(props)
	local v5 = useTokens()

	local createElement = React.createElement
	local v7 = {
		tag = "col align-x-center gap-small size-1700-0 auto-y",
		LayoutOrder = props.LayoutOrder,
		testId = "share-sheet-item-view"
	}
	local v9

	if props.primaryUserId then
		local createElement2 = React.createElement
		local v11 = {
			tag = "size-full-1700",
			LayoutOrder = 1,
			testId = props.secondUserId and "share-sheet-item-avatar-pile" or "share-sheet-item-avatar"
		}
		local v12 = {
			Tile = React.createElement(userTile, {
				userId = props.primaryUserId,
				facePileSecondUserId = props.secondUserId,
				layoutMode = layoutMode.compact,
				userPresenceType = props.userPresence,
				onActivated = props.onActivated,
				selectable = true
			}),
			SelectionIndicator = 0
		}

		local v13 = if props.isSelected then React.createElement(icon, {
			name = iconName.CircleCheck,
			size = iconSize.Small,
			variant = iconVariant.Filled,
			style = v5.Color.System.Contrast,
			Position = UDim2.fromScale(0.8536, 0.1464),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ZIndex = 4,
			testId = "share-sheet-item-selection-indicator"
		}) else nil
		v12.SelectionIndicator = v13
		v9 = createElement2(view, v11, v12)
	else
		v9 = React.createElement(view, {
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

	return createElement(view, v7, {
		Content = v9,
		Label = React.createElement(text, {
			tag = "size-full-0 auto-y text-body-small text-align-x-center content-default",
			Text = props.label,
			TextTruncate = Enum.TextTruncate.AtEnd,
			LayoutOrder = 2
		})
	})
end

return ShareSheetItemView
