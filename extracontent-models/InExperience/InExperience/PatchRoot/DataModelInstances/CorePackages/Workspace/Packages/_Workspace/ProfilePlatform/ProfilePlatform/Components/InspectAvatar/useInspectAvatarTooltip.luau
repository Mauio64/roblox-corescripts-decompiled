local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local GetInspectAvatarTooltipStore = require(ProfilePlatform.Stores.GetInspectAvatarTooltipStore)

local inspectAvatarTooltipStore = GetInspectAvatarTooltipStore(false)

local function useInspectAvatarTooltip()
	local showTooltip = useSignalState(inspectAvatarTooltipStore.getIsOpen)

	React.useEffect(function()
		inspectAvatarTooltipStore.tryShow()

		return function()
			inspectAvatarTooltipStore.hide()
		end
	end, {})

	return { showTooltip = showTooltip, onDismiss = inspectAvatarTooltipStore.permanentlyDismiss }
end

return useInspectAvatarTooltip
