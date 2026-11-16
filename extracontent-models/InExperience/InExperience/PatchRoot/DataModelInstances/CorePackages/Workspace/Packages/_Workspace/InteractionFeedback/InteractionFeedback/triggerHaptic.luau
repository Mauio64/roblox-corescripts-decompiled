local parent = script:FindFirstAncestor("InteractionFeedback").Parent
local Cryo = require(parent.Cryo)

require(script.Parent.InteractionFeedbackContext)
local sendHapticAnalytics = require(script.Parent.sendHapticAnalytics)

local hapticEffects = {}

local function triggerHaptic(p, position: Vector3, radius: number, contextKey: string?, interactionType, p2: string?, options)
	if not hapticEffects[p] then
		hapticEffects[p] = Instance.new("HapticEffect")
		hapticEffects[p].Parent = workspace
		hapticEffects[p].Type = p
	end

	hapticEffects[p].Position = position
	hapticEffects[p].Radius = radius
	hapticEffects[p]:Play()

	if p2 then
		sendHapticAnalytics(
			Cryo.Dictionary.join(
				{ hapticType = p.Name, contextKey = contextKey, interactionType = interactionType },
				options or {}
			),
			p2
		)
	end
end

return triggerHaptic
