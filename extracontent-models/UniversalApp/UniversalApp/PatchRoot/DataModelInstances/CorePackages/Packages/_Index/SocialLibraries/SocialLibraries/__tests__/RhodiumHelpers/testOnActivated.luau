local CoreGui = game:GetService("CoreGui")
local Packages = script:FindFirstAncestor("Packages")
local Rhodium = require(Packages.Dev.Rhodium)
local Roact = require(Packages.Roact)
local Element = Rhodium.Element
local XPath = Rhodium.XPath
local mockStyle = require(script.Parent.Parent.UnitTestHelpers.mockStyle)

return function(p)
	local v = false

	local v2 = mockStyle((Roact.createElement("ScreenGui", {}, {
		buttonElement = Roact.createElement(p, {
			onActivated = function()
				v = true
			end
		})
	})))

	local v3 = Roact.mount(v2, CoreGui, "TestRoot")
	local gameCoreGuiChildrenbuttonElement = XPath.new("game.CoreGui.Children.buttonElement")

	local v4 = Element.new(gameCoreGuiChildrenbuttonElement)

	assert(v4:getRbxInstance() ~= nil, "button was nil")

	v4:click()

	wait(0)

	assert(v == true, "button was not activated")

	Roact.unmount(v3)
end
