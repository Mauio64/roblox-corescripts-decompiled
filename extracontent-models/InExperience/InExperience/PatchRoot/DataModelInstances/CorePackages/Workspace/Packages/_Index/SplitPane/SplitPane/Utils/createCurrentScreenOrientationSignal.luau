local Players = game:GetService("Players")

local parent = script:FindFirstAncestor("SplitPane").Parent
local Signals = require(parent.Signals)

local function createCurrentScreenOrientationSignal()
	local signal, v = Signals.createSignal(nil)
	local currentScreenOrientationChangedConnection = nil
	local childAddedConnection = nil

	local function connectToPlayerGui(playerGui) -- 2 equivalent calls inferred from this helper
		v(playerGui.CurrentScreenOrientation)
		currentScreenOrientationChangedConnection = playerGui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function()
			v(playerGui.CurrentScreenOrientation)
		end)
	end

	local localPlayer = Players.LocalPlayer

	if localPlayer then
		local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")

		if playerGui then
			connectToPlayerGui(playerGui) -- inferred equivalent call
		else
			childAddedConnection = localPlayer.ChildAdded:Connect(function(playerGui2)
				if playerGui2:IsA("PlayerGui") then
					if childAddedConnection then
						childAddedConnection:Disconnect()
					end

					childAddedConnection = nil
					connectToPlayerGui(playerGui2) -- inferred equivalent call
				end
			end)
		end
	end

	return signal, function()
		if currentScreenOrientationChangedConnection then
			currentScreenOrientationChangedConnection:Disconnect()
		end

		if childAddedConnection then
			childAddedConnection:Disconnect()
		end
	end
end

return createCurrentScreenOrientationSignal
