local parent = script.Parent.Parent
local SetCurrentPage = require(parent.Actions.SetCurrentPage)
local Pages = require(parent.Components.Pages)

return function(object)
	local state = object:getState()
	object:dispatch(SetCurrentPage(Pages.pagesByKey[state.menuPage].parentPage))
end
