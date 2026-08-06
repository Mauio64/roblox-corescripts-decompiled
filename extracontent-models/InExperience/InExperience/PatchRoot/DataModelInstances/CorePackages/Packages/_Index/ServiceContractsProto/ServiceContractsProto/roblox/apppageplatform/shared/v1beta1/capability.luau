require(script.Parent.Parent.Parent.Parent.Parent.proto)
require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

return {
	Capability = ({
		Capability = {
			fromNumber = function(n1: number) -- line: 25
				if n1 == 0 then
					return "CAPABILITY_INVALID"
				end

				if n1 == 1 then
					return "CAPABILITY_SUPPORTS_HYDRATION_CLIENT_HINTS"
				end

				if n1 == 2000 then
					return "CAPABILITY_SUPPORTS_EDP_PERSISTENT_ACTION_BAR_PLAY_BUTTON"
				end

				if n1 == 2001 then
					return "CAPABILITY_SUPPORTS_PIN_SHORTCUT_ACTION"
				end

				if n1 == 2002 then
					return "CAPABILITY_SUPPORTS_SPLIT_PANE"
				end

				if n1 == 3000 then
					return "CAPABILITY_SUPPORTS_OPEN_EXPERIENCE_STORE_SEE_ALL_WITH_WEBVIEW_FALLBACK_ACTION"
				end

				return nil
			end,
			toNumber = function(p1) -- line: 43
				if p1 == "CAPABILITY_INVALID" then
					return 0
				end

				if p1 == "CAPABILITY_SUPPORTS_HYDRATION_CLIENT_HINTS" then
					return 1
				end

				if p1 == "CAPABILITY_SUPPORTS_EDP_PERSISTENT_ACTION_BAR_PLAY_BUTTON" then
					return 2000
				end

				if p1 == "CAPABILITY_SUPPORTS_PIN_SHORTCUT_ACTION" then
					return 2001
				end

				if p1 == "CAPABILITY_SUPPORTS_SPLIT_PANE" then
					return 2002
				end

				if p1 == "CAPABILITY_SUPPORTS_OPEN_EXPERIENCE_STORE_SEE_ALL_WITH_WEBVIEW_FALLBACK_ACTION" then
					return 3000
				end

				return p1
			end,
			fromName = function(s1: string) -- line: 61
				if s1 == "CAPABILITY_INVALID" then
					return "CAPABILITY_INVALID"
				end

				if s1 == "CAPABILITY_SUPPORTS_HYDRATION_CLIENT_HINTS" then
					return "CAPABILITY_SUPPORTS_HYDRATION_CLIENT_HINTS"
				end

				if s1 == "CAPABILITY_SUPPORTS_EDP_PERSISTENT_ACTION_BAR_PLAY_BUTTON" then
					return "CAPABILITY_SUPPORTS_EDP_PERSISTENT_ACTION_BAR_PLAY_BUTTON"
				end

				if s1 == "CAPABILITY_SUPPORTS_PIN_SHORTCUT_ACTION" then
					return "CAPABILITY_SUPPORTS_PIN_SHORTCUT_ACTION"
				end

				if s1 == "CAPABILITY_SUPPORTS_SPLIT_PANE" then
					return "CAPABILITY_SUPPORTS_SPLIT_PANE"
				end

				if s1 == "CAPABILITY_SUPPORTS_OPEN_EXPERIENCE_STORE_SEE_ALL_WITH_WEBVIEW_FALLBACK_ACTION" then
					return "CAPABILITY_SUPPORTS_OPEN_EXPERIENCE_STORE_SEE_ALL_WITH_WEBVIEW_FALLBACK_ACTION"
				end

				return nil
			end
		}
	}).Capability
}
