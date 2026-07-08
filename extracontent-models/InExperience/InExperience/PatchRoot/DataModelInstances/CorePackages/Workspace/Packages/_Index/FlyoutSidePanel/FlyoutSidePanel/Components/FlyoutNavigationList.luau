local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local FlyoutNavigationItem = require(script.Parent.FlyoutNavigationItem)

local function FlyoutNavigationList(t1: {[any]: any}) -- line: 16
	-- upvalues: useTokens (copy), React (copy), FlyoutNavigationItem (copy)
	local v7 = useTokens()
	local v8 = React.useMemo(function() -- line: 18
		-- upvalues: React (copy), v7 (copy), t1 (copy), FlyoutNavigationItem (copy)
		local t2 = {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v7.Gap.Small)
			})
		}

		for i, v in ipairs(t1.navigationItems) do
			if v and v.textKey then
				t2[v.itemType] = React.createElement(FlyoutNavigationItem, {
					item = v,
					layoutOrder = i,
					closeDrawer = t1.closeDrawer,
					buildCreatorWebNavUrl = t1.buildCreatorWebNavUrl
				})
			end
		end

		return t2
	end, {
		t1.navigationItems,
		t1.buildCreatorWebNavUrl,
		t1.closeDrawer,
		v7.Gap.Small
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.layoutOrder
	}, v8)
end

return FlyoutNavigationList
