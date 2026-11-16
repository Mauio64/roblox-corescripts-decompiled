local parent = script:FindFirstAncestor("AppBlox").Parent
local DetailsPageTemplate = require(script.Parent.DetailsPageTemplate)
local DetailsPageTenfootTemplate = require(script.Parent.DetailsPageTenfootTemplate)

local RobloxAppEnums = require(parent.RobloxAppEnums)

local DeviceType = RobloxAppEnums.DeviceType

local React = require(parent.React)

local v = {
	[DeviceType.Console] = DetailsPageTenfootTemplate,
	[DeviceType.Phone] = DetailsPageTemplate,
	[DeviceType.Desktop] = DetailsPageTemplate,
	[DeviceType.Unknown] = DetailsPageTemplate,
	[DeviceType.Tablet] = DetailsPageTemplate,
	[DeviceType.VR] = DetailsPageTemplate
}

local function DetailsPageTemplateSelector(p)
	local v2 = v[p.deviceType] or DetailsPageTemplate
	return React.createElement(v2, p.detailsPageProps)
end

return DetailsPageTemplateSelector
