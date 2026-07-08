local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local ReactUtils = require(MomentsParent.ReactUtils)
local Foundation = require(MomentsParent.Foundation)
local getColorStyleWithTransparency = require(Moments.Utils.getColorStyleWithTransparency)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local function formatCount(n1: number?) -- line: 31
	if n1 == nil then
		return ""
	end

	if n1 >= 1000000 then
		return string.format("%.1fM", n1 / 1000000)
	end

	if n1 >= 1000 then
		return string.format("%.1fK", n1 / 1000)
	end

	return (tostring(n1))
end
local function RailItem(t1: {[any]: any}) -- line: 43
	-- upvalues: ReactUtils (copy), useTokens (copy), getColorStyleWithTransparency (copy), React (copy), View (copy), Icon (copy), IconSize (copy), FoundationText (copy), formatCount (copy)
	local count = t1.count
	local v17 = ReactUtils.createNextOrder()
	local v18 = useTokens()
	local v19 = t1.animationRatio:map(function(n2: number) -- line: 49
		-- upvalues: getColorStyleWithTransparency (copy), v18 (copy)
		return getColorStyleWithTransparency(v18.Color.Content.Emphasis, n2)
	end)

	return React.createElement(View, {
		tag = "col align-x-center align-y-center gap-xsmall size-1200-1200 radius-medium",
		LayoutOrder = t1.LayoutOrder,
		isDisabled = t1.isDisabled,
		onActivated = t1.onActivated,
		ref = t1.nativeRef
	}, {
		Slot = if type(t1.slot) ~= "string" then React.createElement(View, {
			tag = "auto-xy",
			Active = t1.isDisabled ~= false,
			LayoutOrder = v17()
		}, t1.slot) else React.createElement(Icon, {
			LayoutOrder = v17(),
			name = t1.slot,
			size = IconSize.Large,
			style = v19
		}),
		Count = if not count then nil else React.createElement(FoundationText, {
			tag = "auto-xy text-caption-large text-align-x-center content-emphasis",
			LayoutOrder = v17(),
			Text = count:map(formatCount),
			Visible = count:map(function(n3: number?) -- line: 78
				return n3 ~= nil
			end),
			textStyle = v19
		})
	})
end

return React.memo(RailItem)
