local parent = script:FindFirstAncestor("ExpChatIntegration").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

require(script.Parent.ChatPlatformContext)
local useChatPlatform = require(script.Parent.useChatPlatform)

local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local FFlagExpChatAddressFrame0Flash = ChatUIPrimitives.Flags.FFlagExpChatAddressFrame0Flash

local function useInterpolatedClientSettings(p)
	local getInterpolators = useChatPlatform().getInterpolators
	local v = SignalsReact.useSignalState(getInterpolators)
	local getBackgroundColor = v.getBackgroundColor
	local getBackgroundTransparency = v.getBackgroundTransparency

	local useState = React.useState
	local backgroundColor

	if FFlagExpChatAddressFrame0Flash then
		backgroundColor = getBackgroundColor(p)
	end

	local backgroundColor2

	if not FFlagExpChatAddressFrame0Flash then
		backgroundColor2 = getBackgroundColor(p)
	end

	local state, setState = useState({
		BackgroundColor3 = backgroundColor,
		BackgroundColor = backgroundColor2,
		BackgroundTransparency = getBackgroundTransparency(p)
	})

	React.useEffect(function()
		setState({
			BackgroundColor3 = getBackgroundColor(p),
			BackgroundTransparency = getBackgroundTransparency(p)
		})
	end, { p, getBackgroundColor, getBackgroundTransparency })

	return state
end

return useInterpolatedClientSettings
