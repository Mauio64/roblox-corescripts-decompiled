local Parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(Parent.React)
local Parent2 = require(script.Parent)
local ClientSettingsUtility = require(script.Parent.ClientSettingsUtility)
local FFlagExpChatAddressFrame0Flash = require(Parent.ChatUIPrimitives).Flags.FFlagExpChatAddressFrame0Flash

return function(p1) -- line: 11
	-- upvalues: React (copy), Parent2 (copy), FFlagExpChatAddressFrame0Flash (copy), ClientSettingsUtility (copy)
	local v7 = React.useContext(Parent2)
	local v8, v9 = React.useState({
		BackgroundColor3 = if not FFlagExpChatAddressFrame0Flash then nil else ClientSettingsUtility.getBackgroundColor(p1, v7),
		BackgroundColor = if FFlagExpChatAddressFrame0Flash then nil else ClientSettingsUtility.getBackgroundColor(p1, v7),
		BackgroundTransparency = ClientSettingsUtility.getBackgroundTransparency(p1, v7)
	})

	React.useEffect(function() -- line: 24
		-- upvalues: v9 (copy), ClientSettingsUtility (copy), p1 (copy), v7 (copy)
		v9({
			BackgroundColor3 = ClientSettingsUtility.getBackgroundColor(p1, v7),
			BackgroundTransparency = ClientSettingsUtility.getBackgroundTransparency(p1, v7)
		})
	end, {
		p1,
		v7
	})

	return v8
end
