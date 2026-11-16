local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)

local Actions = script.Parent.Parent.Actions

local EmotesChanged = require(Actions.EmotesChanged)
local EquippedEmotesChanged = require(Actions.EquippedEmotesChanged)
local NumberEmotesLoadedChanged = require(Actions.NumberEmotesLoadedChanged)

local function createCurrentEmotes(p, equippedEmotes)
	local namesBySlot = {}

	for _, item in ipairs(equippedEmotes) do
		local slot = item.Slot
		local name = item.Name

		if slot and name and p[name] then
			namesBySlot[slot] = name
		end
	end

	return namesBySlot
end

return Rodux.createReducer({
	emotesInfo = {},
	equippedEmotes = {},
	numberEmotesLoaded = -1,
	currentEmotes = {}
}, {
	[EmotesChanged.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			emotesInfo = p2.emotes,
			currentEmotes = createCurrentEmotes(p2.emotes, p.equippedEmotes)
		})
	end,
	[EquippedEmotesChanged.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			equippedEmotes = p2.equippedEmotes,
			currentEmotes = createCurrentEmotes(p.emotesInfo, p2.equippedEmotes)
		})
	end,
	[NumberEmotesLoadedChanged.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { numberEmotesLoaded = p2.numberEmotesLoaded })
	end
})
