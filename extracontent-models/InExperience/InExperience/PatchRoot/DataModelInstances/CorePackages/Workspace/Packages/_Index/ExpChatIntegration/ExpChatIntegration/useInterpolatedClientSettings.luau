local Parent = script:FindFirstAncestor("ExpChatIntegration").Parent
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)

require(script.Parent.ChatPlatformContext)

local useChatPlatform = require(script.Parent.useChatPlatform)
local FFlagExpChatAddressFrame0Flash = require(Parent.ChatUIPrimitives).Flags.FFlagExpChatAddressFrame0Flash

local function useInterpolatedClientSettings(p1) -- line: 14
	-- upvalues: useChatPlatform (copy), SignalsReact (copy), React (copy), FFlagExpChatAddressFrame0Flash (copy)
	local getInterpolators = useChatPlatform().getInterpolators
	local v9 = SignalsReact.useSignalState(getInterpolators)
	local getBackgroundColor = v9.getBackgroundColor
	local getBackgroundTransparency = v9.getBackgroundTransparency
	local v12, v13 = React.useState({
		BackgroundColor3 = if not FFlagExpChatAddressFrame0Flash then nil else getBackgroundColor(p1),
		BackgroundColor = if FFlagExpChatAddressFrame0Flash then nil else getBackgroundColor(p1),
		BackgroundTransparency = getBackgroundTransparency(p1)
	})

	React.useEffect(function() -- line: 26
		-- upvalues: v13 (copy), getBackgroundColor (copy), p1 (copy), getBackgroundTransparency (copy)
		v13({
			BackgroundColor3 = getBackgroundColor(p1),
			BackgroundTransparency = getBackgroundTransparency(p1)
		})
	end, {
		p1,
		getBackgroundColor,
		getBackgroundTransparency
	})

	return v12
end

return useInterpolatedClientSettings
