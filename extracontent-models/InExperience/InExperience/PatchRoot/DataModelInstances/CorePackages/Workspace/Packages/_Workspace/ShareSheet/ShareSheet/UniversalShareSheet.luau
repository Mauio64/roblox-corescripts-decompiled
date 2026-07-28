require(script.Parent.Stores.createUniversalShareSheetStore)

local GetUniversalShareSheetStore = require(script.Parent.Stores.GetUniversalShareSheetStore)

return {
	show = function(p1) -- line: 10
		-- upvalues: GetUniversalShareSheetStore (copy)
		GetUniversalShareSheetStore().show(p1)
	end,
	hide = function() -- line: 14
		-- upvalues: GetUniversalShareSheetStore (copy)
		GetUniversalShareSheetStore().hide()
	end
}
