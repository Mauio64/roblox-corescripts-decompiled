local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Localization").Hooks.useLocalization
local dependencyArray = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/RoactUtils").Hooks.dependencyArray

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/React")
local chip = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Foundation").Chip
local filterStates = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Friends/filterStates")
local FriendsLandingContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingContext")
local FFlagDisableFriendsLandingFilterChipsWithNoFriends = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Flags/FFlagDisableFriendsLandingFilterChipsWithNoFriends")

local v5 = { filterStates.All, filterStates.Online, filterStates.Trusted }

local v6 = {
	[filterStates.All] = "all",
	[filterStates.Online] = "online",
	[filterStates.Trusted] = "trusted"
}

local v7 = { "allFriendsChip", "onlineFriendsChip", "trustedFriendsChip" }

function LUAUFORGE_MODULE_GLOBALS_efn_ChipFilterGroup(props)
	local filter = React.useContext(FriendsLandingContext.Context).filter
	local v8 = useLocalization({
		all = "Feature.Friends.Label.All",
		online = "Common.Presence.Label.Online",
		trusted = "Feature.Friends.TrustedConnection.Label.Trusted"
	})

	local useMemo = React.useMemo
	local function fn()
		local children = {}

		for i, v9 in ipairs(v5) do
			local v10 = v7[i]
			local createElement = React.createElement
			local v12 = {
				id = v9,
				text = v8[v6[v9]],
				LayoutOrder = i,
				onActivated = function()
					props.onActivated(v9)
				end,
				isChecked = filter == v9,
				isDisabled = 0
			}

			local v13 = if FFlagDisableFriendsLandingFilterChipsWithNoFriends then props.isDisabled else nil
			v12.isDisabled = v13
			children[v10] = createElement(chip, v12)
		end

		return children
	end
	local onActivated = props.onActivated
	local v10 = if FFlagDisableFriendsLandingFilterChipsWithNoFriends then props.isDisabled else nil
	local v11 = useMemo(fn, dependencyArray(v8, filter, onActivated, v10))

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
			allFriendsChip = v11.allFriendsChip,
			onlineFriendsChip = v11.onlineFriendsChip,
			trustedFriendsChip = v11.trustedFriendsChip
		}
	)
end

return LUAUFORGE_MODULE_GLOBALS_efn_ChipFilterGroup
