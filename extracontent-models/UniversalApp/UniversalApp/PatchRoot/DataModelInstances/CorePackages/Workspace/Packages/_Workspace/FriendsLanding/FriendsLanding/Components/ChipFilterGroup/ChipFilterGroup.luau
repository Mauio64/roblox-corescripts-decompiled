local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local FriendsLandingParent = FriendsLanding.Parent
local useLocalization = require(FriendsLandingParent.Localization).Hooks.useLocalization
local dependencyArray = require(FriendsLandingParent.RoactUtils).Hooks.dependencyArray
local React = require(FriendsLandingParent.React)
local Chip = require(FriendsLandingParent.Foundation).Chip
local filterStates = require(FriendsLanding.Friends.filterStates)
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local t1 = {
	filterStates.All,
	filterStates.Online,
	filterStates.Trusted
}
local t2 = {
	[filterStates.All] = "all",
	[filterStates.Online] = "online",
	[filterStates.Trusted] = "trusted"
}
local t3 = {
	"allFriendsChip",
	"onlineFriendsChip",
	"trustedFriendsChip"
}

function ChipFilterGroup(t4: {[any]: any}) -- line: 34
	-- upvalues: React (copy), FriendsLandingContext (copy), useLocalization (copy), t1 (copy), t3 (copy), Chip (copy), t2 (copy), dependencyArray (copy)
	local filter = React.useContext(FriendsLandingContext.Context).filter
	local v14 = useLocalization({
		all = "Feature.Friends.Label.All",
		online = "Common.Presence.Label.Online",
		trusted = "Feature.Friends.TrustedConnection.Label.Trusted"
	})
	local v15 = React.useMemo(function() -- line: 43
		-- upvalues: t1 (copy), t3 (copy), React (copy), Chip (copy), v14 (copy), t2 (copy), t4 (copy), filter (copy)
		local t5 = {}

		for i, v in ipairs(t1) do
			t5[t3[i]] = React.createElement(Chip, {
				id = v,
				text = v14[t2[v]],
				LayoutOrder = i,
				onActivated = function() -- line: 50
					-- upvalues: t4 (copy), v (copy)
					t4.onActivated(v)
				end,
				isChecked = v == filter
			})
		end

		return t5
	end, dependencyArray(v14, filter, t4.onActivated))

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 32),
		LayoutOrder = t4.layoutOrder
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8)
		}),
		allFriendsChip = v15.allFriendsChip,
		onlineFriendsChip = v15.onlineFriendsChip,
		trustedFriendsChip = v15.trustedFriendsChip
	})
end

return ChipFilterGroup
