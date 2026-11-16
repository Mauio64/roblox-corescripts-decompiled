local SoundManager = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/SoundManager")
local soundManager = SoundManager.SoundManager
local sounds = SoundManager.Sounds
local soundGroups = SoundManager.SoundGroups

require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/InteractionFeedback/InteractionFeedbackContext")
local triggerHaptic = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/InteractionFeedback/triggerHaptic")

soundManager.init()

local function triggerFeedback(p2, p3, p4, p5, p6, p7, p8)
	if not p4 then
		error("No config table was provided to InteractionFeedbackManager. Something is wrong.")
	end

	local v5 = p4[p2]

	if not v5 then
		return
	end

	local v6 = v5[p3]

	if not v6 then
		return
	end

	local sound = v6.Sound

	if sound then
		local sound2 = sounds[sound]

		if not sound2 then
			error("Sound " .. sound .. " not found in SoundManager given contextKey: " .. p2 .. " and interactionType: " .. tostring(p3) .. ". Please check the Sounds.lua file.")
		end

		soundManager:PlaySound(sound2.Name, {}, soundGroups.AppBackground)
	end

	local haptic = v6.Haptic

	if haptic then
		triggerHaptic(haptic, p5, p6, p2, p3, p7, p8)
	end
end

return triggerFeedback
