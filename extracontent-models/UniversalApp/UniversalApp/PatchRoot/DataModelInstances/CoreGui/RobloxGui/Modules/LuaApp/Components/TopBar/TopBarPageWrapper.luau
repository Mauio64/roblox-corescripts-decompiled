local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local TopBarPageContent = require(script.Parent.TopBarPageContent)
local TopBarContentFrame = require(script.Parent.TopBarContentFrame)

local function TopBarPageWrapper(p1) -- line: 20
	-- upvalues: React (copy), TopBarPageContent (copy), TopBarContentFrame (copy)
	local topBarSlot = p1.topBarSlot
	local v8 = table.clone(p1)

	v8.topBarSlot = nil

	if topBarSlot then
		return React.createElement(React.Fragment, nil, {
			TopBar = topBarSlot,
			TopBarPageContent = React.createElement(TopBarPageContent, v8)
		})
	end

	return React.createElement(TopBarContentFrame, v8)
end

return TopBarPageWrapper
