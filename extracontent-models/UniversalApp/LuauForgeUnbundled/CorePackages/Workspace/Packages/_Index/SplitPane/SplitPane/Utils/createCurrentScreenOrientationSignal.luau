local Players = game:GetService("Players")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Signals")

local function createCurrentScreenOrientationSignal()
	local signal, v5 = Signals.createSignal(nil)
	local currentScreenOrientationChangedConnection = nil
	local childAddedConnection = nil

	local function connectToPlayerGui(instance)
		v5(instance.CurrentScreenOrientation)
		currentScreenOrientationChangedConnection = instance:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function()
			v5(instance.CurrentScreenOrientation)
		end)
	end

	local localPlayer = Players.LocalPlayer

	if localPlayer then
		local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")

		if playerGui then
			v5(playerGui.CurrentScreenOrientation)
			currentScreenOrientationChangedConnection = playerGui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function()
				v5(playerGui.CurrentScreenOrientation)
			end)
		else
			childAddedConnection = localPlayer.ChildAdded:Connect(function(playerGui2)
				if playerGui2:IsA("PlayerGui") then
					if childAddedConnection then
						childAddedConnection:Disconnect()
					end

					childAddedConnection = nil
					v5(playerGui2.CurrentScreenOrientation)
					currentScreenOrientationChangedConnection = playerGui2:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function()
						v5(playerGui2.CurrentScreenOrientation)
					end)
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
