local Parent = script:FindFirstAncestor("CrossPlay").Parent
local CrossPlayCapabilities = require(Parent.UniversalAppPolicy).Enum.CrossPlayCapabilities
local t1 = {
	[CrossPlayCapabilities.CrossPlatform] = 185,
	[CrossPlayCapabilities.Multiplayer] = 254,
	[CrossPlayCapabilities.SharedContent] = 247
}
local t2 = {
	NO_ISSUE = "NoIssue",
	BANNED = "Banned",
	PURCHASE_REQUIRED = "PurchaseRequired",
	ERROR = "Error"
}

return {
	PrivilegeCodes = t1,
	PrivilegeCheckResults = t2
}
