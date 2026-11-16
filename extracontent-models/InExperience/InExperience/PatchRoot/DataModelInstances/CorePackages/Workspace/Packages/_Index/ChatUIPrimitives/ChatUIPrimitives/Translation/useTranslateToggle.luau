local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

require(ChatUIPrimitives.Types)
local useStableSignal = require(ChatUIPrimitives.Hooks.useStableSignal)
local shouldOfferTranslation = require(ChatUIPrimitives.Translation.shouldOfferTranslation)

local function useTranslateToggle(p, p2: string?, flag: boolean)
	local v, v2 = useStableSignal(true)

	React.useEffect(function()
		v2(true)
	end, { p2, v2 })

	local shouldShowTranslation = SignalsReact.useSignalState(v)

	return {
		isOffered = React.useMemo(function()
			return p ~= nil and shouldOfferTranslation(p, flag)
		end, { p, flag }),
		shouldShowTranslation = shouldShowTranslation,
		onToggle = React.useCallback(function()
			v2(not v())
		end, { v, v2 })
	}
end

return useTranslateToggle
