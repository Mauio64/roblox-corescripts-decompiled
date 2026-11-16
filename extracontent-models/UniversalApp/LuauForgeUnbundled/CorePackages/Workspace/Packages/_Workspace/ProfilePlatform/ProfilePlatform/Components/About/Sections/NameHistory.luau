local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local text = Foundation.Text
local view = Foundation.View
local useLocalization = Localization.Hooks.useLocalization

local function NameHistory(p2)
	local v5 = useLocalization({
		previousNames = TextKeys.PreviousNames,
		noPreviousName = TextKeys.NoPreviousName
	})
	local v6

	if p2.nameHistory and #p2.nameHistory ~= 0 then
		v6 = table.concat(p2.nameHistory, ", ")
	else
		v6 = v5.noPreviousName
	end

	return React.createElement(
		view,
		{
			LayoutOrder = p2.layoutOrder,
			tag = "col size-full-0 auto-y gap-small align-x-left"
		},
		{
			Title = React.createElement(text, {
				LayoutOrder = 1,
				tag = "auto-y size-full-0 text-align-x-left text-heading-small",
				Text = v5.previousNames
			}),
			Content = React.createElement(text, {
				LayoutOrder = 2,
				tag = "auto-y size-full-0 text-align-x-left text-body-medium text-wrap",
				Text = v6,
				RichText = true
			})
		}
	)
end

return NameHistory
