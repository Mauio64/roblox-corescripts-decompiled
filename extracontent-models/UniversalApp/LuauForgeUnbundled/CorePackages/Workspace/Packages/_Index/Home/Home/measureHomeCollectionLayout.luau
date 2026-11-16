local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/CollectionViews")
local buildSduiCollectionInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SduiSharedUtilities").buildSduiCollectionInfo
local fFlagSduiPreferredTextSizeLineBudgets = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SharedFlags").FFlagSduiPreferredTextSizeLineBudgets

local udim = UDim.new(1, 72)

local function measureHomeCollectionLayout()
	if CollectionViews.getMainCollectionLayoutStore(false).getIsContainerMeasured(false) then
		return buildSduiCollectionInfo("Small", udim, fFlagSduiPreferredTextSizeLineBudgets and 3 or nil)
	end

	return nil
end

return measureHomeCollectionLayout
