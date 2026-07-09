local CoreGui = game:GetService("CoreGui")
local ParentParent = script.Parent.Parent
local Rhodium = require(ParentParent.Rhodium)
local Roact = require(ParentParent.Roact)
local Element = Rhodium.Element
local XPath = Rhodium.XPath
local mockStyle = require(ParentParent.UnitTestHelpers).mockStyle

return function(p1) -- line: 18
	-- upvalues: Roact (copy), mockStyle (copy), CoreGui (copy), XPath (copy), Element (copy)
	local u9 = false
	local v10 = Roact.createElement("ScreenGui", {}, {
		buttonElement = Roact.createElement(p1, {
			onActivated = function() -- line: 23
				-- upvalues: u9 (ref)
				u9 = true
			end
		})
	})
	local v11 = mockStyle(v10)
	local v12 = Roact.mount(v11, CoreGui, "TestRoot")
	local v13 = XPath.new("game.CoreGui.*.buttonElement")
	local v14 = Element.new(v13)

	assert(v14:getRbxInstance() ~= nil, "button was nil")
	v14:clickWithoutValidation()
	assert(u9 == true, "button was not activated")
	Roact.unmount(v12)
end
