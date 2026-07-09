local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local AvatarSwitcherParent = AvatarSwitcher.Parent
local React = require(AvatarSwitcherParent.React)
local ReactRoblox = require(AvatarSwitcherParent.ReactRoblox)
local ContextProviders = require(AvatarSwitcher.Internal.ContextProviders)

local function renderWithProviders(p1, p2) -- line: 9
	-- upvalues: ReactRoblox (copy), React (copy), ContextProviders (copy)
	local Frame = Instance.new("Frame")
	local v10 = ReactRoblox.createRoot(Frame)

	ReactRoblox.act(function() -- line: 12
		-- upvalues: v10 (copy), React (copy), ContextProviders (copy), p1 (copy), p2 (copy)
		v10:render(React.createElement(ContextProviders, {
			theme = "Dark"
		}, {
			Child = React.createElement(p1, p2)
		}))
	end)

	return Frame, v10
end

return renderWithProviders
