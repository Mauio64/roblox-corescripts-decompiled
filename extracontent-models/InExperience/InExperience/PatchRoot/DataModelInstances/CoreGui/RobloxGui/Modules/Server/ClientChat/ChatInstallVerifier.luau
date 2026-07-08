local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")

local function waitForChildOfClass(p1, p2) -- line: 10
	local p2_2 = p1:FindFirstChildOfClass(p2)

	while not p2_2 or p2 ~= p2_2.ClassName do
		p2_2 = p1.ChildAdded:Wait()
	end

	return p2_2
end

local v4 = waitForChildOfClass(Players.LocalPlayer, "PlayerScripts")
local v5 = waitForChildOfClass(StarterPlayer, "StarterPlayerScripts")

function VerifyScriptExistence() -- line: 22
	-- upvalues: v4 (copy), v5 (copy)
	local Value = script:WaitForChild("ScriptToVerify").Value

	if not v4:FindFirstChild(Value) then
		local Value2 = v5:FindFirstChild(Value)

		if Value2 then
			local Archivable = Value2.Archivable

			Value2.Archivable = true
			Value2:Clone().Parent = v4
			Value2.Archivable = Archivable
		end
	end
end

VerifyScriptExistence()
script:Destroy()
