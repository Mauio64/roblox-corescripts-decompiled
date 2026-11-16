local parent = script:FindFirstAncestor("AvatarWorkshop").Parent

require(parent.React)
local ReactTestingLibrary = require(parent.Dev.ReactTestingLibrary)

local render = ReactTestingLibrary.render
local act = ReactTestingLibrary.act

local CoreGui = game:GetService("CoreGui")

local v = {}

local function renderOnScreen(p, value: number?, value2: number?)
	local screenGui = Instance.new("ScreenGui")
	screenGui.Parent = CoreGui
	table.insert(v, screenGui)

	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromOffset(value or 1000, value2 or 600)
	frame.Parent = screenGui

	local v2 = render(p, { container = frame })

	act(function()
		task.wait()
	end)
	act(function()
		task.wait()
	end)

	return v2
end

return {
	render = renderOnScreen,
	cleanup = function()
		for _, v2 in v do
			v2:Destroy()
		end

		table.clear(v)
	end
}
