local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local isSideSheetEnabled = require(parent.InExperienceSideSheetUtils.isSideSheetEnabled)

local function requestOpenToRobuxTab()
	if isSideSheetEnabled then
		getInExperienceShopStore(false).setShouldOpenToRobuxTab(true)
	end
end

return requestOpenToRobuxTab
