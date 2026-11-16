local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Localization = require(parent.Localization)
local React = require(parent.React)

local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local useLocalization = Localization.Hooks.useLocalization

local function useCaptureToChat(callback, callback2)
	local state, setState = React.useState(nil)
	local v = useLocalization({ addImages = LocalizationStrings.CHAT_CAPTURE_GALLERY_TITLE })

	local onCaptureActivated = React.useCallback(function()
		callback2({
			toastAction = {
				text = v.addImages,
				onActivated = function(p)
					setState(p)
					callback()
				end
			}
		})
	end, { callback, callback2, v.addImages })
	local onCaptureAttached = React.useCallback(function()
		setState(nil)
	end, {})

	if callback2 == nil then
		onCaptureActivated = nil
	end

	return {
		captureToAttach = state,
		onCaptureActivated = onCaptureActivated,
		onCaptureAttached = onCaptureAttached
	}
end

return useCaptureToChat
