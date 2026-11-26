local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local useLocalization = Localization.Hooks.useLocalization

local function useCaptureToChat(callback, callback2)
	local state, setState = React.useState(nil)
	local v5 = useLocalization({ addImages = LocalizationStrings.CHAT_CAPTURE_GALLERY_TITLE })

	local v6 = React.useCallback(function()
		callback2({
			toastAction = {
				text = v5.addImages,
				onActivated = function(p2)
					setState(p2)
					callback()
				end
			}
		})
	end, { callback, callback2, v5.addImages })
	local v7 = React.useCallback(function()
		setState(nil)
	end, {})

	if callback2 == nil then
		v6 = nil
	end

	return { captureToAttach = state, onCaptureActivated = v6, onCaptureAttached = v7 }
end

return useCaptureToChat
