local Squads = script:FindFirstAncestor("Squads")
local dependencies = require(Squads.dependencies)
local React = dependencies.React
local Foundation = dependencies.Foundation
local useLocalization = dependencies.Hooks.useLocalization
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local SquadLobbyLuckyRecommendationModal = require(script.Parent.SquadLobbyLuckyRecommendationModal)

local function SquadLobbyLuckyRecommendationRow(_: {[any]: any}) -- line: 18
	-- upvalues: useTokens (copy), React (copy), useLocalization (copy), View (copy), FoundationText (copy), Icon (copy), IconSize (copy), SquadLobbyLuckyRecommendationModal (copy)
	local v14 = useTokens()
	local v15, v16 = React.useState(false)
	local v17 = useLocalization({
		title = "Feature.Squads.Label.LuckyRecommendationRow",
		body = "Feature.Squads.Description.LuckyRecommendationRow"
	})
	local v18 = React.useCallback(function() -- line: 26
		-- upvalues: v16 (copy)
		v16(true)
	end, {})
	local v19 = React.useCallback(function() -- line: 30
		-- upvalues: v16 (copy)
		v16(false)
	end, {})

	return React.createElement(React.Fragment, nil, {
		Row = React.createElement(View, {
			tag = "size-full-0 auto-y padding-x-xlarge"
		}, {
			Card = React.createElement(View, {
				tag = "row align-y-center gap-medium size-full-0 auto-y stroke-standard stroke-position-inner stroke-default radius-medium bg-surface-0 gui-object-defaults",
				padding = {
					left = UDim.new(0, v14.Padding.XLarge),
					right = UDim.new(0, v14.Padding.Medium),
					top = UDim.new(0, v14.Padding.Large),
					bottom = UDim.new(0, v14.Padding.Large)
				},
				onActivated = v18
			}, {
				Content = React.createElement(View, {
					tag = "col fill gap-xsmall auto-y",
					LayoutOrder = 1
				}, {
					Title = React.createElement(FoundationText, {
						tag = "size-full-0 auto-y text-title-medium text-no-wrap text-align-x-left text-truncate-end content-emphasis",
						LayoutOrder = 1,
						Text = v17.title
					}),
					Body = React.createElement(FoundationText, {
						tag = "size-full-0 auto-y text-body-medium text-no-wrap text-align-x-left text-truncate-end content-default",
						LayoutOrder = 2,
						Text = v17.body
					})
				}),
				Chevron = React.createElement(Icon, {
					LayoutOrder = 2,
					name = "chevron-large-right",
					size = IconSize.Small
				})
			})
		}),
		Modal = if not v15 then nil else React.createElement(SquadLobbyLuckyRecommendationModal, {
			onClose = v19
		})
	})
end

return SquadLobbyLuckyRecommendationRow
