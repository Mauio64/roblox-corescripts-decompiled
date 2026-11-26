local GuiService = game:GetService("GuiService")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedFlags")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/gameInviteModalType")
local GameInviteModalLayoutContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Context/GameInviteModalLayoutContext")

local getFFlagLuaAppEnableTopBanner = SharedFlags.GetFFlagLuaAppEnableTopBanner
local isInExperienceUIVREnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedExperimentDefinition").isInExperienceUIVREnabled
local fFlagEnableInExperienceUIPCVRFix = SharedFlags.FFlagEnableInExperienceUIPCVRFix

local function fn(p2, isCoreScript)
	local udim = UDim.new(0, (p2.X < 800 or p2.Y < 624) and p2.X or 800)
	local udim2 = UDim.new(
		0,
		(p2.X < 800 or p2.Y < 624) and p2.Y - (getFFlagLuaAppEnableTopBanner() and not isCoreScript and 0 or not GuiService and 50 or GuiService:GetGuiInset().Y) or 624
	)
	return UDim2.new(udim, udim2)
end

return function(props)
	local isCoreScript = props.isCoreScript
	local v5

	if isInExperienceUIVREnabled and fFlagEnableInExperienceUIPCVRFix and props.screenSizeOverride then
		v5 = props.screenSizeOverride
	else
		v5 = workspace.CurrentCamera.ViewportSize
	end

	local state, setState = React.useState(fn(v5, isCoreScript))
	local state2, setState2 = React.useState(v5.Y < 624)
	local state3, setState3 = React.useState(v5.X < 800)
	local state4, setState4 = React.useState(v5.X < 800 and "compact" or v5.Y < 624 and "compact" or "default")
	local v6

	if fFlagEnableInExperienceUIPCVRFix then
		v6 = React.useCallback(function()
			local viewportSize = workspace.CurrentCamera.ViewportSize

			local v7 = viewportSize.Y < 624
			local v8 = viewportSize.X < 800
			local v9 = fn(viewportSize, isCoreScript)

			setState2(v7)
			setState3(v8)
			setState(v9)
			setState4(viewportSize.X < 800 and "compact" or viewportSize.Y < 624 and "compact" or "default")
		end, { isCoreScript })
	else
		v6 = function()
			local viewportSize = workspace.CurrentCamera.ViewportSize

			local v7 = viewportSize.Y < 624
			local v8 = viewportSize.X < 800
			local v9 = fn(viewportSize, isCoreScript)

			setState2(v7)
			setState3(v8)
			setState(v9)
			setState4(viewportSize.X < 800 and "compact" or viewportSize.Y < 624 and "compact" or "default")
		end
	end

	React.useEffect(function()
		if isInExperienceUIVREnabled and fFlagEnableInExperienceUIPCVRFix and props.screenSizeOverride then
			return function() end
		end

		v6()
		local viewportSizeChangedConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(v6)

		return function()
			if viewportSizeChangedConnection then
				viewportSizeChangedConnection:Disconnect()
			end
		end
	end, isInExperienceUIVREnabled and fFlagEnableInExperienceUIPCVRFix and { props.screenSizeOverride, v6 } or {})

	return React.createElement(GameInviteModalLayoutContext.Provider, {
		value = {
			isFullHeight = state2,
			isFullWidth = state3,
			modalSize = state,
			modalMode = state4
		}
	}, props.children)
end
