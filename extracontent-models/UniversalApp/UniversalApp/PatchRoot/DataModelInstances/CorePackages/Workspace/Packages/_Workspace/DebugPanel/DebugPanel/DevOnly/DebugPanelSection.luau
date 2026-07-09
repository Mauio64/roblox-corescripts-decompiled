local Parent = script:FindFirstAncestor("DebugPanel").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local function headerBgForDepth(color3: Color3, n1: number) -- line: 33
	local v14 = n1 * 4
	local v15 = math.min(255, math.floor(color3.R * 255 + 0.5) + v14)
	local v16 = math.min(255, math.floor(color3.G * 255 + 0.5) + v14)
	local v17 = math.min(255, math.floor(color3.B * 255 + 0.5) + v14)

	return Color3.fromRGB(v15, v16, v17)
end
local function DebugPanelSection(t1: {[any]: any}) -- line: 49
	-- upvalues: useTokens (copy), React (copy), headerBgForDepth (copy), View (copy), Icon (copy), IconName (copy), IconSize (copy), FoundationText (copy)
	local v19 = useTokens()
	local v20, v21 = React.useState(t1.defaultCollapsed == true)
	local v22 = t1.depth or 0
	local v23 = v22 == 0
	local v24 = React.useCallback(function() -- line: 55
		-- upvalues: v21 (copy)
		v21(function(p1) -- line: 56
			return not p1
		end)
	end, {})
	local v25 = headerBgForDepth(v19.Color.Surface.Surface_300.Color3, v22)

	return React.createElement(View, {
		tag = "col size-full-0 auto-y gap-small",
		LayoutOrder = t1.layoutOrder
	}, {
		Header = React.createElement(View, {
			tag = "row size-full-700 align-y-center gap-xsmall radius-small padding-x-xsmall clip",
			LayoutOrder = 0,
			backgroundStyle = {
				Color3 = v25,
				Transparency = not v23 and 0.5 or 0.2
			},
			onActivated = v24,
			stateLayer = {}
		}, {
			Chevron = React.createElement(Icon, {
				tag = "content-muted",
				LayoutOrder = 0,
				name = if not v20 then IconName.ChevronSmallDown else IconName.ChevronSmallRight,
				size = IconSize.Small
			}),
			Title = React.createElement(FoundationText, {
				tag = "size-full text-label-small text-align-x-left content-emphasis",
				LayoutOrder = 1,
				Text = t1.title
			})
		}),
		Body = React.createElement(View, {
			tag = "col size-full-0 auto-y gap-small padding-left-medium",
			LayoutOrder = 1,
			Visible = not v20
		}, t1.children)
	})
end

return DebugPanelSection
