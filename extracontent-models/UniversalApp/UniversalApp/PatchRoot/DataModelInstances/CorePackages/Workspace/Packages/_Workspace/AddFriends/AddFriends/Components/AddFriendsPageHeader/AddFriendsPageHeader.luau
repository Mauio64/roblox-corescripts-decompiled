local Parent = script:FindFirstAncestor("AddFriends").Parent
local React = require(Parent.React)
local useNavigation = require(Parent.Navigation).useNavigation
local HeaderBar = require(Parent.UIBlox).App.Bar.HeaderBar
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local AppHeaderBar = require(Parent.AppHeaderBar)
local FFlagConnectionsToFriendsRename = require(Parent.SharedFlags).FFlagConnectionsToFriendsRename
local FFlagAFPConnectionsChannelsHeader = require(Parent.SharedFlags).FFlagAFPConnectionsChannelsHeader

local function AddFriendsPageHeader(t1: {[any]: any}) -- line: 24
	-- upvalues: useLocalization (copy), FFlagConnectionsToFriendsRename (copy), useNavigation (copy), React (copy), AppHeaderBar (copy), FFlagAFPConnectionsChannelsHeader (copy), HeaderBar (copy)
	local topBarHeight = t1.topBarHeight
	local v12 = useLocalization({
		titleText = not FFlagConnectionsToFriendsRename and "CommonUI.Features.Label.AddConnections" or "Feature.Friends.Feature.Friends.Heading.AddFriends"
	})
	local v13 = useNavigation()
	local v14 = React.useMemo(function() -- line: 35
		-- upvalues: AppHeaderBar (copy), v13 (copy)
		return AppHeaderBar.makeBackButton(function() -- line: 36
			-- upvalues: v13 (copy)
			v13.pop()
		end)
	end, { v13 })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Size = UDim2.new(1, 0, 0, topBarHeight),
		LayoutOrder = not FFlagAFPConnectionsChannelsHeader and -1 or (t1.layoutOrder or -1)
	}, {
		headerBar = React.createElement(HeaderBar, {
			isSecondary = true,
			title = v12.titleText,
			barHeight = topBarHeight,
			renderLeft = v14,
			paddingTop = UDim.new(0, 0),
			paddingBottom = UDim.new(0, 0)
		})
	})
end

return AddFriendsPageHeader
