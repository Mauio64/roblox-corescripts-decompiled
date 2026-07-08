local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Colors = require(ExpChatParent.UIBlox).App.Style.Colors
local ChatWindowBackgroundColor3 = require(ExpChat.Config).ChatWindowBackgroundColor3

return {
	getBackgroundColor = function(t1: {[any]: any}, p1) -- line: 14
		-- upvalues: ChatWindowBackgroundColor3 (copy), Colors (copy)
		if t1.BackgroundColor3 == ChatWindowBackgroundColor3 then
			return Colors.Flint:Lerp(t1.BackgroundColor3, p1.preferredTransparency)
		end

		return t1.BackgroundColor3
	end,
	getBackgroundTransparency = function(t2: {[any]: any}, p2) -- line: 22
		return t2.BackgroundTransparency * p2.preferredTransparency
	end
}
