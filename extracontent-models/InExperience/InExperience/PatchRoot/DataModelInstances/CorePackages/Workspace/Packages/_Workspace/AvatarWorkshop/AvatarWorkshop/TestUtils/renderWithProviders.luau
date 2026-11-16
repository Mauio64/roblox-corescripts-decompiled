local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")
local parent = AvatarWorkshop.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local ContextProviders = require(AvatarWorkshop.Internal.ContextProviders)

local function renderWithProviders(p, p2)
	local frame = Instance.new("Frame")
	local root = ReactRoblox.createRoot(frame)
	ReactRoblox.act(function()
		root:render(React.createElement(ContextProviders, { theme = "Dark" }, {
			Child = React.createElement(p, p2)
		}))
	end)
	return frame, root
end

return renderWithProviders
