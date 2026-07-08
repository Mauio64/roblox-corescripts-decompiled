local CoreGui = game:GetService("CoreGui")
local Packages = script:FindFirstAncestor("Packages")
local Rhodium = require(Packages.Dev.Rhodium)
local Roact = require(Packages.Roact)
local Element = Rhodium.Element
local XPath = Rhodium.XPath
local mockStyle = require(script.Parent.Parent.UnitTestHelpers.mockStyle)

return function(p1) -- line: 11
	-- upvalues: Roact (copy), mockStyle (copy), CoreGui (copy), XPath (copy), Element (copy)
	local u9 = false
	local v10 = Roact.createElement("ScreenGui", {}, {
		buttonElement = Roact.createElement(p1, {
			onActivated = function() -- line: 16
				-- upvalues: u9 (ref)
				u9 = true
			end
		})
	})
	local v11 = mockStyle(v10)
	local v12 = Roact.mount(v11, CoreGui, "TestRoot")
	local v13 = XPath.new("game.CoreGui.Children.buttonElement")
	local v14 = Element.new(v13)

	assert(v14:getRbxInstance() ~= nil, "button was nil")
	v14:click()
	wait(0)
	assert(u9 == true, "button was not activated")
	Roact.unmount(v12)
end
