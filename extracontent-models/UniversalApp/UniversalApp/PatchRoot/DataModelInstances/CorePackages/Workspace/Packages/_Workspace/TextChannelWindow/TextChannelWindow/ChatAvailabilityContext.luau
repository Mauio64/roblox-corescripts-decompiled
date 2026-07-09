local Players = game:GetService("Players")
local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local useEventConnection = require(ParentParent.ReactUtils).useEventConnection
local t1 = {
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
local t2 = {
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
local t3 = {
	canChat = true,
	reason = nil,
	messageKey = nil,
	messageFallback = nil
}
local v8 = React.createContext(t3)

return {
	Context = v8,
	Provider = function(t4: {[any]: any}) -- line: 85
		-- upvalues: Players (copy), React (copy), useEventConnection (copy), t1 (copy), t2 (copy), v8 (copy)
		local v13 = t4.subjectPlayer or Players.LocalPlayer
		local v14, v15 = React.useState(function() -- line: 88
			-- upvalues: t4 (copy), v13 (copy)
			if t4.value ~= nil then
				return t4.value
			end

			if v13 then
				return v13.ChatAvailabilityStatus
			end

			return "Enabled"
		end)

		useEventConnection(if t4.value ~= nil or not v13 then nil else v13:GetPropertyChangedSignal("ChatAvailabilityStatus"), function() -- line: 98
			-- upvalues: v13 (copy), v15 (copy)
			if v13 then
				v15(v13.ChatAvailabilityStatus)
			end
		end, {})
		React.useEffect(function() -- line: 108
			-- upvalues: t4 (copy), v15 (copy)
			if t4.value ~= nil then
				v15(t4.value)
			end
		end, { t4.value })

		local v16 = React.useMemo(function() -- line: 115
			-- upvalues: v14 (copy), t1 (copy), t2 (copy)
			local v17 = t1[v14]
			local v18 = if not v17 then nil else t2[v17]

			return {
				canChat = v17 == nil,
				reason = v17,
				messageKey = if not v18 then nil else v18.key,
				messageFallback = if not v18 then nil else v18.fallback
			}
		end, { v14 })

		return React.createElement(v8.Provider, {
			value = v16
		}, t4.children)
	end,
	resolve = function(s1: string) -- line: 55
		-- upvalues: t1 (copy), t2 (copy)
		local v10 = t1[s1]
		local v11 = if not v10 then nil else t2[v10]

		return {
			canChat = v10 == nil,
			reason = v10,
			messageKey = if not v11 then nil else v11.key,
			messageFallback = if not v11 then nil else v11.fallback
		}
	end,
	useLocalUserChatAvailability = function() -- line: 124
		-- upvalues: React (copy), v8 (copy)
		return React.useContext(v8)
	end
}
