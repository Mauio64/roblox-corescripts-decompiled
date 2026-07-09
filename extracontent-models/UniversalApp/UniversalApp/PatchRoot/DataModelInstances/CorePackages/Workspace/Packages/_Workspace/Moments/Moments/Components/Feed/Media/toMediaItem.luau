local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local HttpService = game:GetService("HttpService")
local Foundation = require(MomentsParent.Foundation)

require(MomentsParent.MomentsCommon)
require(Moments.Components.Feed.FeedTypes)

local getRbxThumb = Foundation.Utility.getRbxThumb
local ThumbnailType = Foundation.Enums.ThumbnailType

local function getMediaContentUri(n1: number, p1, s1: string?) -- line: 35
	local v12 = `rbxassetid://{ n1 }`

	if p1 ~= Enum.CaptureType.Video or s1 == nil then
		return v12
	end

	return `{ v12 }&accessContext={ s1 }&permissionContext=ignoreUniverse`
end
local function toMediaItem(p2) -- line: 44
	-- upvalues: HttpService (copy), getRbxThumb (copy), ThumbnailType (copy)
	if p2.kind ~= "moment" then
		return nil
	end

	local moment = p2.moment

	if moment == nil or moment.metadata == nil then
		return nil
	end

	local assetId = moment.assetId
	local assetAccessContext = moment.metadata.assetAccessContext
	local v17 = if assetAccessContext == nil or assetAccessContext == "" then nil else HttpService:UrlEncode(assetAccessContext)
	local v18 = if not (assetId > 0) then nil else Content.fromUri(if v17 == nil then getRbxThumb(ThumbnailType.Asset, assetId) else `{ getRbxThumb(ThumbnailType.Asset, assetId) }&accessContext={ v17 }`)
	local t1 = {
		momentId = moment.momentId
	}
	local fromUri = Content.fromUri
	local captureType = moment.metadata.captureType
	local v22 = `rbxassetid://{ assetId }`

	t1.content = fromUri(if captureType == Enum.CaptureType.Video and v17 ~= nil then `{ v22 }&accessContext={ v17 }&permissionContext=ignoreUniverse` else v22)
	t1.posterContent = v18
	t1.captureType = moment.metadata.captureType
	t1.edits = moment.metadata.edits

	return t1
end

return toMediaItem
