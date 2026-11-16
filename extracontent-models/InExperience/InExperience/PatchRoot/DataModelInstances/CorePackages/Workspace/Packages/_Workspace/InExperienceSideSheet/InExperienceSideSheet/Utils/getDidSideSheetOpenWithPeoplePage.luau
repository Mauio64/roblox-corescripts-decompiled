local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local parent = InExperienceSideSheet.Parent

require(parent.Signals)

local GetSideSheetConfigStore = require(InExperienceSideSheet.Stores.GetSideSheetConfigStore)

return function(p)
	return GetSideSheetConfigStore(p).getDidSideSheetOpenWithPeoplePage(p)
end
