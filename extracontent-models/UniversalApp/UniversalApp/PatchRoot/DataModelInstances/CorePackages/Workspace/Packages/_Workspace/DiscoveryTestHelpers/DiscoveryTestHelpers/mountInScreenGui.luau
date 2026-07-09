local CoreGui = game:GetService("CoreGui")
local Parent = script:FindFirstAncestor("DiscoveryTestHelpers").Parent

require(Parent.React)

local Rhodium = require(Parent.Rhodium)
local Roact = require(Parent.Roact)
local ReactRoblox = require(Parent.ReactRoblox)
local Element = Rhodium.Element
local XPath = Rhodium.XPath

local function mountInScreenGui(t1: {[any]: any}, s1: string, t2: {[any]: any}?) -- line: 13
	-- upvalues: Roact (copy), ReactRoblox (copy), CoreGui (copy), XPath (copy), Element (copy)
	local v12 = Roact.createElement("ScreenGui", t2 or {}, {
		Frame = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0)
		}, t1)
	})
	local u13 = nil

	ReactRoblox.act(function() -- line: 24
		-- upvalues: u13 (ref), Roact (copy), v12 (copy), CoreGui (copy), s1 (copy)
		u13 = Roact.mount(v12, CoreGui, s1)
	end)

	local v14 = XPath.new(`game.CoreGui.{ s1 }`)

	Element.new(v14):waitForRbxInstance(1)

	return u13
end

return mountInScreenGui
