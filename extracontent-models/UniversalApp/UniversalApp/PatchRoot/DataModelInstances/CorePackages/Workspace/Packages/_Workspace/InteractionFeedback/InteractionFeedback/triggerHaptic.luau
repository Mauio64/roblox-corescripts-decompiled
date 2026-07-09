local Parent = script:FindFirstAncestor("InteractionFeedback").Parent
local Cryo = require(Parent.Cryo)
local SharedFlags = require(Parent.SharedFlags)

require(script.Parent.InteractionFeedbackContext)

local sendHapticAnalytics = require(script.Parent.sendHapticAnalytics)
local FFlagLuaAppHapticTriggeredTelemetry = SharedFlags.FFlagLuaAppHapticTriggeredTelemetry
local FFlagLuaAppFixExplicitFeedbackTelemetry = SharedFlags.FFlagLuaAppFixExplicitFeedbackTelemetry
local t1 = {}

local function triggerHaptic(p1, vector3: Vector3, n1: number, s1: string?, p2, s2: string?, t2: {[any]: any}?) -- line: 16
	-- upvalues: t1 (copy), FFlagLuaAppHapticTriggeredTelemetry (copy), Cryo (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), sendHapticAnalytics (copy)
	if not t1[p1] then
		t1[p1] = Instance.new("HapticEffect")
		t1[p1].Parent = workspace
		t1[p1].Type = p1
	end

	t1[p1].Position = vector3
	t1[p1].Radius = n1
	t1[p1]:Play()

	if FFlagLuaAppHapticTriggeredTelemetry and s2 then
		local v16 = Cryo.Dictionary.join({
			hapticType = p1.Name,
			contextKey = s1,
			interactionType = p2,
			ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then s2 else nil
		}, t2 or {})

		sendHapticAnalytics(v16, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else s2)
	end
end

return triggerHaptic
