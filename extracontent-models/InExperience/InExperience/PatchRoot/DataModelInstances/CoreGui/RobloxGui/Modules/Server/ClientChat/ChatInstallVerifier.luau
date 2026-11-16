local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")

local function waitForChildOfClass(instance, className)
	local v = instance:FindFirstChildOfClass(className)

	while not v or v.ClassName ~= className do
		v = instance.ChildAdded:Wait()
	end

	return v
end

local parent = waitForChildOfClass(Players.LocalPlayer, "PlayerScripts")
local v = waitForChildOfClass(StarterPlayer, "StarterPlayerScripts")

function VerifyScriptExistence()
	local value = script:WaitForChild("ScriptToVerify").Value
	local child = not parent:FindFirstChild(value) and v:FindFirstChild(value)

	if child then
		local archivable = child.Archivable
		child.Archivable = true
		local clone = child:Clone()
		clone.Parent = parent
		child.Archivable = archivable
	end
end

VerifyScriptExistence()
script:Destroy()
