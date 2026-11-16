local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local UIBlox = require(parent.UIBlox)
local Colors = UIBlox.App.Style.Colors

local Config = require(ExpChat.Config)
local ChatWindowBackgroundColor3 = Config.ChatWindowBackgroundColor3
local ClientSettingsUtility = {}

function ClientSettingsUtility.getBackgroundColor(p, p2)
	if p.BackgroundColor3 == ChatWindowBackgroundColor3 then
		return Colors.Flint:Lerp(p.BackgroundColor3, p2.preferredTransparency)
	end

	return p.BackgroundColor3
end

function ClientSettingsUtility.getBackgroundTransparency(p, p2)
	return p.BackgroundTransparency * p2.preferredTransparency
end

return ClientSettingsUtility
