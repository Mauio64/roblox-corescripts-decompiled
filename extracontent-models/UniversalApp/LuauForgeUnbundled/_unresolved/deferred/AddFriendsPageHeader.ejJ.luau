local module = require("@luauforge/deferred/eil")

local useNavigation = require("@luauforge/deferred/ein").useNavigation

local headerBar = require("@luauforge/deferred/eiT").App.Bar.HeaderBar

local useLocalization = require("@luauforge/deferred/ejG").Hooks.useLocalization

local module2 = require("@luauforge/deferred/ejK")

local fFlagAFPConnectionsChannelsHeader = require("@luauforge/deferred/eiz").FFlagAFPConnectionsChannelsHeader

local function AddFriendsPageHeader(p2)
	local topBarHeight = p2.topBarHeight

	local v5 = useLocalization({
		titleText = "Feature.Friends.Feature.Friends.Heading.AddFriends"
	})

	local v6 = useNavigation()

	local v7 = module.useMemo(function()
		return module2.makeBackButton(function()
			v6.pop()
		end)
	end, { v6 })

	return module.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, topBarHeight),
		LayoutOrder = fFlagAFPConnectionsChannelsHeader and p2.layoutOrder or -1,
		ZIndex = 2
	}, {
		headerBar = module.createElement(headerBar, {
			title = v5.titleText,
			barHeight = topBarHeight,
			renderLeft = v7,
			isSecondary = true,
			paddingTop = UDim.new(0, 0),
			paddingBottom = UDim.new(0, 0)
		})
	})
end

return AddFriendsPageHeader
