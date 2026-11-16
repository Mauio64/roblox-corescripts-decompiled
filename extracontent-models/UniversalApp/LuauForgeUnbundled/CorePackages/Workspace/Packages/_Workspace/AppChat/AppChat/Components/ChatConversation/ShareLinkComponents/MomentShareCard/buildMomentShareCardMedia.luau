local HttpService = game:GetService("HttpService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")

local getRbxThumb = Foundation.Utility.getRbxThumb
local thumbnailType = Foundation.Enums.ThumbnailType

local function getMediaContentUri(p2, p3, p4)
	local formatted = `rbxassetid://{p2}`

	if p3 ~= Enum.CaptureType.Video or p4 == nil then
		return formatted
	end

	if require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMomentShareCardPermissionContextFix") and game.GameId == 0 then
		return `{formatted}&accessContext={p4}`
	end

	return `{formatted}&accessContext={p4}&permissionContext=ignoreUniverse`
end

local function buildMomentShareCardMedia(data)
	local assetId = data.assetId
	local captureType = data.captureType

	if assetId == nil or captureType == nil then
		return nil
	end

	local assetAccessContext = data.assetAccessContext
	local v5

	if not (assetAccessContext == nil or assetAccessContext == "") then
		v5 = HttpService:UrlEncode(assetAccessContext)
	end

	local content

	if assetId > 0 then
		local fromUri = Content.fromUri
		local v6

		if v5 == nil then
			v6 = getRbxThumb(thumbnailType.Asset, assetId)
		else
			v6 = `{getRbxThumb(thumbnailType.Asset, assetId)}&accessContext={v5}`
		end

		content = fromUri(v6)
	end

	local fromUri = Content.fromUri
	local formatted = `rbxassetid://{assetId}`

	if captureType == Enum.CaptureType.Video and v5 ~= nil then
		if require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMomentShareCardPermissionContextFix") and game.GameId == 0 then
			formatted = `{formatted}&accessContext={v5}`
		else
			formatted = `{formatted}&accessContext={v5}&permissionContext=ignoreUniverse`
		end
	end

	return {
		content = fromUri(formatted),
		posterContent = content,
		captureType = captureType
	}
end

return buildMomentShareCardMedia
