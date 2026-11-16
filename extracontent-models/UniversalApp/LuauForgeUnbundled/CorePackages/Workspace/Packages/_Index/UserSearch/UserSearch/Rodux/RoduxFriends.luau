local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Common/Constants").RODUX_KEY
return require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/FriendsRodux").config({
	keyPath = RODUX_KEY .. ".Friends"
})
