local crossPlayCapabilities = require("@luauforge/bundled/hIc").Enum.CrossPlayCapabilities

return {
	PrivilegeCodes = {
		[crossPlayCapabilities.CrossPlatform] = 185,
		[crossPlayCapabilities.Multiplayer] = 254,
		[crossPlayCapabilities.SharedContent] = 247
	},
	PrivilegeCheckResults = {
		NO_ISSUE = "NoIssue",
		BANNED = "Banned",
		PURCHASE_REQUIRED = "PurchaseRequired",
		ERROR = "Error"
	}
}
