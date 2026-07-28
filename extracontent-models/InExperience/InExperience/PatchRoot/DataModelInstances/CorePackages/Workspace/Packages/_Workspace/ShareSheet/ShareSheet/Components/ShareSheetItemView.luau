local Parent = script:FindFirstAncestor("ShareSheet").Parent
local Foundation = require(Parent.Foundation)
local Motion = require(Parent.Motion)
local React = require(Parent.React)
local UserTile = require(Parent.UserTile)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant
local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens
local UserTile2 = UserTile.UserTile
local LayoutMode = UserTile.LayoutMode

local function AnimatedIcon(t1: {[any]: any}) -- line: 27
	-- upvalues: useTokens (copy), usePreferences (copy), React (copy), Motion (copy), View (copy), Icon (copy), IconSize (copy)
	local v19 = useTokens()
	local reducedMotion = usePreferences().reducedMotion
	local v21 = React.useMemo(function() -- line: 30
		-- upvalues: Motion (copy), reducedMotion (copy), v19 (copy)
		return {
			compressed = Motion.createState({
				scale = 0.75
			}, {
				default = Motion.transition({
					duration = 0
				})
			}),
			rest = Motion.createState({
				scale = 1
			}, {
				default = Motion.transition({
					duration = if not reducedMotion then v19.Time.Time_300 else 0,
					easingStyle = v19.Ease.ExpressiveOut
				})
			})
		}
	end, {
		reducedMotion,
		v19
	})
	local v22, v23 = Motion.useMotion(v21.rest)

	React.useEffect(function() -- line: 49
		-- upvalues: t1 (copy), v23 (copy), v21 (copy)
		if not t1.shouldAnimate then
			return
		end

		v23(v21.compressed, {
			onAnimationComplete = function(p1) -- line: 55
				-- upvalues: v23 (copy), v21 (copy)
				if p1 == true then
					v23(v21.rest)
				end
			end
		})
	end, {
		v23,
		t1.shouldAnimate,
		v21
	})

	return React.createElement(View, {
		tag = "auto-xy",
		scale = v22.scale
	}, {
		Icon = React.createElement(Icon, {
			name = t1.icon,
			size = IconSize.Large
		})
	})
end
local function ShareSheetItemView(t2: {[any]: any}) -- line: 86
	-- upvalues: useTokens (copy), React (copy), View (copy), UserTile2 (copy), LayoutMode (copy), Icon (copy), IconName (copy), IconSize (copy), IconVariant (copy), AnimatedIcon (copy), FoundationText (copy)
	local v25 = useTokens()

	return React.createElement(View, {
		tag = "col align-x-center gap-small size-1700-0 auto-y",
		testId = "share-sheet-item-view",
		LayoutOrder = t2.LayoutOrder
	}, {
		Content = if not t2.primaryUserId then React.createElement(View, {
			tag = "align-x-center align-y-center size-full-1700 radius-circle bg-shift-300",
			LayoutOrder = 1,
			testId = "share-sheet-item",
			onActivated = t2.onActivated,
			selection = {
				Selectable = true
			}
		}, {
			IconContent = React.createElement(AnimatedIcon, {
				icon = t2.icon,
				shouldAnimate = t2.shouldAnimate
			})
		}) else React.createElement(View, {
			tag = "size-full-1700",
			LayoutOrder = 1,
			testId = not t2.secondUserId and "share-sheet-item-avatar" or "share-sheet-item-avatar-pile"
		}, {
			Tile = React.createElement(UserTile2, {
				selectable = true,
				userId = t2.primaryUserId,
				facePileSecondUserId = t2.secondUserId,
				layoutMode = LayoutMode.compact,
				userPresenceType = t2.userPresence,
				onActivated = t2.onActivated
			}),
			SelectionIndicator = if not t2.isSelected then nil else React.createElement(Icon, {
				ZIndex = 4,
				testId = "share-sheet-item-selection-indicator",
				name = IconName.CircleCheck,
				size = IconSize.Small,
				variant = IconVariant.Filled,
				style = v25.Color.System.Contrast,
				Position = UDim2.fromScale(0.8536, 0.1464),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})
		}),
		Label = React.createElement(FoundationText, {
			tag = "size-full-0 auto-y text-body-small text-align-x-center content-default",
			LayoutOrder = 2,
			Text = t2.label,
			TextTruncate = Enum.TextTruncate.AtEnd
		})
	})
end

return ShareSheetItemView
