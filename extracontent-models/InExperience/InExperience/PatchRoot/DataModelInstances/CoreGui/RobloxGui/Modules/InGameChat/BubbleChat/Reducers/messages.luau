local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local AddMessage = require(script.Parent.Parent.Actions.AddMessage)
local RemoveMessage = require(script.Parent.Parent.Actions.RemoveMessage)
local SetMessageText = require(script.Parent.Parent.Actions.SetMessageText)

return (Rodux.createReducer({}, {
	[AddMessage.name] = function(p1, p2) -- line: 13
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			[p2.message.id] = p2.message
		})
	end,
	[RemoveMessage.name] = function(p3, p4) -- line: 19
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			[p4.message.id] = Cryo.None
		})
	end,
	[SetMessageText.name] = function(p5, p6) -- line: 25
		-- upvalues: Cryo (copy)
		local v13 = p5[p6.messageId]

		if not v13 then
			return p5
		end

		return Cryo.Dictionary.join(p5, {
			[p6.messageId] = Cryo.Dictionary.join(v13, {
				text = p6.newText
			})
		})
	end
}))
