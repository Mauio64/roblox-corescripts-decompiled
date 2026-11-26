local RunService = game:GetService("RunService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local estimatePostingProgress = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/estimatePostingProgress")

game:DefineFastInt("MomentsPostingProgressSeconds", 100)
game:DefineFastInt("MomentsPostingProgressTargetPercent", 90)

local function getPercent(p2)
	if p2 == nil then
		return 0
	end

	local fastInt = game:GetFastInt("MomentsPostingProgressSeconds")
	local v5 = game:GetFastInt("MomentsPostingProgressTargetPercent") / 100
	return estimatePostingProgress(os.clock(), p2, fastInt, v5) * 100
end

local function usePostingProgress(p2)
	local useBinding = React.useBinding
	local v5

	if p2 == nil then
		v5 = 0
	else
		local fastInt = game:GetFastInt("MomentsPostingProgressSeconds")
		local v6 = game:GetFastInt("MomentsPostingProgressTargetPercent") / 100
		v5 = estimatePostingProgress(os.clock(), p2, fastInt, v6) * 100
	end

	local v6, v7 = useBinding(v5)

	React.useEffect(function()
		if p2 == nil then
			return nil
		end

		local v9 = p2
		local v10

		if v9 == nil then
			v10 = 0
		else
			local fastInt = game:GetFastInt("MomentsPostingProgressSeconds")
			local v11 = game:GetFastInt("MomentsPostingProgressTargetPercent") / 100
			v10 = estimatePostingProgress(os.clock(), v9, fastInt, v11) * 100
		end

		v7(v10)
		local heartbeatConnection = RunService.Heartbeat:Connect(function()
			local v12 = p2
			local v13

			if v12 == nil then
				v13 = 0
			else
				local fastInt = game:GetFastInt("MomentsPostingProgressSeconds")
				local v14 = game:GetFastInt("MomentsPostingProgressTargetPercent") / 100
				v13 = estimatePostingProgress(os.clock(), v12, fastInt, v14) * 100
			end

			v7(v13)
		end)
		return function()
			heartbeatConnection:Disconnect()
		end
	end, { p2 })

	if p2 == nil then
		return nil
	end

	return v6
end

return usePostingProgress
