require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Stores/createUniversalShareSheetStore")
local GetUniversalShareSheetStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Stores/GetUniversalShareSheetStore")
return {
	RecipientSource = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/RecipientSource").RecipientSource,
	show = function(p2)
		GetUniversalShareSheetStore().show(p2)
	end,
	hide = function()
		GetUniversalShareSheetStore().hide()
	end
}
