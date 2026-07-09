local Parent = script:FindFirstAncestor("InteractionFeedback").Parent
local SoundManager = require(Parent.SoundManager)
local SoundManager2 = SoundManager.SoundManager
local Sounds = SoundManager.Sounds
local SoundGroups = SoundManager.SoundGroups

require(script.Parent.InteractionFeedbackContext)

local triggerHaptic = require(script.Parent.triggerHaptic)

SoundManager2.init()

local FFlagLuaAppHapticTriggeredTelemetry = require(Parent.SharedFlags).FFlagLuaAppHapticTriggeredTelemetry

local function triggerFeedback(s1: string, p1, p2, vector3: Vector3, n1: number, s2: string?, t1: {[any]: any}?) -- line: 19
	-- upvalues: Sounds (copy), SoundManager2 (copy), SoundGroups (copy), triggerHaptic (copy), FFlagLuaAppHapticTriggeredTelemetry (copy)
	if not p2 then
		error("No config table was provided to InteractionFeedbackManager. Something is wrong.")
	end

	local v16 = p2[s1]

	if not v16 then
		return
	end

	local v17 = v16[p1]

	if not v17 then
		return
	end

	local Sound = v17.Sound

	if Sound then
		local v19 = Sounds[Sound]

		if not v19 then
			error("Sound " .. Sound .. " not found in SoundManager given contextKey: " .. s1 .. " and interactionType: " .. tostring(p1) .. ". Please check the Sounds.lua file.")
		end

		SoundManager2:PlaySound(v19.Name, {}, SoundGroups.AppBackground)
	end

	local Haptic = v17.Haptic

	if Haptic then
		triggerHaptic(Haptic, vector3, n1, if not FFlagLuaAppHapticTriggeredTelemetry then nil else s1, if not FFlagLuaAppHapticTriggeredTelemetry then nil else p1, if not FFlagLuaAppHapticTriggeredTelemetry then nil else s2, if not FFlagLuaAppHapticTriggeredTelemetry then nil else t1)
	end
end

return triggerFeedback
