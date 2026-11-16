local parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(parent.React)

local parentModule = require(script.Parent)
local ClientSettingsUtility = require(script.Parent.ClientSettingsUtility)

local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local FFlagExpChatAddressFrame0Flash = ChatUIPrimitives.Flags.FFlagExpChatAddressFrame0Flash

return function(p)
	local v = React.useContext(parentModule)

	local useState = React.useState
	local backgroundColor

	if FFlagExpChatAddressFrame0Flash then
		backgroundColor = ClientSettingsUtility.getBackgroundColor(p, v)
	end

	local backgroundColor2

	if not FFlagExpChatAddressFrame0Flash then
		backgroundColor2 = ClientSettingsUtility.getBackgroundColor(p, v)
	end

	local state, setState = useState({
		BackgroundColor3 = backgroundColor,
		BackgroundColor = backgroundColor2,
		BackgroundTransparency = ClientSettingsUtility.getBackgroundTransparency(p, v)
	})

	React.useEffect(function()
		setState({
			BackgroundColor3 = ClientSettingsUtility.getBackgroundColor(p, v),
			BackgroundTransparency = ClientSettingsUtility.getBackgroundTransparency(p, v)
		})
	end, { p, v })

	return state
end
