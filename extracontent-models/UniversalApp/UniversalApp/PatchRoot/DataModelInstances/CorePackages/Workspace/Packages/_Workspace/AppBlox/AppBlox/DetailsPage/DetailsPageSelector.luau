local Parent = script:FindFirstAncestor("AppBlox").Parent
local DetailsPageTemplate = require(script.Parent.DetailsPageTemplate)
local DetailsPageTenfootTemplate = require(script.Parent.DetailsPageTenfootTemplate)
local DeviceType = require(Parent.RobloxAppEnums).DeviceType
local React = require(Parent.React)
local t1 = {
	[DeviceType.Console] = DetailsPageTenfootTemplate,
	[DeviceType.Phone] = DetailsPageTemplate,
	[DeviceType.Desktop] = DetailsPageTemplate,
	[DeviceType.Unknown] = DetailsPageTemplate,
	[DeviceType.Tablet] = DetailsPageTemplate,
	[DeviceType.VR] = DetailsPageTemplate
}

local function DetailsPageTemplateSelector(t2: {[any]: any}) -- line: 32
	-- upvalues: t1 (copy), DetailsPageTemplate (copy), React (copy)
	local v9 = t1[t2.deviceType] or DetailsPageTemplate

	return React.createElement(v9, t2.detailsPageProps)
end

return DetailsPageTemplateSelector
