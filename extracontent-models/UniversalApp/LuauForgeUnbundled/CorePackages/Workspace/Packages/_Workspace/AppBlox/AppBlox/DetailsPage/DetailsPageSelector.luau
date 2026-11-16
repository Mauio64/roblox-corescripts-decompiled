local DetailsPageTemplate = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/DetailsPageTemplate")
local DetailsPageTenfootTemplate = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/DetailsPageTenfootTemplate")

local deviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RobloxAppEnums").DeviceType

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")

local modules = {
	[deviceType.Console] = DetailsPageTenfootTemplate,
	[deviceType.Phone] = DetailsPageTemplate,
	[deviceType.Desktop] = DetailsPageTemplate,
	[deviceType.Unknown] = DetailsPageTemplate,
	[deviceType.Tablet] = DetailsPageTemplate,
	[deviceType.VR] = DetailsPageTemplate
}

local function DetailsPageTemplateSelector(p2)
	local v5 = modules[p2.deviceType] or DetailsPageTemplate
	return React.createElement(v5, p2.detailsPageProps)
end

return DetailsPageTemplateSelector
