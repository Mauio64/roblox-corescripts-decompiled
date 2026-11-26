require("@luauforge/deferred/ent")
local module = require("@luauforge/deferred/enp")

require("@luauforge/bundled/enl")
local module2 = require("@luauforge/deferred/enz")
local module3 = require("@luauforge/deferred/enA")
local module4 = require("@luauforge/deferred/enB")
local module5 = require("@luauforge/deferred/enF")

local getRbxThumb = module.Utility.getRbxThumb
local thumbnailType = module.Enums.ThumbnailType

local function useExperienceJoinTileViewModel(data)
	local item = data.item
	local experienceId

	if not (item.experienceId == nil or item.experienceId == 0) then
		experienceId = item.experienceId
	end

	local v5 = module4(experienceId)

	local v6 = {}

	for k, actor in item.actors do
		local v7 = module3(actor)

		if v7 ~= nil then
			table.insert(v6, v7)
		end
	end

	local v7 = item.count <= 1 and "is" or "are"
	local formatted = `{module2(v6, item.count)} {v7} playing`

	local v8 = module5(item.timestamp)

	if data.timestampText ~= nil then
		v8 = data.timestampText
	end

	if v8 == nil then
		v8 = v5
	elseif v5 ~= nil then
		v8 = `{v5} • {v8}`
	end

	local v10 = if experienceId ~= nil then getRbxThumb(thumbnailType.GameIcon, experienceId) else nil
	return {
		thumbnail = v10,
		title = formatted,
		subtitle = v8,
		isUnread = data.isUnread,
		onActivated = data.onActivated,
		layoutOrder = data.layoutOrder
	}
end

return useExperienceJoinTileViewModel
