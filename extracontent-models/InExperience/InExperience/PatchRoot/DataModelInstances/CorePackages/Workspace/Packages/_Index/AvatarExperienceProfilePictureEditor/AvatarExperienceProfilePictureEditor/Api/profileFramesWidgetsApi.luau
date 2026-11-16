local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local Http = require(parent.Http)
local HttpService = game:GetService("HttpService")
local Promise = require(parent.Promise)
local AvatarExperienceCatalog = require(parent.AvatarExperienceCatalog)

local Enums = require(AvatarExperienceProfilePictureEditor.Common.Enums)

local getWidgetListInfo = AvatarExperienceCatalog.Api.getWidgetListInfo

local function buildHydrateUrl() -- 1 equivalent call inferred from this helper
	return `{Http.Url.APIS_URL}marketplace-widgets/v1/widgets/hydrate`
end

local function extractWidgetContent(p)
	local widgetContent = {}

	if p == nil then
		return widgetContent
	end

	local widgets = p.widgets

	if widgets == nil then
		return widgetContent
	end

	for _, widget in pairs(widgets) do
		local content = widget.content

		if content == nil then
			continue
		end

		for _, v in content do
			table.insert(widgetContent, { type = v.type, id = v.id })
		end
	end

	return widgetContent
end

local function hydrateWidgetContent(callback, content)
	if #content == 0 then
		return nil
	end

	local jsonEncode = HttpService:JSONEncode({ Content = content })

	return callback(buildHydrateUrl(), Enums.RequestMethods.POST, { postBody = jsonEncode }):andThen(function(p) -- inferred equivalent call
		return p.responseBody
	end)
end

local function processWidgetsResponseAndHydrate(callback, widgetListInfo)
	local widgetContent = extractWidgetContent(widgetListInfo)

	if #widgetContent == 0 then
		return Promise.resolve({
			widgetListInfo = widgetListInfo,
			hydrateResponseBody = nil,
			widgetContent = widgetContent
		})
	end

	return hydrateWidgetContent(callback, widgetContent):andThen(function(hydrateResponseBody)
		return {
			widgetListInfo = widgetListInfo,
			hydrateResponseBody = hydrateResponseBody,
			widgetContent = widgetContent
		}
	end)
end

local function toGetWidgetListInfoRequestImpl(callback) -- 1 equivalent call inferred from this helper
	return function(p: string, p2: string)
		return callback(p, p2)
	end
end

return {
	PROFILE_FRAMES_WIDGET_CONTEXT = "catalog-tab:profile-frames",
	buildHydrateUrl = buildHydrateUrl,
	extractWidgetContent = extractWidgetContent,
	fetchProfileFramesWidgets = function(callback, p)
		local v

		if p and p.requestId then
			v = p.requestId
		else
			v = HttpService:GenerateGUID(false)
		end

		return getWidgetListInfo(toGetWidgetListInfoRequestImpl(callback), v, "catalog-tab:profile-frames", nil):andThen(function(widgetListInfo) -- inferred equivalent call
			return processWidgetsResponseAndHydrate(callback, widgetListInfo)
		end)
	end
}
