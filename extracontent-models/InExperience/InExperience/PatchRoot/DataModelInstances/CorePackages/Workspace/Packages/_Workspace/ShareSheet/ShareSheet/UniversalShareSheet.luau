require(script.Parent.Stores.createUniversalShareSheetStore)
local GetUniversalShareSheetStore = require(script.Parent.Stores.GetUniversalShareSheetStore)
local RecipientSource = require(script.Parent.Recipients.RecipientSource)
local UniversalShareSheet = {}
UniversalShareSheet.RecipientSource = RecipientSource.RecipientSource

function UniversalShareSheet.show(p)
	GetUniversalShareSheetStore().show(p)
end

function UniversalShareSheet.hide()
	GetUniversalShareSheetStore().hide()
end

return UniversalShareSheet
