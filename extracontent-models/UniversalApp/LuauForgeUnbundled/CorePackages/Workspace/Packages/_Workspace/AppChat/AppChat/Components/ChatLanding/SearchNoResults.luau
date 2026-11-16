local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization

local view = Foundation.View
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function SearchNoResults(p2)
	local v5 = useLocalization({ noChatFound = "Feature.Chat.Label.NoChatFound" })

	local v6 = useTokens()
	local udim = UDim.new(0, v6.Padding.Large)

	return React.createElement(view, {
		tag = "col align-x-center align-y-center gap-small size-full",
		padding = {
			top = UDim.new(0, (p2.topPadding or 0) + v6.Padding.Large),
			bottom = udim,
			left = udim,
			right = udim
		}
	}, {
		SearchNoResultsMessage = React.createElement(text, {
			tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-center content-default",
			Text = v5.noChatFound
		})
	})
end

return SearchNoResults
