local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Players = game:GetService("Players")
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens

local function BuildEmptyState(t1: {[any]: any}) -- line: 25
	-- upvalues: useTokens (copy), Players (copy), React (copy), View (copy), Icon (copy), IconName (copy), FoundationText (copy)
	local v12 = useTokens()
	local Size_1400 = v12.Size.Size_1400
	local v14 = not Players.LocalPlayer and "" or Players.LocalPlayer.Name
	local v15 = React.useMemo(function() -- line: 30
		-- upvalues: v14 (copy)
		if v14 ~= "" then
			return `Hi, { v14 }`
		end

		return "Hi"
	end, { v14 })

	return React.createElement(View, {
		tag = "col align-x-center gap-small auto-xy",
		LayoutOrder = t1.LayoutOrder,
		testId = t1.testId or "BuildEmptyState"
	}, {
		Nebula = React.createElement(Icon, {
			LayoutOrder = 1,
			name = IconName.Nebula,
			size = Size_1400,
			style = v12.Color.Content.Emphasis
		}),
		Headings = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col align-x-center gap-xxsmall auto-xy"
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy text-heading-small content-emphasis",
				Text = v15
			}),
			Subline = React.createElement(FoundationText, {
				LayoutOrder = 2,
				Text = "What do you want to build today?",
				tag = "auto-xy text-body-medium content-default"
			})
		})
	})
end

return BuildEmptyState
