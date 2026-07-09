local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent

return function(p1) -- line: 4
	-- upvalues: ExpChatParent (copy), ExpChat (copy)
	p1.Roact = require(ExpChatParent.Roact)
	p1.Rodux = require(ExpChatParent.Rodux)
	p1.RoactRodux = require(ExpChatParent.RoactRodux)
	p1.Rhodium = require(ExpChatParent.Dev.Rhodium)
	p1.storyMiddleware = require(ExpChat:FindFirstChild("ExpChat.storybook"):FindFirstChild("storyMiddleware"))
	p1.findFirstInstance = require(script.Parent.findFirstInstance)

	function p1.makeTree(p2, p3, p4) -- line: 11
		local Roact = p2.Roact
		local storyMiddleware = p2.storyMiddleware

		return Roact.createElement(storyMiddleware(p3), p4(p2))
	end
	function p1.createMount(p5, p6) -- line: 16
		return function(p7) -- line: 17
			-- upvalues: p5 (copy), p6 (copy)
			local Roact = p7.Roact
			local ScreenGui = Instance.new("ScreenGui")

			ScreenGui.Parent = game:GetService("CoreGui")

			local v14 = p7:makeTree(p5, p6)
			local v15 = Roact.mount(v14, ScreenGui)

			return {
				roactInstance = v15,
				instance = ScreenGui,
				unmount = function() -- line: 27
					-- upvalues: Roact (copy), v15 (copy), ScreenGui (copy)
					Roact.unmount(v15)
					ScreenGui:Destroy()
				end
			}
		end
	end
end
