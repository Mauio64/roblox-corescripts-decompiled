local parent = script:FindFirstAncestor("InteractionFeedback").Parent

local SoundManager = require(parent.SoundManager)
local soundManager = SoundManager.SoundManager
local Sounds = SoundManager.Sounds
local SoundGroups = SoundManager.SoundGroups

require(script.Parent.InteractionFeedbackContext)
local triggerHaptic = require(script.Parent.triggerHaptic)

soundManager.init()

local function triggerFeedback(p: string, p2, p3, vector3: Vector3, p4: number, p5: string?, p6)
	if not p3 then
		error("No config table was provided to InteractionFeedbackManager. Something is wrong.")
	end

	local v = p3[p]

	if not v then
		return
	end

	local v2 = v[p2]

	if not v2 then
		return
	end

	local sound = v2.Sound

	if sound then
		local sound2 = Sounds[sound]

		if not sound2 then
			error("Sound " .. sound .. " not found in SoundManager given contextKey: " .. p .. " and interactionType: " .. tostring(p2) .. ". Please check the Sounds.lua file.")
		end

		soundManager:PlaySound(sound2.Name, {}, SoundGroups.AppBackground)
	end

	local haptic = v2.Haptic

	if haptic then
		triggerHaptic(haptic, vector3, p4, p, p2, p5, p6)
	end
end

return triggerFeedback
