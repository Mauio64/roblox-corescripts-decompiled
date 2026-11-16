local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local HttpService = game:GetService("HttpService")

local Foundation = require(parent.Foundation)

local getRbxThumb = Foundation.Utility.getRbxThumb
local ThumbnailType = Foundation.Enums.ThumbnailType

local function getMediaContentUri(assetId: number, captureType, p: string?) -- 1 equivalent call inferred from this helper
	local formatted = `rbxassetid://{assetId}`

	if captureType ~= Enum.CaptureType.Video or p == nil then
		return formatted
	end

	local FFlagAppChatMomentShareCardPermissionContextFix = require(AppChat.Flags.FFlagAppChatMomentShareCardPermissionContextFix)

	if FFlagAppChatMomentShareCardPermissionContextFix and game.GameId == 0 then
		return `{formatted}&accessContext={p}`
	end

	return `{formatted}&accessContext={p}&permissionContext=ignoreUniverse`
end

local function buildMomentShareCardMedia(data)
	local assetId = data.assetId
	local captureType = data.captureType

	if assetId == nil or captureType == nil then
		return nil
	end

	local assetAccessContext = data.assetAccessContext
	local v

	if not (assetAccessContext == nil or assetAccessContext == "") then
		v = HttpService:UrlEncode(assetAccessContext)
	end

	local content

	if assetId > 0 then
		local v2

		if v == nil then
			v2 = getRbxThumb(ThumbnailType.Asset, assetId)
		else
			v2 = `{getRbxThumb(ThumbnailType.Asset, assetId)}&accessContext={v}`
		end

		content = Content.fromUri(v2)
	end

	return {
		content = Content.fromUri(getMediaContentUri(assetId, captureType, v)), -- inferred equivalent call
		posterContent = content,
		captureType = captureType
	}
end

return buildMomentShareCardMedia
