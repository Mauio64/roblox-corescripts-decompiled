local ChromeShared = script:FindFirstAncestor("ChromeShared")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ObservableValue = require(ChromeShared.Service.ChromeUtils).ObservableValue
local v5 = ObservableValue.new(Vector2.new(0, 0))
local v6 = ObservableValue.new(false)
local u7 = nil

function createViewportInfo(vector2: Vector2) -- line: 25
	-- upvalues: UserInputService (copy)
	local v10 = vector2.Y > vector2.X
	local Platform = UserInputService:GetPlatform()
	local v12 = Platform == Enum.Platform.IOS or Platform == Enum.Platform.Android

	return {
		size = vector2,
		portraitOrientation = v10,
		tinyPortrait = v12 and (v10 and vector2.X < 360),
		isMobileDevice = v12
	}
end

local v8 = ObservableValue.new(createViewportInfo(Vector2.zero))

function updateViewportSize(vector2: Vector2) -- line: 39
	-- upvalues: v5 (copy), v8 (copy)
	local vector2_2 = Vector2.new(vector2.X, vector2.Y)

	v5:set(vector2_2)
	v8:set(createViewportInfo(vector2_2))
end
function setCurrentCamera(p1) -- line: 45
	-- upvalues: u7 (ref), UserInputService (copy), v6 (copy)
	if u7 then
		pcall(function() -- line: 47
			-- upvalues: u7 (ref)
			u7:Disconnect()
		end)
		u7 = nil
	end

	if p1 then
		local Platform = UserInputService:GetPlatform()

		v6:set(Platform == Enum.Platform.IOS or Platform == Enum.Platform.Android)
		u7 = p1:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 56
			-- upvalues: p1 (copy)
			updateViewportSize(p1.ViewportSize)
		end)
		updateViewportSize(p1.ViewportSize)
	end
end

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 63
	-- upvalues: Workspace (copy)
	setCurrentCamera(Workspace.CurrentCamera)
end)
setCurrentCamera(Workspace.CurrentCamera)

return {
	screenSize = v5,
	mobileDevice = v6,
	viewport = v8,
	isSmallTouchScreen = function() -- line: 72
		-- upvalues: v5 (copy), UserInputService (copy)
		local v17 = v5:get()

		return UserInputService.TouchEnabled and (v17.Y < 500 or v17.X < 700)
	end
}
