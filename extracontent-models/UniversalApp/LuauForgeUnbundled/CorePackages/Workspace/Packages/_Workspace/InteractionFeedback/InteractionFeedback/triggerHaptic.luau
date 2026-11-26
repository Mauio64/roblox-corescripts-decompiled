local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/Cryo")

require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/InteractionFeedback/InteractionFeedbackContext")
local sendHapticAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/InteractionFeedback/sendHapticAnalytics")

local hapticEffects = {}

local function triggerHaptic(p2, position, radius, p3, p4, p5, options)
	if not hapticEffects[p2] then
		hapticEffects[p2] = Instance.new("HapticEffect")
		hapticEffects[p2].Parent = workspace
		hapticEffects[p2].Type = p2
	end

	hapticEffects[p2].Position = position
	hapticEffects[p2].Radius = radius
	hapticEffects[p2]:Play()

	if p5 then
		sendHapticAnalytics(
			Cryo.Dictionary.join(
				{ hapticType = p2.Name, contextKey = p3, interactionType = p4 },
				options or {}
			),
			p5
		)
	end
end

return triggerHaptic
