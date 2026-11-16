local Components = {
	UserListHeader = require(script.UserListHeader),
	UserListFooter = require(script.UserListFooter),
	UserListLayoutAdaptor = require(script.UserListLayoutAdaptor),
	UserRow = 0,
	EntityRow = 0,
	VerticalUserList = 0,
	HorizontalUserList = 0
}

local UserRow = require(script.UserRow)
Components.UserRow = UserRow.UserRow
local UserRow2 = require(script.UserRow)
Components.EntityRow = UserRow2.EntityRow

Components.VerticalUserList = require(script.VerticalUserList)
Components.HorizontalUserList = require(script.HorizontalUserList)
return Components
