local GuiService = game:GetService("GuiService")

local GameInvite = script:FindFirstAncestor("GameInvite")
local Context = GameInvite.Context
local parent = GameInvite.Parent

local SharedFlags = require(parent.SharedFlags)
local React = require(parent.React)
require(GameInvite.gameInviteModalType)
local GameInviteModalLayoutContext = require(Context.GameInviteModalLayoutContext)

local GetFFlagLuaAppEnableTopBanner = SharedFlags.GetFFlagLuaAppEnableTopBanner
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local FFlagEnableInExperienceUIPCVRFix = SharedFlags.FFlagEnableInExperienceUIPCVRFix

local function fn(p) -- 1 equivalent call inferred from this helper
	return (p.X < 800 or p.Y < 624) and p.X or 800
end

local function fn2(p, p2) -- 1 equivalent call inferred from this helper
	return (p.X < 800 or p.Y < 624)
		and p.Y - (GetFFlagLuaAppEnableTopBanner() and not p2 and 0 or not GuiService and 50 or GuiService:GetGuiInset().Y)
		or 624
end

local function fn3(p, isCoreScript)
	local udim = UDim.new(0, fn(p)) -- inferred equivalent call
	local udim2 = UDim.new(0, fn2(p, isCoreScript)) -- inferred equivalent call
	return UDim2.new(udim, udim2)
end

local function fn4() -- 3 equivalent calls inferred from this helper
	return workspace.CurrentCamera.ViewportSize
end

local function fn5(x): boolean -- 6 equivalent calls inferred from this helper
	return x < 800
end

local function fn6(y): boolean -- 6 equivalent calls inferred from this helper
	return y < 624
end

return function(props)
	local isCoreScript = props.isCoreScript
	local v

	if isInExperienceUIVREnabled and FFlagEnableInExperienceUIPCVRFix and props.screenSizeOverride then
		v = props.screenSizeOverride
	else
		v = fn4() -- inferred equivalent call
	end

	local state, setState = React.useState(fn3(v, isCoreScript))
	local state2, setState2 = React.useState(fn6(v.Y)) -- inferred equivalent call
	local state3, setState3 = React.useState(fn5(v.X)) -- inferred equivalent call
	local state4, setState4 = React.useState(fn5(v.X) and "compact" or fn6(v.Y) and "compact" or "default") -- inferred equivalent call
	local v2

	if FFlagEnableInExperienceUIPCVRFix then
		v2 = React.useCallback(function()
			local viewportSize = fn4() -- inferred equivalent call
			local v3 = fn6(viewportSize.Y) -- inferred equivalent call
			local v4 = fn5(viewportSize.X) -- inferred equivalent call
			local v5 = fn3(viewportSize, isCoreScript)

			setState2(v3)
			setState3(v4)
			setState(v5)
			setState4(fn5(viewportSize.X) and "compact" or fn6(viewportSize.Y) and "compact" or "default") -- inferred equivalent call
		end, { isCoreScript })
	else
		v2 = function()
			local viewportSize = fn4() -- inferred equivalent call
			local v3 = fn6(viewportSize.Y) -- inferred equivalent call
			local v4 = fn5(viewportSize.X) -- inferred equivalent call
			local v5 = fn3(viewportSize, isCoreScript)

			setState2(v3)
			setState3(v4)
			setState(v5)
			setState4(fn5(viewportSize.X) and "compact" or fn6(viewportSize.Y) and "compact" or "default") -- inferred equivalent call
		end
	end

	React.useEffect(function()
		if isInExperienceUIVREnabled and FFlagEnableInExperienceUIPCVRFix and props.screenSizeOverride then
			return function() end
		end

		v2()
		local viewportSizeChangedConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(v2)

		return function()
			if viewportSizeChangedConnection then
				viewportSizeChangedConnection:Disconnect()
			end
		end
	end, isInExperienceUIVREnabled and FFlagEnableInExperienceUIPCVRFix and { props.screenSizeOverride, v2 } or {})

	return React.createElement(GameInviteModalLayoutContext.Provider, {
		value = {
			isFullHeight = state2,
			isFullWidth = state3,
			modalSize = state,
			modalMode = state4
		}
	}, props.children)
end
