local Players = game:GetService("Players")

local parent = script.Parent.Parent
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local useEventConnection = ReactUtils.useEventConnection

local v = {
	GeoBlocked = "geoBlocked",
	SettingsDisabled = "settingsOff",
	SettingsDisabledVpc = "parentalConsent",
	AgeCheckVpc = "parentalConsent",
	AgeVerificationRequired = "ageVerification",
	IdVerificationRequired = "ageVerification",
	AgeCheckGateExperiment = "ageVerification",
	Ineligible = "viewOnly",
	NoOne = "viewOnly"
}

local v2 = {
	geoBlocked = {
		key = "CoreScripts.TextChat.ChatWindow.ChatDisabled.RegionUnavailable",
		fallback = "You can only view system messages here. Chat is not available in your region."
	},
	settingsOff = {
		key = "CoreScripts.TextChat.ChatWindow.ChatDisabled.SettingOff",
		fallback = "You can only view system messages here. Update your Communication settings to turn on chat."
	},
	parentalConsent = {
		key = "CoreScripts.TextChat.ChatWindow.ChatDisabled.AskForPermission",
		fallback = "You can only view system messages here. Ask your parent for permission to chat in Communication settings."
	},
	ageVerification = {
		key = "CoreScripts.TextChat.ChatWindow.ChatDisabled.GetAnAgeCheck",
		fallback = "You can only view system messages here. Get an age check to chat."
	},
	viewOnly = {
		key = "CoreScripts.TextChat.ChatWindow.ChatDisabled.OnlyViewSystemMessages",
		fallback = "You can only view system messages here."
	}
}

local function resolve(state: string) -- 1 equivalent call inferred from this helper
	local reason = v[state]
	local v3

	if reason then
		v3 = v2[reason]
	end

	local v4 = {
		canChat = reason == nil,
		reason = reason,
		messageKey = 0,
		messageFallback = 0
	}
	local messageKey

	if v3 then
		messageKey = v3.key
	end

	v4.messageKey = messageKey
	local messageFallback

	if v3 then
		messageFallback = v3.fallback
	end

	v4.messageFallback = messageFallback
	return v4
end

local context = React.createContext({
	canChat = true,
	reason = nil,
	messageKey = nil,
	messageFallback = nil
})
local ChatAvailabilityContext = {}
ChatAvailabilityContext.Context = context

function ChatAvailabilityContext.Provider(props)
	local subjectPlayer = props.subjectPlayer or Players.LocalPlayer

	local state, setState = React.useState(function()
		if props.value ~= nil then
			return props.value
		end

		if subjectPlayer then
			return subjectPlayer.ChatAvailabilityStatus
		end

		return "Enabled"
	end)
	local v3

	if props.value == nil and subjectPlayer then
		v3 = subjectPlayer:GetPropertyChangedSignal("ChatAvailabilityStatus")
	end

	useEventConnection(v3, function()
		if subjectPlayer then
			setState(subjectPlayer.ChatAvailabilityStatus)
		end
	end, {})

	React.useEffect(function()
		if props.value ~= nil then
			setState(props.value)
		end
	end, { props.value })

	local v4 = React.useMemo(function()
		return resolve(state) -- inferred equivalent call
	end, { state })

	return React.createElement(context.Provider, { value = v4 }, props.children)
end

ChatAvailabilityContext.resolve = resolve

function ChatAvailabilityContext.useLocalUserChatAvailability()
	return React.useContext(context)
end

return ChatAvailabilityContext
