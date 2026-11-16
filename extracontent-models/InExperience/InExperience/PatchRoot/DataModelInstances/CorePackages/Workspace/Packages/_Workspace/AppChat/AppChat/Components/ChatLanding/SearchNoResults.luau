local parent = script:FindFirstAncestor("AppChat").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local View = Foundation.View
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function SearchNoResults(p)
	local v = useLocalization({ noChatFound = "Feature.Chat.Label.NoChatFound" })

	local v2 = useTokens()
	local udim = UDim.new(0, v2.Padding.Large)

	return React.createElement(View, {
		tag = "col align-x-center align-y-center gap-small size-full",
		padding = {
			top = UDim.new(0, (p.topPadding or 0) + v2.Padding.Large),
			bottom = udim,
			left = udim,
			right = udim
		}
	}, {
		SearchNoResultsMessage = React.createElement(Text, {
			tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-center content-default",
			Text = v.noChatFound
		})
	})
end

return SearchNoResults
