local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dKU")

local module = require("@luauforge/bundled/dPN")

local module2 = require("@luauforge/bundled/dQs")
local module3 = require("@luauforge/bundled/dSh")
local module4 = require("@luauforge/bundled/dRO")

local characterHistoryStateChangeButtonActivated = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Actions.CharacterHistoryStateChangeButtonActivated

local function createSlotInfo(emotes)
	local slotInfo = {}

	for k, item in emotes do
		local position = item.position
		slotInfo[position] = { assetId = tostring(item.assetId), position = position }
	end

	return slotInfo
end

local function addEmoteToSlot(p2, p3, p4)
	return Cryo.Dictionary.join(p2, { [p3] = p4 })
end

local function removeEmoteFromSlot(p2, p3)
	return Cryo.Dictionary.join(p2, { [p3] = Cryo.None })
end

return Rodux.createReducer({ slotInfo = {}, selectedSlot = 1 }, {
	[module2.name] = function(p2, p3)
		local emotes = p3.avatarData.emotes or {}

		local slotInfo = createSlotInfo(emotes)

		return Cryo.Dictionary.join(p2, { slotInfo = slotInfo })
	end,
	[characterHistoryStateChangeButtonActivated.name] = function(p2, p3)
		if p3.equipped and next(p3.equipped) ~= nil and p3.equipped.EquippedEmotes then
			return Cryo.Dictionary.join(p2, {
				slotInfo = p3.equipped.EquippedEmotes.slotInfo
			})
		end

		return p2
	end,
	[module4.name] = function(p2, p3)
		if p3.assetTypeId ~= module.AssetTypeIdStrings.EmoteAnimation then
			return p2
		end

		local v6 = p2.slotInfo[p2.selectedSlot]

		local v7 = { assetId = p3.assetId, position = p2.selectedSlot }
		local joined

		if v6 and v6.assetId == v7.assetId then
			local slotInfo = p2.slotInfo
			local selectedSlot = p2.selectedSlot
			joined = Cryo.Dictionary.join(slotInfo, { [selectedSlot] = Cryo.None })
		else
			local slotInfo = p2.slotInfo
			local selectedSlot = p2.selectedSlot
			joined = Cryo.Dictionary.join(slotInfo, { [selectedSlot] = v7 })
		end

		return Cryo.Dictionary.join(p2, { slotInfo = joined })
	end,
	[module3.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { selectedSlot = p3.selectedSlot })
	end
})
