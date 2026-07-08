local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local Actions = script.Parent.Parent.Actions
local EmotesChanged = require(Actions.EmotesChanged)
local EquippedEmotesChanged = require(Actions.EquippedEmotesChanged)
local NumberEmotesLoadedChanged = require(Actions.NumberEmotesLoadedChanged)
local t1 = {
	numberEmotesLoaded = -1,
	emotesInfo = {},
	equippedEmotes = {},
	currentEmotes = {}
}

local function createCurrentEmotes(p1, p2) -- line: 24
	local t2 = {}

	for _, v in ipairs(p2) do
		local Slot = v.Slot
		local vName = v.Name

		if Slot and vName and p1[vName] then
			t2[Slot] = vName
		end
	end

	return t2
end

return Rodux.createReducer(t1, {
	[EmotesChanged.name] = function(p3, p4) -- line: 42
		-- upvalues: Cryo (copy), createCurrentEmotes (copy)
		return Cryo.Dictionary.join(p3, {
			emotesInfo = p4.emotes,
			currentEmotes = createCurrentEmotes(p4.emotes, p3.equippedEmotes)
		})
	end,
	[EquippedEmotesChanged.name] = function(p5, p6) -- line: 49
		-- upvalues: Cryo (copy), createCurrentEmotes (copy)
		return Cryo.Dictionary.join(p5, {
			equippedEmotes = p6.equippedEmotes,
			currentEmotes = createCurrentEmotes(p5.emotesInfo, p6.equippedEmotes)
		})
	end,
	[NumberEmotesLoadedChanged.name] = function(p7, p8) -- line: 56
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p7, {
			numberEmotesLoaded = p8.numberEmotesLoaded
		})
	end
})
