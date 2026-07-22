local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Players = game:GetService("Players")
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens

local function BuildEmptyState(t1: {[any]: any}) -- line: 24
	-- upvalues: useTokens (copy), Players (copy), React (copy), LocalizationStrings (copy), View (copy), Icon (copy), IconName (copy), FoundationText (copy)
	local v14 = useTokens()
	local Size_1400 = v14.Size.Size_1400
	local v16 = not Players.LocalPlayer and "" or Players.LocalPlayer.Name
	local v17 = React.useMemo(function() -- line: 29
		-- upvalues: LocalizationStrings (copy), v16 (copy)
		return LocalizationStrings.formatBuildGreeting(v16)
	end, { v16 })

	return React.createElement(View, {
		tag = "col align-x-center gap-small auto-xy",
		LayoutOrder = t1.LayoutOrder,
		testId = t1.testId or "BuildEmptyState"
	}, {
		Nebula = React.createElement(Icon, {
			LayoutOrder = 1,
			name = IconName.Nebula,
			size = Size_1400,
			style = v14.Color.Content.Emphasis
		}),
		Headings = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col align-x-center gap-xxsmall auto-xy"
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy text-heading-small content-emphasis",
				Text = v17
			}),
			Subline = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-xy text-body-medium content-default",
				Text = LocalizationStrings.BUILD_SUBLINE
			})
		})
	})
end

return BuildEmptyState
