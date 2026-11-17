local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local RunService = game:GetService("RunService")

local React = require(parent.React)

local estimatePostingProgress = require(Moments.Components.PostFeedback.estimatePostingProgress)

game:DefineFastInt("MomentsPostingProgressSeconds", 100)
game:DefineFastInt("MomentsPostingProgressTargetPercent", 90)

local function getPercent(p: number?) -- 3 equivalent calls inferred from this helper
	if p == nil then
		return 0
	end

	local fastInt = game:GetFastInt("MomentsPostingProgressSeconds")
	local v = game:GetFastInt("MomentsPostingProgressTargetPercent") / 100
	return estimatePostingProgress(os.clock(), p, fastInt, v) * 100
end

local function usePostingProgress(p: number?)
	local v, v2 = React.useBinding(getPercent(p)) -- inferred equivalent call

	React.useEffect(function()
		if p == nil then
			return nil
		end

		v2(getPercent(p)) -- inferred equivalent call
		local heartbeatConnection = RunService.Heartbeat:Connect(function()
			v2(getPercent(p)) -- inferred equivalent call
		end)
		return function()
			heartbeatConnection:Disconnect()
		end
	end, { p })
	return if p ~= nil then v else nil
end

return usePostingProgress
