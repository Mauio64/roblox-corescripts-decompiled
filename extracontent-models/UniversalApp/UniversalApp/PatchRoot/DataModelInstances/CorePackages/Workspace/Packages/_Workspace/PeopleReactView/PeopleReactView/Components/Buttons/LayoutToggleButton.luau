local Parent = script:FindFirstAncestor("PeopleReactView").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local Icon = Foundation.Icon
local View = Foundation.View
local GameSettings = UserSettings().GameSettings

local function LayoutToggleButton(t1: {[any]: any}) -- line: 20
	-- upvalues: React (copy), GameSettings (copy), View (copy), Icon (copy), IconName (copy), InputSize (copy)
	local v11 = React.useCallback(function(p1) -- line: 21
		-- upvalues: GameSettings (copy), t1 (copy)
		return function() -- line: 22
			-- upvalues: GameSettings (copy), p1 (copy), t1 (copy)
			GameSettings.PeoplePageLayout = p1
			t1.setLayout(p1)
		end
	end, {})

	return React.createElement(View, {
		tag = "row auto-xy bg-shift-100 radius-medium gap-xxsmall padding-xsmall",
		LayoutOrder = t1.LayoutOrder
	}, {
		CardLayoutButton = React.createElement(View, {
			LayoutOrder = 1,
			tag = {
				["row align-x-center align-y-center size-1000-1000 radius-medium"] = true,
				["bg-shift-300"] = t1.layout == Enum.PeoplePageLayout.Card
			},
			onActivated = v11(Enum.PeoplePageLayout.Card)
		}, {
			Icon = React.createElement(Icon, {
				name = IconName.Grid,
				size = InputSize.Medium
			})
		}),
		ListLayoutButton = React.createElement(View, {
			LayoutOrder = 2,
			tag = {
				["row align-x-center align-y-center size-1000-1000 radius-medium"] = true,
				["bg-shift-300"] = t1.layout == Enum.PeoplePageLayout.List
			},
			onActivated = v11(Enum.PeoplePageLayout.List)
		}, {
			Icon = React.createElement(Icon, {
				name = IconName.ListBulleted,
				size = InputSize.Medium
			})
		})
	})
end

return React.memo(LayoutToggleButton)
