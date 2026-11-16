local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local React = require(CorePackages.Packages.React)

local defineFastInt = game:DefineFastInt("AbuseReportMenuScreenshotReduceMotionWaitFrames", 20)
local defineFastInt2 = game:DefineFastInt("AbuseReportMenuScreenshotWaitFrames", 10)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagIEMTabFocusNav = SharedFlags.FFlagIEMTabFocusNav

local UserGameSettings = UserSettings():GetService("UserGameSettings")

local function fn() -- 1 equivalent call inferred from this helper
	if UserGameSettings.ReducedMotion then
		return defineFastInt
	end

	return defineFastInt2
end

local function fn2() -- 1 equivalent call inferred from this helper
	if UserGameSettings.ReducedMotion then
		return defineFastInt / 60
	end

	return defineFastInt2 / 60
end

return function(p, p2, callback, callback2, callback3, callback4)
	local state, setState = React.useState(false)
	local ref

	if FFlagIEMTabFocusNav then
		ref = React.useRef(nil)
	else
		ref = nil
	end

	React.useEffect(function()
		if p2 then
			if state then
				if FFlagIEMTabFocusNav and ref.current and ref.current:IsDescendantOf(game) then
					GuiService.SelectedCoreObject = ref.current
					ref.current = nil
				end

				setState(false)
			elseif p then
				if FFlagIEMTabFocusNav then
					ref.current = GuiService.SelectedCoreObject
				end

				setState(true)
				callback()

				local heartbeatConnection = nil
				local count = 0
				local count2 = 0
				local heartbeatConnection2 = nil

				local lastTime = os.clock()

				heartbeatConnection = RunService.Heartbeat:Connect(function()
					if count ~= 1 then
						count += 1
						return
					end

					callback3()
					heartbeatConnection:Disconnect()
				end)

				heartbeatConnection2 = RunService.Heartbeat:Connect(function()
					local v = os.clock() - lastTime

					if fn2() <= v then -- inferred equivalent call
						local v2 = count2

						if fn() <= v2 then -- inferred equivalent call
							heartbeatConnection2:Disconnect()
							callback2()
							return
						end
					end

					count2 += 1
				end)
			end
		elseif not state then
			callback4()
		end
	end, { p2 })
end
