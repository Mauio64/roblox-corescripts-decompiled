local Home = script:FindFirstAncestor("Home")
local parent = Home.Parent

local SduiSharedUtilities = require(parent.SduiSharedUtilities)

local buildHomeSortDetailPageEntry = require(Home.HomeSortDetailPage.buildHomeSortDetailPageEntry)
local getHomeSortDetailPageKey = require(Home.HomeSortDetailPage.getHomeSortDetailPageKey)
local HomeSortDetailConstants = require(Home.HomeSortDetailPage.HomeSortDetailConstants)

local function fetchHomeSortDetail(p: string, p2: number?, loadTimer)
	local homeSortDetailPageKey = getHomeSortDetailPageKey(p, p2)
	local homeSortDetailPageEntry = buildHomeSortDetailPageEntry(p, p2)

	if homeSortDetailPageEntry == nil then
		return nil, homeSortDetailPageKey
	end

	local createTemplateApiRequestConfig = SduiSharedUtilities.createTemplateApiRequestConfig

	if createTemplateApiRequestConfig == nil then
		return nil, homeSortDetailPageKey
	end

	local templateApiRequestConfig = createTemplateApiRequestConfig({
		surfaceKey = HomeSortDetailConstants.SurfaceKey,
		configKey = homeSortDetailPageKey,
		loadTimer = loadTimer,
		pageEntries = { homeSortDetailPageEntry }
	})

	if templateApiRequestConfig == nil then
		return nil, homeSortDetailPageKey
	end

	return SduiSharedUtilities.getSduiApiStore().fetchIfNeeded(templateApiRequestConfig), homeSortDetailPageKey
end

return fetchHomeSortDetail
