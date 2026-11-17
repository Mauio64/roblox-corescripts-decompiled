local RunService = game:GetService("RunService")

local checkApplyDefaultClothing = require(script.Parent.checkApplyDefaultClothing)

local function pumpScheduler() -- 1 equivalent call inferred from this helper
	if RunService:IsRunning() then
		task.wait()
	else
		wait(0)
	end
end

local function applyDefaultClothing(p, p2: number?)
	local v = p2 == nil and 8 or p2
	local v2 = false
	local success = false
	local result = nil
	task.spawn(function()
		success, result = pcall(checkApplyDefaultClothing, p)
		v2 = true
	end)

	local lastTime = os.clock()

	while not v2 and os.clock() - lastTime < v do
		pumpScheduler() -- inferred equivalent call
	end

	if not v2 then
		warn("applyDefaultClothing: timed out")
		return p
	end

	if not success then
		warn(`applyDefaultClothing: {result}`)
		return p
	end

	if typeof(result) == "Instance" and result:IsA("HumanoidDescription") then
		return result
	end

	return p
end

return applyDefaultClothing
