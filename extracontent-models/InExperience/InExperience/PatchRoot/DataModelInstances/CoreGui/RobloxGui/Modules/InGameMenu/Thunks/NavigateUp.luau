local ParentParent = script.Parent.Parent
local SetCurrentPage = require(ParentParent.Actions.SetCurrentPage)
local Pages = require(ParentParent.Components.Pages)

return function(p1) -- line: 5
	-- upvalues: SetCurrentPage (copy), Pages (copy)
	local v5 = p1:getState()

	p1:dispatch(SetCurrentPage(Pages.pagesByKey[v5.menuPage].parentPage))
end
