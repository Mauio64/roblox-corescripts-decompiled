local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SduiSharedUtilities")

local buildHomeSortDetailPageEntry = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeSortDetailPage/buildHomeSortDetailPageEntry")
local getHomeSortDetailPageKey = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeSortDetailPage/getHomeSortDetailPageKey")
local HomeSortDetailConstants = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeSortDetailPage/HomeSortDetailConstants")

local function fetchHomeSortDetail(p2, p3, p4)
	local v5 = getHomeSortDetailPageKey(p2, p3)
	local v6 = buildHomeSortDetailPageEntry(p2, p3)

	if v6 == nil then
		return nil, v5
	end

	local createTemplateApiRequestConfig = SduiSharedUtilities.createTemplateApiRequestConfig

	if createTemplateApiRequestConfig == nil then
		return nil, v5
	end

	local templateApiRequestConfig = createTemplateApiRequestConfig({
		surfaceKey = HomeSortDetailConstants.SurfaceKey,
		configKey = v5,
		loadTimer = p4,
		pageEntries = { v6 }
	})

	if templateApiRequestConfig == nil then
		return nil, v5
	end

	return SduiSharedUtilities.getSduiApiStore().fetchIfNeeded(templateApiRequestConfig), v5
end

return fetchHomeSortDetail
