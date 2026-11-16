local parent = script:FindFirstAncestor("Home").Parent

local CollectionViews = require(parent.CollectionViews)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local buildSduiCollectionInfo = SduiSharedUtilities.buildSduiCollectionInfo
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiPreferredTextSizeLineBudgets = SharedFlags.FFlagSduiPreferredTextSizeLineBudgets

local udim = UDim.new(1, 72)

local function measureHomeCollectionLayout()
	if CollectionViews.getMainCollectionLayoutStore(false).getIsContainerMeasured(false) then
		return buildSduiCollectionInfo("Small", udim, FFlagSduiPreferredTextSizeLineBudgets and 3 or nil)
	end

	return nil
end

return measureHomeCollectionLayout
