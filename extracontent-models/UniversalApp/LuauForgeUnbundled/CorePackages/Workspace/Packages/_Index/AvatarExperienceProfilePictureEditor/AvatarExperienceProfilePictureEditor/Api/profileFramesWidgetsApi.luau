local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Http")
local HttpService = game:GetService("HttpService")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Promise")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AvatarExperienceCatalog")

local Enums = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/Enums")

local getWidgetListInfo = AvatarExperienceCatalog.Api.getWidgetListInfo

local function extractWidgetContent(p2)
	local widgetContent = {}

	if p2 == nil then
		return widgetContent
	end

	local widgets = p2.widgets

	if widgets == nil then
		return widgetContent
	end

	for k, widget in pairs(widgets) do
		local content = widget.content

		if content == nil then
			continue
		end

		for k2, v5 in content do
			table.insert(widgetContent, { type = v5.type, id = v5.id })
		end
	end

	return widgetContent
end

local function hydrateWidgetContent(callback, list)
	if #list == 0 then
		return nil
	end

	local jsonEncode = HttpService:JSONEncode({ Content = list })
	return callback(
		`{module.Url.APIS_URL}marketplace-widgets/v1/widgets/hydrate`,
		Enums.RequestMethods.POST,
		{ postBody = jsonEncode }
	):andThen(function(p2)
		return p2.responseBody
	end)
end

local function processWidgetsResponseAndHydrate(callback, p2)
	local v5 = extractWidgetContent(p2)

	if #v5 == 0 then
		return Promise.resolve({
			widgetListInfo = p2,
			hydrateResponseBody = nil,
			widgetContent = v5
		})
	end

	return hydrateWidgetContent(callback, v5):andThen(function(p3)
		return { widgetListInfo = p2, hydrateResponseBody = p3, widgetContent = v5 }
	end)
end

local function toGetWidgetListInfoRequestImpl(callback)
	return function(p2, p3)
		return callback(p2, p3)
	end
end

return {
	PROFILE_FRAMES_WIDGET_CONTEXT = "catalog-tab:profile-frames",
	buildHydrateUrl = function()
		return `{module.Url.APIS_URL}marketplace-widgets/v1/widgets/hydrate`
	end,
	extractWidgetContent = extractWidgetContent,
	fetchProfileFramesWidgets = function(callback, p2)
		local v5 = if p2 and p2.requestId then p2.requestId else HttpService:GenerateGUID(false)
		return getWidgetListInfo(function(p3, p4)
			return callback(p3, p4)
		end, v5, "catalog-tab:profile-frames", nil):andThen(function(p3)
			return processWidgetsResponseAndHydrate(callback, p3)
		end)
	end
}
