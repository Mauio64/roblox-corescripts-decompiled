local module = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Rodux/installReducer")
local Deprecated = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Deprecated")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")

require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

return {
	RoduxKey = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Constants").RODUX_KEY,
	installReducer = module,
	Components = Deprecated.Components,
	Enums = module3,
	UserListHeader = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Components").UserListHeader,
	UserListFooter = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Components").UserListFooter,
	UserListLayoutAdaptor = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Components").UserListLayoutAdaptor,
	UserRow = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Components").UserRow,
	EntityRow = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Components").EntityRow,
	VerticalUserList = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Components").VerticalUserList,
	HorizontalUserList = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Components").HorizontalUserList,
	ContactsContext = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Context").ContactsContext
}
