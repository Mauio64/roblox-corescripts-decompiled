local installReducer = require(script.Rodux.installReducer)
local Deprecated = require(script.Deprecated)
local Enums = require(script.Common.Enums)

require(script.Common.Types)

local UserList = {
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = script["jest.config"]
}
local Constants = require(script.Common.Constants)
UserList.RoduxKey = Constants.RODUX_KEY
UserList.installReducer = installReducer
UserList.Components = Deprecated.Components

UserList.Enums = Enums

local Components = require(script.Components)
UserList.UserListHeader = Components.UserListHeader
local Components2 = require(script.Components)
UserList.UserListFooter = Components2.UserListFooter

local Components3 = require(script.Components)
UserList.UserListLayoutAdaptor = Components3.UserListLayoutAdaptor

local Components4 = require(script.Components)
UserList.UserRow = Components4.UserRow
local Components5 = require(script.Components)
UserList.EntityRow = Components5.EntityRow

local Components6 = require(script.Components)
UserList.VerticalUserList = Components6.VerticalUserList
local Components7 = require(script.Components)
UserList.HorizontalUserList = Components7.HorizontalUserList

local Context = require(script.Context)
UserList.ContactsContext = Context.ContactsContext
return UserList
