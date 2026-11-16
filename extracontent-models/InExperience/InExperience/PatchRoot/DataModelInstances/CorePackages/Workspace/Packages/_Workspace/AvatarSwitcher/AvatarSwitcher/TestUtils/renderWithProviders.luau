local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local parent = AvatarSwitcher.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local ContextProviders = require(AvatarSwitcher.Internal.ContextProviders)

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
