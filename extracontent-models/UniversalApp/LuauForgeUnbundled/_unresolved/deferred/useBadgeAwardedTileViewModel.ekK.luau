require("@luauforge/deferred/ejX")
local module = require("@luauforge/deferred/ejT")

require("@luauforge/bundled/ejP")
local module2 = require("@luauforge/deferred/eke")
local module3 = require("@luauforge/deferred/ekL")
local module4 = require("@luauforge/deferred/ekf")
local module5 = require("@luauforge/deferred/ekj")

local getRbxThumb = module.Utility.getRbxThumb
local thumbnailType = module.Enums.ThumbnailType

local function useBadgeAwardedTileViewModel(data)
	local item = data.item
	local v5 = module2(item.actors[1]) or ""

	local v6 = if not (item.assetIds[1] == nil or item.assetIds[1] == 0) then item.assetIds[1] else nil
	local v7 = module3(v6)
	local v8 = module4(item.experienceId)
	local v9 = if item.count > 0 then item.count else #item.assetIds
	local v10

	if v9 > 1 then
		v10 = `{v5} earned {v9} badges`
	else
		v10 = if v7 == nil then `{v5} earned a new badge` else `{v5} achieved {v7}`
	end

	local v11 = module5(item.timestamp)

	if data.timestampText ~= nil then
		v11 = data.timestampText
	end

	if v11 == nil then
		v11 = v8
	elseif v8 ~= nil then
		v11 = `{v8} • {v11}`
	end

	local v13 = if v6 ~= nil then getRbxThumb(thumbnailType.BadgeIcon, v6) else nil
	return {
		thumbnail = v13,
		title = v10,
		subtitle = v11,
		isUnread = data.isUnread,
		onActivated = data.onActivated,
		layoutOrder = data.layoutOrder
	}
end

return useBadgeAwardedTileViewModel
