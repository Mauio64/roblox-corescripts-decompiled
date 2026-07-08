local ParentParent = script.Parent.Parent
local Object = require(ParentParent.LuauPolyfill).Object
local reportCounter = require(script.Parent.reportCounter)
local customFields = require(script.Parent.customFields)

return {
	customFields = customFields,
	reportNewDevtoolsConnection = function() -- line: 12
		-- upvalues: reportCounter (copy), customFields (copy)
		reportCounter({
			eventName = "react_new_devtools_connection",
			description = "A new connection to React Devtools",
			links = "https://roblox.atlassian.net/wiki/spaces/luauee/pages/3836510338/DevTools+Telemetry",
			lastUpdated = {
				2025,
				8,
				28
			},
			customFields = customFields
		})
	end,
	reportFailedDevtoolsConnection = function(s1: string) -- line: 23
		-- upvalues: reportCounter (copy), Object (copy), customFields (copy)
		reportCounter({
			eventName = "react_failed_devtools_connection",
			description = "A failed connection to React Devtools",
			links = "https://roblox.atlassian.net/wiki/spaces/luauee/pages/3836510338/DevTools+Telemetry",
			lastUpdated = {
				2025,
				8,
				28
			},
			customFields = Object.assign({}, customFields, {
				error_type = s1
			})
		})
	end
}
