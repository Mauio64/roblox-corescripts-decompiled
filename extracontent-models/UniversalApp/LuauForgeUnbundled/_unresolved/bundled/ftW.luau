local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useRouteName = require("@game/CorePackages/Workspace/Packages/Navigation").useRouteName

local module = require("@luauforge/bundled/foz")
local module2 = require("@luauforge/bundled/ftX")
local module3 = require("@luauforge/bundled/eeH")

local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images
local utilityActionIcon = UIBlox.App.Button.UtilityActionIcon

local iconsactionsfriendsfriendAdd = images["icons/actions/friends/friendAdd"]

return function(props)
	local v5 = useDispatch()
	local v6 = useRouteName()
	local v7 = module3(module)

	local function onActivated()
		if props.isSearching then
			return
		end

		v5(module2())
		v7.reportAddFriendsButtonClick(v6)
	end

	React.useEffect(function()
		local v8 = not props.isSearching

		props.setVisible(v8)
	end, { props.isSearching, props.setVisible })

	return React.createElement(utilityActionIcon, {
		icon = iconsactionsfriendsfriendAdd,
		onActivated = onActivated,
		ref = props.buttonRef
	})
end
