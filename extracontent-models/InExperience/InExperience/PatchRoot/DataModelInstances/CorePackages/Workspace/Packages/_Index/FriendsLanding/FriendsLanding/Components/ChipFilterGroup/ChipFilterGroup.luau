local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local parent = FriendsLanding.Parent
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RoactUtils = require(parent.RoactUtils)
local dependencyArray = RoactUtils.Hooks.dependencyArray

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Chip = Foundation.Chip
local filterStates = require(FriendsLanding.Friends.filterStates)
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local FFlagDisableFriendsLandingFilterChipsWithNoFriends = require(FriendsLanding.Flags.FFlagDisableFriendsLandingFilterChipsWithNoFriends)

local v = { filterStates.All, filterStates.Online, filterStates.Trusted }

local v2 = {
	[filterStates.All] = "all",
	[filterStates.Online] = "online",
	[filterStates.Trusted] = "trusted"
}

local v3 = { "allFriendsChip", "onlineFriendsChip", "trustedFriendsChip" }

function ChipFilterGroup(props)
	local filter = React.useContext(FriendsLandingContext.Context).filter
	local v4 = useLocalization({
		all = "Feature.Friends.Label.All",
		online = "Common.Presence.Label.Online",
		trusted = "Feature.Friends.TrustedConnection.Label.Trusted"
	})

	local useMemo = React.useMemo
	local function fn()
		local children = {}

		for i, id in ipairs(v) do
			local v5 = v3[i]
			local createElement = React.createElement
			local v6 = {
				id = id,
				text = v4[v2[id]],
				LayoutOrder = i,
				onActivated = function()
					props.onActivated(id)
				end,
				isChecked = filter == id,
				isDisabled = 0
			}
			local isDisabled

			if FFlagDisableFriendsLandingFilterChipsWithNoFriends then
				isDisabled = props.isDisabled
			end

			v6.isDisabled = isDisabled
			children[v5] = createElement(Chip, v6)
		end

		return children
	end
	local onActivated = props.onActivated
	local v5

	if FFlagDisableFriendsLandingFilterChipsWithNoFriends then
		v5 = props.isDisabled
	end

	local v6 = useMemo(fn, dependencyArray(v4, filter, onActivated, v5))

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, 32),
			LayoutOrder = props.layoutOrder,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		},
		{
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 8)
			}),
			allFriendsChip = v6.allFriendsChip,
			onlineFriendsChip = v6.onlineFriendsChip,
			trustedFriendsChip = v6.trustedFriendsChip
		}
	)
end

return ChipFilterGroup
